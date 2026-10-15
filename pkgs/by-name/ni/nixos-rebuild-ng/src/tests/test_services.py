import argparse
import os
from pathlib import Path
from subprocess import CompletedProcess
from unittest.mock import ANY, Mock, call, patch

import pytest
from pytest import MonkeyPatch

import nixos_rebuild as n
import nixos_rebuild.services as s

from .helpers import get_qualified_name

grouped_nix_args = n.models.GroupedNixArgs(
    build_flags={"build": True},
    common_flags={"common": True},
    copy_flags={"copy": True},
    flake_eval_flags={"flake_eval": True},
    flake_build_flags={"flake_build": True},
)


def test__get_system_attr() -> None:
    args = argparse.Namespace(specialisation=None)
    tests = {
        n.models.Action.BOOT: "config.system.build.toplevel",
        n.models.Action.BUILD_VM: "config.system.build.vm",
        n.models.Action.BUILD_VM_WITH_BOOTLOADER: "config.system.build.vmWithBootLoader",
        # Action.BUILD_IMAGE is handled in the below test
    }
    for action, expected_system_attr in tests.items():
        assert (
            s._get_system_attr(
                action=action,
                args=args,
                flake=None,
                build_attr=None,
                grouped_nix_args=grouped_nix_args,
            )
            == expected_system_attr
        )

    args = argparse.Namespace(specialisation="custom-specialisation")
    tests = {
        n.models.Action.BOOT: "config.system.build.toplevel",
        n.models.Action.BUILD_VM: "config.specialisation.custom-specialisation.configuration.system.build.vm",
        n.models.Action.BUILD_VM_WITH_BOOTLOADER: "config.specialisation.custom-specialisation.configuration.system.build.vmWithBootLoader",
        # Action.BUILD_IMAGE is handled in the below test
    }
    for action, expected_system_attr in tests.items():
        assert (
            s._get_system_attr(
                action=action,
                args=args,
                flake=None,
                build_attr=None,
                grouped_nix_args=grouped_nix_args,
            )
            == expected_system_attr
        )

@patch(
    get_qualified_name(n.nix.run_wrapper, n.nix),
    autospec=True,
    return_value=CompletedProcess([], 0, stdout='["amazon","azure","cloudstack","digital-ocean","google-compute","hyperv","iso","iso-installer","kexec","kubevirt","linode","lxc","lxc-metadata","oci","openstack","openstack-zfs","proxmox","proxmox-lxc","qemu","qemu-efi","raw","raw-efi","sd-card","vagrant-virtualbox","virtualbox","vmware"]\n'),
)
def test__get_system_attr__build_image(
    mock_run: Mock,
    monkeypatch: MonkeyPatch,
    tmpdir: Path,
) -> None:
    monkeypatch.chdir(tmpdir)

    # both `flake` & `build_attr` None
    args = argparse.Namespace(specialisation=None)
    with pytest.raises(Exception) as e:
        s._get_system_attr(
            action=n.models.Action.BUILD_IMAGE,
            args=args,
            flake=None,
            build_attr=None,
            grouped_nix_args=grouped_nix_args,
        )

    # no specialisation
    ## flake
    args = argparse.Namespace(image_variant="iso", specialisation=None)
    assert (
        s._get_system_attr(
            action=n.models.Action.BUILD_IMAGE,
            args=args,
            flake=n.models.Flake.parse("/flake.nix#hostname"),
            build_attr=None,
            grouped_nix_args=grouped_nix_args,
        )
        == "config.system.build.images.iso"
    )

    ## build_attr
    args = argparse.Namespace(image_variant="iso", specialisation=None)
    assert (
        s._get_system_attr(
            action=n.models.Action.BUILD_IMAGE,
            args=args,
            flake=None,
            build_attr=n.BuildAttr.from_arg(None, None),
            grouped_nix_args=grouped_nix_args,
        )
        == "config.system.build.images.iso"
    )

    # with specialisation
    ## flake
    args = argparse.Namespace(image_variant="iso", specialisation="custom-specialisation")
    assert (
        s._get_system_attr(
            action=n.models.Action.BUILD_IMAGE,
            args=args,
            flake=n.models.Flake.parse("/flake.nix#hostname"),
            build_attr=None,
            grouped_nix_args=grouped_nix_args,
        )
        == "config.specialisation.custom-specialisation.configuration.system.build.images.iso"
    )

    ## build_attr
    args = argparse.Namespace(image_variant="iso", specialisation="custom-specialisation")
    assert (
        s._get_system_attr(
            action=n.models.Action.BUILD_IMAGE,
            args=args,
            flake=None,
            build_attr=n.BuildAttr.from_arg(None, None),
            grouped_nix_args=grouped_nix_args,
        )
        == "config.specialisation.custom-specialisation.configuration.system.build.images.iso"
    )

@patch.dict(os.environ, {}, clear=True)
@patch("os.execve", autospec=True)
@patch(get_qualified_name(n.nix.run_wrapper, n.nix), autospec=True)
@patch(get_qualified_name(s.nix.build), autospec=True)
def test_reexec(
    mock_build: Mock,
    mock_run: Mock,
    mock_execve: Mock,
    monkeypatch: MonkeyPatch,
) -> None:
    mock_run.return_value = CompletedProcess([], 0, stdout="")

    monkeypatch.setattr(s, "EXECUTABLE", "nixos-rebuild-ng")
    argv = ["/path/bin/nixos-rebuild-ng", "switch", "--no-flake"]
    args, _ = n.parse_args(argv)
    mock_build.return_value = Path("/path")

    s.reexec(argv, args, grouped_nix_args)
    assert mock_build.mock_calls == [
        call(
            s.NIXOS_REBUILD_ATTR,
            n.models.BuildAttr(ANY, ANY),
            {"build": True, "no_out_link": True},
        )
    ]
    # do not exec if there is no new version
    mock_execve.assert_not_called()

    mock_build.return_value = Path("/path/new")

    s.reexec(argv, args, grouped_nix_args)
    # exec in the new version successfully
    mock_execve.assert_called_once_with(
        Path("/path/new/bin/nixos-rebuild-ng"),
        ["/path/bin/nixos-rebuild-ng", "switch", "--no-flake"],
        {s.NIXOS_REBUILD_REEXEC_ENV: "1"},
    )

    mock_execve.reset_mock()
    mock_execve.side_effect = [OSError("BOOM"), None]

    s.reexec(argv, args, grouped_nix_args)
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

    s.reexec(argv, args, grouped_nix_args)
    mock_build.assert_called_once_with(
        s.NIXOS_REBUILD_ATTR,
        n.models.Flake(ANY, ANY),
        {"flake_build": True, "flake_eval": True, "no_link": True},
    )
    # do not exec if there is no new version
    mock_execve.assert_not_called()

    mock_build.return_value = Path("/path/new")

    s.reexec(argv, args, grouped_nix_args)
    # exec in the new version successfully
    mock_execve.assert_called_once_with(
        Path("/path/new/bin/nixos-rebuild-ng"),
        ["/path/bin/nixos-rebuild-ng", "switch", "--flake"],
        {s.NIXOS_REBUILD_REEXEC_ENV: "1"},
    )

    mock_execve.reset_mock()
    mock_execve.side_effect = [OSError("BOOM"), None]

    s.reexec(argv, args, grouped_nix_args)
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

    s.reexec(argv, args, grouped_nix_args)
    mock_build.assert_not_called()
    mock_execve.assert_not_called()
