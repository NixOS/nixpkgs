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

import gettext
_ = gettext.translation("calamares-python",
                        localedir=libcalamares.utils.gettext_path(),
                        languages=libcalamares.utils.gettext_languages(),
                        fallback=True).gettext


# The following strings contain pieces of a nix-configuration file.
# They are adapted from the default config generated from the nixos-generate-config command.

cfghead = """# Edit this configuration file to define what should be installed on
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

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = "/crypto_keyfile.bin";
  };

"""

cfgswapcrypt = """  # Enable swap on luks
  boot.initrd.luks.devices."@@swapdev@@".device = "/dev/disk/by-uuid/@@swapuuid@@";
  boot.initrd.luks.devices."@@swapdev@@".keyFile = "/crypto_keyfile.bin";

"""

cfgnetwork = """  networking.hostName = "@@hostname@@"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

"""

cfgnetworkenlightenment = """  networking.hostName = "@@hostname@@"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  services.connman.enable = true;
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

"""

cfgnmapplet = """  # Enable network manager applet
  programs.nm-applet.enable = true;

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

"""

cfggnome = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

"""

cfgplasma = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

"""

cfgxfce = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

"""

cfgpantheon = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Pantheon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.displayManager.lightdm.greeters.pantheon.enable = true;
  # services.pantheon.apps.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

"""

cfgcinnamon = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

"""

cfgmate = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the MATE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.mate.enable = true;

"""

cfgenlightenment = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Enlightenment Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.enlightenment.enable = true;

  # Enable acpid
  services.acpid.enable = true;

"""

cfglxqt = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the LXQT Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;

"""

cfglumina = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Lumina Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.lumina.enable = true;

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

"""

cfgautologingdm = """  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

