# This module generates nixos-install, nixos-rebuild,
# nixos-generate-config, etc.

{ config, lib, pkgs, ... }:

with lib;

let
  makeProg = args: pkgs.substituteAll (lib.recursiveUpdate
    {
      dir = "bin";
      isExecutable = true;
      nativeBuildInputs = [
        pkgs.installShellFiles
      ];
      postInstall = ''
        installManPage ${args.manPage}
      '';
      meta.license = lib.licenses.mit;
    }
    args
  );
in

{
  options = {
    system.nixos-generate-config = {
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
        default = [ ];
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

    system.disableInstallerTools = mkOption {
      internal = true;
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Disable nixos-rebuild, nixos-generate-config, nixos-installer
        and other NixOS tools. This is useful to shrink embedded,
        read-only systems which are not expected to be rebuilt or to
        reconfigure themselves. Use at your own risk!
      '';
    };

    system.installerTools =
      let
        # We need to rename the config variable because it gets shadowed below
        systemConfig = config;
      in
      lib.mkOption {
        internal = true;
        type = lib.types.attrsOf (lib.types.submodule ({ name, config, lib, ... }: {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = lib.mdDoc ''
                the name of the package
              '';
            };

            enable = lib.mkEnableOption (lib.mdDoc "the package as part of the installer tools.") // {
              default = ! systemConfig.system.disableInstallerTools;
              defaultText = lib.literalExpression "! config.system.disableInstallerTools";
            };

            package = lib.mkOption {
              type = lib.types.package;
              description = lib.mdDoc ''
                the derivation providing the package
              '';
            };
          };

          config.name = lib.mkDefault name;
        }));
      };
  };

  config =
    let
      installerTools = lib.filterAttrs (_: tool: tool.enable) config.system.installerTools;
    in
    lib.mkIf config.nix.enable {

      system.installerTools = {
        nixos-build-vms = {
          package = lib.mkDefault (makeProg {
            name = "nixos-build-vms";
            src = ./nixos-build-vms/nixos-build-vms.sh;
            inherit (pkgs) runtimeShell;
            manPage = ./manpages/nixos-build-vms.8;
            meta = {
              maintainers = [ lib.maintainers.rvdp ];
              mainProgram = "nixos-build-vms";
            };
          });
        };

        nixos-enter = {
          package = lib.mkDefault (makeProg {
            name = "nixos-enter";
            src = ./nixos-enter.sh;
            inherit (pkgs) runtimeShell;
            path = makeBinPath [
              pkgs.util-linuxMinimal
            ];
            manPage = ./manpages/nixos-enter.8;
            meta = {
              maintainers = [ lib.maintainers.rvdp ];
              mainProgram = "nixos-enter";
            };
          });
        };

        nixos-generate-config = {
          package = lib.mkDefault (makeProg {
            name = "nixos-generate-config";
            src = ./nixos-generate-config.pl;
            perl = "${pkgs.perl.withPackages (p: [ p.FileSlurp ])}/bin/perl";
            hostPlatformSystem = pkgs.stdenv.hostPlatform.system;
            detectvirt = "${config.systemd.package}/bin/systemd-detect-virt";
            btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
            inherit (config.system.nixos-generate-config) configuration desktopConfiguration;
            xserverEnabled = config.services.xserver.enable;
            manPage = ./manpages/nixos-generate-config.8;
            meta = {
              maintainers = [ ];
              mainProgram = "nixos-generate-config";
            };
          });
        };

        nixos-install = {
          package = lib.mkDefault (makeProg {
            name = "nixos-install";
            src = ./nixos-install.sh;
            inherit (pkgs) runtimeShell;
            nix = config.nix.package.out;
            path = makeBinPath [
              pkgs.jq
              config.system.installerTools.nixos-enter.package
              pkgs.util-linuxMinimal
            ];
            manPage = ./manpages/nixos-install.8;
            meta = {
              maintainers = [ lib.maintainers.rvdp ];
              mainProgram = "nixos-install";
            };
          });
        };

        nixos-option = {
          package = lib.mkDefault pkgs.nixos-option;
        };

        nixos-rebuild = {
          package = lib.mkDefault (pkgs.nixos-rebuild.override { nix = config.nix.package.out; });
        };

        nixos-version = {
          package = lib.mkDefault (makeProg {
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
            meta = {
              maintainers = [ lib.maintainers.rvdp ];
              mainProgram = "nixos-version";
            };
          });
        };
      };

      system.nixos-generate-config.configuration = mkDefault ''
        # Edit this configuration file to define what should be installed on
        # your system.  Help is available in the configuration.nix(5) man page
        # and in the NixOS manual (accessible by running `nixos-help`).

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
        lib.attrValues (lib.mapAttrs (_: tool: tool.package) installerTools);

      documentation.man.man-db.skipPackages =
        lib.mkIf (installerTools ? nixos-version) [ config.system.installerTools.nixos-version.package ];

      system.build = lib.mapAttrs (_: tool: tool.package) installerTools;
    };
}
