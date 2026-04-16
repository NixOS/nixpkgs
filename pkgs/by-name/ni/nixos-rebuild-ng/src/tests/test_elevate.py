import pytest
from pytest import MonkeyPatch

import nixos_rebuild.elevate as e


def test_no_elevator() -> None:
    n = e.NoElevator()
    assert not n.elevates
    assert n.wrap_local() == e.Wrapped(prefix=[])
    assert n.wrap_remote() == e.Wrapped(prefix=[])
    with pytest.raises(e.ElevateError):
        n.with_password("x")


def test_sudo_elevator(monkeypatch: MonkeyPatch) -> None:
    monkeypatch.delenv("NIX_SUDOOPTS", raising=False)

    s = e.SudoElevator()
    assert s.elevates
    assert s.wrap_local() == e.Wrapped(prefix=["sudo"])
    assert s.wrap_remote() == e.Wrapped(prefix=["sudo"])
    assert s.on_remote_failure() is not None

    sp = s.with_password("hunter2")
    assert sp.wrap_remote() == e.Wrapped(
        prefix=["sudo", "--prompt=", "--stdin"],
        stdin="hunter2\n",
    )
    assert sp.on_remote_failure() is None
    # original unchanged
    assert s.password is None


def test_sudo_elevator_extra_opts(monkeypatch: MonkeyPatch) -> None:
    monkeypatch.setenv("NIX_SUDOOPTS", "--preserve-env=FOO -H")
    s = e.SudoElevator()
    assert s.wrap_local() == e.Wrapped(prefix=["sudo", "--preserve-env=FOO", "-H"])
    assert s.with_password("p").wrap_remote() == e.Wrapped(
        prefix=["sudo", "--prompt=", "--stdin", "--preserve-env=FOO", "-H"],
        stdin="p\n",
    )


def test_elevator_kind() -> None:
    assert isinstance(e.ElevatorKind.from_name("sudo"), e.SudoElevator)
    assert isinstance(e.ElevatorKind.from_name("none"), e.NoElevator)
    with pytest.raises(e.ElevateError):
        e.ElevatorKind.from_name("doas")
    assert set(e.ElevatorKind.choices()) == {"none", "sudo"}
