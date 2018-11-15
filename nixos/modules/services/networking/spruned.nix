{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spruned;

  cliArgs = "--datadir ${cfg.dataDir} --network bitcoin.${cfg.network} ${cfg.extraArguments}";
in
{
  options = {
    services.spruned = {
      enable = mkEnableOption "The spruned lightweight Bitcoin pseudonode daemon service";
      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/spruned";
        description = ''
          Directory to store cached block data and spruned logs.
        '';
      };
      network = mkOption {
        type = types.enum [ "mainnet" "testnet" ];
        default = "mainnet";
        description = ''
          Whether to use Bitcoin mainnet or testnet.
        '';
      };
      extraArguments = mkOption {
        type = types.separatedString " ";
        example = "--mempoolsize 20 --debug";
        default = "";
        description = ''
          Additional arguments to be passed to spruned.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.spruned = {
      description = "spruned service";
      after = [ "local-fs.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "on-abort";
        ExecStart = "${pkgs.spruned}/bin/spruned ${cliArgs}";
      };
    };
  };
}
