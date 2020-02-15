{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.nanod;

in {

  options.services.nanod = {

    enable = mkEnableOption "nanod";

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/nano";
      description =
        "The data directory where nanod will store its state, including the block-lattice";
    };

    nodeConfig = mkOption {
      type = types.path;
      description =
        "The path to the config-node.toml file. Setting this option will overwrite any other configuration setting";
      default = pkgs.runCommand "config-node.toml" {
        json = builtins.toJSON cfg.nodeConfigOptions;
        passAsFile = [ "json" ];
      } ''
        ${pkgs.remarshal}/bin/json2toml < $jsonPath > $out
      '';
      defaultText =
        "Generates a TOML configuration from services.nanod.nodeConfigOptions";
    };

    nodeConfigOptions = mkOption {
      type = types.attrs;
      description =
        "Configuration options for the nano node daemon. See: https://docs.nano.org/running-a-node/configuration/";
      example = {
        node = { enable-voting = true; };
        websocket = {
          address = "::1";
          enable = true;
          port = 7078;
        };
      };
    };

    rpcConfig = mkOption {
      type = types.path;
      description =
        "The path to the config-rpc.toml file. Setting this option will overwrite any other configuration setting";
      default = pkgs.runCommand "config-rpc.toml" {
        json = builtins.toJSON cfg.rpcConfigOptions;
        passAsFile = [ "json" ];
      } ''
        ${pkgs.remarshal}/bin/json2toml < $jsonPath > $out
      '';
      defaultText =
        "Generates a TOML configuration from services.nanod.rpcConfigOptions";
    };

    rpcConfigOptions = mkOption {
      type = types.attrs;
      description =
        "Configuration options for the nano node RPC interface. See: https://docs.nano.org/running-a-node/configuration/";
      example = {
        enable-control = true;
        address = "::1";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.nanod = {
      name = "nanod";
      group = "nanod";
      uid = config.ids.uids.nanod;
      description = "nanod daemon user";
    };
    users.groups.nanod.gid = config.ids.gids.nanod;

    systemd.services.nanod = {
      description = "NANO node daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        cp ${nodeConfig} ${cfg.dataDir}/config-node.toml
        cp ${rpcConfig} ${cfg.dataDir}/config-rpc.toml
      '';

      serviceConfig = {
        User = "nanod";
        Group = "nanod";
        ExecStart = "${pkgs.nanod}/bin/nanod --data_path ${cfg.dataDir}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        Restart = "on-failure";

        PrivateDevices = true;
        PrivateTmp = true;
        ProtectSystem = "full";
        NoNewPrivileges = true;
      };
    };
  };
}
