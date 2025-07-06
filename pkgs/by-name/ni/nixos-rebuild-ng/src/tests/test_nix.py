import textwrap
import uuid
from pathlib import Path
from subprocess import PIPE, CompletedProcess
from typing import Any
from unittest.mock import ANY, Mock, call, patch

import pytest
from pytest import MonkeyPatch

import nixos_rebuild.models as m
import nixos_rebuild.nix as n
import nixos_rebuild.process as p

from .helpers import get_qualified_name


@patch(
    get_qualified_name(n.run_wrapper, n),
    autospec=True,
    return_value=CompletedProcess([], 0, stdout=" \n/path/to/file\n "),
)
def test_build(mock_run: Mock) -> None:
    assert n.build(
        "config.system.build.attr",
        m.BuildAttr("<nixpkgs/nixos>", None),
        {"nix_flag": "foo"},
    ) == Path("/path/to/file")
    mock_run.assert_called_with(
        [
            "nix-build",
            "<nixpkgs/nixos>",
            "--attr",
            "config.system.build.attr",
            "--nix-flag",
            "foo",
        ],
        stdout=PIPE,
    )

    assert n.build(
        "config.system.build.attr", m.BuildAttr(Path("file"), "preAttr")
    ) == Path("/path/to/file")
    mock_run.assert_called_with(
        ["nix-build", Path("file"), "--attr", "preAttr.config.system.build.attr"],
        stdout=PIPE,
    )


@patch(
    get_qualified_name(n.run_wrapper, n),
    autospec=True,
    return_value=CompletedProcess([], 0, stdout=" \n/path/to/file\n "),
)
def test_build_flake(mock_run: Mock, monkeypatch: MonkeyPatch, tmpdir: Path) -> None:
    monkeypatch.chdir(tmpdir)
    flake = m.Flake.parse(".#hostname")

    assert n.build_flake(
        "config.system.build.toplevel",
        flake,
        {"no_link": True, "nix_flag": "foo"},
    ) == Path("/path/to/file")
    mock_run.assert_called_with(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command flakes",
            "build",
            "--print-out-paths",
            '.#nixosConfigurations."hostname".config.system.build.toplevel',
            "--no-link",
            "--nix-flag",
            "foo",
        ],
        stdout=PIPE,
    )


@patch(get_qualified_name(n.run_wrapper, n), autospec=True)
@patch("uuid.uuid4", autospec=True)
def test_build_remote(
    mock_uuid4: Mock, mock_run: Mock, monkeypatch: MonkeyPatch
) -> None:
    build_host = m.Remote("user@host", [], None)
    monkeypatch.setenv("NIX_SSHOPTS", "--ssh opts")

    def run_wrapper_side_effect(
        args: list[str], **kwargs: Any
    ) -> CompletedProcess[str]:
        if args[0] == "nix-instantiate":
            return CompletedProcess([], 0, stdout=" \n/path/to/file\n ")
        elif args[0] == "mktemp":
            return CompletedProcess([], 0, stdout=" \n/tmp/tmpdir\n ")
        elif args[0] == "nix-store":
            return CompletedProcess([], 0, stdout=" \n/tmp/tmpdir/config\n ")
        elif args[0] == "readlink":
            return CompletedProcess([], 0, stdout=" \n/path/to/config\n ")
        else:
            return CompletedProcess([], 0)

    mock_run.side_effect = run_wrapper_side_effect
    mock_uuid4.side_effect = [uuid.UUID(int=1), uuid.UUID(int=2)]

    assert n.build_remote(
        "config.system.build.toplevel",
        m.BuildAttr("<nixpkgs/nixos>", "preAttr"),
        build_host,
        realise_flags={"realise": True},
        instantiate_flags={"inst": True},
        copy_flags={"copy": True},
    ) == Path("/path/to/config")

    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix-instantiate",
                    "<nixpkgs/nixos>",
                    "--attr",
                    "preAttr.config.system.build.toplevel",
                    "--add-root",
                    n.tmpdir.TMPDIR_PATH / "00000000000000000000000000000001",
                    "--inst",
                ],
                stdout=PIPE,
            ),
            call(
                [
                    "nix-copy-closure",
                    "--copy",
                    "--to",
                    "user@host",
                    Path("/path/to/file"),
                ],
                extra_env={
                    "NIX_SSHOPTS": " ".join([*p.SSH_DEFAULT_OPTS, "--ssh opts"])
                },
            ),
            call(
                ["mktemp", "-d", "-t", "nixos-rebuild.XXXXX"],
                remote=build_host,
                stdout=PIPE,
            ),
            call(
                [
                    "nix-store",
                    "--realise",
                    Path("/path/to/file"),
                    "--add-root",
                    Path("/tmp/tmpdir/00000000000000000000000000000002"),
                    "--realise",
                ],
                remote=build_host,
                stdout=PIPE,
            ),
            call(
                ["readlink", "-f", "/tmp/tmpdir/config"],
                remote=build_host,
                stdout=PIPE,
            ),
            call(["rm", "-rf", Path("/tmp/tmpdir")], remote=build_host, check=False),
        ]
    )


