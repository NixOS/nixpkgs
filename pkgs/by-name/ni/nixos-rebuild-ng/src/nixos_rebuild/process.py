from __future__ import annotations

import os
import subprocess
from typing import Sequence, TypedDict, Unpack

from .models import Ssh


# Not exhaustive, but we can always extend it later.
class RunKwargs(TypedDict, total=False):
    capture_output: bool
    input: str | None
    stderr: int | None
    stdin: int | None
    stdout: int | None


def run_wrapper(
    args: Sequence[str | bytes | os.PathLike[str] | os.PathLike[bytes]],
    *,
    check: bool,  # make it explicit so we always know if the code is handling errors
    env: dict[str, str] | None = None,  # replaces the current environment
    extra_env: dict[str, str] | None = None,  # appends to the current environment
    allow_tty: bool = True,
    remote: Ssh | None = None,
    sudo: bool = False,
    **kwargs: Unpack[RunKwargs],
) -> subprocess.CompletedProcess[str]:
    "Wrapper around `subprocess.run` that supports extra functionality."
    if remote:
        assert env is None, "'env' can't be used with 'remote'"
        if extra_env:
            extra_env_args = [f"{env}={value}" for env, value in extra_env.items()]
            args = ["env", *extra_env_args, *args]
        if sudo:
            args = ["sudo", *args]
        if allow_tty:
            # SSH's TTY will redirect all output to stdout, that may cause
            # unwanted effects when used
            assert not kwargs.get(
                "capture_output"
            ), "SSH's TTY is incompatible with capture_output"
            assert not kwargs.get("stderr"), "SSH's TTY is incompatible with stderr"
            assert not kwargs.get("stdout"), "SSH's TTY is incompatible with stdout"
        if allow_tty and remote.tty:
            args = ["ssh", "-t", *remote.opts, remote.host, "--", *args]
        else:
            args = ["ssh", *remote.opts, remote.host, "--", *args]
    else:
        if extra_env:
            env = (env or os.environ) | extra_env
        if sudo:
            args = ["sudo", *args]

    return subprocess.run(
        args,
        check=check,
        env=env,
        # Hope nobody is using NixOS with non-UTF8 encodings, but "surrogateescape"
        # should still work in those systems.
        text=True,
        errors="surrogateescape",
        **kwargs,
    )
