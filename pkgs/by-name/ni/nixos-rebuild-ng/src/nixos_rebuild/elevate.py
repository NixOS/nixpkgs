"""Privilege-elevation backends for activation commands.

An :class:`Elevator` describes how to wrap a command so it runs as root,
both on the local machine and on a remote target host over SSH (where no
controlling terminal is available), and how to feed it a pre-supplied
password when the backend supports that. ``run_wrapper`` and its callers
carry a single ``elevate: Elevator`` value and let it produce the command
prefix and stdin.

The remote case has no controlling terminal and the elevated command's
environment depends on the backend (``sudo`` inherits the SSH login env,
while the run0 backend starts a transient unit with only systemd's
default ``PATH``), so each backend builds the full remote argv itself
via :meth:`Elevator.wrap_remote`.
"""

from __future__ import annotations

import getpass
import os
import shlex
from abc import ABC, abstractmethod
from collections.abc import Mapping, Sequence
from dataclasses import dataclass, field, replace
from enum import Enum
from pathlib import Path, PurePosixPath
from typing import ClassVar, Final, Literal, Self, override

# Kept here (rather than in process.py) so that elevators can build remote
# argvs without a circular import.
type Arg = str | bytes | os.PathLike[str] | os.PathLike[bytes]
type Args = Sequence[Arg]


class _Env(Enum):
    PRESERVE_ENV = "PRESERVE"

    @override
    def __repr__(self) -> str:
        return self.value


#: Sentinel meaning "copy this variable from the environment the wrapped
#: command would naturally see" (``os.environ`` locally, the SSH login
#: shell's environment remotely).
PRESERVE_ENV: Final = _Env.PRESERVE_ENV

type EnvValue = str | Literal[_Env.PRESERVE_ENV]


def _remote_env_shell_argv(
    prefix: Sequence[str],
    env: Mapping[str, EnvValue],
    args: Args,
) -> list[Arg]:
    """Build ``<prefix> /bin/sh -c 'exec /usr/bin/env -i K=V… "$@"' sh <args>``.

    The wrapper runs in the SSH login session, resolves ``PRESERVE_ENV``
    variables against that session's environment, and re-execs the command
    with exactly that set. ``/usr/bin/env`` is referenced by absolute path so
    the wrapper does not depend on ``PATH`` itself (provided on NixOS via
    ``environment.usrbinenv``).
    """
    assigns: list[str] = []
    for k, v in env.items():
        if v is PRESERVE_ENV:
            assigns.append(f'{k}="${{{k}-}}"')
        else:
            assigns.append(f"{k}={shlex.quote(v)}")
    script = f'exec /usr/bin/env -i {" ".join(assigns)} "$@"'
    return [*prefix, "/bin/sh", "-c", script, "sh", *args]


@dataclass(frozen=True)
class Wrapped:
    """Result of wrapping a command for local elevation."""

    #: Arguments to prepend to the command.
    prefix: list[str]
    #: Text to send on the wrapped command's stdin (typically a password
    #: followed by a newline), or ``None`` to leave stdin alone.
    stdin: str | None = None


@dataclass(frozen=True)
class RemoteWrapped:
    """Result of wrapping a command for remote elevation over SSH.

    Unlike :class:`Wrapped` this carries the *full* remote argv: backends
    differ in where the env-resolution shell wrapper must sit relative to
    the elevator (inside ``sudo``, but *around* ``systemd-run``), so a
    plain prefix is not expressive enough.
    """

    argv: list[Arg]
    stdin: str | None = None


class Elevator(ABC):
    """How to gain root for activation commands."""

    #: CLI name, e.g. ``sudo`` or ``run0``.
    name: str

    @property
    def elevates(self) -> bool:
        """Whether this elevator actually changes privileges.

        ``run_wrapper`` uses this to decide between passing ``env`` to
        :func:`subprocess.run` directly (unprivileged local case) and
        injecting it via ``env -i`` inside the wrapped command (where the
        elevator may otherwise scrub the environment).
        """
        return True

    @abstractmethod
    def wrap_local(self) -> Wrapped:
        """Wrap a command run on the local machine."""

    @abstractmethod
    def wrap_remote(self, env: Mapping[str, EnvValue], args: Args) -> RemoteWrapped:
        """Wrap a command run on a target host over SSH.

        The remote side has no controlling terminal, so backends that need
        interactive prompts must either accept a pre-supplied password
        (see :meth:`with_password`) or rely on a passwordless policy on
        the target.

        *env* is the environment to establish for the elevated command.
        :data:`PRESERVE_ENV` values are resolved against the SSH login
        shell's environment, and the backend must do so before any step
        that replaces it with a service-style one.
        """

    @abstractmethod
    def with_password(self, password: str) -> Self:
        """Return a copy that will feed *password* to the backend.

        Backends that have no stdin path for credentials must raise
        :class:`ElevateError` with a hint pointing at the alternative
        (e.g. a polkit rule).
        """

    def with_prompted_password(self, *, ask: bool, host_label: str) -> Self:
        """Prompt locally for a password and return a copy carrying it.

        No-op when *ask* is false. May raise :class:`ElevateError` (e.g.
        on :class:`NoElevator`).
        """
        if not ask:
            return self
        password = getpass.getpass(f"[{self.name}] password for {host_label}: ")
        return self.with_password(password)

    def for_target_config(self, toplevel: PurePosixPath | Path) -> Self:
        """Return a copy bound to the toplevel being activated on the target.

        Backends that need a helper binary on the remote
        (:class:`Run0Elevator`'s ``polkit-stdin-agent``) use this to find
        a target-architecture copy inside the just-copied closure. No-op
        by default.
        """
        del toplevel  # unused in the base implementation
        return self

    def on_remote_failure(self) -> str | None:
        """Optional hint to print when a remote elevated command fails."""
        return None


