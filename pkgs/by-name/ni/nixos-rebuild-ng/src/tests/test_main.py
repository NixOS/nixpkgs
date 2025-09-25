import logging
import os
import textwrap
import uuid
from pathlib import Path
from subprocess import PIPE, CompletedProcess
from typing import Any
from unittest.mock import ANY, Mock, call, patch

import pytest

import nixos_rebuild as nr

from .helpers import get_qualified_name

DEFAULT_RUN_KWARGS = {
    "env": ANY,
    "input": None,
    "text": True,
    "errors": "surrogateescape",
}


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

    r1, g1 = nr.parse_args(
        [
            "nixos-rebuild",
            "switch",
            "--install-grub",
            "--flake",
            "/etc/nixos",
            "--option",
            "foo1",
            "bar1",
            "--option",
            "foo2",
            "bar2",
            "--override-input",
            "override1",
            "input1",
            "--override-input",
            "override2",
            "input2",
            "--update-input",
            "input1",
            "--update-input",
            "input2",
        ]
    )
    assert nr.logger.level == logging.INFO
    assert r1.flake == "/etc/nixos"
    assert r1.install_bootloader is True
    assert r1.install_grub is True
    assert r1.profile_name == "system"
    assert r1.action == "switch"
    # round-trip test (ensure that we have the same flags as parsed)
    assert nr.utils.dict_to_flags(vars(g1["common_flags"])) == [
        "--option",
        "foo1",
        "bar1",
        "--option",
        "foo2",
        "bar2",
    ]
    assert nr.utils.dict_to_flags(vars(g1["flake_common_flags"])) == [
        "--update-input",
        "input1",
        "--update-input",
        "input2",
        "--override-input",
        "override1",
        "input1",
        "--override-input",
        "override2",
        "input2",
    ]

    r2, g2 = nr.parse_args(
        [
            "nixos-rebuild",
            "dry-run",
            "--flake",
            "--no-flake",
            "-f",
            "foo",
            "--attr",
            "bar",
            "-I",
            "include1",
            "-I",
            "include2",
            "-vvv",
            "--quiet",
            "--quiet",
        ]
    )
    assert nr.logger.level == logging.DEBUG
    assert r2.v == 3
    assert r2.flake is False
    assert r2.action == "dry-build"
    assert r2.file == "foo"
    assert r2.attr == "bar"
    # round-trip test (ensure that we have the same flags as parsed)
    assert nr.utils.dict_to_flags(vars(g2["common_flags"])) == [
        "-vvv",
        "--quiet",
        "--quiet",
    ]
    assert nr.utils.dict_to_flags(vars(g2["common_build_flags"])) == [
        "--include",
        "include1",
        "--include",
        "include2",
    ]


@patch.dict(
    os.environ,
    {"NIXOS_REBUILD_I_UNDERSTAND_THE_CONSEQUENCES_PLEASE_BREAK_MY_SYSTEM": "1"},
    clear=True,
)
@patch("subprocess.run", autospec=True)
def test_execute_nix_boot(mock_run: Mock, tmp_path: Path) -> None:
    nixpkgs_path = tmp_path / "nixpkgs"
    nixpkgs_path.mkdir()
    config_path = tmp_path / "test"
    config_path.touch()

    def run_side_effect(args: list[str], **kwargs: Any) -> CompletedProcess[str]:
        if args[0] == "nix-instantiate":
            return CompletedProcess([], 0, str(nixpkgs_path))
        elif args[0] == "git" and "rev-parse" in args:
            return CompletedProcess([], 0, "nixpkgs-rev")
        elif args[0] == "nix-build":
            return CompletedProcess([], 0, str(config_path))
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_side_effect

    nr.execute(["nixos-rebuild", "boot", "--no-flake", "-vvv", "--no-reexec"])

    assert mock_run.call_count == 7
    mock_run.assert_has_calls(
        [
            call(
                ["nix-instantiate", "--find-file", "nixpkgs", "-vvv"],
                stdout=PIPE,
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["git", "-C", nixpkgs_path, "rev-parse", "--short", "HEAD"],
                check=False,
                capture_output=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["git", "-C", nixpkgs_path, "diff", "--quiet"],
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "nix-build",
                    "<nixpkgs/nixos>",
                    "--attr",
                    "config.system.build.toplevel",
                    "-vvv",
                    "--no-out-link",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
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
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["test", "-d", "/run/systemd/system"],
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    *nr.nix.SWITCH_TO_CONFIGURATION_CMD_PREFIX,
                    config_path / "bin/switch-to-configuration",
                    "boot",
                ],
                check=True,
                **(
                    DEFAULT_RUN_KWARGS
                    | {
                        "env": {
                            "NIXOS_INSTALL_BOOTLOADER": "0",
                            "NIXOS_REBUILD_I_UNDERSTAND_THE_CONSEQUENCES_PLEASE_BREAK_MY_SYSTEM": "1",
                        }
                    }
                ),
            ),
        ]
    )


