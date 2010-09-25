{config, pkgs, ...}:

with pkgs.lib;

let
  # Location of the repository on the harddrive
  profilePath = toString ./.;

  # Check if the path is from the NixOS repository
  isProfile = path:
    let s = toString path; in
      removePrefix profilePath s != s;

  # Rename NixOS modules used to setup the current device to make findable form
  # the default location of the configuration.nix file.
  getProfileModules =
    map (path: "./nixos/modules/profiles" + removePrefix isProfile (toString path))
      filter (m: isPath m && isProfile m) modules;

  # A dummy /etc/nixos/configuration.nix in the booted CD that
  # rebuilds the CD's configuration (and allows the configuration to
  # be modified, of course, providing a true live CD).  Problem is
  # that we don't really know how the CD was built - the Nix
  # expression language doesn't allow us to query the expression being
  # evaluated.  So we'll just hope for the best.
  configClone = pkgs.writeText "configuration.nix"
    ''
      {config, pkgs, ...}:

      {
        require = [${toString config.installer.cloneConfigIncludes}];

        # Add your own options below and run "nixos-rebuild switch".
        # E.g.,
        #   services.openssh.enable = true;
      }
    '';
in

{
  options = {
    system.nixosVersion = mkOption {
      default = "${builtins.readFile ../../VERSION}";
      description = ''
        NixOS version number.
      '';
    };

    installer.cloneConfig = mkOption {
      default = true;
      description = ''
        Try to clone the installation-device configuration by re-using it's
        profile from the list of imported modules.
      '';
    };

    installer.cloneConfigIncludes = mkOption {
      default = [];
      example = [ "./nixos/modules/hardware/network/rt73.nix" ];
      description = ''
        List of modules used to re-build this installation device profile.
      '';
    };
  };

  config = {
    installer.cloneConfigIncludes = getProfileModules;

    # Show the manual.
    services.nixosManual.showManual = true;

    # Let the user play Rogue on TTY 8 during the installation.
    services.rogue.enable = true;

    # Disable some other stuff we don't need.
    security.sudo.enable = false;

    # Include only the en_US locale.  This saves 75 MiB or so compared to
    # the full glibcLocales package.
    i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "en_US/ISO-8859-1"];

    # nixos-install will do a pull from this channel to speed up the
    # installation.
    installer.nixpkgsURL = http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable;

    boot.postBootCommands =
      ''
        # Provide a mount point for nixos-install.
        mkdir -p /mnt

        ${optionalString config.installer.cloneConfig ''
          # Provide a configuration for the CD/DVD itself, to allow users
          # to run nixos-rebuild to change the configuration of the
          # running system on the CD/DVD.
          cp ${configClone} /etc/nixos/configuration.nix
       ''}
      '';

    # Some more help text.
    services.mingetty.helpLine =
      ''
          
        Log in as "root" with an empty password.  ${
          if config.services.xserver.enable then
            "Type `start xserver' to start\nthe graphical user interface."
          else ""
        }
      '';


    # Allow sshd to be started manually through "start sshd".  It should
    # not be started by default on the installation CD because the
    # default root password is empty.
    services.openssh.enable = true;
    jobs.sshd.startOn = pkgs.lib.mkOverride 50 "";

    # Enable wpa_supplicant, but don't start it by default.
    networking.enableWLAN = true;
    jobs.wpa_supplicant.startOn = pkgs.lib.mkOverride 50 "";
  };
}
