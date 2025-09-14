#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import configparser
import libcalamares
import os
import subprocess
import re

import gettext

_ = gettext.translation(
    "calamares-python",
    localedir=libcalamares.utils.gettext_path(),
    languages=libcalamares.utils.gettext_languages(),
    fallback=True,
).gettext


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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

"""

cfgbootbios = """  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "@@bootdev@@";
  boot.loader.grub.useOSProber = true;

"""

cfgbootnone = """  # Disable bootloader.
  boot.loader.grub.enable = false;

"""

cfgbootgrubcrypt = """  # Setup keyfile
  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;

"""

cfgnetwork = """  networking.hostName = "@@hostname@@"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

"""

cfgnetworkmanager = """  # Enable networking
  networking.networkmanager.enable = true;

"""

cfgconnman = """  # Enable networking
  services.connman.enable = true;

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

"""

cfggnome = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

"""

cfgplasma6 = """  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

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
  services.desktopManager.pantheon.enable = true;

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

cfgbudgie = """  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;

"""

cfgkeymap = """  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "@@kblayout@@";
    variant = "@@kbvariant@@";
  };

"""
cfgconsole = """  # Configure console keymap
  console.keyMap = "@@vconsole@@";

"""

cfgmisc = """  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
cfgusers = """  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.@@username@@ = {
    isNormalUser = true;
    description = "@@fullname@@";
    extraGroups = [ @@groups@@ ];
    packages = with pkgs; [@@pkgs@@];
  };

"""

cfgfirefox = """  # Install firefox.
  programs.firefox.enable = true;

"""

cfgautologin = """  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "@@username@@";

"""

cfgautologingdm = """  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

"""

cfgautologintty = """  # Enable automatic login for the user.
  services.getty.autologinUser = "@@username@@";

"""

cfgunfree = """  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

"""

cfgpkgs = """  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
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
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "@@nixosversion@@"; # Did you read the comment?

}
"""

cfglatestkernel = """  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

"""
def env_is_set(name):
    envValue = os.environ.get(name)
    return not (envValue is None or envValue == "")

def generateProxyStrings():
    proxyEnv = []
    if env_is_set('http_proxy'):
        proxyEnv.append('http_proxy={}'.format(os.environ.get('http_proxy')))
    if env_is_set('https_proxy'):
        proxyEnv.append('https_proxy={}'.format(os.environ.get('https_proxy')))
    if env_is_set('HTTP_PROXY'):
        proxyEnv.append('HTTP_PROXY={}'.format(os.environ.get('HTTP_PROXY')))
    if env_is_set('HTTPS_PROXY'):
        proxyEnv.append('HTTPS_PROXY={}'.format(os.environ.get('HTTPS_PROXY')))

    if len(proxyEnv) > 0:
        proxyEnv.insert(0, "env")

    return proxyEnv

def pretty_name():
    return _("Installing NixOS.")


status = pretty_name()


