from typing import Any
from unittest.mock import patch

from pytest import MonkeyPatch

import nixos_rebuild.models as m
import nixos_rebuild.process as p


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

    with patch.dict(p.os.environ, {"PATH": "/path/to/bin"}, clear=True):
        p.run_wrapper(
            ["test", "--with", "flags"],
            check=False,
            sudo=True,
            extra_env={"FOO": "bar"},
        )
    mock_run.assert_called_with(
        ["sudo", "test", "--with", "flags"],
        check=False,
        text=True,
        errors="surrogateescape",
        env={
            "PATH": "/path/to/bin",
            "FOO": "bar",
        },
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
        extra_env={"FOO": "bar"},
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
            "env",
            "FOO=bar",
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
