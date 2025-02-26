import platform
import subprocess
from pathlib import Path
from unittest.mock import Mock, patch

from pytest import MonkeyPatch

import nixos_rebuild.models as m

from .helpers import get_qualified_name


def test_build_attr_from_arg() -> None:
    assert m.BuildAttr.from_arg(None, None) == m.BuildAttr("<nixpkgs/nixos>", None)
    assert m.BuildAttr.from_arg("attr", None) == m.BuildAttr(
        Path("default.nix"), "attr"
    )
    assert m.BuildAttr.from_arg("attr", "file.nix") == m.BuildAttr(
        Path("file.nix"), "attr"
    )
    assert m.BuildAttr.from_arg(None, "file.nix") == m.BuildAttr(Path("file.nix"), None)


def test_build_attr_to_attr() -> None:
    assert (
        m.BuildAttr("<nixpkgs/nixos>", None).to_attr("attr1", "attr2") == "attr1.attr2"
    )
    assert (
        m.BuildAttr("<nixpkgs/nixos>", "preAttr").to_attr("attr1", "attr2")
        == "preAttr.attr1.attr2"
    )


def test_flake_parse(tmpdir: Path, monkeypatch: MonkeyPatch) -> None:
    assert m.Flake.parse("/path/to/flake#attr") == m.Flake(
        Path("/path/to/flake"), "nixosConfigurations.attr"
    )
    assert m.Flake.parse("/path/ to /flake", lambda: "hostname") == m.Flake(
        Path("/path/ to /flake"), "nixosConfigurations.hostname"
    )
    assert m.Flake.parse("/path/to/flake", lambda: "hostname") == m.Flake(
        Path("/path/to/flake"), "nixosConfigurations.hostname"
    )
    # change directory to tmpdir
    with monkeypatch.context() as patch_context:
        patch_context.chdir(tmpdir)
        assert m.Flake.parse(".#attr") == m.Flake(Path("."), "nixosConfigurations.attr")
        assert m.Flake.parse("#attr") == m.Flake(Path("."), "nixosConfigurations.attr")
        assert m.Flake.parse(".") == m.Flake(Path("."), "nixosConfigurations.default")
    assert m.Flake.parse("path:/to/flake#attr") == m.Flake(
        "path:/to/flake", "nixosConfigurations.attr"
    )
    assert m.Flake.parse("github:user/repo/branch") == m.Flake(
        "github:user/repo/branch", "nixosConfigurations.default"
    )
    git_root = tmpdir / "git_root"
    git_root.mkdir()
    (git_root / ".git").mkdir()
    assert m.Flake.parse(str(git_root)) == m.Flake(
        f"git+file://{git_root}", "nixosConfigurations.default"
    )

    work_tree = tmpdir / "work_tree"
    work_tree.mkdir()
    (work_tree / ".git").write_text("gitdir: /path/to/git", "utf-8")
    assert m.Flake.parse(str(work_tree)) == m.Flake(
        "git+file:///path/to/git", "nixosConfigurations.default"
    )


def test_flake_to_attr() -> None:
    assert (
        m.Flake(Path("/path/to/flake"), "nixosConfigurations.preAttr").to_attr(
            "attr1", "attr2"
        )
        == "/path/to/flake#nixosConfigurations.preAttr.attr1.attr2"
    )


@patch(get_qualified_name(platform.node), autospec=True)
def test_flake_from_arg(
    mock_node: Mock, monkeypatch: MonkeyPatch, tmpdir: Path
) -> None:
    mock_node.return_value = "hostname"

    # Flake string
    assert m.Flake.from_arg("/path/to/flake#attr", None) == m.Flake(
        Path("/path/to/flake"), "nixosConfigurations.attr"
    )

    # False
    assert m.Flake.from_arg(False, None) is None

    # True
    with monkeypatch.context() as patch_context:
        patch_context.chdir(tmpdir)
        assert m.Flake.from_arg(True, None) == m.Flake(
            Path("."), "nixosConfigurations.hostname"
        )

    # None when we do not have /etc/nixos/flake.nix
    with patch(
        get_qualified_name(m.Path.exists, m),
        autospec=True,
        return_value=False,
    ):
        assert m.Flake.from_arg(None, None) is None

    # None when we have a file in /etc/nixos/flake.nix
    with (
        patch(
            get_qualified_name(m.Path.exists, m),
            autospec=True,
            return_value=True,
        ),
        patch(
            get_qualified_name(m.Path.is_symlink, m),
            autospec=True,
            return_value=False,
        ),
        patch(
            get_qualified_name(m.discover_git, m),
            autospec=True,
            return_value="/etc/nixos",
        ),
    ):
        assert m.Flake.from_arg(None, None) == m.Flake(
            "git+file:///etc/nixos", "nixosConfigurations.hostname"
        )

    with (
        patch(
            get_qualified_name(m.Path.exists, m),
            autospec=True,
            return_value=True,
        ),
        patch(
            get_qualified_name(m.Path.is_symlink, m),
            autospec=True,
            return_value=True,
        ),
        patch(
            get_qualified_name(m.Path.resolve, m),
            autospec=True,
            return_value=Path("/path/to/flake.nix"),
        ),
    ):
        assert m.Flake.from_arg(None, None) == m.Flake(
            Path("/path/to"), "nixosConfigurations.hostname"
        )

    with (
        patch(
            get_qualified_name(m.subprocess.run),
            autospec=True,
            return_value=subprocess.CompletedProcess([], 0, "remote-hostname\n"),
        ),
    ):
        assert m.Flake.from_arg("/path/to", m.Remote("user@host", [], None)) == m.Flake(
            Path("/path/to"), "nixosConfigurations.remote-hostname"
        )


@patch(get_qualified_name(m.Path.mkdir, m), autospec=True)
def test_profile_from_arg(mock_mkdir: Mock) -> None:
    assert m.Profile.from_arg("system") == m.Profile(
        "system",
        Path("/nix/var/nix/profiles/system"),
    )
    mock_mkdir.assert_not_called()

    assert m.Profile.from_arg("something") == m.Profile(
        "something",
        Path("/nix/var/nix/profiles/system-profiles/something"),
    )
    mock_mkdir.assert_called_once()