@patch(
    get_qualified_name(n.run_wrapper, n),
    autospec=True,
    return_value=CompletedProcess([], 0, stdout=" \n/path/to/file\n "),
)
def test_build_remote_flake(
    mock_run: Mock, monkeypatch: MonkeyPatch, tmpdir: Path
) -> None:
    monkeypatch.chdir(tmpdir)
    flake = m.Flake.parse(".#hostname")
    build_host = m.Remote("user@host", [], None)
    monkeypatch.setenv("NIX_SSHOPTS", "--ssh opts")

    assert n.build_remote_flake(
        "config.system.build.toplevel",
        flake,
        build_host,
        eval_flags={"flake": True},
        copy_flags={"copy": True},
        flake_build_flags={"build": True},
    ) == Path("/path/to/file")
    mock_run.assert_has_calls(
        [
            call(
                [
                    "nix",
                    "--extra-experimental-features",
                    "nix-command flakes",
                    "eval",
                    "--raw",
                    '.#nixosConfigurations."hostname".config.system.build.toplevel.drvPath',
                    "--flake",
                ],
                stdout=PIPE,
            ),
            call(
                [
                    "nix-copy-closure",
                    "--copy",
                    "--to",
                    "user@host",
                    Path("/path/to/file"),
                ],
                extra_env={
                    "NIX_SSHOPTS": " ".join([*p.SSH_DEFAULT_OPTS, "--ssh opts"])
                },
            ),
            call(
                [
                    "nix",
                    "--extra-experimental-features",
                    "nix-command flakes",
                    "build",
                    "/path/to/file^*",
                    "--print-out-paths",
                    "--build",
                ],
                remote=build_host,
                stdout=PIPE,
            ),
        ]
    )


