from typing import Any
from unittest.mock import patch

from pytest import MonkeyPatch

import nixos_rebuild.elevate as e
import nixos_rebuild.models as m
import nixos_rebuild.process as p


def test_remote_env_shell_argv() -> None:
    assert e._remote_env_shell_argv([], {"PATH": e.PRESERVE_ENV}, ["cmd"]) == [
        "/bin/sh",
        "-c",
        '''exec /usr/bin/env -i PATH="${PATH-}" "$@"''',
        "sh",
        "cmd",
    ]
    assert e._remote_env_shell_argv(
        ["sudo"],
        {
            "PATH": e.PRESERVE_ENV,
            "LOCALE_ARCHIVE": e.PRESERVE_ENV,
            "NIXOS_NO_CHECK": e.PRESERVE_ENV,
            "NIXOS_INSTALL_BOOTLOADER": "0",
        },
        ["cmd", "arg"],
    ) == [
        "sudo",
        "/bin/sh",
        "-c",
        """exec /usr/bin/env -i PATH="${PATH-}" LOCALE_ARCHIVE="${LOCALE_ARCHIVE-}" """
        '''NIXOS_NO_CHECK="${NIXOS_NO_CHECK-}" NIXOS_INSTALL_BOOTLOADER=0 "$@"''',
        "sh",
        "cmd",
        "arg",
    ]
    assert e._remote_env_shell_argv(
        [], {"PATH": e.PRESERVE_ENV, "FOO": "some value"}, []
    ) == [
        "/bin/sh",
        "-c",
        '''exec /usr/bin/env -i PATH="${PATH-}" FOO='some value' "$@"''',
        "sh",
    ]


@patch.dict(p.os.environ, {"PATH": "/path/to/bin"}, clear=True)
@patch("subprocess.run", autospec=True)
def test_run_wrapper(mock_run: Any) -> None:
    p.run_wrapper(["test", "--with", "flags"], check=True)
    mock_run.assert_called_with(
        ["test", "--with", "flags"],
        check=True,
        text=True,
        errors="surrogateescape",
        env=None,
        input=None,
    )

    p.run_wrapper(
        ["test", "--with", "flags"],
        check=False,
        elevate=e.SudoElevator(),
        env={"FOO": "bar"},
    )
    mock_run.assert_called_with(
        [
            "sudo",
            "env",
            "-i",
            "PATH=/path/to/bin",
            "FOO=bar",
            "test",
            "--with",
            "flags",
        ],
        check=False,
        text=True,
        errors="surrogateescape",
        env=None,
        input=None,
    )

    p.run_wrapper(
        ["test", "--with", "flags"],
        check=False,
        append_local_env={"FOO": "bar"},
    )
    mock_run.assert_called_with(
        [
            "test",
            "--with",
            "flags",
        ],
        check=False,
        text=True,
        errors="surrogateescape",
        env={
            "FOO": "bar",
            "PATH": "/path/to/bin",
        },
        input=None,
    )

    p.run_wrapper(
        ["test", "--with", "flags"],
        check=False,
        env={"PATH": "/"},
        append_local_env={"FOO": "bar"},
    )
    mock_run.assert_called_with(
        [
            "test",
            "--with",
            "flags",
        ],
        check=False,
        text=True,
        errors="surrogateescape",
        env={
            "FOO": "bar",
            "PATH": "/",
        },
        input=None,
    )

    p.run_wrapper(
        ["test", "--with", "some flags"],
        check=True,
        remote=m.Remote("user@localhost", ["--ssh", "opt"], "ssh"),
    )
    mock_run.assert_called_with(
        [
            "ssh",
            "--ssh",
            "opt",
            *p.SSH_DEFAULT_OPTS,
            "user@localhost",
            "--",
            "/bin/sh",
            "-c",
            """'exec /usr/bin/env -i PATH="${PATH-}" "$@"'""",
            "sh",
            "test",
            "--with",
            "'some flags'",
        ],
        check=True,
        text=True,
        errors="surrogateescape",
        env=None,
        input=None,
    )

    p.run_wrapper(
        ["test", "--with", "flags"],
        check=True,
        elevate=e.SudoElevator(password="password"),
        env={"FOO": "bar"},
        remote=m.Remote("user@localhost", ["--ssh", "opt"], "ssh"),
    )
    mock_run.assert_called_with(
        [
            "ssh",
            "--ssh",
            "opt",
            *p.SSH_DEFAULT_OPTS,
            "user@localhost",
            "--",
            "sudo",
            "--prompt=",
            "--stdin",
            "/bin/sh",
            "-c",
            """'exec /usr/bin/env -i PATH="${PATH-}" FOO=bar "$@"'""",
            "sh",
            "test",
            "--with",
            "flags",
        ],
        check=True,
        env=None,
        text=True,
        errors="surrogateescape",
        input="password\n",
    )


@patch("subprocess.run", autospec=True)
def test__kill_long_running_ssh_process(mock_run: Any) -> None:
    p._kill_long_running_ssh_process(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command flakes",
            "build",
            "/nix/store/la0c8nmpr9xfclla0n4f3qq9iwgdrq4g-nixos-system-sankyuu-nixos-25.05.20250424.f771eb4.drv^*",
        ],
        m.Remote("user@localhost", opts=[], store_type="ssh"),
    )
    mock_run.assert_called_with(
        [
            "ssh",
            *p.SSH_DEFAULT_OPTS,
            "user@localhost",
            "--",
            "pkill",
            "--signal",
            "SIGINT",
            "--full",
            "--",
            r"nix\ \-\-extra\-experimental\-features\ 'nix\-command\ flakes'\ build\ '/nix/store/la0c8nmpr9xfclla0n4f3qq9iwgdrq4g\-nixos\-system\-sankyuu\-nixos\-25\.05\.20250424\.f771eb4\.drv\^\*'",
        ],
        check=False,
        capture_output=True,
        text=True,
    )


