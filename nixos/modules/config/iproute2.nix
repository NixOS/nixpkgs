{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.iproute2;
  confDir = "/run/iproute2";
in
{
  options.networking.iproute2.enable = mkEnableOption "copy IP route configuration files";

  config = mkMerge [
    ({ nixpkgs.config.iproute2.confDir = confDir; })

    (mkIf cfg.enable {
      system.activationScripts.iproute2 = ''
        cp -R ${pkgs.iproute}/etc/iproute2 ${confDir}
        chmod -R 664 ${confDir}
        chmod +x ${confDir}
      '';
    })
  ];
}
