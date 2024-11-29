import textwrap
from pathlib import Path
from subprocess import PIPE, CompletedProcess
from typing import Any
from unittest.mock import ANY, call, patch

import pytest

import nixos_rebuild.nix as n
from nixos_rebuild import models as m

from .helpers import get_qualified_name


@patch(get_qualified_name(n.run, n), autospec=True)
def test_edit(mock_run: Any, monkeypatch: Any, tmpdir: Any) -> None:
    # Flake
    flake = m.Flake.parse(".#attr")
    n.edit(flake, ["--commit-lock-file"])
    mock_run.assert_called_with(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command flakes",
            "edit",
            "--commit-lock-file",
            "--",
            ".#nixosConfigurations.attr",
        ],
        check=False,
    )

    # Classic
    with monkeypatch.context() as mp:
        default_nix = tmpdir.join("default.nix")
        default_nix.write("{}")

        mp.setenv("NIXOS_CONFIG", str(tmpdir))
        mp.setenv("EDITOR", "editor")

        n.edit(None)
        mock_run.assert_called_with(["editor", default_nix], check=False)


@patch(get_qualified_name(n.shutil.which), autospec=True, return_value="/bin/git")
def test_get_nixpkgs_rev(mock_which: Any) -> None:
    assert n.get_nixpkgs_rev(None) is None

    path = Path("/path/to/nix")

    with patch(
        get_qualified_name(n.run, n),
        autospec=True,
        side_effect=[CompletedProcess([], 0, "")],
    ) as mock_run:
        assert n.get_nixpkgs_rev(path) is None
        mock_run.assert_called_with(
            ["git", "-C", path, "rev-parse", "--short", "HEAD"],
            check=False,
            stdout=PIPE,
            text=True,
        )

    expected_calls = [
        call(
            ["git", "-C", path, "rev-parse", "--short", "HEAD"],
            check=False,
            stdout=PIPE,
            text=True,
        ),
        call(
            ["git", "-C", path, "diff", "--quiet"],
            check=False,
        ),
    ]

    with patch(
        get_qualified_name(n.run, n),
        autospec=True,
        side_effect=[
            CompletedProcess([], 0, "0f7c82403fd6"),
            CompletedProcess([], returncode=0),
        ],
    ) as mock_run:
        assert n.get_nixpkgs_rev(path) == ".git.0f7c82403fd6"
        mock_run.assert_has_calls(expected_calls)

    with patch(
        get_qualified_name(n.run, n),
        autospec=True,
        side_effect=[
            CompletedProcess([], 0, "0f7c82403fd6"),
            CompletedProcess([], returncode=1),
        ],
    ) as mock_run:
        assert n.get_nixpkgs_rev(path) == ".git.0f7c82403fd6M"
        mock_run.assert_has_calls(expected_calls)


def test_get_generations_from_nix_store(tmp_path: Path) -> None:
    nixos_path = tmp_path / "nixos-system"
    nixos_path.mkdir()

    (tmp_path / "system").symlink_to(tmp_path / "system-2-link")
    # In the "wrong" order on purpose to make sure we are sorting the results
    (tmp_path / "system-1-link").symlink_to(nixos_path)
    (tmp_path / "system-3-link").symlink_to(nixos_path)
    (tmp_path / "system-2-link").symlink_to(nixos_path)

    assert n.get_generations(
        m.Profile("system", tmp_path / "system"),
        lock_profile=False,
    ) == [
        m.Generation(id=1, current=False, timestamp=ANY),
        m.Generation(id=2, current=True, timestamp=ANY),
        m.Generation(id=3, current=False, timestamp=ANY),
    ]


@patch(
    get_qualified_name(n.run, n),
    autospec=True,
    return_value=CompletedProcess(
        [],
        0,
        stdout=textwrap.dedent("""\
        2082   2024-11-07 22:58:56
        2083   2024-11-07 22:59:41
        2084   2024-11-07 23:54:17   (current)
        """),
    ),
)
def test_get_generations_from_nix_env(mock_run: Any, tmp_path: Path) -> None:
    path = tmp_path / "test"
    path.touch()

    assert n.get_generations(m.Profile("system", path), lock_profile=True) == [
        m.Generation(id=2082, current=False, timestamp="2024-11-07 22:58:56"),
        m.Generation(id=2083, current=False, timestamp="2024-11-07 22:59:41"),
        m.Generation(id=2084, current=True, timestamp="2024-11-07 23:54:17"),
    ]


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
def test_list_generations(mock_get_generations: Any, tmp_path: Path) -> None:
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


@patch(
    get_qualified_name(n.run, n),
    autospec=True,
    return_value=CompletedProcess([], 0, stdout=" \n/path/to/file\n "),
)
def test_nixos_build_flake(mock_run: Any) -> None:
    flake = m.Flake.parse(".#hostname")

    assert n.nixos_build_flake(
        "toplevel",
        flake,
        ["--nix-flag", "foo"],
        no_link=True,
    ) == Path("/path/to/file")
    mock_run.assert_called_with(
        [
            "nix",
            "--extra-experimental-features",
            "nix-command flakes",
            "build",
            "--print-out-paths",
            ".#nixosConfigurations.hostname.config.system.build.toplevel",
            "--no-link",
            "--nix-flag",
            "foo",
        ],
        check=True,
        text=True,
        stdout=PIPE,
    )


