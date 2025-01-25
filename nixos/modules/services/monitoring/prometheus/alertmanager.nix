{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.prometheus.alertmanager;
  mkConfigFile = pkgs.writeText "alertmanager.yml" (builtins.toJSON cfg.configuration);

  checkedConfig =
    file:
    if cfg.checkConfig then
      pkgs.runCommand "checked-config" { nativeBuildInputs = [ cfg.package ]; } ''
        ln -s ${file} $out
        amtool check-config $out
      ''
    else
      file;

  alertmanagerYml =
    let
      yml =
        if cfg.configText != null then pkgs.writeText "alertmanager.yml" cfg.configText else mkConfigFile;
    in
    checkedConfig yml;

  cmdlineArgs =
    cfg.extraFlags
    ++ [
      "--config.file /tmp/alert-manager-substituted.yaml"
      "--web.listen-address ${cfg.listenAddress}:${toString cfg.port}"
      "--log.level ${cfg.logLevel}"
      "--storage.path /var/lib/alertmanager"
      (toString (map (peer: "--cluster.peer ${peer}:9094") cfg.clusterPeers))
    ]
    ++ (lib.optional (cfg.webExternalUrl != null) "--web.external-url ${cfg.webExternalUrl}")
    ++ (lib.optional (cfg.logFormat != null) "--log.format ${cfg.logFormat}");
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "prometheus" "alertmanager" "user" ]
      "The alertmanager service is now using systemd's DynamicUser mechanism which obviates a user setting."
    )
    (lib.mkRemovedOptionModule [ "services" "prometheus" "alertmanager" "group" ]
      "The alertmanager service is now using systemd's DynamicUser mechanism which obviates a group setting."
    )
    (lib.mkRemovedOptionModule [ "services" "prometheus" "alertmanagerURL" ] ''
      Due to incompatibility, the alertmanagerURL option has been removed,
      please use 'services.prometheus.alertmanagers' instead.
    '')
  ];

  options = {
    services.prometheus.alertmanager = {
      enable = lib.mkEnableOption "Prometheus Alertmanager";

      package = lib.mkPackageOption pkgs "prometheus-alertmanager" { };

      configuration = lib.mkOption {
        type = lib.types.nullOr lib.types.attrs;
        default = null;
        description = ''
          Alertmanager configuration as nix attribute set.

          The contents of the resulting config file are processed using envsubst.
          `$` needs to be escaped as `$$` to be preserved.
        '';
      };

      configText = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        default = null;
        description = ''
          Alertmanager configuration as YAML text. If non-null, this option
          defines the text that is written to alertmanager.yml. If null, the
          contents of alertmanager.yml is generated from the structured config
          options.

          The contents of the resulting config file are processed using envsubst.
          `$` needs to be escaped as `$$` to be preserved.
        '';
      };

      checkConfig = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Check configuration with `amtool check-config`. The call to `amtool` is
          subject to sandboxing by Nix.

          If you use credentials stored in external files
          (`environmentFile`, etc),
          they will not be visible to `amtool`
          and it will report errors, despite a correct configuration.
        '';
      };

      logFormat = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          If set use a syslog logger or JSON logging.
        '';
      };

      logLevel = lib.mkOption {
        type = lib.types.enum [
          "debug"
          "info"
          "warn"
          "error"
          "fatal"
        ];
        default = "warn";
        description = ''
          Only log messages with the given severity or above.
        '';
      };

      webExternalUrl = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The URL under which Alertmanager is externally reachable (for example, if Alertmanager is served via a reverse proxy).
          Used for generating relative and absolute links back to Alertmanager itself.
          If the URL has a path portion, it will be used to prefix all HTTP endoints served by Alertmanager.
          If omitted, relevant URL components will be derived automatically.
        '';
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Address to listen on for the web interface and API. Empty string will listen on all interfaces.
          "localhost" will listen on 127.0.0.1 (but not ::1).
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9093;
        description = ''
          Port to listen on for the web interface and API.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open port in firewall for incoming connections.
        '';
      };

      clusterPeers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Initial peers for HA cluster.
        '';
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Extra commandline options when launching the Alertmanager.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/root/alertmanager.env";
        description = ''
          File to load as environment file. Environment variables
          from this file will be interpolated into the config file
          using envsubst with this syntax:
          `$ENVIRONMENT ''${VARIABLE}`
        '';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      assertions = lib.singleton {
        assertion = cfg.configuration != null || cfg.configText != null;
        message =
          "Can not enable alertmanager without a configuration. "
          + "Set either the `configuration` or `configText` attribute.";
      };
    })
    (lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

      systemd.services.alertmanager = {
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        preStart = ''
          ${lib.getBin pkgs.envsubst}/bin/envsubst -o "/tmp/alert-manager-substituted.yaml" \
                                                   -i "${alertmanagerYml}"
        '';
        serviceConfig = {
          ExecStart =
            "${cfg.package}/bin/alertmanager"
            + lib.optionalString (lib.length cmdlineArgs != 0) (
              " \\\n  " + lib.concatStringsSep " \\\n  " cmdlineArgs
            );
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";

          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

          CapabilityBoundingSet = [ "" ];
          DeviceAllow = [ "" ];
          DynamicUser = true;
          NoNewPrivileges = true;

          MemoryDenyWriteExecute = true;

          LockPersonality = true;

          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ProtectHome = "tmpfs";

          PrivateTmp = true;
          PrivateDevices = true;
          PrivateIPC = true;

          ProcSubset = "pid";

          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;

          Restart = "always";

          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;

          StateDirectory = "alertmanager";
          SystemCallFilter = [
            "@system-service"
            "~@cpu-emulation"
            "~@privileged"
            "~@reboot"
            "~@setuid"
            "~@swap"
          ];

          WorkingDirectory = "/tmp";
        };
      };
    })
  ];
}
