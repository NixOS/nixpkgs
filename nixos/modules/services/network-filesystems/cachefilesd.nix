{
  config,
  pkgs,
  lib,
  ...
}:
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

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable cachefilesd network filesystems caching daemon.";
      };

      cacheDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/cache/fscache";
        description = "Directory to contain filesystem cache.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "brun 10%";
        description = "Additional configuration file entries. See cachefilesd.conf(5) for more information.";
      };

    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    boot.kernelModules = [ "cachefiles" ];

    systemd.services.cachefilesd = {
      description = "Local network file caching management daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.cachefilesd}/bin/cachefilesd -n -f ${cfgFile}";
        Restart = "on-failure";
        PrivateTmp = true;
      };
    };

    systemd.tmpfiles.settings."10-cachefilesd".${cfg.cacheDir}.d = {
      user = "root";
      group = "root";
      mode = "0700";
    };
  };
}
