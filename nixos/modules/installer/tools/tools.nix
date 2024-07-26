# This module generates nixos-install, nixos-rebuild,
# nixos-generate-config, etc.

{ config, lib, pkgs, ... }:

with lib;

let
  makeProg = args: pkgs.substituteAll (args // {
    dir = "bin";
    isExecutable = true;
    nativeBuildInputs = [
      pkgs.installShellFiles
    ];
    postInstall = ''
      installManPage ${args.manPage}
    '';
  });

  nixos-build-vms = makeProg {
    name = "nixos-build-vms";
    src = ./nixos-build-vms/nixos-build-vms.sh;
    inherit (pkgs) runtimeShell;
    manPage = ./manpages/nixos-build-vms.8;
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
    manPage = ./manpages/nixos-install.8;
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
    manPage = ./manpages/nixos-generate-config.8;
  };

  inherit (pkgs) nixos-option;

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
    manPage = ./manpages/nixos-version.8;
  };

  nixos-enter = makeProg {
    name = "nixos-enter";
    src = ./nixos-enter.sh;
    inherit (pkgs) runtimeShell;
    path = makeBinPath [
      pkgs.util-linuxMinimal
    ];
    manPage = ./manpages/nixos-enter.8;
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

  config = lib.mkMerge [ (lib.mkIf (config.nix.enable && !config.system.disableInstallerTools) {

    system.nixos-generate-config.configuration = mkDefault ''
      # Edit this configuration file to define what should be installed on
      # your system. Help is available in the configuration.nix(5) man page, on
      # https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

      { config, lib, pkgs, ... }:

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
        #   useXkbConfig = true; # use xkb.options in tty.
        # };

      $xserverConfig

      $desktopConfiguration
        # Configure keymap in X11
        # services.xserver.xkb.layout = "us";
        # services.xserver.xkb.options = "eurosign:e,caps:escape";

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

        # This option defines the first version of NixOS you have installed on this particular machine,
        # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
        #
        # Most users should NEVER change this value after the initial install, for any reason,
        # even if you've upgraded your system to a new NixOS release.
        #
        # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
        # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
        # to actually do that.
        #
        # This value being lower than the current NixOS release does NOT mean your system is
        # out of date, out of support, or vulnerable.
        #
        # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
        # and migrated your data accordingly.
        #
        # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
        system.stateVersion = "${config.system.nixos.release}"; # Did you read the comment?

      }
    '';

    environment.systemPackages =
      [ nixos-build-vms
        nixos-install
        nixos-rebuild
        nixos-generate-config
        nixos-option
        nixos-version
        nixos-enter
      ];

    documentation.man.man-db.skipPackages = [ nixos-version ];

  })

  # These may be used in auxiliary scripts (ie not part of toplevel), so they are defined unconditionally.
  ({
    system.build = {
      inherit nixos-install nixos-generate-config nixos-option nixos-rebuild nixos-enter;
    };
  })];

}
