import atexit
import getpass
import logging
import os
import re
import shlex
import subprocess
from collections.abc import Mapping, Sequence
from dataclasses import dataclass
from enum import Enum
from ipaddress import AddressValueError, IPv6Address
from typing import Final, Literal, Self, TextIO, TypedDict, Unpack, override

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


class _Env(Enum):
    PRESERVE_ENV = "PRESERVE"

    @override
    def __repr__(self) -> str:
        return self.value


PRESERVE_ENV: Final = _Env.PRESERVE_ENV


type Arg = str | bytes | os.PathLike[str] | os.PathLike[bytes]
type Args = Sequence[Arg]
type EnvValue = str | Literal[_Env.PRESERVE_ENV]


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

    def ssh_host(self) -> str:
        """Fix up host string for SSH.

        It returns an SSH-compatible host string if the host is using an
        IPv6 address, otherwise it returns the passed host string unmodified.
        """
        try:
            host_split = self.host.split("@")
            host_fixed = host_split[-1].strip("[]").replace("%25", "%")
            IPv6Address(host_fixed)
            if len(host_split) > 1:
                return host_split[0] + "@" + host_fixed
            else:
                return host_fixed
        except AddressValueError:
            return self.host


# Not exhaustive, but we can always extend it later.
class RunKwargs(TypedDict, total=False):
    capture_output: bool
    stderr: int | TextIO | None
    stdout: int | TextIO | None


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
    env: Mapping[str, EnvValue] | None = None,
    remote: Remote | None = None,
    sudo: bool = False,
    **kwargs: Unpack[RunKwargs],
) -> subprocess.CompletedProcess[str]:
    "Wrapper around `subprocess.run` that supports extra functionality."
    process_input = None
    run_args: list[Arg] = list(args)
    final_args: list[Arg]

    normalized_env = _normalize_env(env)
    resolved_env = _resolve_env_local(normalized_env)

    if remote:
        remote_run_args: list[Arg] = [
            "/bin/sh",
            "-c",
            _remote_shell_script(normalized_env),
            "sh",
            *run_args,
        ]

        if sudo:
            sudo_args = shlex.split(os.getenv("NIX_SUDOOPTS", ""))
            if remote.sudo_password:
                remote_run_args = [
                    "sudo",
                    "--prompt=",
                    "--stdin",
                    *sudo_args,
                    *remote_run_args,
                ]
                process_input = remote.sudo_password + "\n"
            else:
                remote_run_args = ["sudo", *sudo_args, *remote_run_args]

        ssh_args: list[Arg] = [
            "ssh",
            *remote.opts,
            *SSH_DEFAULT_OPTS,
            remote.ssh_host(),
            "--",
            *[_quote_remote_arg(a) for a in remote_run_args],
        ]
        final_args = ssh_args
        popen_env = None  # keep ssh's environment normal

    else:
        if sudo:
            # subprocess.run(env=...) would affect sudo, but sudo may drop env
            # for the target command.
            # So we inject env via `sudo env ... cmd`.
            if env is not None and resolved_env:
                run_args = _prefix_env_cmd(run_args, resolved_env)

            sudo_args = shlex.split(os.getenv("NIX_SUDOOPTS", ""))
            final_args = ["sudo", *sudo_args, *run_args]

            # No need to pass env to subprocess.run; keep sudo's own env
            # default.
            popen_env = None
        else:
            # Non-sudo local: we can fully control the environment with
            # subprocess.run(env=...)
            final_args = run_args
            popen_env = None if env is None else resolved_env

    logger.debug(
        "calling run with args=%r, kwargs=%r, env=%r",
        _sanitize_env_run_args(remote_run_args if remote else run_args),
        kwargs,
        env,
    )

    try:
        r = subprocess.run(
            final_args,
            check=check,
            env=popen_env,
            input=process_input,
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


def _resolve_env(env: Mapping[str, EnvValue] | None) -> dict[str, str]:
    normalized = _normalize_env(env)
    return _resolve_env_local(normalized)


def _normalize_env(env: Mapping[str, EnvValue] | None) -> dict[str, EnvValue]:
    """
    Normalize env mapping, but preserve some environment variables by default.
    """
    return {"PATH": PRESERVE_ENV, **(env or {})}


def _resolve_env_local(env: dict[str, EnvValue]) -> dict[str, str]:
    """
    Resolve env mapping where values can be:
      - PRESERVE_ENV: copy from current os.environ (if present)
      - str: explicit value
    """
    result: dict[str, str] = {}

    for k, v in env.items():
        if v == PRESERVE_ENV:
            cur = os.environ.get(k)
            if cur is not None:
                result[k] = cur
        else:
            result[k] = v
    return result


def _prefix_env_cmd(cmd: Sequence[Arg], resolved_env: dict[str, str]) -> list[Arg]:
    """
    Prefix a command with `env -i K=V ... -- <cmd...>` to set vars for the
    command.
    """
    if not resolved_env:
        return list(cmd)

    assigns = [f"{k}={v}" for k, v in resolved_env.items()]
    return ["env", "-i", *assigns, *cmd]


def _remote_shell_script(env: Mapping[str, EnvValue]) -> str:
    """
    Build the POSIX shell wrapper used for remote execution over SSH.

    SSH sends the remote command as a shell-interpreted command line, so we
    need a wrapper to establish a clean environment before `exec`-ing the real
    command. This wrapper is always run under `/bin/sh -c` so preserved
    variables like `${PATH-}` do not depend on the remote user's login shell.
    """
    shell_assigns: list[str] = []
    for k, v in env.items():
        if v is PRESERVE_ENV:
            shell_assigns.append(f'{k}="${{{k}-}}"')
        else:
            shell_assigns.append(f"{k}={shlex.quote(v)}")
    return f'exec env -i {" ".join(shell_assigns)} "$@"'


def _quote_remote_arg(arg: Arg) -> str:
    return shlex.quote(str(arg))


def _sanitize_env_run_args(run_args: list[Arg]) -> list[Arg]:
    """
    Sanitize long or sensitive environment variables from logs.
    """
    sanitized: list[Arg] = []
    for value in run_args:
        if isinstance(value, str) and value.startswith("PATH="):
            sanitized.append("PATH=<PATH>")
        elif isinstance(value, str | bytes | os.PathLike):
            sanitized.append(value)
        else:
            sanitized.append(str(value))
    return sanitized


def _kill_long_running_ssh_process(args: Args, remote: Remote) -> None:
    """
    SSH does not send the signals to the process when running without usage of
    pseudo-TTY (that causes a whole other can of worms), so if the process is
    long running (e.g.: a build) this will result in the underlying process
    staying alive.
    See: https://stackoverflow.com/a/44354466
    Issue: https://github.com/NixOS/nixpkgs/issues/403269
    """
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
                remote.ssh_host(),
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
