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


def test_resolve() -> None:
    warnings: list[str] = []

    def w(msg: str) -> None:
        warnings.append(msg)

    resolve = e.ElevatorKind.resolve
    assert resolve(name=None, sudo=False, ask_password=False, warn=w) is e.NO_ELEVATOR
    assert isinstance(
        resolve(name="none", sudo=False, ask_password=False, warn=w), e.NoElevator
    )
    assert isinstance(
        resolve(name=None, sudo=True, ask_password=False, warn=w), e.SudoElevator
    )
    assert warnings == []

    # --elevate wins over --sudo alias
    assert isinstance(
        resolve(name="none", sudo=True, ask_password=False, warn=w), e.NoElevator
    )
    assert warnings == []

    # -S alone falls back to sudo with a warning
    assert isinstance(
        resolve(name=None, sudo=False, ask_password=True, warn=w), e.SudoElevator
    )
    assert len(warnings) == 1


def test_with_prompted_password(monkeypatch: MonkeyPatch) -> None:
    prompts: list[str] = []

    def fake_getpass(prompt: str) -> str:
        prompts.append(prompt)
        return "hunter2"

    monkeypatch.setattr(e.getpass, "getpass", fake_getpass)

    s = e.SudoElevator()
    assert s.with_prompted_password(ask=False, host_label="x") is s
    assert prompts == []

    sp = s.with_prompted_password(ask=True, host_label="user@host")
    assert isinstance(sp, e.SudoElevator)
    assert sp.password == "hunter2"
    assert prompts == ["[sudo] password for user@host: "]

    with pytest.raises(e.ElevateError):
        e.NoElevator().with_prompted_password(ask=True, host_label="localhost")