@patch.dict(os.environ, {}, clear=True)
@patch("subprocess.run", autospec=True)
def test_execute_nix_build_vm(mock_run: Mock, tmp_path: Path) -> None:
    config_path = tmp_path / "test"
    config_path.touch()

    def run_side_effect(args: list[str], **kwargs: Any) -> CompletedProcess[str]:
        if args[0] == "nix-build":
            return CompletedProcess([], 0, str(config_path))
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_side_effect

    nr.execute(
        [
            "nixos-rebuild",
            "build-vm",
            "--no-flake",
            "-I",
            "nixos-config=./configuration.nix",
            "-I",
            "nixpkgs=$HOME/.nix-defexpr/channels/pinned_nixpkgs",
            "--no-reexec",
        ]
    )

    assert mock_run.call_count == 1
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix-build",
                    "<nixpkgs/nixos>",
                    "--attr",
                    "config.system.build.vm",
                    "--include",
                    "nixos-config=./configuration.nix",
                    "--include",
                    "nixpkgs=$HOME/.nix-defexpr/channels/pinned_nixpkgs",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            )
        ]
    )


@patch.dict(os.environ, {}, clear=True)
@patch("subprocess.run", autospec=True)
def test_execute_nix_build_image_flake(mock_run: Mock, tmp_path: Path) -> None:
    config_path = tmp_path / "test"
    config_path.touch()

    def run_side_effect(args: list[str], **kwargs: Any) -> CompletedProcess[str]:
        if args[0] == "nix" and "eval" in args:
            return CompletedProcess(
                [],
                0,
                '"nixos-image-azure-25.05.20250102.6df2492-x86_64-linux.vhd"',
            )
        elif args[0] == "nix":
            return CompletedProcess([], 0, str(config_path))
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_side_effect

    nr.execute(
        [
            "nixos-rebuild",
            "build-image",
            "--image-variant",
            "azure",
            "--flake",
            "/path/to/config#hostname",
        ]
    )

    assert mock_run.call_count == 3
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix",
                    "eval",
                    "--json",
                    '/path/to/config#nixosConfigurations."hostname".config.system.build.images',
                    "--apply",
                    "builtins.attrNames",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "nix",
                    "--extra-experimental-features",
                    "nix-command flakes",
                    "build",
                    "--print-out-paths",
                    '/path/to/config#nixosConfigurations."hostname".config.system.build.images.azure',
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "nix",
                    "eval",
                    "--json",
                    '/path/to/config#nixosConfigurations."hostname".config.system.build.images.azure.passthru.filePath',
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
        ]
    )


