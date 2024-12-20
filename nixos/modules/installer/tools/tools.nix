# This module generates nixos-install, nixos-rebuild,
# nixos-generate-config, etc.

{ config, lib, pkgs, ... }:

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

  nixos-version = makeProg {
    name = "nixos-version";
    src = ./nixos-version.sh;
    inherit (pkgs) runtimeShell;
    inherit (config.system.nixos) version codeName revision;
    inherit (config.system) configurationRevision;
    json = builtins.toJSON ({
      nixosVersion = config.system.nixos.version;
    } // lib.optionalAttrs (config.system.nixos.revision != null) {
      nixpkgsRevision = config.system.nixos.revision;
    } // lib.optionalAttrs (config.system.configurationRevision != null) {
      configurationRevision = config.system.configurationRevision;
    });
    manPage = ./manpages/nixos-version.8;
  };

  nixos-install = pkgs.nixos-install.override { nix = config.nix.package; };
  nixos-rebuild = pkgs.nixos-rebuild.override { nix = config.nix.package; };
  nixos-rebuild-ng = pkgs.nixos-rebuild-ng.override {
    nix = config.nix.package;
    withNgSuffix = false;
    withReexec = true;
  };

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
      # hardware.pulseaudio.enable = true;
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
in
{
  options.system.nixos-generate-config = {
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
      default = [];
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
      read-only systems which are not expected to be rebuild or
      reconfigure themselves. Use at your own risk!
    '';
  };

  options.system.rebuild.enableNg = lib.mkEnableOption "" // {
    description = ''
      Whether to use ‘nixos-rebuild-ng’ in place of ‘nixos-rebuild’, the
      Python-based re-implementation of the original in Bash.
    '';
  };

  imports = let
    mkToolModule = { name, package ? pkgs.${name} }: { config, ... }: {
      options.system.tools.${name}.enable = lib.mkEnableOption "${name} script" // {
        default = config.nix.enable && ! config.system.disableInstallerTools;
        defaultText = "config.nix.enable && !config.system.disableInstallerTools";
      };

      config = lib.mkIf config.system.tools.${name}.enable {
        environment.systemPackages = [ package ];
      };
    };
  in [
    (mkToolModule { name = "nixos-build-vms"; })
    (mkToolModule { name = "nixos-enter"; })
    (mkToolModule { name = "nixos-generate-config"; package = config.system.build.nixos-generate-config; })
    (mkToolModule { name = "nixos-install"; package = config.system.build.nixos-install; })
    (mkToolModule { name = "nixos-option"; })
    (mkToolModule { name = "nixos-rebuild"; package = config.system.build.nixos-rebuild; })
    (mkToolModule { name = "nixos-version"; package = nixos-version; })
  ];

  config = {
    documentation.man.man-db.skipPackages = [ nixos-version ];

    # These may be used in auxiliary scripts (ie not part of toplevel), so they are defined unconditionally.
    system.build = {
      inherit nixos-generate-config nixos-install;
      nixos-rebuild =
        if config.system.rebuild.enableNg
          then nixos-rebuild-ng
          else nixos-rebuild;
      nixos-option = lib.warn "Accessing nixos-option through `config.system.build` is deprecated, use `pkgs.nixos-option` instead." pkgs.nixos-option;
      nixos-enter = lib.warn "Accessing nixos-enter through `config.system.build` is deprecated, use `pkgs.nixos-enter` instead." pkgs.nixos-enter;
    };
  };
}
