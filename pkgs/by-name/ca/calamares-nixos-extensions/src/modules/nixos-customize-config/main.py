#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#   SPDX-FileCopyrightText: 2022 Victor Fuentes <vmfuentes64@gmail.com>
#   SPDX-FileCopyrightText: 2019 Adriaan de Groot <groot@kde.org>
#   SPDX-License-Identifier: GPL-3.0-or-later
#
#   Calamares is Free Software: see the License-Identifier above.
#

import libcalamares
import os
import subprocess
from time import gmtime, strftime, sleep

import gettext
_ = gettext.translation("calamares-python",
                        localedir=libcalamares.utils.gettext_path(),
                        languages=libcalamares.utils.gettext_languages(),
                        fallback=True).gettext


# The following strings contain pieces of a nix-configuration file.
# They are adapted from the default config generated from the nixos-generate-config command.

cfghead ="""# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

"""
cfgbootefi = """  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

"""

cfgbootbios = """  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "@@bootdev@@";
  boot.loader.grub.useOSProber = true;

"""

cfgbootnone = """  # Disable bootloader.
  boot.loader.grub.enable = false;

"""

cfgbootcrypt = """  # Enable grub cryptodisk
  boot.loader.grub.enableCryptodisk=true;

"""

cfgnetwork = """  networking.hostName = "@@hostname@@"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

"""

cfgtime = """  # Set your time zone.
  time.timeZone = "@@timezone@@";

"""

cfglocale = """  # Select internationalisation properties.
  i18n.defaultLocale = "@@LANG@@";

"""

cfglocaleextra = """  i18n.extraLocaleSettings = {
    LC_ADDRESS = "@@LC_ADDRESS@@";
    LC_IDENTIFICATION = "@@LC_IDENTIFICATION@@";
    LC_MEASUREMENT = "@@LC_MEASUREMENT@@";
    LC_MONETARY = "@@LC_MONETARY@@";
    LC_NAME = "@@LC_NAME@@";
    LC_NUMERIC = "@@LC_NUMERIC@@";
    LC_PAPER = "@@LC_PAPER@@";
    LC_TELEPHONE = "@@LC_TELEPHONE@@";
    LC_TIME = "@@LC_TIME@@";
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Fix localectl: https://github.com/NixOS/nixpkgs/issues/19629
  services.xserver.exportConfiguration = true;

"""

cfggnome = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Override GNOME defaults
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
  [org.gnome.desktop.interface]
  gtk-theme='Adwaita-dark'
  '';

"""

cfgkeymap = """  # Configure keymap in X11
  services.xserver = {
    layout = "@@kblayout@@";
    xkbVariant = "@@kbvariant@@";
  };

"""

cfgmisc = """  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

"""
cfgusers = """
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.@@username@@ = {
    isNormalUser = true;
    description = "@@fullname@@";
    extraGroups = [ @@groups@@ ];
  };

"""

cfgautologin = """  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "@@username@@";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

"""

cfgpkgs = """  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
  ];

"""

cfgtail = """  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "@@nixosversion@@"; # Did you read the comment?

}
"""

def pretty_name():
    return _("Configuring NixOS.")

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

    # Create initial config file
    cfg = cfghead
    gs = libcalamares.globalstorage
    variables = dict()

    # Setup variables
    root_mount_point = gs.value("rootMountPoint")
    config = os.path.join(root_mount_point, "etc/nixos/configuration.nix")
    fw_type = gs.value("firmwareType")
    bootdev = "nodev" if gs.value("bootLoader") is None else gs.value("bootLoader")['installPath']

    # Pick config parts and prepare substitution
    if (fw_type == "efi"):
      cfg += cfgbootefi
    elif (bootdev != "nodev"):
      cfg += cfgbootbios
      catenate(variables, "bootdev", bootdev)
    else:
      cfg += cfgbootnone

    for part in gs.value("partitions"):
      if part["claimed"] == True and part["fsName"] == "luks":
        cfg += cfgbootcrypt
        break
    
    cfg += cfgnetwork
    if (gs.value("hostname") is None):
      catenate(variables, "hostname", "nixos")
    else:
      catenate(variables, "hostname", gs.value("hostname"))

    if (gs.value("locationRegion") is not None and gs.value("locationZone") is not None):
      cfg += cfgtime
      catenate(variables, "timezone", gs.value("locationRegion"), "/", gs.value("locationZone"))

    if (gs.value("localeConf") is not None):
        localeconf = gs.value("localeConf")
        locale = localeconf.pop("LANG")
        cfg += cfglocale
        catenate(variables, "LANG", locale)
        if (len(set(localeconf.values())) != 1 or list(set(localeconf.values()))[0] != locale):
          cfg += cfglocaleextra
          for conf in localeconf:
            catenate(variables, conf, localeconf.get(conf))

    cfg += cfggnome

    if (gs.value("KeyboardLayout") is not None and gs.value("KeyboardVariant") is not None):
      cfg += cfgkeymap
      catenate(variables, "kblayout", gs.value("keyboardLayout"))
      catenate(variables, "kbvariant", gs.value("keyboardVariant"))

    cfg += cfgmisc

    if (gs.value("username") is not None):
      passwd = subprocess.check_output(["chroot", root_mount_point, "getent","passwd", gs.value("username")], stderr=subprocess.STDOUT).decode("utf-8").rstrip("\n").split(":")
      fullname = passwd[4]
      groups = subprocess.check_output(["chroot", root_mount_point, "groups",gs.value("username")]).decode("utf-8").rstrip("\n").split(":")[1].lstrip().split(" ")
      groups.remove("users")
      groups.remove(gs.value("username"))
      cfg += cfgusers
      catenate(variables, "username", gs.value("username"))
      catenate(variables, "fullname", fullname)
      catenate(variables, "groups", (" ").join(["\"" + s + "\"" for s in groups]))
      print("AUTOLOGINUSER")
      print(gs.value("autologinUser"))
      if (gs.value("autoLoginUser") is not None):
        cfg += cfgautologin

    cfg += cfgpkgs

    cfg += cfgtail
    version = ".".join(subprocess.getoutput(["nixos-version"]).split(".")[:2])[:5]
    catenate(variables, "nixosversion", version)

    # Check that all variables are used
    for key in variables.keys():
        pattern = "@@{key}@@".format(key=key)
        if not pattern in cfg:
            libcalamares.utils.warning("Variable '{key}' is not used.".format(key=key))

    # Check that all patterns exist
    import re
    variable_pattern = re.compile("@@\w+@@")
    for match in variable_pattern.finditer(cfg):
        variable_name = cfg[match.start()+2:match.end()-2]
        if not variable_name in variables:
            libcalamares.utils.warning("Variable '{key}' is used but not defined.".format(key=variable_name))

    # Do the substitutions
    for key in variables.keys():
        pattern = "@@{key}@@".format(key=key)
        cfg = cfg.replace(pattern, str(variables[key]))

    # Write the configuration file
    with open(config, "w") as f:
        f.write(cfg)

    libcalamares.job.setprogress(0.1)

    # Install customizations
    subprocess.check_output(["nixos-install", "--no-root-passwd", "--no-bootloader", "--root", root_mount_point], stderr=subprocess.STDOUT)
    subprocess.check_output(["nixos-enter", "--root", root_mount_point, "--", "nix-collect-garbage","-d"], stderr=subprocess.STDOUT)
    libcalamares.job.setprogress(0.4)
    subprocess.check_output(["nixos-enter", "--root", root_mount_point, "--", "nixos-rebuild", "boot"], stderr=subprocess.STDOUT)

    return None
