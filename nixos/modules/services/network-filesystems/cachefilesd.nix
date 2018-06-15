{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.cachefilesd;

  cfgFile = pkgs.writeText "cachefilesd.conf" ''
    dir ${cfg.cacheDir}
    ${cfg.extraConfig}
  '';

in

{
  options = {
    services.cachefilesd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable cachefilesd network filesystems caching daemon.";
      };

      cacheDir = mkOption {
        type = types.str;
        default = "/var/cache/fscache";
        description = "Directory to contain filesystem cache.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = "brun 10%";
        description = "Additional configuration file entries. See cachefilesd.conf(5) for more information.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.cachefilesd = {
      description = "Local network file caching management daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.kmod pkgs.cachefilesd ];
      script = ''
        modprobe -qab cachefiles
        mkdir -p ${cfg.cacheDir}
        chmod 700 ${cfg.cacheDir}
        exec cachefilesd -n -f ${cfgFile}
      '';
    };

  };
}
