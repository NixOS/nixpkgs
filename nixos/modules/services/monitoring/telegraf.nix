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
    systemd.services.telegraf = {
      description = "Telegraf Agent";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        ExecStart=''${cfg.package}/bin/telegraf -config "${configFile}"'';
        ExecReload="${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = "telegraf";
        Restart = "on-failure";
      };
    };

    users.users.telegraf = {
      uid = config.ids.uids.telegraf;
      description = "telegraf daemon user";
    };
  };
}