@patch.dict(
    os.environ,
    {"NIXOS_REBUILD_I_UNDERSTAND_THE_CONSEQUENCES_PLEASE_BREAK_MY_SYSTEM": "1"},
    clear=True,
)
@patch("subprocess.run", autospec=True)
def test_execute_nix_switch_flake(mock_run: Mock, tmp_path: Path) -> None:
    config_path = tmp_path / "test"
    config_path.touch()

    def run_side_effect(args: list[str], **kwargs: Any) -> CompletedProcess[str]:
        if args[0] == "nix":
            return CompletedProcess([], 0, str(config_path))
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_side_effect

    nr.execute(
        [
            "nixos-rebuild",
            "switch",
            "--flake",
            "/path/to/config#hostname",
            "--install-bootloader",
            "--sudo",
            "--verbose",
            "--no-reexec",
            # https://github.com/NixOS/nixpkgs/issues/374050
            "--option",
            "narinfo-cache-negative-ttl",
            "1200",
        ]
    )

    assert mock_run.call_count == 4
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix",
                    "--extra-experimental-features",
                    "nix-command flakes",
                    "build",
                    "--print-out-paths",
                    '/path/to/config#nixosConfigurations."hostname".config.system.build.toplevel',
                    "-v",
                    "--option",
                    "narinfo-cache-negative-ttl",
                    "1200",
                    "--no-link",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "sudo",
                    "nix-env",
                    "-p",
                    Path("/nix/var/nix/profiles/system"),
                    "--set",
                    config_path,
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["test", "-d", "/run/systemd/system"],
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "sudo",
                    *nr.nix.SWITCH_TO_CONFIGURATION_CMD_PREFIX,
                    config_path / "bin/switch-to-configuration",
                    "switch",
                ],
                check=True,
                **(
                    DEFAULT_RUN_KWARGS
                    | {
                        "env": {
                            "NIXOS_INSTALL_BOOTLOADER": "1",
                            "NIXOS_REBUILD_I_UNDERSTAND_THE_CONSEQUENCES_PLEASE_BREAK_MY_SYSTEM": "1",
                        }
                    }
                ),
            ),
        ]
    )


