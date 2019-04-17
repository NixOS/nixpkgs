{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.virtualisation.digitalOceanImage;
  defaultConfigFile = pkgs.writeText "configuration.nix" ''
    { modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/virtualisation/digital-ocean-config.nix")
      ];
    }
  '';
in
{

  imports = [ ./digital-ocean-config.nix ];

  options = {
    virtualisation.digitalOceanImage.diskSize = mkOption {
      type = with types; int;
      default = 4096;
      description = ''
        Size of disk image. Unit is MB.
      '';
    };

    virtualisation.digitalOceanImage.configFile = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        A path to a configuration file which will be placed at `/etc/nixos/configuration.nix`
        and be used when switching to a new configuration.
        If set to `null`, a default configuration is used, where the only import is
        `(modulesPath + "/virtualisation/digital-ocean-config.nix")`.
      '';
    };
  };

  #### implementation
  config = {

    system.build.digitalOceanImage = import ../../lib/make-disk-image.nix {
      name = "digital-ocean-image";
      format = "qcow2";
      postVM = ''
        ${pkgs.gzip}/bin/gzip $diskImage
      '';
      configFile = if isNull cfg.configFile then defaultConfigFile else cfg.configFile;
      inherit (cfg) diskSize;
      inherit config lib pkgs;
    };

  };

  meta.maintainers = with maintainers; [ arianvp eamsden ];

}
