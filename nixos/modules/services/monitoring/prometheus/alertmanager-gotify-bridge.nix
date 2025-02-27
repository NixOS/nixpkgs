{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.prometheus.alertmanagerGotify;
  pkg = cfg.package;
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    mkPackageOption
    optionalString
    ;
in
{
  meta.maintainers = with lib.maintainers; [ juli0604 ];
  options.services.prometheus.alertmanagerGotify = {
    enable = mkEnableOption "alertmagager-gotify";
    package = mkPackageOption pkgs "alertmanager-gotify-bridge" { };
    bindAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "The address the server will listen on (bind address).";
    };
    defaultPriority = mkOption {
      type = types.int;
      default = 5;
      description = "The default priority for messages sent to gotify.";
    };
    debug = mkOption {
      type = types.bool;
      default = false;
      description = "Enables extended logs for debugging purposes. Should be disabled in productive mode.";
    };
    dispatchErrors = mkOption {
      type = types.bool;
      default = false;
      description = "When enabled, alerts will be tried to dispatch with an error message regarding faulty templating or missing fields to help debugging.";
    };
    extendedDetails = mkOption {
      type = types.bool;
      default = false;
      description = "When enabled, alerts are presented in HTML format and include colorized status (FIR|RES), alert start time, and a link to the generator of the alert.";
    };
    messageAnnotation = mkOption {
      type = types.str;
      description = "Annotation holding the alert message.";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Opens the bridge port in the firewall.";
    };
    port = mkOption {
      type = types.port;
      default = 8080;
      description = "The local port the bridge is listening on.";
    };
    priorityAnnotation = mkOption {
      type = types.str;
      default = "priority";
      description = "Annotation holding the priority of the alert.";
    };
    timeout = mkOption {
      type = types.ints.positive;
      default = 5;
      description = "The time between sending a message and the timeout.";
    };
    titleAnnotation = mkOption {
      type = types.str;
      default = "summary";
      description = "Annotation holding the title of the alert";
    };
    webhookPath = mkOption {
      type = types.str;
      default = "/gotify_webhook";
      description = "The URL path to handle requests on.";
    };
    environmentFile = mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing additional config environment variables for alertmanager-gotify-bridge.
        This is especially for secrets like GOTIFY_TOKEN and AUTH_PASSWORD.
      '';
    };
    gotifyEndpoint = {
      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The hostname or ip your gotify endpoint is running.";
      };
      port = mkOption {
        type = types.port;
        default = 443;
        description = "The port your gotify endpoint is running.";
      };
      tls = mkOption {
        type = types.bool;
        default = true;
        description = "If your gotify endpoint uses https, leave this option set to default";
      };
    };
    metrics = {
      username = mkOption {
        type = types.str;
        description = "The username used to access your metrics.";
      };
      namespace = mkOption {
        type = types.str;
        default = "alertmanager-gotify-bridge";
        description = "The namescape of the metrics.";
      };
      path = mkOption {
        type = types.str;
        default = "/metrics";
        description = "The path under which the metrics will be exposed.";
      };
    };
  };

  config = mkIf cfg.enable {
    users = {
      groups.alertmanager-gotify = { };
      users.alertmanager-gotify = {
        group = "alertmanager-gotify";
        isSystemUser = true;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.alertmanager-gotify-bridge = {
      description = "A bridge between Prometheus AlertManager and a Gotify server";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkg} ${optionalString cfg.debug "--debug"}";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        User = "alertmanager-gotify";
        Group = "alertmanager-gotify";

        #hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateIPC = true;
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectKernelTunables = true;
        ProtectHostname = true;
        ProtectProc = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        ProcSubset = "pid";
        SystemCallArchitectures = "native";
        RemoveIPC = true;

      };
      environment = {
        BIND_ADDRESS = cfg.bindAddress;
        DEFAULT_PRIORITY = toString cfg.defaultPriority;
        DISPATCH_ERRORS = toString cfg.dispatchErrors;
        EXTENDED_DETAILS = toString cfg.extendedDetails;
        MESSAGE_ANNOTATION = cfg.messageAnnotation;
        PORT = toString cfg.port;
        PRIORITY_ANNOTATION = cfg.priorityAnnotation;
        TIMEOUT = "${toString cfg.timeout}s";
        TITLE_ANNOTATION = cfg.titleAnnotation;
        WEBHOOK_PATH = cfg.webhookPath;
        GOTIFY_ENDPOINT = "${
          if cfg.gotifyEndpoint.tls then "https://" else "http://"
        }${toString cfg.gotifyEndpoint.host}:${toString cfg.gotifyEndpoint.port}/message";
        AUTH_USERNAME = cfg.metrics.username;
      };
    };
  };
}
