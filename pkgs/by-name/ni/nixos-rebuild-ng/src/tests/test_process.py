from typing import Any
from unittest.mock import patch

import nixos_rebuild.models as m
import nixos_rebuild.process as p

from .helpers import get_qualified_name


@patch(get_qualified_name(p.subprocess.run), autospec=True)
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


def test_remote_from_name(monkeypatch: Any) -> None:
    monkeypatch.setenv("NIX_SSHOPTS", "")
    assert m.Remote.from_arg("user@localhost", None, False) == m.Remote(
        "user@localhost",
        opts=[],
        sudo_password=None,
    )

    # get_qualified_name doesn't work because getpass is aliased to another
    # function
    with patch(f"{p.__name__}.getpass", return_value="password"):
        monkeypatch.setenv("NIX_SSHOPTS", "-f foo -b bar -t")
        assert m.Remote.from_arg("user@localhost", True, True) == m.Remote(
            "user@localhost",
            opts=["-f", "foo", "-b", "bar", "-t"],
            sudo_password="password",
        )
