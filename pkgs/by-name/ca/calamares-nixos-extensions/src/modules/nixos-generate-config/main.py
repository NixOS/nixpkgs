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
import shutil
import re

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
    return _( "Installing NixOS base system." )

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
    subprocess.check_output(["chmod", "o+rx", root_mount_point], stderr=subprocess.STDOUT)
    subprocess.check_output(["nixos-generate-config", "--root", root_mount_point], stderr=subprocess.STDOUT)

    config = os.path.join(root_mount_point, "etc/nixos/configuration.nix")

    if not os.path.exists(config):
        return ("nixos-generate-config failed",
                "nixos-generate-config did not create configuration.nix")

    bootloader = gs.value("bootLoader")
    fw_type = gs.value("firmwareType")

    # If we have a BIOS system set the grub device
    # If no device is specified, disable grub
    if (fw_type != "efi"):
        if (bootloader != None):
            subprocess.check_output(["sed","-i","s,  # boot.loader.grub.device = .*,  boot.loader.grub.device = \"" + bootloader['installPath'] + "\";,g", config], stderr=subprocess.STDOUT)
        else:
            subprocess.check_output(["sed","-i","s,  boot.loader.grub.enable = .*,  boot.loader.grub.enable = false;,g", config], stderr=subprocess.STDOUT)

    # Remove services, we'll install them later
    subprocess.check_output(["sed","-i","/  services.*/d", config], stderr=subprocess.STDOUT)

    libcalamares.job.setprogress(0.3)

    subprocess.check_output(["nixos-install", "--no-root-passwd", "--no-bootloader", "--root", root_mount_point], stderr=subprocess.STDOUT)

    libcalamares.job.setprogress(0.9)
    # Fix issues in modules that use chroot
    subprocess.check_output(["chroot", root_mount_point, "/nix/var/nix/profiles/system/activate"], stderr=subprocess.STDOUT)

    return None