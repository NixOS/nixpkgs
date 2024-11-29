import textwrap
from pathlib import Path
from subprocess import PIPE, CompletedProcess
from typing import Any
from unittest.mock import call, patch

import pytest

import nixos_rebuild as nr

from .helpers import get_qualified_name


@pytest.fixture(autouse=True)
def setup(monkeypatch: Any) -> None:
    monkeypatch.setenv("LOCALE_ARCHIVE", "/locale")


def test_parse_args() -> None:
    with pytest.raises(SystemExit) as e:
        nr.parse_args(["nixos-rebuild", "unknown-action"])
    assert e.value.code == 2

    with pytest.raises(SystemExit) as e:
        nr.parse_args(["nixos-rebuild", "test", "--flake", "--file", "abc"])
    assert e.value.code == 2

    with pytest.raises(SystemExit) as e:
        nr.parse_args(["nixos-rebuild", "edit", "--attr", "attr"])
    assert e.value.code == 2

    r1, remainder = nr.parse_args(
        [
            "nixos-rebuild",
            "switch",
            "--install-grub",
            "--flake",
            "/etc/nixos",
            "--extra",
            "flag",
        ]
    )
    assert remainder == ["--extra", "flag"]
    assert r1.flake == "/etc/nixos"
    assert r1.install_bootloader is True
    assert r1.install_grub is True
    assert r1.profile_name == "system"
    assert r1.action == "switch"

    r2, remainder = nr.parse_args(
        [
            "nixos-rebuild",
            "dry-run",
            "--flake",
            "--no-flake",
            "-f",
            "foo",
            "--attr",
            "bar",
        ]
    )
    assert remainder == []
    assert r2.flake is False
    assert r2.action == "dry-build"
    assert r2.file == "foo"
    assert r2.attr == "bar"


@patch(get_qualified_name(nr.nix.run, nr.nix), autospec=True)
@patch(get_qualified_name(nr.nix.shutil.which), autospec=True, return_value="/bin/git")
def test_execute_nix_boot(mock_which: Any, mock_run: Any, tmp_path: Path) -> None:
    nixpkgs_path = tmp_path / "nixpkgs"
    nixpkgs_path.mkdir()
    config_path = tmp_path / "test"
    config_path.touch()
    mock_run.side_effect = [
        # update_nixpkgs_rev
        CompletedProcess([], 0, str(nixpkgs_path)),
        CompletedProcess([], 0, "nixpkgs-rev"),
        CompletedProcess([], 0),
        # nixos_build
        CompletedProcess([], 0, str(config_path)),
        # set_profile
        CompletedProcess([], 0),
        # switch_to_configuration
        CompletedProcess([], 0),
    ]

    nr.execute(["nixos-rebuild", "boot", "--no-flake", "-vvv"])

    assert nr.VERBOSE is True
    assert mock_run.call_count == 6
    mock_run.assert_has_calls(
        [
            call(
                ["nix-instantiate", "--find-file", "nixpkgs", "-vvv"],
                stdout=PIPE,
                check=False,
                text=True,
            ),
            call(
                ["git", "-C", nixpkgs_path, "rev-parse", "--short", "HEAD"],
                check=False,
                stdout=PIPE,
                text=True,
            ),
            call(
                ["git", "-C", nixpkgs_path, "diff", "--quiet"],
                check=False,
            ),
            call(
                [
                    "nix-build",
                    "<nixpkgs/nixos>",
                    "--attr",
                    "system",
                    "--no-out-link",
                    "-vvv",
                ],
                check=True,
                text=True,
                stdout=PIPE,
            ),
            call(
                [
                    "nix-env",
                    "-p",
                    Path("/nix/var/nix/profiles/system"),
                    "--set",
                    config_path,
                ],
                check=True,
            ),
            call(
                [config_path / "bin/switch-to-configuration", "boot"],
                env={"NIXOS_INSTALL_BOOTLOADER": "0", "LOCALE_ARCHIVE": "/locale"},
                check=True,
            ),
        ]
    )


