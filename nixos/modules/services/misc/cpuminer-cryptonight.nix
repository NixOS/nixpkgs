{ config, lib, pkgs, ... }:

with lib;

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
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the cpuminer cryptonight miner.
        '';
      };
      url = mkOption {
        type = types.str;
        description = lib.mdDoc "URL of mining server";
      };
      user = mkOption {
        type = types.str;
        description = lib.mdDoc "Username for mining server";
      };
      pass = mkOption {
        type = types.str;
        default = "x";
        description = lib.mdDoc "Password for mining server";
      };
      threads = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc "Number of miner threads, defaults to available processors";
      };
    };

  };

  config = mkIf config.services.cpuminer-cryptonight.enable {

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
