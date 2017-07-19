{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.consul;

  dataDir = "/var/lib/consul";

  configFile = pkgs.writeText "consul.json" (builtins.toJSON (
    { data_dir = dataDir; } //
    (optionalAttrs cfg.webUi { ui_dir = pkgs.consul.ui; }) //
    cfg.extraConfig));
in
{
  options = {

    services.consul = {

      enable = mkEnableOption "Consul daemon";

      webUi = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables the web interface on the consul http port.
        '';
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        example = literalExample ''
          { server = true;
            bootstrap_expect = 3;
            disable_anonymous_signature = true;
            disable_update_check = true;
          }
        '';
        description = ''
          Extra configuration options which are serialized to json and added
          to the config.json file.
        '';
      };

      alerts = {
        enable = mkEnableOption "consul-alerts";

        listenAddr = mkOption {
          description = "Api listening address.";
          default = "localhost:9000";
          type = types.str;
        };

        consulAddr = mkOption {
          description = "Consul api listening adddress";
          default = "localhost:8500";
          type = types.str;
        };

        watchChecks = mkOption {
          description = "Whether to enable check watcher.";
          default = true;
          type = types.bool;
        };

        watchEvents = mkOption {
          description = "Whether to enable event watcher.";
          default = true;
          type = types.bool;
        };
      };

    };

  };

  config = mkIf cfg.enable (
    mkMerge [{

      users.extraUsers."consul" = {
        description = "Consul agent daemon user";
        uid = config.ids.uids.consul;
        # The shell is needed for health checks
        shell = "/run/current-system/sw/bin/bash";
      };

      systemd.services.consul = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        unitConfig.RequiresMountsFor = dataDir;

        serviceConfig = {
          ExecStart = "${pkgs.consul.bin}/bin/consul agent -config-file ${configFile}";
          ExecReload = "${pkgs.consul.bin}/bin/consul reload";
          PermissionsStartOnly = true;
          User = "consul";
          TimeoutStartSec = "0";
        };

        path = with pkgs; [ iproute gnugrep gawk consul ];
        preStart = ''
          install -d -m0700 -o consul "${dataDir}"
        '';
      };

      environment.systemPackages =  [ pkgs.consul ]; # cli tools
    }

    (mkIf (cfg.alerts.enable) {
      systemd.services.consul-alerts = {
        wantedBy = [ "multi-user.target" ];
        after = [ "consul.service" ];

        path = [ pkgs.consul ];

        serviceConfig = {
          ExecStart = ''
            ${pkgs.consul-alerts.bin}/bin/consul-alerts start \
              --alert-addr=${cfg.alerts.listenAddr} \
              --consul-addr=${cfg.alerts.consulAddr} \
              ${optionalString cfg.alerts.watchChecks "--watch-checks"} \
              ${optionalString cfg.alerts.watchEvents "--watch-events"} \
              --log-level=warn
          '';
          User = "consul";
          Restart = "on-failure";
        };
      };
    })

  ]);
}
