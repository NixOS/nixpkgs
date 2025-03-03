import atexit
import logging
import os
import shlex
import subprocess
from dataclasses import dataclass
from getpass import getpass
from typing import Final, Self, Sequence, TypedDict, Unpack

from . import tmpdir

logger = logging.getLogger(__name__)

SSH_DEFAULT_OPTS: Final = [
    "-o",
    "ControlMaster=auto",
    "-o",
    f"ControlPath={tmpdir.TMPDIR_PATH / "ssh-%n"}",
    "-o",
    "ControlPersist=60",
]


@dataclass(frozen=True)
class Remote:
    host: str
    opts: list[str]
    sudo_password: str | None

    @classmethod
    def from_arg(
        cls,
        host: str | None,
        ask_sudo_password: bool | None,
        validate_opts: bool = True,
    ) -> Self | None:
        if not host:
            return None

        opts = shlex.split(os.getenv("NIX_SSHOPTS", ""))
        if validate_opts:
            cls._validate_opts(opts, ask_sudo_password)
        sudo_password = None
        if ask_sudo_password:
            sudo_password = getpass(f"[sudo] password for {host}: ")
        return cls(host, opts, sudo_password)

    @staticmethod
    def _validate_opts(opts: list[str], ask_sudo_password: bool | None) -> None:
        for o in opts:
            if o in ["-t", "-tt", "RequestTTY=yes", "RequestTTY=force"]:
                logger.warning(
                    f"detected option '{o}' in NIX_SSHOPTS. SSH's TTY may "
                    + "cause issues, it is recommended to remove this option"
                )
                if not ask_sudo_password:
                    logger.warning(
                        "if you want to prompt for sudo password use "
                        + "'--ask-sudo-password' option instead"
                    )


# Not exhaustive, but we can always extend it later.
class RunKwargs(TypedDict, total=False):
    capture_output: bool
    stderr: int | None
    stdout: int | None


def cleanup_ssh() -> None:
    "Close SSH ControlMaster connection."
    for ctrl in tmpdir.TMPDIR_PATH.glob("ssh-*"):
        run_wrapper(
            ["ssh", "-o", f"ControlPath={ctrl}", "-O", "exit", "dummyhost"],
            check=False,
            capture_output=True,
        )


atexit.register(cleanup_ssh)


def run_wrapper(
    args: Sequence[str | bytes | os.PathLike[str] | os.PathLike[bytes]],
    *,
    check: bool = True,
    extra_env: dict[str, str] | None = None,
    remote: Remote | None = None,
    sudo: bool = False,
    **kwargs: Unpack[RunKwargs],
) -> subprocess.CompletedProcess[str]:
    "Wrapper around `subprocess.run` that supports extra functionality."
    env = None
    input = None
    if remote:
        if extra_env:
            extra_env_args = [f"{env}={value}" for env, value in extra_env.items()]
            args = ["env", *extra_env_args, *args]
        if sudo:
            if remote.sudo_password:
                args = ["sudo", "--prompt=", "--stdin", *args]
                input = remote.sudo_password + "\n"
            else:
                args = ["sudo", *args]
        args = [
            "ssh",
            *remote.opts,
            *SSH_DEFAULT_OPTS,
            remote.host,
            "--",
            # SSH will join the parameters here and pass it to the shell, so we
            # need to quote it to avoid issues.
            # We can't use `shlex.join`, otherwise we will hit MAX_ARG_STRLEN
            # limits when the command becomes too big.
            *[shlex.quote(str(a)) for a in args],
        ]
    else:
        if extra_env:
            env = os.environ | extra_env
        if sudo:
            args = ["sudo", *args]

    logger.debug(
        "calling run with args=%r, kwargs=%r, extra_env=%r",
        args,
        kwargs,
        extra_env,
    )

    try:
        r = subprocess.run(
            args,
            check=check,
            env=env,
            input=input,
            # Hope nobody is using NixOS with non-UTF8 encodings, but "surrogateescape"
            # should still work in those systems.
            text=True,
            errors="surrogateescape",
            **kwargs,
        )

        if kwargs.get("capture_output") or kwargs.get("stderr") or kwargs.get("stdout"):
            logger.debug("captured output stdout=%r, stderr=%r", r.stdout, r.stderr)

        return r
    except subprocess.CalledProcessError:
        if sudo and remote and remote.sudo_password is None:
            logger.error(
                "while running command with remote sudo, did you forget to use "
                + "--ask-sudo-password?"
            )
        raise