def test_copy_closure(monkeypatch: MonkeyPatch) -> None:
    closure = Path("/path/to/closure")
    with patch(get_qualified_name(n.run_wrapper, n), autospec=True) as mock_run:
        n.copy_closure(closure, None)
        mock_run.assert_not_called()

    target_host = m.Remote("user@target.host", [], None)
    build_host = m.Remote("user@build.host", [], None)
    with patch(get_qualified_name(n.run_wrapper, n), autospec=True) as mock_run:
        n.copy_closure(closure, target_host)
        mock_run.assert_called_with(
            ["nix-copy-closure", "--to", "user@target.host", closure],
            extra_env={"NIX_SSHOPTS": " ".join(p.SSH_DEFAULT_OPTS)},
        )

    monkeypatch.setenv("NIX_SSHOPTS", "--ssh build-opt")
    with patch(get_qualified_name(n.run_wrapper, n), autospec=True) as mock_run:
        n.copy_closure(closure, None, build_host, {"copy_flag": True})
        mock_run.assert_called_with(
            ["nix-copy-closure", "--copy-flag", "--from", "user@build.host", closure],
            extra_env={
                "NIX_SSHOPTS": " ".join([*p.SSH_DEFAULT_OPTS, "--ssh build-opt"])
            },
        )

    monkeypatch.setenv("NIX_SSHOPTS", "--ssh build-target-opt")
    monkeypatch.setattr(n, "WITH_NIX_2_18", True)
    extra_env = {
        "NIX_SSHOPTS": " ".join([*p.SSH_DEFAULT_OPTS, "--ssh build-target-opt"])
    }
    with patch(get_qualified_name(n.run_wrapper, n), autospec=True) as mock_run:
        n.copy_closure(closure, target_host, build_host, {"copy_flag": True})
        mock_run.assert_called_with(
            [
                "nix",
                "--extra-experimental-features",
                "nix-command flakes",
                "copy",
                "--copy-flag",
                "--from",
                "ssh://user@build.host",
                "--to",
                "ssh://user@target.host",
                closure,
            ],
            extra_env=extra_env,
        )

    monkeypatch.setattr(n, "WITH_NIX_2_18", False)
    with patch(get_qualified_name(n.run_wrapper, n), autospec=True) as mock_run:
        n.copy_closure(closure, target_host, build_host)
        mock_run.assert_has_calls(
            [
                call(
                    ["nix-copy-closure", "--from", "user@build.host", closure],
                    extra_env=extra_env,
                ),
                call(
                    ["nix-copy-closure", "--to", "user@target.host", closure],
                    extra_env=extra_env,
                ),
            ]
        )


@patch(get_qualified_name(n.run_wrapper, n), autospec=True)
def test_edit(mock_run: Mock, monkeypatch: MonkeyPatch, tmpdir: Path) -> None:
    with monkeypatch.context() as mp:
        default_nix = tmpdir / "default.nix"
        default_nix.write_text("{}", encoding="utf-8")

        mp.setenv("NIXOS_CONFIG", str(tmpdir))
        mp.setenv("EDITOR", "editor")

        n.edit()
        mock_run.assert_called_with(["editor", default_nix], check=False)


@patch(get_qualified_name(n.run_wrapper, n), autospec=True)
def test_edit_flake(mock_run: Mock) -> None:
    flake = m.Flake.parse(".#attr")
    n.edit_flake(flake, {"commit_lock_file": True})
    mock_run.assert_called_with(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command flakes",
            "edit",
            "--commit-lock-file",
            "--",
            '.#nixosConfigurations."attr"',
        ],
        check=False,
    )


@patch(
    get_qualified_name(n.run_wrapper, n),
    autospec=True,
    return_value=CompletedProcess(
        [],
        0,
        """
        {
          "azure": "nixos-image-azure-25.05.20250102.6df2492-x86_64-linux.vhd",
          "vmware": "nixos-image-vmware-25.05.20250102.6df2492-x86_64-linux.vmdk"
        }
        """,
    ),
)
def test_get_build_image_variants(mock_run: Mock, tmp_path: Path) -> None:
    build_attr = m.BuildAttr("<nixpkgs/nixos>", None)
    assert n.get_build_image_variants(build_attr) == {
        "azure": "nixos-image-azure-25.05.20250102.6df2492-x86_64-linux.vhd",
        "vmware": "nixos-image-vmware-25.05.20250102.6df2492-x86_64-linux.vmdk",
    }
    mock_run.assert_called_with(
        [
            "nix-instantiate",
            "--eval",
            "--strict",
            "--json",
            "--expr",
            textwrap.dedent("""
            let
              value = import <nixpkgs/nixos>;
              set = if builtins.isFunction value then value {} else value;
            in
              builtins.attrNames set.config.system.build.images
            """),
        ],
        stdout=PIPE,
    )

    build_attr = m.BuildAttr(Path(tmp_path), "preAttr")
    assert n.get_build_image_variants(build_attr, {"inst_flag": True}) == {
        "azure": "nixos-image-azure-25.05.20250102.6df2492-x86_64-linux.vhd",
        "vmware": "nixos-image-vmware-25.05.20250102.6df2492-x86_64-linux.vmdk",
    }
    mock_run.assert_called_with(
        [
            "nix-instantiate",
            "--eval",
            "--strict",
            "--json",
            "--expr",
            textwrap.dedent(f"""
            let
              value = import "{tmp_path}";
              set = if builtins.isFunction value then value {{}} else value;
            in
              builtins.attrNames set.preAttr.config.system.build.images
            """),
            "--inst-flag",
        ],
        stdout=PIPE,
    )


