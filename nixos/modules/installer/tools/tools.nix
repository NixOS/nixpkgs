# This module generates nixos-install, nixos-rebuild,
# nixos-generate-config, etc.

{ config, lib, pkgs, ... }:

with lib;

let
  makeProg = args: pkgs.substituteAll (args // {
    dir = "bin";
    isExecutable = true;
  });

  nixos-build-vms = makeProg {
    name = "nixos-build-vms";
    src = ./nixos-build-vms/nixos-build-vms.sh;
    inherit (pkgs) runtimeShell;
  };

  nixos-install = makeProg {
    name = "nixos-install";
    src = ./nixos-install.sh;
    inherit (pkgs) runtimeShell;
    nix = config.nix.package.out;
    path = makeBinPath [
      pkgs.jq
      nixos-enter
      pkgs.util-linuxMinimal
    ];
  };

  nixos-rebuild = pkgs.nixos-rebuild.override { nix = config.nix.package.out; };

  nixos-generate-config = makeProg {
    name = "nixos-generate-config";
    src = ./nixos-generate-config.pl;
    perl = "${pkgs.perl.withPackages (p: [ p.FileSlurp ])}/bin/perl";
    hostPlatformSystem = pkgs.stdenv.hostPlatform.system;
    detectvirt = "${config.systemd.package}/bin/systemd-detect-virt";
    btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
    inherit (config.system.nixos-generate-config) configuration desktopConfiguration;
    xserverEnabled = config.services.xserver.enable;
  };

  nixos-option =
    if lib.versionAtLeast (lib.getVersion config.nix.package) "2.4pre"
    then null
    else pkgs.nixos-option;

  nixos-version = makeProg {
    name = "nixos-version";
    src = ./nixos-version.sh;
    inherit (pkgs) runtimeShell;
    inherit (config.system.nixos) version codeName revision;
    inherit (config.system) configurationRevision;
    json = builtins.toJSON ({
      nixosVersion = config.system.nixos.version;
    } // optionalAttrs (config.system.nixos.revision != null) {
      nixpkgsRevision = config.system.nixos.revision;
    } // optionalAttrs (config.system.configurationRevision != null) {
      configurationRevision = config.system.configurationRevision;
    });
  };

  nixos-enter = makeProg {
    name = "nixos-enter";
    src = ./nixos-enter.sh;
    inherit (pkgs) runtimeShell;
    path = makeBinPath [
      pkgs.util-linuxMinimal
    ];
  };

in

{

  options.system.nixos-generate-config = {
    configuration = mkOption {
      internal = true;
      type = types.str;
      description = lib.mdDoc ''
        The NixOS module that `nixos-generate-config`
        saves to `/etc/nixos/configuration.nix`.

        This is an internal option. No backward compatibility is guaranteed.
        Use at your own risk!

        Note that this string gets spliced into a Perl script. The perl
        variable `$bootLoaderConfig` can be used to
        splice in the boot loader configuration.
      '';
    };

    desktopConfiguration = mkOption {
      internal = true;
      type = types.listOf types.lines;
      default = [];
      description = lib.mdDoc ''
        Text to preseed the desktop configuration that `nixos-generate-config`
        saves to `/etc/nixos/configuration.nix`.

        This is an internal option. No backward compatibility is guaranteed.
        Use at your own risk!

        Note that this string gets spliced into a Perl script. The perl
        variable `$bootLoaderConfig` can be used to
        splice in the boot loader configuration.
      '';
    };
  };

  options.system.disableInstallerTools = mkOption {
    internal = true;
    type = types.bool;
    default = false;
    description = lib.mdDoc ''
      Disable nixos-rebuild, nixos-generate-config, nixos-installer
      and other NixOS tools. This is useful to shrink embedded,
      read-only systems which are not expected to be rebuild or
      reconfigure themselves. Use at your own risk!
    '';
  };

  config = lib.mkIf (config.nix.enable && !config.system.disableInstallerTools) {

    system.nixos-generate-config.configuration = mkDefault ''
      # Edit this configuration file to define what should be installed on
      # your system.  Help is available in the configuration.nix(5) man page
      # and in the NixOS manual (accessible by running `nixos-help`).

      { config, pkgs, ... }:

      {
        imports =
          [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
          ];

      $bootLoaderConfig
        # networking.hostName = "nixos"; # Define your hostname.
        # Pick only one of the below networking options.
        # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
        # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

        # Set your time zone.
        # time.timeZone = "Europe/Amsterdam";

        # Configure network proxy if necessary
        # networking.proxy.default = "http://user:password\@proxy:port/";
        # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

        # Select internationalisation properties.
        # i18n.defaultLocale = "en_US.UTF-8";
        # console = {
        #   font = "Lat2-Terminus16";
        #   keyMap = "us";
        #   useXkbConfig = true; # use xkbOptions in tty.
        # };

      $xserverConfig

      $desktopConfiguration
        # Configure keymap in X11
        # services.xserver.layout = "us";
        # services.xserver.xkbOptions = "eurosign:e,caps:escape";

        # Enable CUPS to print documents.
        # services.printing.enable = true;

        # Enable sound.
        # sound.enable = true;
        # hardware.pulseaudio.enable = true;

        # Enable touchpad support (enabled default in most desktopManager).
        # services.xserver.libinput.enable = true;

        # Define a user account. Don't forget to set a password with ‘passwd’.
        # users.users.alice = {
        #   isNormalUser = true;
        #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        #   packages = with pkgs; [
        #     firefox
        #     tree
        #   ];
        # };

        # List packages installed in system profile. To search, run:
        # \$ nix search wget
        # environment.systemPackages = with pkgs; [
        #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        #   wget
        # ];

        # Some programs need SUID wrappers, can be configured further or are
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

        # Copy the NixOS configuration file and link it from the resulting system
        # (/run/current-system/configuration.nix). This is useful in case you
        # accidentally delete configuration.nix.
        # system.copySystemConfiguration = true;

        # This value determines the NixOS release from which the default
        # settings for stateful data, like file locations and database versions
        # on your system were taken. It's perfectly fine and recommended to leave
        # this value at the release version of the first install of this system.
        # Before changing this value read the documentation for this option
        # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
        system.stateVersion = "${config.system.nixos.release}"; # Did you read the comment?

      }
    '';

    environment.systemPackages =
      [ nixos-build-vms
        nixos-install
        nixos-rebuild
        nixos-generate-config
        nixos-version
        nixos-enter
      ] ++ lib.optional (nixos-option != null) nixos-option;

    documentation.man.man-db.skipPackages = [ nixos-version ];

    system.build = {
      inherit nixos-install nixos-generate-config nixos-option nixos-rebuild nixos-enter;
    };

  };

}
