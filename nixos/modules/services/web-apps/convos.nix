{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.convos;
in
{
  options.services.convos = {
    enable = lib.mkEnableOption "Convos";
    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      example = 8080;
      description = "Port the web interface should listen on";
    };
    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "*";
      example = "127.0.0.1";
      description = "Address or host the web interface should listen on";
    };
    reverseProxy = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enables reverse proxy support. This will allow Convos to automatically
        pick up the `X-Forwarded-For` and
        `X-Request-Base` HTTP headers set in your reverse proxy
        web server. Note that enabling this option without a reverse proxy in
        front will be a security issue.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.convos = {
      description = "Convos Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      environment = {
        CONVOS_HOME = "%S/convos";
        CONVOS_REVERSE_PROXY = if cfg.reverseProxy then "1" else "0";
        MOJO_LISTEN = "http://${toString cfg.listenAddress}:${toString cfg.listenPort}";
      };
      serviceConfig = {
        ExecStart = "${pkgs.convos}/bin/convos daemon";
        Restart = "on-failure";
        StateDirectory = "convos";
        WorkingDirectory = "%S/convos";
        DynamicUser = true;
        MemoryDenyWriteExecute = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        SystemCallFilter = "@system-service";
        SystemCallArchitectures = "native";
        CapabilityBoundingSet = "";
      };
    };
  };
}