@patch(
    get_qualified_name(n.run_wrapper, n),
    autospec=True,
    return_value=CompletedProcess(
        [],
        0,
        """
        {
          "azure": "nixos-image-azure-25.05.20250102.6df2492-x86_64-linux.vhd",
          "vmware": "nixos-image-vmware-25.05.20250102.6df2492-x86_64-linux.vmdk"
        }
        """,
    ),
)
def test_get_build_image_variants_flake(mock_run: Mock) -> None:
    flake = m.Flake(Path("flake.nix"), "myAttr")
    assert n.get_build_image_variants_flake(flake, {"eval_flag": True}) == {
        "azure": "nixos-image-azure-25.05.20250102.6df2492-x86_64-linux.vhd",
        "vmware": "nixos-image-vmware-25.05.20250102.6df2492-x86_64-linux.vmdk",
    }
    mock_run.assert_called_with(
        [
            "nix",
            "eval",
            "--json",
            "flake.nix#myAttr.config.system.build.images",
            "--apply",
            "builtins.attrNames",
            "--eval-flag",
        ],
        stdout=PIPE,
    )


def test_get_nixpkgs_rev() -> None:
    assert n.get_nixpkgs_rev(None) is None

    path = Path("/path/to/nix")

    with patch(
        get_qualified_name(n.run_wrapper, n),
        autospec=True,
        side_effect=[CompletedProcess([], 0, "")],
    ) as mock_run:
        assert n.get_nixpkgs_rev(path) is None
        mock_run.assert_called_with(
            ["git", "-C", path, "rev-parse", "--short", "HEAD"],
            check=False,
            capture_output=True,
        )

    expected_calls = [
        call(
            ["git", "-C", path, "rev-parse", "--short", "HEAD"],
            check=False,
            capture_output=True,
        ),
        call(
            ["git", "-C", path, "diff", "--quiet"],
            check=False,
        ),
    ]

    with patch(
        get_qualified_name(n.run_wrapper, n),
        autospec=True,
        side_effect=[
            CompletedProcess([], 0, "0f7c82403fd6"),
            CompletedProcess([], returncode=0),
        ],
    ) as mock_run:
        assert n.get_nixpkgs_rev(path) == ".git.0f7c82403fd6"
        mock_run.assert_has_calls(expected_calls)

    with patch(
        get_qualified_name(n.run_wrapper, n),
        autospec=True,
        side_effect=[
            CompletedProcess([], 0, "0f7c82403fd6"),
            CompletedProcess([], returncode=1),
        ],
    ) as mock_run:
        assert n.get_nixpkgs_rev(path) == ".git.0f7c82403fd6M"
        mock_run.assert_has_calls(expected_calls)


def test_get_generations(tmp_path: Path) -> None:
    nixos_path = tmp_path / "nixos-system"
    nixos_path.mkdir()

    (tmp_path / "system").symlink_to(tmp_path / "system-2-link")
    # In the "wrong" order on purpose to make sure we are sorting the results
    (tmp_path / "system-1-link").symlink_to(nixos_path)
    (tmp_path / "system-3-link").symlink_to(nixos_path)
    (tmp_path / "system-2-link").symlink_to(nixos_path)

    assert n.get_generations(m.Profile("system", tmp_path / "system")) == [
        m.Generation(id=1, current=False, timestamp=ANY),
        m.Generation(id=2, current=True, timestamp=ANY),
        m.Generation(id=3, current=False, timestamp=ANY),
    ]