class ElevateError(Exception):
    """Raised for invalid elevator/flag combinations."""


@dataclass(frozen=True)
class NoElevator(Elevator):
    name: str = "none"

    @property
    @override
    def elevates(self) -> bool:
        return False

    @override
    def wrap_local(self) -> Wrapped:
        return Wrapped(prefix=[])

    @override
    def wrap_remote(self, env: Mapping[str, EnvValue], args: Args) -> RemoteWrapped:
        return RemoteWrapped(argv=_remote_env_shell_argv([], env, args))

    @override
    def with_password(self, password: str) -> Self:
        raise ElevateError(
            "--ask-elevate-password requires --elevate to select an elevation method"
        )


@dataclass(frozen=True)
class SudoElevator(Elevator):
    """Wrap with ``sudo``, optionally feeding the password on stdin.

    Extra arguments come from ``NIX_SUDOOPTS`` for backwards
    compatibility with the previous implementation in ``run_wrapper``.
    """

    name: str = "sudo"
    password: str | None = None
    extra_opts: list[str] = field(
        default_factory=lambda: shlex.split(os.getenv("NIX_SUDOOPTS", ""))
    )

    @override
    def wrap_local(self) -> Wrapped:
        # Local sudo can prompt on /dev/tty itself, so the password is
        # only piped when one was supplied explicitly.
        if self.password is not None:
            return Wrapped(
                prefix=["sudo", "--prompt=", "--stdin", *self.extra_opts],
                stdin=self.password + "\n",
            )
        return Wrapped(prefix=["sudo", *self.extra_opts])

    @override
    def wrap_remote(self, env: Mapping[str, EnvValue], args: Args) -> RemoteWrapped:
        # sudo runs inside the SSH login session, so the env wrapper can
        # sit *inside* it and ${VAR-} resolves against the login env.
        if self.password is not None:
            prefix = ["sudo", "--prompt=", "--stdin", *self.extra_opts]
            stdin = self.password + "\n"
        else:
            prefix = ["sudo", *self.extra_opts]
            stdin = None
        return RemoteWrapped(
            argv=_remote_env_shell_argv(prefix, env, args),
            stdin=stdin,
        )

    @override
    def with_password(self, password: str) -> Self:
        return replace(self, password=password)

    @override
    def on_remote_failure(self) -> str | None:
        if self.password is None:
            return (
                "while running command with remote sudo, did you forget to "
                "use --ask-elevate-password?"
            )
        return None