"""

cfgpkgs = """  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox@@pkgs@@
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
    return _("Installing NixOS.")


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
    bootdev = "nodev" if gs.value("bootLoader") is None else gs.value(
        "bootLoader")['installPath']

    # Pick config parts and prepare substitution

    # Check bootloader
    if (fw_type == "efi"):
        cfg += cfgbootefi
    elif (bootdev != "nodev"):
        cfg += cfgbootbios
        catenate(variables, "bootdev", bootdev)
    else:
        cfg += cfgbootnone

    # Check partitions
    for part in gs.value("partitions"):
        if part["claimed"] == True and part["fsName"] == "luks" and part["fs"] != "linuxswap":
            cfg += cfgbootcrypt
            break

    for part in gs.value("partitions"):
        if part["claimed"] == True and part["fsName"] == "luks" and part["fs"] != "linuxswap":
            cfg += """  boot.initrd.luks.devices."{}".keyFile = "/crypto_keyfile.bin";
""".format(part["luksMapperName"])

    for part in gs.value("partitions"):
        if part["claimed"] == True and part["fs"] == "linuxswap" and part["fsName"] == "luks":
            cfg += cfgswapcrypt
            catenate(variables, "swapdev", part["luksMapperName"])
            catenate(variables, "swapuuid", part["luksUuid"])
            break

    if gs.value("packagechooser_packagechooser") == "enlightenment":
        cfg += cfgnetworkenlightenment
    else:
        cfg += cfgnetwork

    if (gs.value("packagechooser_packagechooser") == "mate") | (gs.value("packagechooser_packagechooser") == "lxqt") | (gs.value("packagechooser_packagechooser") == "lumina"):
        cfg += cfgnmapplet

    if (gs.value("hostname") is None):
        catenate(variables, "hostname", "nixos")
    else:
        catenate(variables, "hostname", gs.value("hostname"))

    if (gs.value("locationRegion") is not None and gs.value("locationZone") is not None):
        cfg += cfgtime
        catenate(variables, "timezone", gs.value(
            "locationRegion"), "/", gs.value("locationZone"))

    if (gs.value("localeConf") is not None):
        localeconf = gs.value("localeConf")
        locale = localeconf.pop("LANG")
        cfg += cfglocale
        catenate(variables, "LANG", locale)
        if (len(set(localeconf.values())) != 1 or list(set(localeconf.values()))[0] != locale):
            cfg += cfglocaleextra
            for conf in localeconf:
                catenate(variables, conf, localeconf.get(conf))

    # Choose desktop environment
    if gs.value("packagechooser_packagechooser") == "gnome":
        cfg += cfggnome
    elif gs.value("packagechooser_packagechooser") == "plasma":
        cfg += cfgplasma
    elif gs.value("packagechooser_packagechooser") == "xfce":
        cfg += cfgxfce
    elif gs.value("packagechooser_packagechooser") == "pantheon":
        cfg += cfgpantheon
    elif gs.value("packagechooser_packagechooser") == "cinnamon":
        cfg += cfgcinnamon
    elif gs.value("packagechooser_packagechooser") == "mate":
        cfg += cfgmate
    elif gs.value("packagechooser_packagechooser") == "enlightenment":
        cfg += cfgenlightenment
    elif gs.value("packagechooser_packagechooser") == "lxqt":
        cfg += cfglxqt
    elif gs.value("packagechooser_packagechooser") == "lumina":
        cfg += cfglumina

    if (gs.value("keyboardLayout") is not None and gs.value("keyboardVariant") is not None):
        cfg += cfgkeymap
        catenate(variables, "kblayout", gs.value("keyboardLayout"))
        catenate(variables, "kbvariant", gs.value("keyboardVariant"))

    cfg += cfgmisc

    if (gs.value("username") is not None):
        fullname = gs.value("fullname")
        groups = ["users" "networkmanager" "wheel"]

        if "users" in groups:
            groups.remove("users")
        if gs.value("username") in groups:
            groups.remove(gs.value("username"))

        cfg += cfgusers
        catenate(variables, "username", gs.value("username"))
        catenate(variables, "fullname", fullname)
        catenate(variables, "groups", (" ").join(
            ["\"" + s + "\"" for s in groups]))
        if (gs.value("autoLoginUser") is not None):
            cfg += cfgautologin
            if (gs.value("packagechooser_packagechooser") == "gnome"):
                cfg += cfgautologingdm

    cfg += cfgpkgs
    if gs.value("packagechooser_packagechooser") == "plasma":
        catenate(variables, "pkgs", "\n    kate")
    else:
        catenate(variables, "pkgs", "")

    cfg += cfgtail
    version = ".".join(subprocess.getoutput(
        ["nixos-version"]).split(".")[:2])[:5]
    catenate(variables, "nixosversion", version)

    # Check that all variables are used
    for key in variables.keys():
        pattern = "@@{key}@@".format(key=key)
        if not pattern in cfg:
            libcalamares.utils.warning(
                "Variable '{key}' is not used.".format(key=key))

    # Check that all patterns exist
    import re
    variable_pattern = re.compile("@@\w+@@")
    for match in variable_pattern.finditer(cfg):
        variable_name = cfg[match.start()+2:match.end()-2]
        if not variable_name in variables:
            libcalamares.utils.warning(
                "Variable '{key}' is used but not defined.".format(key=variable_name))

    # Do the substitutions
    for key in variables.keys():
        pattern = "@@{key}@@".format(key=key)
        cfg = cfg.replace(pattern, str(variables[key]))

    libcalamares.job.setprogress(0.1)

    try:
        # Generate hardware.nix with mounted swap device
        subprocess.check_output(
            ["nixos-generate-config", "--root", root_mount_point], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        if e.output != None:
            libcalamares.utils.error(e.output.decode("utf8"))
        return (_("nixos-generate-config failed"), _(e.output.decode("utf8")))

    libcalamares.job.setprogress(0.3)

    # Write the configuration file
    with open(config, "w") as f:
        f.write(cfg)

    # Install customizations
    try:
        subprocess.check_output(["nixos-install", "--no-root-passwd",
                                 "--root", root_mount_point], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        if e.output != None:
            libcalamares.utils.error(e.output.decode("utf8"))
        return (_("nixos-install failed"), _(e.output.decode("utf8")))

    return None
