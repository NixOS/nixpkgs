{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.alertmanager;
  cfg2 = config.services.prometheus2.alertmanager;
  mkConfigFile = amCfg:
    pkgs.writeText "alertmanager.yml" (builtins.toJSON amCfg.configuration);

  mkAlertmanagerYml = amCfg: let
      checkedConfig = file:
        pkgs.runCommand "checked-config" { buildInputs = [ amCfg.package ]; } ''
        ln -s ${file} $out
        amtool check-config $out
      '';
      yml = if amCfg.configText != null then
        pkgs.writeText "alertmanager.yml" amCfg.configText
        else mkConfigFile amCfg;
    in
      checkedConfig yml;

  mkCmdlineArgs = amCfg:
    amCfg.extraFlags ++ [
    "--config.file ${mkAlertmanagerYml amCfg}"
    "--web.listen-address ${amCfg.listenAddress}:${toString amCfg.port}"
    "--log.level ${amCfg.logLevel}"
    ] ++ (optional (amCfg.webExternalUrl != null)
      "--web.external-url ${amCfg.webExternalUrl}"
    ) ++ (optional (amCfg.logFormat != null)
      "--log.format ${amCfg.logFormat}"
    );
    amOptions = {
      enable = mkEnableOption "Prometheus Alertmanager";

      package = mkOption {
        type = types.package;
        default = pkgs.prometheus-alertmanager;
        defaultText = "pkgs.alertmanager";
        description = ''
          Package that should be used for alertmanager.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "nobody";
        description = ''
          User name under which Alertmanager shall be run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = ''
          Group under which Alertmanager shall be run.
        '';
      };

      configuration = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = ''
          Alertmanager configuration as nix attribute set.
        '';
      };

      configText = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Alertmanager configuration as YAML text. If non-null, this option
          defines the text that is written to alertmanager.yml. If null, the
          contents of alertmanager.yml is generated from the structured config
          options.
        '';
      };

      logFormat = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          If set use a syslog logger or JSON logging.
        '';
      };

      logLevel = mkOption {
        type = types.enum ["debug" "info" "warn" "error" "fatal"];
        default = "warn";
        description = ''
          Only log messages with the given severity or above.
        '';
      };

      webExternalUrl = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The URL under which Alertmanager is externally reachable (for example, if Alertmanager is served via a reverse proxy).
          Used for generating relative and absolute links back to Alertmanager itself.
          If the URL has a path portion, it will be used to prefix all HTTP endoints served by Alertmanager.
          If omitted, relevant URL components will be derived automatically.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "";
        description = ''
          Address to listen on for the web interface and API.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 9093;
        description = ''
          Port to listen on for the web interface and API.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open port in firewall for incoming connections.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the Alertmanager.
        '';
      };
    };
    mkAMConfig = amCfg: amVersion: [
      (mkIf amCfg.enable {
        assertions = singleton {
          assertion = amCfg.configuration != null || amCfg.configText != null;
          message = "Can not enable alertmanager without a configuration. "
           + "Set either the `configuration` or `configText` attribute.";
        };
      })
      (mkIf amCfg.enable {
        networking.firewall.allowedTCPPorts = optional amCfg.openFirewall amCfg.port;

        systemd.services."alertmanager${amVersion}" = {
          wantedBy = [ "multi-user.target" ];
          after    = [ "network.target" ];
          script = ''
            ${amCfg.package}/bin/alertmanager \
              ${concatStringsSep " \\\n  " (mkCmdlineArgs amCfg)}
          '';
          serviceConfig = {
            User = amCfg.user;
            Group = amCfg.group;
            Restart  = "always";
            PrivateTmp = true;
            WorkingDirectory = "/tmp";
            ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          };
        };
      })
    ];
in {
  options = {
    services.prometheus.alertmanager = amOptions;
    services.prometheus2.alertmanager = amOptions;
  };

  config = mkMerge ((mkAMConfig cfg "") ++ (mkAMConfig cfg2 "2"));
}
