#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# === This file is part of Calamares - <https://github.com/calamares> ===
#
#   Calamares is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   Calamares is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with Calamares. If not, see <http://www.gnu.org/licenses/>.
#
#   SPDX-FileCopyrightText: 2019 Adriaan de Groot <groot@kde.org>
#   SPDX-License-Identifier: GPL-3.0-or-later
#

"""
=== NixOS Configuration

NixOS has its own "do all the things" configuration file which
declaratively handles what things need to be done in the target
system, and it has an existing tool to "execute" that declarative
specification. This module takes configuration values set by
Calamares viewmodules (e.g. the users module) and puts
them into the configuration file in the target system,
and then runs the necessary NixOS specific tools.
"""

import libcalamares
import os
from time import gmtime, strftime, sleep

import gettext
_ = gettext.translation("calamares-python",
                        localedir=libcalamares.utils.gettext_path(),
                        languages=libcalamares.utils.gettext_languages(),
                        fallback=True).gettext


# The following long **long** string is the entire text of
# a nix-configuration file. It is cribbed from, and adapted from,
# the sample file in https://github.com/itamar567/dotnix .
#
# We are going to substitute values into this text. However,
# Python's .format() function wants parens { } around variable
# names, and Nix's config file wants to use parens { } for block
# structure. So we have a compromise format here:
#
# - Write the config file as you would normally,
# - Write @@variable@@ instead of {variable}
#
# Some minor trickery later will massage this and substitute variables.
#
configuration_nix_sample = """# Nix configuration file
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./command-not-found/command-not-found.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Zen Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "@@hostname@@"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "@@timezone@@";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;
  networking.interfaces.enp42s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure X11
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };

    # Set i3 to the default session in the display manager
    displayManager.defaultSession = "none+i3";
  };

  # SSH fix
  programs.ssh.askPassword = pkgs.lib.mkForce "";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.username = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
  };

  # Disable password for sudo
  security.sudo.extraRules= [{
    groups = [ "wheel" ];
    commands = [{
        command = "ALL" ;
        options= [ "NOPASSWD" ];
    }];
  }];

  # Set ZSH as the default shell
  users.defaultUserShell = pkgs.zsh;

  # clean /tmp on boot
  boot.cleanTmpDir=true;

  # Config packages
  nixpkgs.config = {
    allowUnfree = true;

    chromium = {
      enableWideVine = true;
    };
  };

   # Automatically upgrade the system
   # This service is a modified version of https://github.com/NixOS/nixpkgs/blob/nixos-21.05/nixos/modules/tasks/auto-upgrade.nix#L122
   systemd = {
     services.nixos-upgrade = {
       description = "NixOS Upgrade";

       # We use --upgrade, so we need internet access
       wants = [ "network-online.target" ];

       restartIfChanged = false;
       unitConfig.X-StopOnRemoval = false;

       serviceConfig.Type = "oneshot";

       environment = config.nix.envVars // {
         inherit (config.environment.sessionVariables) NIX_PATH;
         HOME = "/root";
       } // config.networking.proxy.envVars;

       path = with pkgs; [
         coreutils
         gnutar
         xz.bin
         gzip
         gitMinimal
         config.nix.package.out
       ];

       script = let
         nixos-rebuild =
           "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
       in ''
         ${nixos-rebuild} boot --upgrade
         booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
         built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"
         if [ "$booted" = "$built" ]; then
           ${nixos-rebuild} switch
         fi
       '';
     };

     # To start the service at boot, we will use a systemd timer
     timers.nixos-upgrade = {
       wantedBy = [ "timers.target" ];
       partOf = [ "nixos-upgrade.service" ];
       timerConfig.OnBootSec = "5s";
     };
   };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
"""


def pretty_name():
    return _("NixOS Configuration.")


def catenate(d, key, *values):
    """
    Sets @p d[key] to the string-concatenation of @p values
    if none of the values are None.

    This can be used to set keys conditionally based on
    the values being found.
    """
    if [v for v in values if v is None]:
        return

    d[key] = "".join(values)


def run():
    """NixOS Configuration."""

    gs = libcalamares.globalstorage
    text = configuration_nix_sample

    # Collect variables to substitute into the main text
    variables = dict()
    catenate(variables, "hostname", gs.value("hostname"))
    catenate(variables, "timezone", gs.value("locationRegion"), "/", gs.value("locationZone"))

    # Check that all variables are used
    for key in variables.keys():
        pattern = "@@{key}@@".format(key=key)
        if not pattern in text:
            libcalamares.utils.warning("Variable '{key}' is not used.".format(key=key))

    # Check that all patterns exist
    import re
    variable_pattern = re.compile("@@\w+@@")
    for match in variable_pattern.finditer(text):
        variable_name = text[match.start()+2:match.end()-2]
        if not variable_name in variables:
            libcalamares.utils.warning("Variable '{key}' is used but not defined.".format(key=variable_name))

    # Do the substitutions
    for key in variables.keys():
        pattern = "@@{key}@@".format(key=key)
        text = text.replace(pattern, str(variables[key]))

    # Write the result to a temp-file, then run the main tool.
    # There is no progress reporting from the tool, so it's going
    # to seem like the module is hanging (see issue #1740).
    configuration_filename = "/tmp/configuration.nix"
    with open(configuration_filename, "w") as f:
        f.write(text)

    libcalamares.job.setprogress(0.1)
    libcalamares.utils.check_target_env_call(["nix", configuration_filename])

    # To indicate an error, return a tuple of:
    # (message, detailed-error-message)
    return None