@patch.dict(
    os.environ,
    {"NIXOS_REBUILD_I_UNDERSTAND_THE_CONSEQUENCES_PLEASE_BREAK_MY_SYSTEM": "1"},
    clear=True,
)
@patch("subprocess.run", autospec=True)
@patch("uuid.uuid4", autospec=True)
@patch(get_qualified_name(nr.services.cleanup_ssh), autospec=True)
def test_execute_nix_switch_build_target_host(
    mock_cleanup_ssh: Mock,
    mock_uuid4: Mock,
    mock_run: Mock,
    tmp_path: Path,
) -> None:
    config_path = tmp_path / "test"
    config_path.touch()

    def run_side_effect(args: list[str], **kwargs: Any) -> CompletedProcess[str]:
        if args[0] == "nix":
            return CompletedProcess([], 0, str(config_path))
        elif args[0] == "nix-instantiate" and "--find-file" in args:
            return CompletedProcess([], 1)
        elif args[0] == "nix-instantiate":
            return CompletedProcess([], 0, str(config_path))
        elif args[0] == "ssh" and "nix-store" in args:
            return CompletedProcess([], 0, "/tmp/tmpdir/config")
        elif args[0] == "ssh" and "mktemp" in args:
            return CompletedProcess([], 0, "/tmp/tmpdir")
        elif args[0] == "ssh" and "readlink" in args:
            return CompletedProcess([], 0, str(config_path))
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_side_effect
    mock_uuid4.return_value = uuid.UUID(int=0)

    nr.execute(
        [
            "nixos-rebuild",
            "switch",
            "--no-flake",
            "--sudo",
            "--build-host",
            "user@build-host",
            "--target-host",
            "user@target-host",
            "--no-reexec",
            # https://github.com/NixOS/nixpkgs/issues/381457
            "-I",
            "nixos-config=./configuration.nix",
            "-I",
            "nixpkgs=$HOME/.nix-defexpr/channels/pinned_nixpkgs",
        ]
    )

    assert mock_run.call_count == 11
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix-instantiate",
                    "--find-file",
                    "nixpkgs",
                    "--include",
                    "nixos-config=./configuration.nix",
                    "--include",
                    "nixpkgs=$HOME/.nix-defexpr/channels/pinned_nixpkgs",
                ],
                check=False,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "nix-instantiate",
                    "<nixpkgs/nixos>",
                    "--attr",
                    "config.system.build.toplevel",
                    "--add-root",
                    nr.tmpdir.TMPDIR_PATH / "00000000000000000000000000000000",
                    "--include",
                    "nixos-config=./configuration.nix",
                    "--include",
                    "nixpkgs=$HOME/.nix-defexpr/channels/pinned_nixpkgs",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["nix-copy-closure", "--to", "user@build-host", config_path],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@build-host",
                    "--",
                    "mktemp",
                    "-d",
                    "-t",
                    "nixos-rebuild.XXXXX",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@build-host",
                    "--",
                    "nix-store",
                    "--realise",
                    str(config_path),
                    "--add-root",
                    "/tmp/tmpdir/00000000000000000000000000000000",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@build-host",
                    "--",
                    "readlink",
                    "-f",
                    "/tmp/tmpdir/config",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@build-host",
                    "--",
                    "rm",
                    "-rf",
                    "/tmp/tmpdir",
                ],
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "nix",
                    "--extra-experimental-features",
                    "nix-command flakes",
                    "copy",
                    "--from",
                    "ssh://user@build-host",
                    "--to",
                    "ssh://user@target-host",
                    config_path,
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@target-host",
                    "--",
                    "sudo",
                    "nix-env",
                    "-p",
                    "/nix/var/nix/profiles/system",
                    "--set",
                    str(config_path),
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@target-host",
                    "--",
                    "test",
                    "-d",
                    "/run/systemd/system",
                ],
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@target-host",
                    "--",
                    "sudo",
                    "env",
                    "NIXOS_INSTALL_BOOTLOADER=0",
                    *nr.nix.SWITCH_TO_CONFIGURATION_CMD_PREFIX,
                    str(config_path / "bin/switch-to-configuration"),
                    "switch",
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
        ]
    )


@patch.dict(
    os.environ,
    {"NIXOS_REBUILD_I_UNDERSTAND_THE_CONSEQUENCES_PLEASE_BREAK_MY_SYSTEM": "1"},
    clear=True,
)
@patch("subprocess.run", autospec=True)
@patch(get_qualified_name(nr.services.cleanup_ssh), autospec=True)
def test_execute_nix_switch_flake_target_host(
    mock_cleanup_ssh: Mock,
    mock_run: Mock,
    tmp_path: Path,
) -> None:
    config_path = tmp_path / "test"
    config_path.touch()

    def run_side_effect(args: list[str], **kwargs: Any) -> CompletedProcess[str]:
        if args[0] == "nix":
            return CompletedProcess([], 0, str(config_path))
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_side_effect

    nr.execute(
        [
            "nixos-rebuild",
            "switch",
            "--flake",
            "/path/to/config#hostname",
            "--use-remote-sudo",
            "--target-host",
            "user@localhost",
            "--no-reexec",
        ]
    )

    assert mock_run.call_count == 5
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix",
                    "--extra-experimental-features",
                    "nix-command flakes",
                    "build",
                    "--print-out-paths",
                    '/path/to/config#nixosConfigurations."hostname".config.system.build.toplevel',
                    "--no-link",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["nix-copy-closure", "--to", "user@localhost", config_path],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@localhost",
                    "--",
                    "sudo",
                    "nix-env",
                    "-p",
                    "/nix/var/nix/profiles/system",
                    "--set",
                    str(config_path),
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@localhost",
                    "--",
                    "test",
                    "-d",
                    "/run/systemd/system",
                ],
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@localhost",
                    "--",
                    "sudo",
                    "env",
                    "NIXOS_INSTALL_BOOTLOADER=0",
                    *nr.nix.SWITCH_TO_CONFIGURATION_CMD_PREFIX,
                    str(config_path / "bin/switch-to-configuration"),
                    "switch",
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
        ]
    )