def test_get_generations_from_nix_env(tmp_path: Path) -> None:
    path = tmp_path / "test"
    path.touch()
    return_value = CompletedProcess(
        [],
        0,
        stdout=textwrap.dedent("""\
        2082   2024-11-07 22:58:56
        2083   2024-11-07 22:59:41
        2084   2024-11-07 23:54:17   (current)
        """),
    )

    with patch(
        get_qualified_name(n.run_wrapper, n), autospec=True, return_value=return_value
    ) as mock_run:
        assert n.get_generations_from_nix_env(m.Profile("system", path)) == [
            m.Generation(id=2082, current=False, timestamp="2024-11-07 22:58:56"),
            m.Generation(id=2083, current=False, timestamp="2024-11-07 22:59:41"),
            m.Generation(id=2084, current=True, timestamp="2024-11-07 23:54:17"),
        ]
        mock_run.assert_called_with(
            ["nix-env", "-p", path, "--list-generations"],
            stdout=PIPE,
            remote=None,
            sudo=False,
        )

    remote = m.Remote("user@host", [], "password")
    with patch(
        get_qualified_name(n.run_wrapper, n), autospec=True, return_value=return_value
    ) as mock_run:
        assert n.get_generations_from_nix_env(
            m.Profile("system", path), remote, True
        ) == [
            m.Generation(id=2082, current=False, timestamp="2024-11-07 22:58:56"),
            m.Generation(id=2083, current=False, timestamp="2024-11-07 22:59:41"),
            m.Generation(id=2084, current=True, timestamp="2024-11-07 23:54:17"),
        ]
        mock_run.assert_called_with(
            ["nix-env", "-p", path, "--list-generations"],
            stdout=PIPE,
            remote=remote,
            sudo=True,
        )


@patch(
    get_qualified_name(n.get_generations),
    autospec=True,
    return_value=[
        m.Generation(
            id=1,
            timestamp="2024-11-07 23:54:17",
            current=False,
        ),
        m.Generation(
            id=2,
            timestamp="2024-11-07 23:54:17",
            current=True,
        ),
    ],
)
def test_list_generations(mock_get_generations: Mock, tmp_path: Path) -> None:
    # Probably better to test this function in a real system, this test is
    # mostly to make sure it doesn't break horribly
    assert n.list_generations(m.Profile("system", tmp_path)) == [
        {
            "configurationRevision": "Unknown",
            "current": True,
            "date": "2024-11-07 23:54:17",
            "generation": 2,
            "kernelVersion": "Unknown",
            "nixosVersion": "Unknown",
            "specialisations": [],
        },
        {
            "configurationRevision": "Unknown",
            "current": False,
            "date": "2024-11-07 23:54:17",
            "generation": 1,
            "kernelVersion": "Unknown",
            "nixosVersion": "Unknown",
            "specialisations": [],
        },
    ]


@patch(get_qualified_name(n.run_wrapper, n), autospec=True)
def test_repl(mock_run: Mock) -> None:
    n.repl(m.BuildAttr("<nixpkgs/nixos>", None), {"nix_flag": True})
    mock_run.assert_called_with(
        ["nix", "repl", "--file", "<nixpkgs/nixos>", "--nix-flag"]
    )

    n.repl(m.BuildAttr(Path("file.nix"), "myAttr"))
    mock_run.assert_called_with(["nix", "repl", "--file", Path("file.nix"), "myAttr"])


@patch(get_qualified_name(n.run_wrapper, n), autospec=True)
def test_repl_flake(mock_run: Mock) -> None:
    n.repl_flake(m.Flake(Path("flake.nix"), "myAttr"), {"nix_flag": True})
    # See nixos-rebuild-ng.tests.repl for a better test,
    # this is mostly for sanity check
    assert mock_run.call_count == 1


