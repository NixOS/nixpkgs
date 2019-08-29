{ config, lib, pkgs, modules, ... }:

with lib;

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
    # FIXME: use typeOf (Nix 1.6.1).
    filter (x: !isAttrs x && !lib.isFunction x) modules;

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
        "<nixpkgs/nixos" + removePrefix nixosPath (toString path) + ">";
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
        imports = [ ${toString config.installer.cloneConfigIncludes} ];

        ${config.installer.cloneConfigExtra}
      }
    '';

in

{

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

    installer.cloneConfigExtra = mkOption {
      default = "";
      description = ''
        Extra text to include in the cloned configuration.nix included in this
        installer.
      '';
    };
  };

  config = {

    installer.cloneConfigIncludes =
      relocatedModuleFiles.nixos ++ relocatedModuleFiles.others;

    boot.postBootCommands =
      ''
        # Provide a mount point for nixos-install.
        mkdir -p /mnt

        ${optionalString config.installer.cloneConfig ''
          # Provide a configuration for the CD/DVD itself, to allow users
          # to run nixos-rebuild to change the configuration of the
          # running system on the CD/DVD.
          if ! [ -e /etc/nixos/configuration.nix ]; then
            cp ${configClone} /etc/nixos/configuration.nix
          fi
       ''}
      '';

  };

}
