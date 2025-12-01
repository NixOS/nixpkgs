# This module generates nixos-install, nixos-rebuild,
# nixos-generate-config, etc.

{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  makeProg =
    args:
    pkgs.replaceVarsWith (
      args
      // {
        dir = "bin";
        isExecutable = true;
        nativeBuildInputs = [
          pkgs.installShellFiles
        ];
        postInstall = ''
          installManPage ${args.manPage}
        '';
      }
    );

  nixos-generate-config = makeProg {
    name = "nixos-generate-config";
    src = ./nixos-generate-config.pl;
    replacements = {
      perl = "${
        pkgs.perl.withPackages (p: [
          p.FileSlurp
          p.ConfigIniFiles
        ])
      }/bin/perl";
      hostPlatformSystem = pkgs.stdenv.hostPlatform.system;
      detectvirt = "${config.systemd.package}/bin/systemd-detect-virt";
      btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
      inherit (config.system.nixos-generate-config) configuration desktopConfiguration flake;
      xserverEnabled = config.services.xserver.enable;
    };
    manPage = ./manpages/nixos-generate-config.8;
  };

  nixos-version = makeProg {
    name = "nixos-version";
    src = ./nixos-version.sh;
    replacements = {
      inherit (pkgs) runtimeShell;
      inherit (config.system.nixos) version codeName revision;
      inherit (config.system) configurationRevision;
      json = builtins.toJSON (
        {
          nixosVersion = config.system.nixos.version;
        }
        // lib.optionalAttrs (config.system.nixos.revision != null) {
          nixpkgsRevision = config.system.nixos.revision;
        }
        // lib.optionalAttrs (config.system.configurationRevision != null) {
          configurationRevision = config.system.configurationRevision;
        }
      );
    };
    manPage = ./manpages/nixos-version.8;
  };

  nixos-install = pkgs.nixos-install.override { };
  nixos-rebuild-ng = pkgs.nixos-rebuild-ng.override {
    nix = config.nix.package;
    withNgSuffix = false;
    withReexec = true;
  };

  defaultFlakeTemplate = ''
    {
      inputs = {
        # This is pointing to an unstable release.
        # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
        # i.e. nixos-24.11
        # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      };
      outputs = inputs\@{ self, nixpkgs, ... }: {
        # NOTE: '${options.networking.hostName.default}' is the default hostname
        nixosConfigurations.${options.networking.hostName.default} = nixpkgs.lib.nixosSystem {
          modules = [ ./configuration.nix ];
        };
      };
    }
  '';

  defaultConfigTemplate = ''
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

      # Configure network connections interactively with nmcli or nmtui.
      networking.networkmanager.enable = true;

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
      # services.pulseaudio.enable = true;
      # OR
      # services.pipewire = {
      #   enable = true;
      #   pulse.enable = true;
      # };

      # Enable touchpad support (enabled default in most desktopManager).
      # services.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      # users.users.alice = {
      #   isNormalUser = true;
      #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      #   packages = with pkgs; [
      #     tree
      #   ];
      # };

      # programs.firefox.enable = true;

      # List packages installed in system profile.
      # You can use https://search.nixos.org/ to find more packages (and options).
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
in
{
  options.system.nixos-generate-config = {

    flake = lib.mkOption {
      internal = true;
      type = lib.types.str;
      default = defaultFlakeTemplate;
      description = ''
        The NixOS module that `nixos-generate-config`
        saves to `/etc/nixos/flake.nix` if --flake is set.

        This is an internal option. No backward compatibility is guaranteed.
        Use at your own risk!

        Note that this string gets spliced into a Perl script. The perl
        variable `$bootLoaderConfig` can be used to
        splice in the boot loader configuration.
      '';
    };

    configuration = lib.mkOption {
      internal = true;
      type = lib.types.str;
      default = defaultConfigTemplate;
      description = ''
        The NixOS module that `nixos-generate-config`
        saves to `/etc/nixos/configuration.nix`.

        This is an internal option. No backward compatibility is guaranteed.
        Use at your own risk!

        Note that this string gets spliced into a Perl script. The perl
        variable `$bootLoaderConfig` can be used to
        splice in the boot loader configuration.
      '';
    };

    desktopConfiguration = lib.mkOption {
      internal = true;
      type = lib.types.listOf lib.types.lines;
      default = [ ];
      description = ''
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

  options.system.disableInstallerTools = lib.mkOption {
    internal = true;
    type = lib.types.bool;
    default = false;
    description = ''
      Disable nixos-rebuild, nixos-generate-config, nixos-installer
      and other NixOS tools. This is useful to shrink embedded,
      read-only systems which are not expected to rebuild or
      reconfigure themselves. Use at your own risk!
    '';
  };

  imports =
    let
      mkToolModule =
        {
          name,
          package ? pkgs.${name},
        }:
        { config, ... }:
        {
          options.system.tools.${name}.enable = lib.mkEnableOption "${name} script" // {
            default = config.nix.enable && !config.system.disableInstallerTools;
            defaultText = "config.nix.enable && !config.system.disableInstallerTools";
          };

          config = lib.mkIf config.system.tools.${name}.enable {
            environment.systemPackages = [ package ];
          };
        };
    in
    [
      (mkToolModule { name = "nixos-build-vms"; })
      (mkToolModule { name = "nixos-enter"; })
      (mkToolModule {
        name = "nixos-generate-config";
        package = config.system.build.nixos-generate-config;
      })
      (mkToolModule {
        name = "nixos-install";
        package = config.system.build.nixos-install;
      })
      (mkToolModule { name = "nixos-option"; })
      (mkToolModule {
        name = "nixos-rebuild";
        package = config.system.build.nixos-rebuild;
      })
      (mkToolModule {
        name = "nixos-version";
        package = nixos-version;
      })
      (lib.mkRemovedOptionModule [ "system" "rebuild" "enableNg" ] ''
        The Bash implementation of nixos-rebuild has been removed in favor of the new Python implementation.
        If you have any issues with the new implementation, please create an issue in GitHub and tag the maintainers of 'nixos-rebuild-ng'.
      '')
    ];

  config = {
    documentation.man.man-db.skipPackages = [ nixos-version ];

    # These may be used in auxiliary scripts (ie not part of toplevel), so they are defined unconditionally.
    system.build = {
      inherit nixos-generate-config nixos-install;
      nixos-rebuild = nixos-rebuild-ng;
    };
  };
}