@patch.dict(
    os.environ,
    {"NIXOS_REBUILD_I_UNDERSTAND_THE_CONSEQUENCES_PLEASE_BREAK_MY_SYSTEM": "1"},
    clear=True,
)
@patch("subprocess.run", autospec=True)
@patch(get_qualified_name(nr.services.cleanup_ssh), autospec=True)
def test_execute_nix_switch_flake_build_host(
    mock_cleanup_ssh: Mock,
    mock_run: Mock,
    tmp_path: Path,
) -> None:
    config_path = tmp_path / "test"
    config_path.touch()

    def run_side_effect(args: list[str], **kwargs: Any) -> CompletedProcess[str]:
        if args[0] == "nix" and "eval" in args:
            return CompletedProcess([], 0, str(config_path))
        elif args[0] == "ssh" and "nix" in args:
            return CompletedProcess([], 0, str(config_path))
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_side_effect

    nr.execute(
        [
            "nixos-rebuild",
            "switch",
            "--flake",
            "/path/to/config#hostname",
            "--build-host",
            "user@localhost",
            "--no-reexec",
        ]
    )

    assert mock_run.call_count == 7
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix",
                    "--extra-experimental-features",
                    "nix-command flakes",
                    "eval",
                    "--raw",
                    '/path/to/config#nixosConfigurations."hostname".config.system.build.toplevel.drvPath',
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["nix-copy-closure", "--to", "user@localhost", config_path],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@localhost",
                    "--",
                    "nix",
                    "--extra-experimental-features",
                    "'nix-command flakes'",
                    "build",
                    f"'{config_path}^*'",
                    "--print-out-paths",
                    "--no-link",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "nix-copy-closure",
                    "--from",
                    "user@localhost",
                    config_path,
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
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
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["test", "-d", "/run/systemd/system"],
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    *nr.nix.SWITCH_TO_CONFIGURATION_CMD_PREFIX,
                    config_path / "bin/switch-to-configuration",
                    "switch",
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
        ]
    )


@patch("subprocess.run", autospec=True)
def test_execute_switch_rollback(mock_run: Mock, tmp_path: Path) -> None:
    nixpkgs_path = tmp_path / "nixpkgs"
    nixpkgs_path.touch()

    def run_side_effect(args: list[str], **kwargs: Any) -> CompletedProcess[str]:
        if args[0] == "nix-instantiate":
            return CompletedProcess([], 0, str(nixpkgs_path))
        elif args[0] == "git":
            return CompletedProcess([], 0, "")
        elif args[0] == "test":
            return CompletedProcess([], 1)
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_side_effect

    nr.execute(
        [
            "nixos-rebuild",
            "switch",
            "--rollback",
            "--install-bootloader",
            "--no-reexec",
            "--no-flake",
        ]
    )

    assert mock_run.call_count == 5
    mock_run.assert_has_calls(
        [
            call(
                ["nix-instantiate", "--find-file", "nixpkgs"],
                check=False,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "git",
                    "-C",
                    nixpkgs_path,
                    "rev-parse",
                    "--short",
                    "HEAD",
                ],
                check=False,
                capture_output=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "nix-env",
                    "--rollback",
                    "-p",
                    Path("/nix/var/nix/profiles/system"),
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["test", "-d", "/run/systemd/system"],
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    Path("/nix/var/nix/profiles/system/bin/switch-to-configuration"),
                    "switch",
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
        ]
    )


@patch("subprocess.run", autospec=True)
def test_execute_build(mock_run: Mock, tmp_path: Path) -> None:
    config_path = tmp_path / "test"
    config_path.touch()
    mock_run.side_effect = [
        # nixos_build_flake
        CompletedProcess([], 0, str(config_path)),
    ]

    nr.execute(["nixos-rebuild", "build", "--no-flake", "--no-reexec"])

    assert mock_run.call_count == 1
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix-build",
                    "<nixpkgs/nixos>",
                    "--attr",
                    "config.system.build.toplevel",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            )
        ]
    )