@patch(get_qualified_name(n.run_wrapper, n), autospec=True)
def test_rollback(mock_run: Mock, tmp_path: Path) -> None:
    path = tmp_path / "test"
    path.touch()

    profile = m.Profile("system", path)

    assert n.rollback(profile, None, False) == profile.path
    mock_run.assert_called_with(
        ["nix-env", "--rollback", "-p", path],
        remote=None,
        sudo=False,
    )

    target_host = m.Remote("user@localhost", [], None)
    assert n.rollback(profile, target_host, True) == profile.path
    mock_run.assert_called_with(
        ["nix-env", "--rollback", "-p", path],
        remote=target_host,
        sudo=True,
    )


def test_rollback_temporary_profile(tmp_path: Path) -> None:
    path = tmp_path / "test"
    path.touch()
    profile = m.Profile("system", path)

    with patch(get_qualified_name(n.run_wrapper, n), autospec=True) as mock_run:
        mock_run.return_value = CompletedProcess(
            [],
            0,
            stdout=textwrap.dedent("""\
                2082   2024-11-07 22:58:56
                2083   2024-11-07 22:59:41
                2084   2024-11-07 23:54:17   (current)
                """),
        )
        assert (
            n.rollback_temporary_profile(m.Profile("system", path), None, False)
            == path.parent / "system-2083-link"
        )
        mock_run.assert_called_with(
            [
                "nix-env",
                "-p",
                path,
                "--list-generations",
            ],
            stdout=PIPE,
            remote=None,
            sudo=False,
        )

        target_host = m.Remote("user@localhost", [], None)
        assert (
            n.rollback_temporary_profile(m.Profile("foo", path), target_host, True)
            == path.parent / "foo-2083-link"
        )
        mock_run.assert_called_with(
            [
                "nix-env",
                "-p",
                path,
                "--list-generations",
            ],
            stdout=PIPE,
            remote=target_host,
            sudo=True,
        )

    with patch(get_qualified_name(n.run_wrapper, n), autospec=True) as mock_run:
        mock_run.return_value = CompletedProcess([], 0, stdout="")
        assert n.rollback_temporary_profile(profile, None, False) is None


@patch(get_qualified_name(n.run_wrapper, n), autospec=True)
def test_set_profile(mock_run: Mock) -> None:
    profile_path = Path("/path/to/profile")
    config_path = Path("/path/to/config")
    mock_run.return_value = CompletedProcess([], 0)

    n.set_profile(
        m.Profile("system", profile_path),
        config_path,
        target_host=None,
        sudo=False,
    )

    mock_run.assert_called_with(
        ["nix-env", "-p", profile_path, "--set", config_path],
        remote=None,
        sudo=False,
    )

    mock_run.return_value = CompletedProcess([], 1)

    with pytest.raises(m.NixOSRebuildError) as e:
        n.set_profile(
            m.Profile("system", profile_path),
            config_path,
            target_host=None,
            sudo=False,
        )
    assert str(e.value).startswith(
        "error: your NixOS configuration path seems to be missing essential files."
    )


