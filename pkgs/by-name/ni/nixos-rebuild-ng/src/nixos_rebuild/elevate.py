"""Privilege-elevation backends for activation commands.

An :class:`Elevator` describes how to wrap a command so it runs as root,
both on the local machine and on a remote target host over SSH (where no
controlling terminal is available), and how to feed it a pre-supplied
password when the backend supports that. ``run_wrapper`` and its callers
carry a single ``elevate: Elevator`` value and let it produce the command
prefix and stdin.
"""

from __future__ import annotations

import os
import shlex
from abc import ABC, abstractmethod
from dataclasses import dataclass, field, replace
from enum import Enum
from typing import Final, Self, override


@dataclass(frozen=True)
class Wrapped:
    """Result of wrapping a command for elevation."""

    #: Arguments to prepend to the command. Kept as ``list[str]`` rather than
    #: the wider ``process.Args`` because elevators only ever prepend plain
    #: strings; callers splice this into their existing ``Args`` list.
    prefix: list[str]
    #: Text to send on the wrapped command's stdin (typically a password
    #: followed by a newline), or ``None`` to leave stdin alone.
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
    def wrap_remote(self) -> Wrapped:
        """Wrap a command run on a target host over SSH.

        The remote side has no controlling terminal, so backends that need
        interactive prompts must either accept a pre-supplied password
        (see :meth:`with_password`) or rely on a passwordless policy on
        the target.
        """

    @abstractmethod
    def with_password(self, password: str) -> Self:
        """Return a copy that will feed *password* to the backend.

        Backends that have no stdin path for credentials must raise
        :class:`ElevateError` with a hint pointing at the alternative
        (e.g. a polkit rule).
        """

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
    def wrap_remote(self) -> Wrapped:
        return Wrapped(prefix=[])

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
        return self._wrap()

    @override
    def wrap_remote(self) -> Wrapped:
        return self._wrap()

    def _wrap(self) -> Wrapped:
        if self.password is not None:
            return Wrapped(
                prefix=["sudo", "--prompt=", "--stdin", *self.extra_opts],
                stdin=self.password + "\n",
            )
        return Wrapped(prefix=["sudo", *self.extra_opts])

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


class ElevatorKind(Enum):
    """CLI-selectable elevation backends.

    The enum *value* is the :class:`Elevator` subclass to instantiate;
    ``str(member)`` is what ``--elevate`` accepts on the command line.
    Extended by later commits.
    """

    NONE = NoElevator
    SUDO = SudoElevator

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
                f"unknown elevation method {name!r}; choose from: "
                + ", ".join(cls.choices())
            ) from None


#: Singleton used as the default ``elevate=`` argument throughout.
NO_ELEVATOR: Final[Elevator] = NoElevator()
