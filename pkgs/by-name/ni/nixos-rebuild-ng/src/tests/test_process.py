from typing import Any
from unittest.mock import patch

from pytest import MonkeyPatch

import nixos_rebuild.models as m
import nixos_rebuild.process as p


def test_remote_shell_script() -> None:
    assert p._remote_shell_script({"PATH": p.PRESERVE_ENV}) == (
        '''exec env -i PATH="${PATH-}" "$@"'''
    )
    assert p._remote_shell_script(
        {
            "PATH": p.PRESERVE_ENV,
            "LOCALE_ARCHIVE": p.PRESERVE_ENV,
            "NIXOS_NO_CHECK": p.PRESERVE_ENV,
            "NIXOS_INSTALL_BOOTLOADER": "0",
        }
    ) == (
        """exec env -i PATH="${PATH-}" LOCALE_ARCHIVE="${LOCALE_ARCHIVE-}" """
        '''NIXOS_NO_CHECK="${NIXOS_NO_CHECK-}" NIXOS_INSTALL_BOOTLOADER=0 "$@"'''
    )
    assert p._remote_shell_script({"PATH": p.PRESERVE_ENV, "FOO": "some value"}) == (
        '''exec env -i PATH="${PATH-}" FOO='some value' "$@"'''
    )


@patch.dict(p.os.environ, {"PATH": "/path/to/bin"}, clear=True)
@patch("subprocess.run", autospec=True)
def test_run(mock_run: Any) -> None:
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
        sudo=True,
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
        ["test", "--with", "some flags"],
        check=True,
        remote=m.Remote("user@localhost", ["--ssh", "opt"], "password"),
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
            """'exec env -i PATH="${PATH-}" "$@"'""",
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
        sudo=True,
        env={"FOO": "bar"},
        remote=m.Remote("user@localhost", ["--ssh", "opt"], "password"),
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
            """'exec env -i PATH="${PATH-}" FOO=bar "$@"'""",
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
        m.Remote("user@localhost", opts=[], sudo_password=None),
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
    assert m.Remote.from_arg("user@localhost", None, False) == m.Remote(
        "user@localhost",
        opts=[],
        sudo_password=None,
    )

    with patch("getpass.getpass", autospec=True, return_value="password"):
        monkeypatch.setenv("NIX_SSHOPTS", "-f foo -b bar -t")
        assert m.Remote.from_arg("user@localhost", True, True) == m.Remote(
            "user@localhost",
            opts=["-f", "foo", "-b", "bar", "-t"],
            sudo_password="password",
        )


def test_ssh_host() -> None:
    remotes = {
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
    }

    for host_input, expected in remotes.items():
        remote = m.Remote.from_arg(host_input, None, False)
        assert remote is not None
        assert remote.ssh_host() == expected


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
            sudo=True,
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
            sudo=True,
            remote=m.Remote("user@localhost", [], None),
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
            """'exec env -i PATH="${PATH-}" "$@"'""",
            "sh",
            "test",
        ],
        check=False,
        env=None,
        input=None,
        text=True,
        errors="surrogateescape",
    )