@patch("subprocess.run", autospec=True)
def test_execute_build_dry_run_build_and_target_remote(
    mock_run: Mock, tmp_path: Path
) -> None:
    config_path = tmp_path / "test"
    config_path.touch()
    mock_run.side_effect = [
        CompletedProcess([], 0, str(config_path)),
        CompletedProcess([], 0),
        CompletedProcess([], 0, str(config_path)),
    ]

    nr.execute(
        [
            "nixos-rebuild",
            "dry-build",
            "--flake",
            "/path/to/config#hostname",
            "--build-host",
            "user@build-host",
            "--target-host",
            "user@target-host",
        ]
    )

    assert mock_run.call_count == 3
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix",
                    "--extra-experimental-features",
                    "nix-command flakes",
                    "eval",
                    "--raw",
                    '/path/to/config#nixosConfigurations."hostname".config.system.build.toplevel.drvPath',
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["nix-copy-closure", "--to", "user@build-host", config_path],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    "ssh",
                    *nr.process.SSH_DEFAULT_OPTS,
                    "user@build-host",
                    "--",
                    "nix",
                    "--extra-experimental-features",
                    "'nix-command flakes'",
                    "build",
                    f"'{config_path}^*'",
                    "--print-out-paths",
                    "--dry-run",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
        ]
    )


@patch("subprocess.run", autospec=True)
def test_execute_test_flake(mock_run: Mock, tmp_path: Path) -> None:
    config_path = tmp_path / "test"
    config_path.touch()

    def run_side_effect(args: list[str], **kwargs: Any) -> CompletedProcess[str]:
        if args[0] == "nix":
            return CompletedProcess([], 0, str(config_path))
        elif args[0] == "test":
            return CompletedProcess([], 1)
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_side_effect

    nr.execute(
        ["nixos-rebuild", "test", "--flake", "github:user/repo#hostname", "--no-reexec"]
    )

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
                    'github:user/repo#nixosConfigurations."hostname".config.system.build.toplevel',
                    "--no-link",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["test", "-d", "/run/systemd/system"],
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [config_path / "bin/switch-to-configuration", "test"],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
        ]
    )


@patch("subprocess.run", autospec=True)
@patch("pathlib.Path.exists", autospec=True, return_value=True)
@patch("pathlib.Path.mkdir", autospec=True)
def test_execute_test_rollback(
    mock_path_mkdir: Mock,
    mock_path_exists: Mock,
    mock_run: Mock,
) -> None:
    def run_side_effect(args: list[str], **kwargs: Any) -> CompletedProcess[str]:
        if args[0] == "nix-env":
            return CompletedProcess(
                [],
                0,
                stdout=textwrap.dedent("""\
                2082   2024-11-07 22:58:56
                2083   2024-11-07 22:59:41
                2084   2024-11-07 23:54:17   (current)
                """),
            )
        elif args[0] == "test":
            return CompletedProcess([], 1)
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_side_effect

    nr.execute(
        ["nixos-rebuild", "test", "--rollback", "--profile-name", "foo", "--no-reexec"]
    )

    assert mock_run.call_count == 3
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix-env",
                    "-p",
                    Path("/nix/var/nix/profiles/system-profiles/foo"),
                    "--list-generations",
                ],
                check=True,
                stdout=PIPE,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                ["test", "-d", "/run/systemd/system"],
                check=False,
                **DEFAULT_RUN_KWARGS,
            ),
            call(
                [
                    Path(
                        "/nix/var/nix/profiles/system-profiles/foo-2083-link/bin/switch-to-configuration"
                    ),
                    "test",
                ],
                check=True,
                **DEFAULT_RUN_KWARGS,
            ),
        ]
    )
