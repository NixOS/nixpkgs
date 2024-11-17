from typing import Any
from unittest.mock import patch

import nixos_rebuild.models as m
import nixos_rebuild.process as p

from .helpers import get_qualified_name


@patch(get_qualified_name(p.subprocess.run))
def test_run(mock_run: Any) -> None:
    p.run(["test", "--with", "flags"], check=True)
    mock_run.assert_called_with(["test", "--with", "flags"], check=True)

    p.run(["test", "--with", "flags"], check=False, sudo=True)
    mock_run.assert_called_with(["sudo", "test", "--with", "flags"], check=False)

    p.run(
        ["test", "--with", "flags"],
        check=True,
        remote=m.SSH("user@localhost", ["--ssh", "opt"]),
    )
    mock_run.assert_called_with(
        ["ssh", "--ssh", "opt", "user@localhost", "--", "test", "--with", "flags"],
        check=True,
    )

    p.run(
        ["test", "--with", "flags"],
        check=True,
        sudo=True,
        remote=m.SSH("user@localhost", ["--ssh", "opt"]),
    )
    mock_run.assert_called_with(
        [
            "ssh",
            "--ssh",
            "opt",
            "user@localhost",
            "--",
            "sudo",
            "test",
            "--with",
            "flags",
        ],
        check=True,
    )
