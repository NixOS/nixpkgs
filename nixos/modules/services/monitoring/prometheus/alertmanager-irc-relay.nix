{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.prometheus.alertmanagerIrcRelay;

  configFormat = pkgs.formats.yaml { };
  configFile = configFormat.generate "alertmanager-irc-relay.yml" cfg.settings;
in
{
  options.services.prometheus.alertmanagerIrcRelay = {
    enable = mkEnableOption (mdDoc "Alertmanager IRC Relay");

    package = mkOption {
      type = types.package;
      default = pkgs.alertmanager-irc-relay;
      defaultText = literalExpression "pkgs.alertmanager-irc-relay";
      description = mdDoc "Alertmanager IRC Relay package to use.";
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [];
      description = mdDoc "Extra command line options to pass to alertmanager-irc-relay.";
    };

    settings = mkOption {
      type = configFormat.type;
      example = literalExpression ''
        {
          http_host = "localhost";
          http_port = 8000;

          irc_host = "irc.example.com";
          irc_port = 7000;
          irc_nickname = "myalertbot";

          irc_channels = [
            { name = "#mychannel"; }
          ];
        }
      '';
      description = mdDoc ''
        Configuration for Alertmanager IRC Relay as a Nix attribute set.
        For a reference, check out the
        [example configuration](https://github.com/google/alertmanager-irc-relay#configuring-and-running-the-bot)
        and the
        [source code](https://github.com/google/alertmanager-irc-relay/blob/master/config.go).

        Note: The webhook's URL MUST point to the IRC channel where the message
        should be posted. For `#mychannel` from the example, this would be
        `http://localhost:8080/mychannel`.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.alertmanager-irc-relay = {
      description = "Alertmanager IRC Relay";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/alertmanager-irc-relay \
          -config ${configFile} \
          ${escapeShellArgs cfg.extraFlags}
        '';

        DynamicUser = true;
        NoNewPrivileges = true;

        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProtectHome = "tmpfs";

        PrivateTmp = true;
        PrivateDevices = true;
        PrivateIPC = true;

        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;

        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation"
          "~@privileged"
          "~@reboot"
          "~@setuid"
          "~@swap"
        ];
      };
    };
  };

  meta.maintainers = [ maintainers.oxzi ];
}