@patch(
    get_qualified_name(n.run, n),
    autospec=True,
    return_value=CompletedProcess([], 0, stdout=" \n/path/to/file\n "),
)
def test_nixos_build(mock_run: Any, monkeypatch: Any) -> None:
    assert n.nixos_build("attr", None, None, ["--nix-flag", "foo"]) == Path(
        "/path/to/file"
    )
    mock_run.assert_called_with(
        ["nix-build", "<nixpkgs/nixos>", "--attr", "attr", "--nix-flag", "foo"],
        check=True,
        text=True,
        stdout=PIPE,
    )

    n.nixos_build("attr", "preAttr", "file")
    mock_run.assert_called_with(
        ["nix-build", "file", "--attr", "preAttr.attr"],
        check=True,
        text=True,
        stdout=PIPE,
    )

    n.nixos_build("attr", None, "file", no_out_link=True)
    mock_run.assert_called_with(
        ["nix-build", "file", "--attr", "attr", "--no-out-link"],
        check=True,
        text=True,
        stdout=PIPE,
    )

    n.nixos_build("attr", "preAttr", None, no_out_link=False, keep_going=True)
    mock_run.assert_called_with(
        ["nix-build", "default.nix", "--attr", "preAttr.attr", "--keep-going"],
        check=True,
        text=True,
        stdout=PIPE,
    )


@patch(get_qualified_name(n.run, n), autospec=True)
def test_rollback(mock_run: Any, tmp_path: Path) -> None:
    path = tmp_path / "test"
    path.touch()

    profile = m.Profile("system", path)

    assert n.rollback(profile) == profile.path
    mock_run.assert_called_with(["nix-env", "--rollback", "-p", path], check=True)


def test_rollback_temporary_profile(tmp_path: Path) -> None:
    path = tmp_path / "test"
    path.touch()
    profile = m.Profile("system", path)

    with patch(get_qualified_name(n.run, n), autospec=True) as mock_run:
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
            n.rollback_temporary_profile(m.Profile("system", path))
            == path.parent / "system-2083-link"
        )
        assert (
            n.rollback_temporary_profile(m.Profile("foo", path))
            == path.parent / "foo-2083-link"
        )

    with patch(get_qualified_name(n.run, n), autospec=True) as mock_run:
        mock_run.return_value = CompletedProcess([], 0, stdout="")
        assert n.rollback_temporary_profile(profile) is None


@patch(get_qualified_name(n.run, n), autospec=True)
def test_set_profile(mock_run: Any) -> None:
    profile_path = Path("/path/to/profile")
    config_path = Path("/path/to/config")
    n.set_profile(m.Profile("system", profile_path), config_path)

    mock_run.assert_called_with(
        ["nix-env", "-p", profile_path, "--set", config_path], check=True
    )


@patch(get_qualified_name(n.run, n), autospec=True)
def test_switch_to_configuration(mock_run: Any, monkeypatch: Any) -> None:
    profile_path = Path("/path/to/profile")
    config_path = Path("/path/to/config")

    with monkeypatch.context() as mp:
        mp.setenv("LOCALE_ARCHIVE", "")

        n.switch_to_configuration(
            profile_path,
            m.Action.SWITCH,
            specialisation=None,
            install_bootloader=False,
        )
    mock_run.assert_called_with(
        [profile_path / "bin/switch-to-configuration", "switch"],
        env={"NIXOS_INSTALL_BOOTLOADER": "0", "LOCALE_ARCHIVE": ""},
        check=True,
    )

    with pytest.raises(m.NRError) as e:
        n.switch_to_configuration(
            config_path,
            m.Action.BOOT,
            specialisation="special",
        )
    assert (
        str(e.value)
        == "error: '--specialisation' can only be used with 'switch' and 'test'"
    )

    with monkeypatch.context() as mp:
        mp.setenv("LOCALE_ARCHIVE", "/path/to/locale")
        mp.setattr(Path, Path.exists.__name__, lambda self: True)

        n.switch_to_configuration(
            Path("/path/to/config"),
            m.Action.TEST,
            install_bootloader=True,
            specialisation="special",
        )
    mock_run.assert_called_with(
        [
            config_path / "specialisation/special/bin/switch-to-configuration",
            "test",
        ],
        env={"NIXOS_INSTALL_BOOTLOADER": "1", "LOCALE_ARCHIVE": "/path/to/locale"},
        check=True,
    )


@patch(
    get_qualified_name(n.Path.glob, n),
    autospec=True,
    return_value=[
        Path("/nix/var/nix/profiles/per-user/root/channels/nixos"),
        Path("/nix/var/nix/profiles/per-user/root/channels/nixos-hardware"),
        Path("/nix/var/nix/profiles/per-user/root/channels/home-manager"),
    ],
)
def test_upgrade_channels(mock_glob: Any) -> None:
    with patch(get_qualified_name(n.run, n), autospec=True) as mock_run:
        n.upgrade_channels(False)
    mock_run.assert_called_with(["nix-channel", "--update", "nixos"], check=False)

    with patch(get_qualified_name(n.run, n), autospec=True) as mock_run:
        n.upgrade_channels(True)
    mock_run.assert_has_calls(
        [
            call(["nix-channel", "--update", "nixos"], check=False),
            call(["nix-channel", "--update", "nixos-hardware"], check=False),
            call(["nix-channel", "--update", "home-manager"], check=False),
        ]
    )
