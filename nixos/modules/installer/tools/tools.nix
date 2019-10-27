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
  };

  nixos-install = makeProg {
    name = "nixos-install";
    src = ./nixos-install.sh;
    nix = config.nix.package.out;
    path = makeBinPath [ nixos-enter ];
  };

  nixos-rebuild =
    let fallback = import ./nix-fallback-paths.nix; in
    makeProg {
      name = "nixos-rebuild";
      src = ./nixos-rebuild.sh;
      nix = config.nix.package.out;
      nix_x86_64_linux = fallback.x86_64-linux;
      nix_i686_linux = fallback.i686-linux;
    };

  nixos-generate-config = makeProg {
    name = "nixos-generate-config";
    src = ./nixos-generate-config.pl;
    path = lib.optionals (lib.elem "btrfs" config.boot.supportedFilesystems) [ pkgs.btrfs-progs ];
    perl = "${pkgs.perl}/bin/perl -I${pkgs.perlPackages.FileSlurp}/${pkgs.perl.libPrefix}";
    inherit (config.system.nixos-generate-config) configuration;
  };

  nixos-option = makeProg {
    name = "nixos-option";
    src = ./nixos-option.sh;
  };

  nixos-version = makeProg {
    name = "nixos-version";
    src = ./nixos-version.sh;
    inherit (config.system.nixos) version codeName revision;
  };

  nixos-enter = makeProg {
    name = "nixos-enter";
    src = ./nixos-enter.sh;
  };

in

{

  options.system.nixos-generate-config.configuration = mkOption {
    internal = true;
    type = types.str;
    description = ''
      The NixOS module that <literal>nixos-generate-config</literal>
      saves to <literal>/etc/nixos/configuration.nix</literal>.

      This is an internal option. No backward compatibility is guaranteed.
      Use at your own risk!

      Note that this string gets spliced into a Perl script. The perl
      variable <literal>$bootLoaderConfig</literal> can be used to
      splice in the boot loader configuration.
    '';
  };

  config = {

    system.nixos-generate-config.configuration = mkDefault ''
      # Edit this configuration file to define what should be installed on
      # your system.  Help is available in the configuration.nix(5) man page
      # and in the NixOS manual (accessible by running ‘nixos-help’).

      { config, pkgs, ... }:

      {
        imports =
          [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
          ];

      $bootLoaderConfig
        # networking.hostName = "nixos"; # Define your hostname.
        # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      $networkingDhcpConfig
        # Configure network proxy if necessary
        # networking.proxy.default = "http://user:password\@proxy:port/";
        # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

        # Select internationalisation properties.
        # i18n = {
        #   consoleFont = "Lat2-Terminus16";
        #   consoleKeyMap = "us";
        #   defaultLocale = "en_US.UTF-8";
        # };

        # Set your time zone.
        # time.timeZone = "Europe/Amsterdam";

        # List packages installed in system profile. To search, run:
        # \$ nix search wget
        # environment.systemPackages = with pkgs; [
        #   wget vim
        # ];

        # Some programs need SUID wrappers, can be configured further or are
        # started in user sessions.
        # programs.mtr.enable = true;
        # programs.gnupg.agent = {
        #   enable = true;
        #   enableSSHSupport = true;
        #   flavour = "gnome3";
        # };

        # List services that you want to enable:

        # Enable the OpenSSH daemon.
        # services.openssh.enable = true;

        # Open ports in the firewall.
        # networking.firewall.allowedTCPPorts = [ ... ];
        # networking.firewall.allowedUDPPorts = [ ... ];
        # Or disable the firewall altogether.
        # networking.firewall.enable = false;

        # Enable CUPS to print documents.
        # services.printing.enable = true;

        # Enable sound.
        # sound.enable = true;
        # hardware.pulseaudio.enable = true;

        # Enable the X11 windowing system.
        # services.xserver.enable = true;
        # services.xserver.layout = "us";
        # services.xserver.xkbOptions = "eurosign:e";

        # Enable touchpad support.
        # services.xserver.libinput.enable = true;

        # Enable the KDE Desktop Environment.
        # services.xserver.displayManager.sddm.enable = true;
        # services.xserver.desktopManager.plasma5.enable = true;

        # Define a user account. Don't forget to set a password with ‘passwd’.
        # users.users.jane = {
        #   isNormalUser = true;
        #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        # };

        # This value determines the NixOS release with which your system is to be
        # compatible, in order to avoid breaking some software such as database
        # servers. You should change this only after NixOS release notes say you
        # should.
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

    system.build = {
      inherit nixos-install nixos-generate-config nixos-option nixos-rebuild nixos-enter;
    };

  };

}
