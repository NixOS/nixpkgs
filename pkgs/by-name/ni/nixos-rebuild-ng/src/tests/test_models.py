import platform
from pathlib import Path
from typing import Any
from unittest.mock import patch

from nixos_rebuild import models as m

from .helpers import get_qualified_name


def test_flake_parse() -> None:
    assert m.Flake.parse("/path/to/flake#attr") == m.Flake(
        Path("/path/to/flake"), "nixosConfigurations.attr"
    )
    assert m.Flake.parse("/path/ to /flake", "hostname") == m.Flake(
        Path("/path/ to /flake"), "nixosConfigurations.hostname"
    )
    assert m.Flake.parse("/path/to/flake", "hostname") == m.Flake(
        Path("/path/to/flake"), "nixosConfigurations.hostname"
    )
    assert m.Flake.parse(".#attr") == m.Flake(Path("."), "nixosConfigurations.attr")
    assert m.Flake.parse("#attr") == m.Flake(Path("."), "nixosConfigurations.attr")
    assert m.Flake.parse(".", None) == m.Flake(Path("."), "nixosConfigurations.default")
    assert m.Flake.parse("", "") == m.Flake(Path("."), "nixosConfigurations.default")


@patch(get_qualified_name(platform.node), autospec=True)
def test_flake_from_arg(mock_node: Any) -> None:
    mock_node.return_value = "hostname"

    # Flake string
    assert m.Flake.from_arg("/path/to/flake#attr") == m.Flake(
        Path("/path/to/flake"), "nixosConfigurations.attr"
    )

    # False
    assert m.Flake.from_arg(False) is None

    # True
    assert m.Flake.from_arg(True) == m.Flake(Path("."), "nixosConfigurations.hostname")

    # None when we do not have /etc/nixos/flake.nix
    with patch(
        get_qualified_name(m.Path.exists, m),
        autospec=True,
        return_value=False,
    ):
        assert m.Flake.from_arg(None) is None

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
    ):
        assert m.Flake.from_arg(None) == m.Flake(
            Path("/etc/nixos"), "nixosConfigurations.hostname"
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
            get_qualified_name(m.Path.readlink, m),
            autospec=True,
            return_value=Path("/path/to/flake.nix"),
        ),
    ):
        assert m.Flake.from_arg(None) == m.Flake(
            Path("/path/to"), "nixosConfigurations.hostname"
        )


@patch(get_qualified_name(m.Path.mkdir, m), autospec=True)
def test_profile_from_name(mock_mkdir: Any) -> None:
    assert m.Profile.from_name("system") == m.Profile(
        "system",
        Path("/nix/var/nix/profiles/system"),
    )

    assert m.Profile.from_name("something") == m.Profile(
        "something",
        Path("/nix/var/nix/profiles/system-profiles/something"),
    )
    mock_mkdir.assert_called_once()
