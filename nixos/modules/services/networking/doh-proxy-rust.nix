{ config, lib, pkgs, ... }:
let

  cfg = config.services.doh-proxy-rust;

in {

  options.services.doh-proxy-rust = {

    enable = lib.mkEnableOption "doh-proxy-rust";

    flags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = [ "--server-address=9.9.9.9:53" ];
      description = ''
        A list of command-line flags to pass to doh-proxy. For details on the
        available options, see <https://github.com/jedisct1/doh-server#usage>.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.doh-proxy-rust = {
      description = "doh-proxy-rust";
      after = [ "network.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.doh-proxy-rust}/bin/doh-proxy ${lib.escapeShellArgs cfg.flags}";
        Restart = "always";
        RestartSec = 10;
        DynamicUser = true;

        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        RemoveIPC = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" "~@privileged @resources" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ stephank ];

}
