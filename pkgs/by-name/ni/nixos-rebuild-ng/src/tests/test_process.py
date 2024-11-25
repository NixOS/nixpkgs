from typing import Any
from unittest.mock import patch

import pytest

import nixos_rebuild.models as m
import nixos_rebuild.process as p

from .helpers import get_qualified_name


@patch(get_qualified_name(p.subprocess.run))
def test_run(mock_run: Any) -> None:
    p.run_wrapper(["test", "--with", "flags"], check=True)
    mock_run.assert_called_with(
        ["test", "--with", "flags"],
        check=True,
        text=True,
        errors="surrogateescape",
        env=None,
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
    )

    p.run_wrapper(
        ["test", "--with", "flags"],
        check=True,
        remote=m.Remote("user@localhost", ["--ssh", "opt"], False),
    )
    mock_run.assert_called_with(
        ["ssh", "--ssh", "opt", "user@localhost", "--", "test", "--with", "flags"],
        check=True,
        text=True,
        errors="surrogateescape",
        env=None,
    )

    p.run_wrapper(
        ["test", "--with", "flags"],
        check=True,
        sudo=True,
        extra_env={"FOO": "bar"},
        remote=m.Remote("user@localhost", ["--ssh", "opt"], True),
    )
    mock_run.assert_called_with(
        [
            "ssh",
            "-t",
            "--ssh",
            "opt",
            "user@localhost",
            "--",
            "sudo",
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
    )

    with pytest.raises(AssertionError):
        p.run_wrapper(
            ["test", "--with", "flags"],
            check=False,
            allow_tty=True,
            remote=m.Remote("user@localhost", [], False),
            capture_output=True,
        )
