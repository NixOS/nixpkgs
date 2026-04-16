from pathlib import PurePosixPath

import pytest
from pytest import MonkeyPatch

import nixos_rebuild.elevate as e


def test_no_elevator() -> None:
    n = e.NoElevator()
    assert not n.elevates
    assert n.wrap_local() == e.Wrapped(prefix=[])
    rw = n.wrap_remote({"PATH": e.PRESERVE_ENV}, ["cmd"])
    assert rw.stdin is None
    assert rw.argv[:2] == ["/bin/sh", "-c"]
    assert rw.argv[-1] == "cmd"
    with pytest.raises(e.ElevateError):
        n.with_password("x")


def test_sudo_elevator(monkeypatch: MonkeyPatch) -> None:
    monkeypatch.delenv("NIX_SUDOOPTS", raising=False)

    s = e.SudoElevator()
    assert s.elevates
    assert s.wrap_local() == e.Wrapped(prefix=["sudo"])
    rw = s.wrap_remote({"PATH": e.PRESERVE_ENV}, ["cmd"])
    assert rw.argv[0] == "sudo"
    assert rw.argv[1:3] == ["/bin/sh", "-c"]
    assert rw.stdin is None
    assert s.on_remote_failure() is not None

    sp = s.with_password("hunter2")
    rw = sp.wrap_remote({"PATH": e.PRESERVE_ENV}, ["cmd"])
    assert rw.argv[:3] == ["sudo", "--prompt=", "--stdin"]
    assert rw.stdin == "hunter2\n"
    assert sp.on_remote_failure() is None
    # original unchanged
    assert s.password is None


def test_sudo_elevator_extra_opts(monkeypatch: MonkeyPatch) -> None:
    monkeypatch.setenv("NIX_SUDOOPTS", "--preserve-env=FOO -H")
    s = e.SudoElevator()
    assert s.wrap_local() == e.Wrapped(prefix=["sudo", "--preserve-env=FOO", "-H"])
    rw = s.with_password("p").wrap_remote({"PATH": e.PRESERVE_ENV}, ["cmd"])
    assert rw.argv[:5] == ["sudo", "--prompt=", "--stdin", "--preserve-env=FOO", "-H"]
    assert rw.stdin == "p\n"


def test_run0_elevator() -> None:
    r = e.Run0Elevator()
    assert r.elevates
    assert r.wrap_local() == e.Wrapped(prefix=["run0", "--"])
    assert r.on_remote_failure() is not None

    rp = r.with_password("hunter2")
    w = rp.wrap_local()
    assert w.prefix[0] == "polkit-stdin-agent"
    assert "run0" in w.prefix
    assert w.stdin == "hunter2\n"
    # With a password the failure hint points at the agent, not at -S.
    hint = rp.on_remote_failure()
    assert hint is not None and "polkit-stdin-agent" in hint


def test_run0_elevator_remote() -> None:
    r = e.Run0Elevator()

    # No password: /bin/sh wrapper around systemd-run, env passed via
    # --setenv so it is resolved in the SSH login shell rather than
    # inside the transient unit (which has a useless PATH on NixOS).
    rw = r.wrap_remote(
        {"PATH": e.PRESERVE_ENV, "NIXOS_INSTALL_BOOTLOADER": "1"},
        ["nix-env", "-p", "/profile"],
    )
    assert rw.stdin is None
    assert rw.argv[:2] == ["/bin/sh", "-c"]
    script = rw.argv[2]
    assert isinstance(script, str)
    assert script.startswith("exec systemd-run --uid=0 --pipe ")
    assert '--setenv=PATH="${PATH-}"' in script
    assert "--setenv=NIXOS_INSTALL_BOOTLOADER=1" in script
    assert script.endswith(' -- "$@"')
    assert rw.argv[3:] == ["sh", "nix-env", "-p", "/profile"]

    # With password: an agent-picker /bin/sh wraps the inner /bin/sh, so
    # the agent is registered for the inner shell (and the systemd-run it
    # execs into). With no toplevel bound the only candidate is bare-name
    # PATH lookup.
    rw = r.with_password("pw").wrap_remote({"PATH": e.PRESERVE_ENV}, ["cmd"])
    assert rw.stdin == "pw\n"
    assert rw.argv[:3] == ["/bin/sh", "-c", e.Run0Elevator._AGENT_PICKER]
    sep = rw.argv.index("--")
    assert rw.argv[3:sep] == ["sh", "polkit-stdin-agent"]
    assert rw.argv[sep + 1 : sep + 3] == ["/bin/sh", "-c"]

    # Explicit values containing spaces are shell-quoted inside the
    # script (the whole thing is later shlex.quoted again for SSH).
    rw = r.wrap_remote({"FOO": "a b"}, ["cmd"])
    script = rw.argv[2]
    assert isinstance(script, str)
    assert "--setenv='FOO=a b'" in script


def test_run0_for_target_config() -> None:
    toplevel = PurePosixPath("/nix/store/aaaa-nixos-system")
    r = e.Run0Elevator().with_password("pw").for_target_config(toplevel)
    assert r.remote_agent == f"{toplevel}/sw/bin/polkit-stdin-agent"

    rw = r.wrap_remote({"PATH": e.PRESERVE_ENV}, ["cmd"])
    sep = rw.argv.index("--")
    # Order matters: target-arch toplevel first, then PATH.
    assert rw.argv[4:sep] == [
        f"{toplevel}/sw/bin/polkit-stdin-agent",
        "polkit-stdin-agent",
    ]
    # Inner argv is preserved verbatim after the separator.
    assert rw.argv[sep + 1 : sep + 3] == ["/bin/sh", "-c"]
    assert rw.argv[-1] == "cmd"

    # Non-run0 elevators ignore the toplevel.
    s = e.SudoElevator()
    assert s.for_target_config(toplevel) is s


def test_elevator_kind() -> None:
    assert isinstance(e.ElevatorKind.from_name("sudo"), e.SudoElevator)
    assert isinstance(e.ElevatorKind.from_name("run0"), e.Run0Elevator)
    assert isinstance(e.ElevatorKind.from_name("none"), e.NoElevator)
    with pytest.raises(e.ElevateError):
        e.ElevatorKind.from_name("doas")
    assert set(e.ElevatorKind.choices()) == {"none", "sudo", "run0"}


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
