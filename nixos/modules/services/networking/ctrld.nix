{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ctrld;
  toml = pkgs.formats.toml { };
  configFile =
    if lib.isString cfg.settings then
      cfg.settings
    else if lib.isPath cfg.settings then
      builtins.toString cfg.settings
    else
      toml.generate "ctrld.toml" cfg.settings;
in
{
  options.services.ctrld = {
    enable = lib.mkEnableOption "Enable ctrld DNS proxy";
    package = lib.mkPackageOption pkgs "ctrld" { };

    # https://github.com/Control-D-Inc/ctrld/blob/main/README.md#default-config
    settings = lib.mkOption {
      type =
        with lib.types;
        lib.types.oneOf [
          path
          str
          toml.type
        ];

      default = {
        listener."listener.0" = {
          ip = "";
          port = 0;
          restricted = false;
        };

        network."network.0" = {
          cidrs = [ "0.0.0.0/0" ];
          name = "Network 0";
        };

        service = {
          log_level = "info";
          log_path = "";
        };

        upstream = {
          "upstream.0" = {
            bootstrap_ip = "76.76.2.11";
            endpoint = "https://freedns.controld.com/p1";
            name = "Control D - Anti-Malware";
            timeout = 5000;
            type = "doh";
          };

          "upstream.1" = {
            bootstrap_ip = "76.76.2.11";
            endpoint = "p2.freedns.controld.com";
            name = "Control D - No Ads";
            timeout = 3000;
            type = "doq";
          };
        };
      };

      description = ''
        Configuration for ctrld. Accepts path to a TOML file, see
        <https://github.com/Control-D-Inc/ctrld/blob/main/docs/config.md>
      '';
    };

    setNameservers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        If true, sets the nameservers of this machine to 127.0.0.1 (our local ctrld instance)
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.nameservers = lib.mkIf cfg.setNameservers [ "127.0.0.1" ];

    systemd.services.ctrld = {
      description = "Control-D DNS Proxy";
      after = [
        "network.target"
      ];
      before = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ cfg.package ];

      serviceConfig = {
        Type = "exec";
        Restart = "always";
        RestartSec = 5;

        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ "/var/run" ];

        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
        ];

        MemoryDenyWriteExecute = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectClock = true;

        RestrictNamespaces = true;
        RestrictRealtime = true;
        PrivateDevices = true;
        LockPersonality = true;

        NoNewPrivileges = true;
        RestrictSUIDSGID = true;

        ExecStart = "${pkgs.lib.getExe cfg.package} run --config=${configFile}";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ GustavoWidman ];
}