def test_remote_from_name(monkeypatch: MonkeyPatch) -> None:
    monkeypatch.setenv("NIX_SSHOPTS", "")
    assert m.Remote.from_arg("user@localhost", validate_opts=False) == m.Remote(
        "user@localhost",
        opts=[],
        store_type="ssh",
    )

    monkeypatch.setenv("NIX_SSHOPTS", "-f foo -b bar -t")
    assert m.Remote.from_arg("user@localhost") == m.Remote(
        "user@localhost",
        opts=["-f", "foo", "-b", "bar", "-t"],
        store_type="ssh",
    )


def test_ssh_host() -> None:
    ssh_remotes = {
        "user@[fe80::1%25eth0]": "user@fe80::1%eth0",
        "[fe80::c98b%25enp4s0]": "fe80::c98b%enp4s0",
        "user@[2001::5fce:a:198]": "user@2001::5fce:a:198",
        "[2001::dead:beef]": "2001::dead:beef",
        "root@192.168.178.1": "root@192.168.178.1",
        "192.168.178.1": "192.168.178.1",
        "user@localhost": "user@localhost",
        "localhost": "localhost",
        "user@example.org": "user@example.org",
        "example.org": "example.org",
        "ssh://explicit-store@localhost": "explicit-store@localhost",
    }
    ssh_ng_remotes = {
        "ssh-ng://example.org": "example.org",
    }

    for host_input, expected in ssh_remotes.items():
        remote = m.Remote.from_arg(host_input, validate_opts=False)
        assert remote is not None
        assert remote.ssh_host() == expected
        assert remote.store_type == "ssh"

    for host_input, expected in ssh_ng_remotes.items():
        remote = m.Remote.from_arg(host_input, validate_opts=False)
        assert remote is not None
        assert remote.ssh_host() == expected
        assert remote.store_type == "ssh-ng"


@patch.dict(p.os.environ, {"PATH": "/path/to/bin"}, clear=True)
@patch("subprocess.run", autospec=True)
def test_run_wrapper_run0(mock_run: Any) -> None:
    p.run_wrapper(["cmd", "arg"], elevate=e.Run0Elevator())
    mock_run.assert_called_with(
        ["run0", "--", "cmd", "arg"],
        check=True,
        text=True,
        errors="surrogateescape",
        env=None,
        input=None,
    )

    run0_script = (
        "exec systemd-run --uid=0 --pipe --quiet --wait --collect "
        "--service-type=exec --send-sighup "
        '--setenv=PATH="${PATH-}" -- "$@"'
    )

    p.run_wrapper(
        ["cmd", "arg"],
        elevate=e.Run0Elevator(),
        remote=m.Remote("user@host", [], "ssh"),
    )
    mock_run.assert_called_with(
        [
            "ssh",
            *p.SSH_DEFAULT_OPTS,
            "user@host",
            "--",
            "/bin/sh",
            "-c",
            p._quote_remote_arg(run0_script),
            "sh",
            "cmd",
            "arg",
        ],
        check=True,
        text=True,
        errors="surrogateescape",
        env=None,
        input=None,
    )

    p.run_wrapper(
        ["cmd"],
        elevate=e.Run0Elevator().with_password("pw"),
        remote=m.Remote("user@host", [], "ssh"),
    )
    mock_run.assert_called_with(
        [
            "ssh",
            *p.SSH_DEFAULT_OPTS,
            "user@host",
            "--",
            "/bin/sh",
            "-c",
            p._quote_remote_arg(e.Run0Elevator._AGENT_PICKER),
            "sh",
            # No toplevel bound, so the only candidate is PATH lookup.
            "polkit-stdin-agent",
            "--",
            "/bin/sh",
            "-c",
            p._quote_remote_arg(run0_script),
            "sh",
            "cmd",
        ],
        check=True,
        text=True,
        errors="surrogateescape",
        env=None,
        input="pw\n",
    )


@patch("subprocess.run", autospec=True)
def test_custom_sudo_args(mock_run: Any) -> None:
    with patch.dict(
        p.os.environ,
        {"NIX_SUDOOPTS": "--custom foo --args", "PATH": "/path/to/bin"},
        clear=True,
    ):
        p.run_wrapper(
            ["test"],
            check=False,
            elevate=e.SudoElevator(),
        )
    mock_run.assert_called_with(
        [
            "sudo",
            "--custom",
            "foo",
            "--args",
            "test",
        ],
        check=False,
        env=None,
        input=None,
        text=True,
        errors="surrogateescape",
    )

    with patch.dict(
        p.os.environ,
        {"NIX_SUDOOPTS": "--custom foo --args", "PATH": "/path/to/bin"},
        clear=True,
    ):
        p.run_wrapper(
            ["test"],
            check=False,
            elevate=e.SudoElevator(),
            remote=m.Remote("user@localhost", [], "ssh"),
        )
    mock_run.assert_called_with(
        [
            "ssh",
            *p.SSH_DEFAULT_OPTS,
            "user@localhost",
            "--",
            "sudo",
            "--custom",
            "foo",
            "--args",
            "/bin/sh",
            "-c",
            """'exec /usr/bin/env -i PATH="${PATH-}" "$@"'""",
            "sh",
            "test",
        ],
        check=False,
        env=None,
        input=None,
        text=True,
        errors="surrogateescape",
    )
