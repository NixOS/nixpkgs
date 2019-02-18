{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.virtualisation.googleComputeImage;
  defaultConfigFile = pkgs.writeText "configuration.nix" ''
    { ... }:
    {
      imports = [
        <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
      ];
    }
  '';
in
{

  imports = [ ./google-compute-config.nix ];

  options = {
    virtualisation.googleComputeImage.diskSize = mkOption {
      type = with types; int;
      default = 1536;
      description = ''
        Size of disk image. Unit is MB.
      '';
    };

    virtualisation.googleComputeImage.configFile = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        A path to a configuration file which will be placed at `/etc/nixos/configuration.nix`
        and be used when switching to a new configuration.
        If set to `null`, a default configuration is used, where the only import is
        `<nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>`.
      '';
    };
  };

  #### implementation
  config = {

    system.build.googleComputeImage = import ../../lib/make-disk-image.nix {
      name = "google-compute-image";
      postVM = ''
        PATH=$PATH:${with pkgs; stdenv.lib.makeBinPath [ gnutar gzip ]}
        pushd $out
        mv $diskImage disk.raw
        tar -Szcf nixos-image-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.raw.tar.gz disk.raw
        rm $out/disk.raw
        popd
      '';
      format = "raw";
      configFile = if isNull cfg.configFile then defaultConfigFile else cfg.configFile;
      inherit (cfg) diskSize;
      inherit config lib pkgs;
    };

  };

}
