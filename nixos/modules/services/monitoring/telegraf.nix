{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.telegraf;

  configFile = pkgs.runCommand "config.toml" {
    buildInputs = [ pkgs.remarshal ];
    preferLocalBuild = true;
  } ''
    remarshal -if json -of toml \
      < ${pkgs.writeText "config.json" (builtins.toJSON cfg.extraConfig)} \
      > $out
  '';
in {
  ###### interface
  options = {
    services.telegraf = {
      enable = mkEnableOption "telegraf server";

      package = mkOption {
        default = pkgs.telegraf;
        defaultText = "pkgs.telegraf";
        description = "Which telegraf derivation to use";
        type = types.package;
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/telegraf.env";
        description = ''
          File to load as environment file. Environment variables
          from this file will be interpolated into the config file
          using envsubst with this syntax:
          <literal>$ENVIRONMENT ''${VARIABLE}</literal>
          This is useful to avoid putting secrets into the nix store.
        '';
      };

      extraConfig = mkOption {
        default = {};
        description = "Extra configuration options for telegraf";
        type = types.attrs;
        example = {
          outputs = {
            influxdb = {
              urls = ["http://localhost:8086"];
              database = "telegraf";
            };
          };
          inputs = {
            statsd = {
              service_address = ":8125";
              delete_timings = true;
            };
          };
        };
      };
    };
  };


  ###### implementation
  config = mkIf config.services.telegraf.enable {
    systemd.services.telegraf = let
      finalConfigFile = if config.services.telegraf.environmentFile == null
                        then configFile
                        else "/tmp/config.toml";
    in {
      description = "Telegraf Agent";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        EnvironmentFile = config.services.telegraf.environmentFile;
        ExecStartPre = lib.optional (config.services.telegraf.environmentFile != null)
          ''${pkgs.envsubst}/bin/envsubst -o /tmp/config.toml -i "${configFile}"'';
        ExecStart=''${cfg.package}/bin/telegraf -config ${finalConfigFile}'';
        ExecReload="${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = "telegraf";
        Restart = "on-failure";
        PrivateTmp = true;
        # for ping probes
        AmbientCapabilities = [ "CAP_NET_RAW" ];
      };
    };

    users.users.telegraf = {
      uid = config.ids.uids.telegraf;
      description = "telegraf daemon user";
    };
  };
}
