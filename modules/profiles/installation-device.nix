# Provide a basic configuration for installation devices like CDs.
{ config, pkgs, modules, ... }:

with pkgs.lib;

let
  # Location of the repository on the harddrive
  nixosPath = toString ../..;

  # Check if the path is from the NixOS repository
  isNixOSFile = path:
    let s = toString path; in
      removePrefix nixosPath s != s;

  # Copy modules given as extra configuration files.  Unfortunately, we
  # cannot serialized attribute set given in the list of modules (that's why
  # you should use files).
  moduleFiles =
    filter isPath modules;

  # Partition module files because between NixOS and non-NixOS files.  NixOS
  # files may change if the repository is updated.
  partitionedModuleFiles =
    let p = partition isNixOSFile moduleFiles; in
    { nixos = p.right; others = p.wrong; };

  # Path transformed to be valid on the installation device.  Thus the
  # device configuration could be rebuild.
  relocatedModuleFiles =
    let
      relocateNixOS = path:
        "<nixos" + removePrefix nixosPath (toString path) + ">";
      relocateOthers = null;
    in
      { nixos = map relocateNixOS partitionedModuleFiles.nixos;
        others = []; # TODO: copy the modules to the install-device repository.
      };

  # A dummy /etc/nixos/configuration.nix in the booted CD that
  # rebuilds the CD's configuration (and allows the configuration to
  # be modified, of course, providing a true live CD).  Problem is
  # that we don't really know how the CD was built - the Nix
  # expression language doesn't allow us to query the expression being
  # evaluated.  So we'll just hope for the best.
  configClone = pkgs.writeText "configuration.nix"
    ''
      { config, pkgs, ... }:

      {
        require = [
          ${toString config.installer.cloneConfigIncludes}
        ];
      }
    '';
in

{
  imports = [
    # Enable devices which are usually scanned, because we don't know the
    # target system.
    ../installer/scan/detected.nix
    ../installer/scan/not-detected.nix
  ];

  options = {
  
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
    installer.cloneConfigIncludes =
      relocatedModuleFiles.nixos ++ relocatedModuleFiles.others;

    # Show the manual.
    services.nixosManual.showManual = true;

    # Let the user play Rogue on TTY 8 during the installation.
    services.rogue.enable = true;

    # Disable some other stuff we don't need.
    security.sudo.enable = false;

    # Include only the en_US locale.  This saves 75 MiB or so compared to
    # the full glibcLocales package.
    i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "en_US/ISO-8859-1"];

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
          optionalString config.services.xserver.enable
            "Type `start display-manager' to\nstart the graphical user interface."}
      '';

    # Allow sshd to be started manually through "start sshd".  It should
    # not be started by default on the installation CD because the
    # default root password is empty.
    services.openssh.enable = true;
    jobs.sshd.startOn = pkgs.lib.mkOverride 50 "";

    # Enable wpa_supplicant, but don't start it by default.
    networking.wireless.enable = true;
    jobs.wpa_supplicant.startOn = pkgs.lib.mkOverride 50 "";

    # Tell the Nix evaluator to garbage collect more aggressively.
    # This is desirable in memory-constrained environments that don't
    # (yet) have swap set up.
    environment.shellInit =
      ''
        export GC_INITIAL_HEAP_SIZE=100000
      '';
  };
}
