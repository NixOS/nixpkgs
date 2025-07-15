import atexit
import getpass
import logging
import os
import re
import shlex
import subprocess
from collections.abc import Sequence
from dataclasses import dataclass
from typing import Final, Self, TypedDict, Unpack

from . import tmpdir

logger: Final = logging.getLogger(__name__)

SSH_DEFAULT_OPTS: Final = [
    "-o",
    "ControlMaster=auto",
    "-o",
    f"ControlPath={tmpdir.TMPDIR_PATH / 'ssh-%n'}",
    "-o",
    "ControlPersist=60",
]

type Args = Sequence[str | bytes | os.PathLike[str] | os.PathLike[bytes]]


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
            sudo_password = getpass.getpass(f"[sudo] password for {host}: ")
        return cls(host, opts, sudo_password)

    @staticmethod
    def _validate_opts(opts: list[str], ask_sudo_password: bool | None) -> None:
        for o in opts:
            if o in ["-t", "-tt", "RequestTTY=yes", "RequestTTY=force"]:
                logger.warning(
                    f"detected option '{o}' in NIX_SSHOPTS. SSH's TTY may "
                    "cause issues, it is recommended to remove this option"
                )
                if not ask_sudo_password:
                    logger.warning(
                        "if you want to prompt for sudo password use "
                        "'--ask-sudo-password' option instead"
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
    args: Args,
    *,
    check: bool = True,
    extra_env: dict[str, str] | None = None,
    remote: Remote | None = None,
    sudo: bool = False,
    **kwargs: Unpack[RunKwargs],
) -> subprocess.CompletedProcess[str]:
    "Wrapper around `subprocess.run` that supports extra functionality."
    env = None
    process_input = None
    run_args = args

    if remote:
        if extra_env:
            extra_env_args = [f"{env}={value}" for env, value in extra_env.items()]
            args = ["env", *extra_env_args, *args]
        if sudo:
            if remote.sudo_password:
                args = ["sudo", "--prompt=", "--stdin", *args]
                process_input = remote.sudo_password + "\n"
            else:
                args = ["sudo", *args]
        run_args = [
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
            run_args = ["sudo", *run_args]

    logger.debug(
        "calling run with args=%r, kwargs=%r, extra_env=%r",
        run_args,
        kwargs,
        extra_env,
    )

    try:
        r = subprocess.run(
            run_args,
            check=check,
            env=env,
            input=process_input,
            # Hope nobody is using NixOS with non-UTF8 encodings, but
            # "surrogateescape" should still work in those systems.
            text=True,
            errors="surrogateescape",
            **kwargs,
        )

        if kwargs.get("capture_output") or kwargs.get("stderr") or kwargs.get("stdout"):
            logger.debug(
                "captured output with stdout=%r, stderr=%r", r.stdout, r.stderr
            )

        return r
    except KeyboardInterrupt:
        # sudo commands are activation only and unlikely to be long running
        if remote and not sudo:
            _kill_long_running_ssh_process(args, remote)
        raise
    except subprocess.CalledProcessError:
        if sudo and remote and remote.sudo_password is None:
            logger.error(
                "while running command with remote sudo, did you forget to use "
                "--ask-sudo-password?"
            )
        raise


# SSH does not send the signals to the process when running without usage of
# pseudo-TTY (that causes a whole other can of worms), so if the process is
# long running (e.g.: a build) this will result in the underlying process
# staying alive.
# See: https://stackoverflow.com/a/44354466
# Issue: https://github.com/NixOS/nixpkgs/issues/403269
def _kill_long_running_ssh_process(args: Args, remote: Remote) -> None:
    logger.info("cleaning-up remote process, please wait...")

    # We need to escape both the shell and regex here (since pkill interprets
    # its arguments as regex)
    quoted_args = re.escape(shlex.join(str(a) for a in args))
    logger.debug("killing remote process using pkill with args=%r", quoted_args)
    cleanup_interrupted = False

    try:
        r = subprocess.run(
            [
                "ssh",
                *remote.opts,
                *SSH_DEFAULT_OPTS,
                remote.host,
                "--",
                "pkill",
                "--signal",
                "SIGINT",
                "--full",
                "--",
                quoted_args,
            ],
            check=False,
            capture_output=True,
            text=True,
        )
        logger.debug(
            "remote pkill captured output with stdout=%r, stderr=%r, returncode=%s",
            r.stdout,
            r.stderr,
            r.returncode,
        )
    except KeyboardInterrupt:
        cleanup_interrupted = True
        raise
    finally:
        if cleanup_interrupted or r.returncode:
            logger.warning(
                "could not clean-up remote process, the command %s may still be running in host '%s'",
                args,
                remote.host,
            )