def pretty_status_message():
    return status


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

    global status
    status = _("Configuring NixOS")
    libcalamares.job.setprogress(0.1)

    ngc_cfg = configparser.ConfigParser()
    ngc_cfg["Defaults"] = { "Kernel": "lts" }
    ngc_cfg.read("/etc/nixos-generate-config.conf")

    # Create initial config file
    cfg = cfghead
    gs = libcalamares.globalstorage
    variables = dict()

    # Setup variables
    root_mount_point = gs.value("rootMountPoint")
    config = os.path.join(root_mount_point, "etc/nixos/configuration.nix")
    fw_type = gs.value("firmwareType")
    bootdev = (
        "nodev"
        if gs.value("bootLoader") is None
        else gs.value("bootLoader")["installPath"]
    )

    # Pick config parts and prepare substitution

    # Check bootloader
    if fw_type == "efi":
        cfg += cfgbootefi
    elif bootdev != "nodev":
        cfg += cfgbootbios
        catenate(variables, "bootdev", bootdev)
    else:
        cfg += cfgbootnone

    if ngc_cfg["Defaults"]["Kernel"] == "latest":
        cfg += cfglatestkernel

    # Setup encrypted swap devices. nixos-generate-config doesn't seem to notice them.
    for part in gs.value("partitions"):
        if (
            part["claimed"] is True
            and (part["fsName"] == "luks" or part["fsName"] == "luks2")
            and part["device"] is not None
            and part["fs"] == "linuxswap"
        ):
            cfg += """  boot.initrd.luks.devices."{}".device = "/dev/disk/by-uuid/{}";\n""".format(
                part["luksMapperName"], part["uuid"]
            )

    # Check partitions
    root_is_encrypted = False
    boot_is_encrypted = False
    boot_is_partition = False

    for part in gs.value("partitions"):
        if part["mountPoint"] == "/":
            root_is_encrypted = part["fsName"] in ["luks", "luks2"]
        elif part["mountPoint"] == "/boot":
            boot_is_partition = True
            boot_is_encrypted = part["fsName"] in ["luks", "luks2"]

    # Setup keys in /boot/crypto_keyfile if using BIOS and Grub cryptodisk
    if fw_type != "efi" and (
        (boot_is_partition and boot_is_encrypted)
        or (root_is_encrypted and not boot_is_partition)
    ):
        cfg += cfgbootgrubcrypt
        status = _("Setting up LUKS")
        libcalamares.job.setprogress(0.15)
        try:
            libcalamares.utils.host_env_process_output(
                ["mkdir", "-p", root_mount_point + "/boot"], None
            )
            libcalamares.utils.host_env_process_output(
                ["chmod", "0700", root_mount_point + "/boot"], None
            )
            # Create /boot/crypto_keyfile.bin
            libcalamares.utils.host_env_process_output(
                [
                    "dd",
                    "bs=512",
                    "count=4",
                    "if=/dev/random",
                    "of=" + root_mount_point + "/boot/crypto_keyfile.bin",
                    "iflag=fullblock",
                ],
                None,
            )
            libcalamares.utils.host_env_process_output(
                ["chmod", "600", root_mount_point + "/boot/crypto_keyfile.bin"], None
            )
        except subprocess.CalledProcessError:
            libcalamares.utils.error("Failed to create /boot/crypto_keyfile.bin")
            return (
                _("Failed to create /boot/crypto_keyfile.bin"),
                _("Check if you have enough free space on your partition."),
            )

        for part in gs.value("partitions"):
            if (
                part["claimed"] is True
                and (part["fsName"] == "luks" or part["fsName"] == "luks2")
                and part["device"] is not None
            ):
                cfg += """  boot.initrd.luks.devices."{}".keyFile = "/boot/crypto_keyfile.bin";\n""".format(
                    part["luksMapperName"]
                )
                try:
                    # Grub currently only supports pbkdf2 for luks2
                    libcalamares.utils.host_env_process_output(
                        [
                            "cryptsetup",
                            "luksConvertKey",
                            "--hash",
                            "sha256",
                            "--pbkdf",
                            "pbkdf2",
                            part["device"],
                        ],
                        None,
                        part["luksPassphrase"],
                    )
                    # Add luks drives to /boot/crypto_keyfile.bin
                    libcalamares.utils.host_env_process_output(
                        [
                            "cryptsetup",
                            "luksAddKey",
                            "--hash",
                            "sha256",
                            "--pbkdf",
                            "pbkdf2",
                            part["device"],
                            root_mount_point + "/boot/crypto_keyfile.bin",
                        ],
                        None,
                        part["luksPassphrase"],
                    )
                except subprocess.CalledProcessError:
                    libcalamares.utils.error(
                        "Failed to add {} to /boot/crypto_keyfile.bin".format(
                            part["luksMapperName"]
                        )
                    )
                    return (
                        _("cryptsetup failed"),
                        _(
                            "Failed to add {} to /boot/crypto_keyfile.bin".format(
                                part["luksMapperName"]
                            )
                        ),
                    )

    status = _("Configuring NixOS")
    libcalamares.job.setprogress(0.18)

    cfg += cfgnetwork
    if gs.value("packagechooser_packagechooser") == "enlightenment":
        cfg += cfgconnman
    else:
        cfg += cfgnetworkmanager

    if (
        (gs.value("packagechooser_packagechooser") == "mate")
        | (gs.value("packagechooser_packagechooser") == "lxqt")
        | (gs.value("packagechooser_packagechooser") == "lumina")
    ):
        cfg += cfgnmapplet

    if gs.value("hostname") is None:
        catenate(variables, "hostname", "nixos")
    else:
        catenate(variables, "hostname", gs.value("hostname"))

    if gs.value("locationRegion") is not None and gs.value("locationZone") is not None:
        cfg += cfgtime
        catenate(
            variables,
            "timezone",
            gs.value("locationRegion"),
            "/",
            gs.value("locationZone"),
        )

    if gs.value("localeConf") is not None:
        localeconf = gs.value("localeConf")
        locale = localeconf.pop("LANG").split("/")[0]
        cfg += cfglocale
        catenate(variables, "LANG", locale)
        if (
            len(set(localeconf.values())) != 1
            or list(set(localeconf.values()))[0] != locale
        ):
            cfg += cfglocaleextra
            for conf in localeconf:
                catenate(variables, conf, localeconf.get(conf).split("/")[0])

    # Choose desktop environment
    if gs.value("packagechooser_packagechooser") == "gnome":
        cfg += cfggnome
    elif gs.value("packagechooser_packagechooser") == "plasma6":
        cfg += cfgplasma6
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
    elif gs.value("packagechooser_packagechooser") == "budgie":
        cfg += cfgbudgie

    if (
        gs.value("keyboardLayout") is not None
        and gs.value("keyboardVariant") is not None
    ):
        cfg += cfgkeymap
        catenate(variables, "kblayout", gs.value("keyboardLayout"))
        catenate(variables, "kbvariant", gs.value("keyboardVariant"))

        if gs.value("keyboardVConsoleKeymap") is not None:
            try:
                subprocess.check_output(
                    ["pkexec", "loadkeys", gs.value("keyboardVConsoleKeymap").strip()],
                    stderr=subprocess.STDOUT,
                )
                cfg += cfgconsole
                catenate(
                    variables, "vconsole", gs.value("keyboardVConsoleKeymap").strip()
                )
            except subprocess.CalledProcessError as e:
                libcalamares.utils.error("loadkeys: {}".format(e.output))
                libcalamares.utils.error(
                    "Setting vconsole keymap to {} will fail, using default".format(
                        gs.value("keyboardVConsoleKeymap").strip()
                    )
                )
        else:
            kbdmodelmap = open(
                "/run/current-system/sw/share/systemd/kbd-model-map", "r"
            )
            kbd = kbdmodelmap.readlines()
            out = []
            for line in kbd:
                if line.startswith("#"):
                    continue
                out.append(line.split())
            # Find rows with same layout
            find = []
            for row in out:
                if gs.value("keyboardLayout") == row[1]:
                    find.append(row)
            if find != []:
                vconsole = find[0][0]
            else:
                vconsole = ""
            if gs.value("keyboardVariant") is not None:
                variant = gs.value("keyboardVariant")
            else:
                variant = "-"
            # Find rows with same variant
            for row in find:
                if variant in row[3]:
                    vconsole = row[0]
                    break
                # If none found set to "us"
            if vconsole != "" and vconsole != "us" and vconsole is not None:
                try:
                    subprocess.check_output(
                        ["pkexec", "loadkeys", vconsole], stderr=subprocess.STDOUT
                    )
                    cfg += cfgconsole
                    catenate(variables, "vconsole", vconsole)
                except subprocess.CalledProcessError as e:
                    libcalamares.utils.error("loadkeys: {}".format(e.output))
                    libcalamares.utils.error("vconsole value: {}".format(vconsole))
                    libcalamares.utils.error(
                        "Setting vconsole keymap to {} will fail, using default".format(
                            gs.value("keyboardVConsoleKeymap")
                        )
                    )

    if (
        gs.value("packagechooser_packagechooser") is not None
        and gs.value("packagechooser_packagechooser") != ""
    ):
        cfg += cfgmisc

    if gs.value("username") is not None:
        fullname = gs.value("fullname")
        groups = ["networkmanager", "wheel"]

        cfg += cfgusers
        catenate(variables, "username", gs.value("username"))
        catenate(variables, "fullname", fullname)
        catenate(variables, "groups", (" ").join(['"' + s + '"' for s in groups]))
        if (
            gs.value("autoLoginUser") is not None
            and gs.value("packagechooser_packagechooser") is not None
            and gs.value("packagechooser_packagechooser") != ""
        ):
            cfg += cfgautologin
            if gs.value("packagechooser_packagechooser") == "gnome":
                cfg += cfgautologingdm
        elif gs.value("autoLoginUser") is not None:
            cfg += cfgautologintty

    if gs.value("packagechooser_packagechooser") != "":
        cfg += cfgfirefox

    # Check if unfree packages are allowed
    free = True
    if gs.value("nixos_allow_unfree"):
        free = False
        cfg += cfgunfree

    cfg += cfgpkgs
    # Use firefox as default as a graphical web browser, and add kate to plasma desktop
    if gs.value("packagechooser_packagechooser") == "plasma6":
        catenate(
            variables, "pkgs", "\n      kdePackages.kate\n    #  thunderbird\n    "
        )
    elif gs.value("packagechooser_packagechooser") != "":
        catenate(variables, "pkgs", "\n    #  thunderbird\n    ")
    else:
        catenate(variables, "pkgs", "")

    cfg += cfgtail
    version = ".".join(subprocess.getoutput(["nixos-version"]).split(".")[:2])[:5]
    catenate(variables, "nixosversion", version)

    # Check that all variables are used
    for key in variables.keys():
        pattern = "@@{key}@@".format(key=key)
        if pattern not in cfg:
            libcalamares.utils.warning("Variable '{key}' is not used.".format(key=key))

    # Check that all patterns exist
    variable_pattern = re.compile(r"@@\w+@@")
    for match in variable_pattern.finditer(cfg):
        variable_name = cfg[match.start() + 2 : match.end() - 2]
        if variable_name not in variables:
            libcalamares.utils.warning(
                "Variable '{key}' is used but not defined.".format(key=variable_name)
            )

    # Do the substitutions
    for key in variables.keys():
        pattern = "@@{key}@@".format(key=key)
        cfg = cfg.replace(pattern, str(variables[key]))

    status = _("Generating NixOS configuration")
    libcalamares.job.setprogress(0.25)

    try:
        # Generate hardware.nix with mounted swap device
        subprocess.check_output(
            ["pkexec", "nixos-generate-config", "--root", root_mount_point],
            stderr=subprocess.STDOUT,
        )
    except subprocess.CalledProcessError as e:
        if e.output is not None:
            libcalamares.utils.error(e.output.decode("utf8"))
        return (_("nixos-generate-config failed"), _(e.output.decode("utf8")))

    # Check for unfree stuff in hardware-configuration.nix
    hf = open(root_mount_point + "/etc/nixos/hardware-configuration.nix", "r")
    htxt = hf.read()
    search = re.search(r"boot\.extraModulePackages = \[ (.*) \];", htxt)

    # Check if any extraModulePackages are defined, and remove if only free packages are allowed
    if search is not None and free:
        expkgs = search.group(1).split(" ")
        for pkg in expkgs:
            p = ".".join(pkg.split(".")[3:])
            # Check package p is unfree
            isunfree = subprocess.check_output(
                [
                    "nix-instantiate",
                    "--eval",
                    "--strict",
                    "-E",
                    "with import <nixpkgs> {{}}; pkgs.linuxKernel.packageAliases.linux_default.{}.meta.unfree".format(
                        p
                    ),
                    "--json",
                ],
                stderr=subprocess.STDOUT,
            )
            if isunfree == b"true":
                libcalamares.utils.warning(
                    "{} is marked as unfree, removing from hardware-configuration.nix".format(
                        p
                    )
                )
                expkgs.remove(pkg)
        hardwareout = re.sub(
            r"boot\.extraModulePackages = \[ (.*) \];",
            "boot.extraModulePackages = [ {}];".format(
                "".join(map(lambda x: x + " ", expkgs))
            ),
            htxt,
        )
        # Write the hardware-configuration.nix file
        libcalamares.utils.host_env_process_output(
            [
                "cp",
                "/dev/stdin",
                root_mount_point + "/etc/nixos/hardware-configuration.nix",
            ],
            None,
            hardwareout,
        )

    # Write the configuration.nix file
    libcalamares.utils.host_env_process_output(["cp", "/dev/stdin", config], None, cfg)

    status = _("Installing NixOS")
    libcalamares.job.setprogress(0.3)

    # build nixos-install command
    nixosInstallCmd = [ "pkexec" ]
    nixosInstallCmd.extend(generateProxyStrings())
    nixosInstallCmd.extend(
        [
            "nixos-install",
            "--no-root-passwd",
            "--root",
            root_mount_point
        ]
    )

    # Install customizations
    try:
        output = ""
        proc = subprocess.Popen(
            nixosInstallCmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        )
        while True:
            line = proc.stdout.readline().decode("utf-8")
            output += line
            libcalamares.utils.debug("nixos-install: {}".format(line.strip()))
            if not line:
                break
        exit = proc.wait()
        if exit != 0:
            return (_("nixos-install failed"), _(output))
    except:
        return (_("nixos-install failed"), _("Installation failed to complete"))

    return None