@patch(get_qualified_name(n.run_wrapper, n), autospec=True)
def test_switch_to_configuration_without_systemd_run(
    mock_run: Any, monkeypatch: MonkeyPatch
) -> None:
    profile_path = Path("/path/to/profile")
    config_path = Path("/path/to/config")
    mock_run.return_value = CompletedProcess([], 1)

    with monkeypatch.context() as mp:
        mp.setenv("LOCALE_ARCHIVE", "")

        n.switch_to_configuration(
            profile_path,
            m.Action.SWITCH,
            sudo=False,
            target_host=None,
            specialisation=None,
            install_bootloader=False,
        )
    mock_run.assert_called_with(
        [profile_path / "bin/switch-to-configuration", "switch"],
        extra_env={"NIXOS_INSTALL_BOOTLOADER": "0"},
        sudo=False,
        remote=None,
    )

    with pytest.raises(m.NixOSRebuildError) as e:
        n.switch_to_configuration(
            config_path,
            m.Action.BOOT,
            sudo=False,
            target_host=None,
            specialisation="special",
        )
    assert (
        str(e.value)
        == "error: '--specialisation' can only be used with 'switch' and 'test'"
    )

    target_host = m.Remote("user@localhost", [], None)
    with monkeypatch.context() as mp:
        mp.setenv("LOCALE_ARCHIVE", "/path/to/locale")
        mp.setenv("PATH", "/path/to/bin")
        mp.setattr(Path, Path.exists.__name__, lambda self: True)

        n.switch_to_configuration(
            Path("/path/to/config"),
            m.Action.TEST,
            sudo=True,
            target_host=target_host,
            install_bootloader=True,
            specialisation="special",
        )
    mock_run.assert_called_with(
        [
            config_path / "specialisation/special/bin/switch-to-configuration",
            "test",
        ],
        extra_env={"NIXOS_INSTALL_BOOTLOADER": "1"},
        sudo=True,
        remote=target_host,
    )


@patch(get_qualified_name(n.run_wrapper, n), autospec=True)
def test_switch_to_configuration_with_systemd_run(
    mock_run: Mock, monkeypatch: MonkeyPatch
) -> None:
    profile_path = Path("/path/to/profile")
    config_path = Path("/path/to/config")
    mock_run.return_value = CompletedProcess([], 0)

    with monkeypatch.context() as mp:
        mp.setenv("LOCALE_ARCHIVE", "")

        n.switch_to_configuration(
            profile_path,
            m.Action.SWITCH,
            sudo=False,
            target_host=None,
            specialisation=None,
            install_bootloader=False,
        )
    mock_run.assert_called_with(
        [
            *n.SWITCH_TO_CONFIGURATION_CMD_PREFIX,
            profile_path / "bin/switch-to-configuration",
            "switch",
        ],
        extra_env={"NIXOS_INSTALL_BOOTLOADER": "0"},
        sudo=False,
        remote=None,
    )

    target_host = m.Remote("user@localhost", [], None)
    with monkeypatch.context() as mp:
        mp.setenv("LOCALE_ARCHIVE", "/path/to/locale")
        mp.setenv("PATH", "/path/to/bin")
        mp.setattr(Path, Path.exists.__name__, lambda self: True)

        n.switch_to_configuration(
            Path("/path/to/config"),
            m.Action.TEST,
            sudo=True,
            target_host=target_host,
            install_bootloader=True,
            specialisation="special",
        )
    mock_run.assert_called_with(
        [
            *n.SWITCH_TO_CONFIGURATION_CMD_PREFIX,
            config_path / "specialisation/special/bin/switch-to-configuration",
            "test",
        ],
        extra_env={"NIXOS_INSTALL_BOOTLOADER": "1"},
        sudo=True,
        remote=target_host,
    )


@patch(
    "pathlib.Path.glob",
    autospec=True,
    return_value=[
        Path("/nix/var/nix/profiles/per-user/root/channels/nixos"),
        Path("/nix/var/nix/profiles/per-user/root/channels/nixos-hardware"),
        Path("/nix/var/nix/profiles/per-user/root/channels/home-manager"),
    ],
)
@patch("pathlib.Path.is_dir", autospec=True, return_value=True)
def test_upgrade_channels(mock_is_dir: Mock, mock_glob: Mock) -> None:
    with patch(get_qualified_name(n.run_wrapper, n), autospec=True) as mock_run:
        n.upgrade_channels(False)
    mock_run.assert_called_once_with(["nix-channel", "--update", "nixos"], check=False)

    with patch(get_qualified_name(n.run_wrapper, n), autospec=True) as mock_run:
        n.upgrade_channels(True)
    mock_run.assert_has_calls(
        [
            call(["nix-channel", "--update", "nixos"], check=False),
            call(["nix-channel", "--update", "nixos-hardware"], check=False),
            call(["nix-channel", "--update", "home-manager"], check=False),
        ]
    )