@dataclass(frozen=True)
class Run0Elevator(Elevator):
    """Wrap with systemd's polkit-based ``run0``.

    Locally, ``run0`` is used directly and the user's polkit agent
    (graphical or ``pkttyagent``) handles any prompts.

    Remotely we spell out the explicit ``systemd-run --uid=0 --pipe``
    form instead. ``run0`` would internally do the same thing when stdio
    is not a TTY (see systemd ``src/run/run.c``), but going through
    ``systemd-run`` directly gives us ``--setenv K=V``, which we need to
    forward the SSH login environment into the transient unit (whose own
    ``PATH`` on NixOS is just the systemd store path), and keeps the
    argv independent of whether the SSH session happens to have a TTY.

    Authorisation comes from either a polkit rule on the target granting
    ``org.freedesktop.systemd1.manage-units`` to the deploying user, or
    from ``polkit-stdin-agent`` for ``--ask-elevate-password``.
    """

    name: str = "run0"
    password: str | None = None
    #: ``${toplevel}/sw/bin/polkit-stdin-agent`` on the target, set via
    #: :meth:`for_target_config`. ``None`` falls back to the target's ``PATH``.
    remote_agent: str | None = None

    #: Non-interactive equivalent of ``run0`` (see the class docstring).
    REMOTE_BASE: ClassVar[tuple[str, ...]] = (
        "systemd-run",
        "--uid=0",
        "--pipe",
        "--quiet",
        "--wait",
        "--collect",
        "--service-type=exec",
        "--send-sighup",
    )

    @override
    def wrap_local(self) -> Wrapped:
        if self.password is not None:
            # Resolved from PATH, same requirement as the remote case: the
            # machine doing the elevation needs
            # system.tools.nixos-rebuild.enableRun0Elevation.
            return Wrapped(
                prefix=["polkit-stdin-agent", "--password-fd=0", "--", "run0", "--"],
                stdin=self.password + "\n",
            )
        return Wrapped(prefix=["run0", "--"])

    @override
    def wrap_remote(self, env: Mapping[str, EnvValue], args: Args) -> RemoteWrapped:
        # /bin/sh wrapper resolves PRESERVE_ENV in the SSH login session
        # and forwards the result into the unit via --setenv.
        setenvs: list[str] = []
        for k, v in env.items():
            if v is PRESERVE_ENV:
                setenvs.append(f'--setenv={k}="${{{k}-}}"')
            else:
                setenvs.append(f"--setenv={shlex.quote(f'{k}={v}')}")
        script = f'exec {shlex.join(self.REMOTE_BASE)} {" ".join(setenvs)} -- "$@"'
        argv: list[Arg] = ["/bin/sh", "-c", script, "sh", *args]
        if self.password is not None:
            # polkit has no `sudo --stdin` equivalent. polkit-stdin-agent
            # registers a per-process agent for the wrapped command and
            # answers the PAM conversation from its stdin.
            argv = self._remote_agent_argv(argv)
            return RemoteWrapped(argv=argv, stdin=self.password + "\n")
        return RemoteWrapped(argv=argv)

    #: POSIX sh fragment that picks the first runnable agent from the
    #: positional parameters up to ``--`` and execs it with the remainder.
    #: ``command -v`` covers both absolute paths and ``PATH`` lookups.
    _AGENT_PICKER: ClassVar[str] = (
        "agent=; "
        "for a; do "
        "shift; "
        '[ "$a" = -- ] && break; '
        '[ -z "$agent" ] && command -v "$a" >/dev/null 2>&1 && agent="$a"; '
        "done; "
        '[ -n "$agent" ] && exec "$agent" --password-fd=0 -- "$@"; '
        'echo "nixos-rebuild: polkit-stdin-agent not found on target host '
        '(set system.tools.nixos-rebuild.enableRun0Elevation = true)" >&2; '
        "exit 127"
    )

    def _remote_agent_argv(self, inner: list[Arg]) -> list[Arg]:
        """Wrap *inner* in a target-side agent lookup.

        The deployer's own agent may be the wrong arch/nixpkgs (cross-arch
        deploys, Darwin deployers, ``--no-reexec``), so resolve on the
        target instead: first ``${toplevel}/sw/bin/polkit-stdin-agent``
        (present when ``system.tools.nixos-rebuild.enableRun0Elevation``
        is set), then bare ``polkit-stdin-agent`` on the SSH login PATH.
        :data:`_AGENT_PICKER` exits 127 with a hint if neither is found.
        """
        candidates: list[str] = []
        if self.remote_agent is not None:
            candidates.append(self.remote_agent)
        candidates.append("polkit-stdin-agent")
        return ["/bin/sh", "-c", self._AGENT_PICKER, "sh", *candidates, "--", *inner]

    @override
    def with_password(self, password: str) -> Self:
        return replace(self, password=password)

    @override
    def for_target_config(self, toplevel: PurePosixPath | Path) -> Self:
        return replace(
            self, remote_agent=str(toplevel / "sw" / "bin" / "polkit-stdin-agent")
        )

    @override
    def on_remote_failure(self) -> str | None:
        if self.password is None:
            return (
                "while running command with remote run0. Either pass "
                "--ask-elevate-password, or grant the deploying user the "
                "polkit action 'org.freedesktop.systemd1.manage-units' on "
                "the target host (security.polkit.extraConfig)."
            )
        return (
            "while running command with remote run0. If the error above "
            "mentions polkit-stdin-agent or PolicyKit1, the target host "
            "needs system.tools.nixos-rebuild.enableRun0Elevation = true."
        )


class ElevatorKind(Enum):
    """CLI-selectable elevation backends.

    The enum *value* is the :class:`Elevator` subclass to instantiate,
    ``str(member)`` is what ``--elevate`` accepts on the command line.
    """

    NONE = NoElevator
    SUDO = SudoElevator
    RUN0 = Run0Elevator

    @override
    def __str__(self) -> str:
        return self.name.lower()

    def make(self) -> Elevator:
        """Instantiate a fresh, unparameterised elevator of this kind."""
        cls: type[Elevator] = self.value
        return cls()

    @classmethod
    def choices(cls) -> list[str]:
        """All ``--elevate`` values, for argparse ``choices=``."""
        return [str(m) for m in cls]

    @classmethod
    def from_name(cls, name: str) -> Elevator:
        try:
            return cls[name.upper()].make()
        except KeyError:
            raise ElevateError(
                f"unknown elevation method {name!r}, choose from: "
                + ", ".join(cls.choices())
            ) from None


#: Singleton used as the default ``elevate=`` argument throughout.
NO_ELEVATOR: Final[Elevator] = NoElevator()
