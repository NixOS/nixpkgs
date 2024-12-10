{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.doh-proxy-rust;

in
{

  options.services.doh-proxy-rust = {

    enable = mkEnableOption "doh-proxy-rust";

    flags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--server-address=9.9.9.9:53" ];
      description = ''
        A list of command-line flags to pass to doh-proxy. For details on the
        available options, see <https://github.com/jedisct1/doh-server#usage>.
      '';
    };

  };

  config = mkIf cfg.enable {
    systemd.services.doh-proxy-rust = {
      description = "doh-proxy-rust";
      after = [
        "network.target"
        "nss-lookup.target"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.doh-proxy-rust}/bin/doh-proxy ${escapeShellArgs cfg.flags}";
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
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
        ];
      };
    };
  };

  meta.maintainers = with maintainers; [ stephank ];

}