@patch(get_qualified_name(nr.nix.run, nr.nix), autospec=True)
def test_execute_nix_switch_flake(mock_run: Any, tmp_path: Path) -> None:
    config_path = tmp_path / "test"
    config_path.touch()
    mock_run.side_effect = [
        # nixos_build_flake
        CompletedProcess([], 0, str(config_path)),
        # set_profile
        CompletedProcess([], 0),
        # switch_to_configuration
        CompletedProcess([], 0),
    ]

    nr.execute(
        [
            "nixos-rebuild",
            "switch",
            "--flake",
            "/path/to/config#hostname",
            "--install-bootloader",
            "--verbose",
        ]
    )

    assert nr.VERBOSE is True
    assert mock_run.call_count == 3
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix",
                    "--extra-experimental-features",
                    "nix-command flakes",
                    "build",
                    "--print-out-paths",
                    "/path/to/config#nixosConfigurations.hostname.config.system.build.toplevel",
                    "--no-link",
                    "--verbose",
                ],
                check=True,
                text=True,
                stdout=PIPE,
            ),
            call(
                [
                    "nix-env",
                    "-p",
                    Path("/nix/var/nix/profiles/system"),
                    "--set",
                    config_path,
                ],
                check=True,
            ),
            call(
                [config_path / "bin/switch-to-configuration", "switch"],
                env={"NIXOS_INSTALL_BOOTLOADER": "1", "LOCALE_ARCHIVE": "/locale"},
                check=True,
            ),
        ]
    )


@patch(get_qualified_name(nr.nix.run, nr.nix), autospec=True)
def test_execute_switch_rollback(mock_run: Any, tmp_path: Path) -> None:
    nixpkgs_path = tmp_path / "nixpkgs"
    nixpkgs_path.touch()

    nr.execute(["nixos-rebuild", "switch", "--rollback", "--install-bootloader"])

    assert nr.VERBOSE is False
    assert mock_run.call_count == 3
    # ignoring update_nixpkgs_rev calls
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix-env",
                    "--rollback",
                    "-p",
                    Path("/nix/var/nix/profiles/system"),
                ],
                check=True,
            ),
            call(
                [
                    Path("/nix/var/nix/profiles/system/bin/switch-to-configuration"),
                    "switch",
                ],
                env={"NIXOS_INSTALL_BOOTLOADER": "1", "LOCALE_ARCHIVE": "/locale"},
                check=True,
            ),
        ]
    )


@patch(get_qualified_name(nr.nix.run, nr.nix), autospec=True)
@patch(get_qualified_name(nr.nix.Path.exists, nr.nix), autospec=True, return_value=True)
@patch(get_qualified_name(nr.nix.Path.mkdir, nr.nix), autospec=True)
def test_execute_test_rollback(
    mock_path_mkdir: Any,
    mock_path_exists: Any,
    mock_run: Any,
) -> None:
    mock_run.side_effect = [
        # rollback_temporary_profile
        CompletedProcess(
            [],
            0,
            stdout=textwrap.dedent("""\
            2082   2024-11-07 22:58:56
            2083   2024-11-07 22:59:41
            2084   2024-11-07 23:54:17   (current)
            """),
        ),
        # switch_to_configuration
        CompletedProcess([], 0),
    ]

    nr.execute(
        [
            "nixos-rebuild",
            "test",
            "--rollback",
            "--profile-name",
            "foo",
        ]
    )

    assert nr.VERBOSE is False
    assert mock_run.call_count == 2
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix-env",
                    "-p",
                    Path("/nix/var/nix/profiles/system-profiles/foo"),
                    "--list-generations",
                ],
                text=True,
                stdout=True,
                check=True,
            ),
            call(
                [
                    Path(
                        "/nix/var/nix/profiles/system-profiles/foo-2083-link/bin/switch-to-configuration"
                    ),
                    "test",
                ],
                env={"NIXOS_INSTALL_BOOTLOADER": "0", "LOCALE_ARCHIVE": "/locale"},
                check=True,
            ),
        ]
    )
