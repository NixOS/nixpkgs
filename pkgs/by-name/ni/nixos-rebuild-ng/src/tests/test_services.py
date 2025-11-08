import os
from pathlib import Path
from unittest.mock import ANY, Mock, call, patch

from pytest import MonkeyPatch

import nixos_rebuild as n
import nixos_rebuild.services as s

from .helpers import get_qualified_name


@patch.dict(os.environ, {}, clear=True)
@patch("os.execve", autospec=True)
@patch(get_qualified_name(s.nix.build), autospec=True)
def test_reexec(mock_build: Mock, mock_execve: Mock, monkeypatch: MonkeyPatch) -> None:
    monkeypatch.setattr(s, "EXECUTABLE", "nixos-rebuild-ng")
    argv = ["/path/bin/nixos-rebuild-ng", "switch", "--no-flake"]
    args, _ = n.parse_args(argv)
    mock_build.return_value = Path("/path")

    s.reexec(argv, args, {"build": True}, {"flake": True})
    mock_build.assert_has_calls(
        [
            call(
                s.NIXOS_REBUILD_ATTR,
                n.models.BuildAttr(ANY, ANY),
                {"build": True, "no_out_link": True},
            )
        ]
    )
    # do not exec if there is no new version
    mock_execve.assert_not_called()

    mock_build.return_value = Path("/path/new")

    s.reexec(argv, args, {}, {})
    # exec in the new version successfully
    mock_execve.assert_called_once_with(
        Path("/path/new/bin/nixos-rebuild-ng"),
        ["/path/bin/nixos-rebuild-ng", "switch", "--no-flake"],
        {s.NIXOS_REBUILD_REEXEC_ENV: "1"},
    )

    mock_execve.reset_mock()
    mock_execve.side_effect = [OSError("BOOM"), None]

    s.reexec(argv, args, {}, {})
    # exec in the previous version if the new version fails
    mock_execve.assert_any_call(
        Path("/path/bin/nixos-rebuild-ng"),
        ["/path/bin/nixos-rebuild-ng", "switch", "--no-flake"],
        {s.NIXOS_REBUILD_REEXEC_ENV: "1"},
    )


@patch.dict(os.environ, {}, clear=True)
@patch("os.execve", autospec=True)
@patch(get_qualified_name(s.nix.build_flake), autospec=True)
def test_reexec_flake(
    mock_build: Mock, mock_execve: Mock, monkeypatch: MonkeyPatch
) -> None:
    monkeypatch.setattr(s, "EXECUTABLE", "nixos-rebuild-ng")
    argv = ["/path/bin/nixos-rebuild-ng", "switch", "--flake"]
    args, _ = n.parse_args(argv)
    mock_build.return_value = Path("/path")

    s.reexec(argv, args, {"build": True}, {"flake": True})
    mock_build.assert_called_once_with(
        s.NIXOS_REBUILD_ATTR,
        n.models.Flake(ANY, ANY),
        {"flake": True, "no_link": True},
    )
    # do not exec if there is no new version
    mock_execve.assert_not_called()

    mock_build.return_value = Path("/path/new")

    s.reexec(argv, args, {}, {})
    # exec in the new version successfully
    mock_execve.assert_called_once_with(
        Path("/path/new/bin/nixos-rebuild-ng"),
        ["/path/bin/nixos-rebuild-ng", "switch", "--flake"],
        {s.NIXOS_REBUILD_REEXEC_ENV: "1"},
    )

    mock_execve.reset_mock()
    mock_execve.side_effect = [OSError("BOOM"), None]

    s.reexec(argv, args, {}, {})
    # exec in the previous version if the new version fails
    mock_execve.assert_any_call(
        Path("/path/bin/nixos-rebuild-ng"),
        ["/path/bin/nixos-rebuild-ng", "switch", "--flake"],
        {s.NIXOS_REBUILD_REEXEC_ENV: "1"},
    )


@patch.dict(os.environ, {s.NIXOS_REBUILD_REEXEC_ENV: "1"}, clear=True)
@patch("os.execve", autospec=True)
@patch(get_qualified_name(s.nix.build_flake), autospec=True)
def test_reexec_skip_if_already_reexec(mock_build: Mock, mock_execve: Mock) -> None:
    argv = ["/path/bin/nixos-rebuild-ng", "switch", "--flake"]
    args, _ = n.parse_args(argv)
    mock_build.return_value = Path("/path")

    s.reexec(argv, args, {"build": True}, {"flake": True})
    mock_build.assert_not_called()
    mock_execve.assert_not_called()
