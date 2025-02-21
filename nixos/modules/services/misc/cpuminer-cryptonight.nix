{ config, lib, pkgs, ... }:
let
  cfg = config.services.cpuminer-cryptonight;

  json = builtins.toJSON (
    cfg // {
       enable = null;
       threads =
         if cfg.threads == 0 then null else toString cfg.threads;
    }
  );

  confFile = builtins.toFile "cpuminer.json" json;
in
{

  options = {

    services.cpuminer-cryptonight = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the cpuminer cryptonight miner.
        '';
      };
      url = lib.mkOption {
        type = lib.types.str;
        description = "URL of mining server";
      };
      user = lib.mkOption {
        type = lib.types.str;
        description = "Username for mining server";
      };
      pass = lib.mkOption {
        type = lib.types.str;
        default = "x";
        description = "Password for mining server";
      };
      threads = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Number of miner threads, defaults to available processors";
      };
    };

  };

  config = lib.mkIf config.services.cpuminer-cryptonight.enable {

    systemd.services.cpuminer-cryptonight = {
      description = "Cryptonight cpuminer";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.cpuminer-multi}/bin/minerd --syslog --config=${confFile}";
        User = "nobody";
      };
    };

  };

}
