#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#   SPDX-FileCopyrightText: 2022 Victor Fuentes <vmfuentes64@gmail.com>
#   SPDX-License-Identifier: GPL-3.0-or-later
#
#   Calamares is Free Software: see the License-Identifier above.
#

import os
import subprocess

import libcalamares
from libcalamares.utils import gettext_path, gettext_languages

import gettext
_translation = gettext.translation("calamares-python",
                                   localedir=gettext_path(),
                                   languages=gettext_languages(),
                                   fallback=True)
_ = _translation.gettext
_n = _translation.ngettext


def pretty_name():
    return _("Installing NixOS base system.")


def run():

    gs = libcalamares.globalstorage
    root_mount_point = gs.value("rootMountPoint")

    if not root_mount_point:
        return ("No mount point for root partition in globalstorage",
                "globalstorage does not contain a \"rootMountPoint\" key, "
                "doing nothing")

    if not os.path.exists(root_mount_point):
        return ("Bad mount point for root partition in globalstorage",
                "globalstorage[\"rootMountPoint\"] is \"{}\", which does not "
                "exist, doing nothing".format(root_mount_point))

    # Mount swap partition
    for part in gs.value("partitions"):
        if part["claimed"] == True and part["fs"] == "linuxswap":
            if part["fsName"] == "luks":
                try:
                    subprocess.check_output(
                        ["swapon", "/dev/mapper/" + part["luksMapperName"]], stderr=subprocess.STDOUT)
                except subprocess.CalledProcessError as e:
                    if e.output != None:
                        libcalamares.utils.error(e.output.decode("utf8"))
                    return (_("swapon failed to activate swap " + "/dev/mapper/" + part["luksMapperName"]), _(e.output.decode("utf8")))
            else:
                try:
                    subprocess.check_output(
                        ["swapon", part["device"]], stderr=subprocess.STDOUT)
                except subprocess.CalledProcessError as e:
                    if e.output != None:
                        libcalamares.utils.error(e.output.decode("utf8"))
                    return (_("swapon failed to activate swap " + part["device"]), _(e.output.decode("utf8")))
            break

    subprocess.check_output(
        ["chmod", "o+rx", root_mount_point], stderr=subprocess.STDOUT)
    try:
        subprocess.check_output(
            ["nixos-generate-config", "--root", root_mount_point], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        if e.output != None:
            libcalamares.utils.error(e.output.decode("utf8"))
        return (_("nixos-generate-config failed"), _(e.output.decode("utf8")))

    config = os.path.join(root_mount_point, "etc/nixos/configuration.nix")

    if not os.path.exists(config):
        return (_("nixos-generate-config failed"),
                _("nixos-generate-config did not create configuration.nix"))

    bootloader = gs.value("bootLoader")
    fw_type = gs.value("firmwareType")

    try:
        # If we have a BIOS system set the grub device
        # If no device is specified, disable grub
        if (fw_type != "efi"):
            if (bootloader != None):
                subprocess.check_output(["sed", "-i", "s,  # boot.loader.grub.device = .*,  boot.loader.grub.device = \"" +
                                        bootloader['installPath'] + "\";,g", config], stderr=subprocess.STDOUT)
            else:
                subprocess.check_output(
                    ["sed", "-i", "s,  boot.loader.grub.enable = .*,  boot.loader.grub.enable = false;,g", config], stderr=subprocess.STDOUT)

        # Remove services and networking options, we'll install them later
        subprocess.check_output(
            ["sed", "-i", "/  services.*/d", config], stderr=subprocess.STDOUT)
        subprocess.check_output(
            ["sed", "-i", "/  networking.*/d", config], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        if e.output != None:
            libcalamares.utils.error(e.output.decode("utf8"))
        return (_("sed failed"), _(e.output.decode("utf8")))

    libcalamares.job.setprogress(0.3)

    try:
        subprocess.check_output(["nixos-install", "--no-root-passwd", "--no-bootloader",
                                 "--root", root_mount_point], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        if e.output != None:
            libcalamares.utils.error(e.output.decode("utf8"))
        return (_("nixos-install failed"), _(e.output.decode("utf8")))

    libcalamares.job.setprogress(0.9)
    # Fix issues in modules that use chroot
    try:
        subprocess.check_output(
            ["chroot", root_mount_point, "/nix/var/nix/profiles/system/activate"], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        if e.output != None:
            libcalamares.utils.error(e.output.decode("utf8"))
        return (_("chroot failed"), _(e.output.decode("utf8")))

    return None
