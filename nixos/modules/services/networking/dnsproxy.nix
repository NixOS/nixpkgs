{ config, lib, pkgs, ... }:

let
  inherit (lib)
    escapeShellArgs
    getExe
    lists
    literalExpression
    maintainers
    mdDoc
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types;

  cfg = config.services.dnsproxy;

  yaml = pkgs.formats.yaml { };
  configFile = yaml.generate "config.yaml" cfg.settings;

  finalFlags = (lists.optional (cfg.settings != { }) "--config-path=${configFile}") ++ cfg.flags;
in
{

  options.services.dnsproxy = {

    enable = mkEnableOption (lib.mdDoc "dnsproxy");

    package = mkPackageOption pkgs "dnsproxy" { };

    settings = mkOption {
      type = yaml.type;
      default = { };
      example = literalExpression ''
        {
          bootstrap = [
            "8.8.8.8:53"
          ];
          listen-addrs = [
            "0.0.0.0"
          ];
          listen-ports = [
            53
          ];
          upstream = [
            "1.1.1.1:53"
          ];
        }
      '';
      description = mdDoc ''
        Contents of the `config.yaml` config file.
        The `--config-path` argument will only be passed if this set is not empty.

        See <https://github.com/AdguardTeam/dnsproxy/blob/master/config.yaml.dist>.
      '';
    };

    flags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--upstream=1.1.1.1:53" ];
      description = lib.mdDoc ''
        A list of extra command-line flags to pass to dnsproxy. For details on the
        available options, see <https://github.com/AdguardTeam/dnsproxy#usage>.
        Keep in mind that options passed through command-line flags override
        config options.
      '';
    };

  };

  config = mkIf cfg.enable {
    systemd.services.dnsproxy = {
      description = "Simple DNS proxy with DoH, DoT, DoQ and DNSCrypt support";
      after = [ "network.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${getExe cfg.package} ${escapeShellArgs finalFlags}";
        Restart = "always";
        RestartSec = 10;
        DynamicUser = true;

        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" "~@privileged @resources" ];
      };
    };
  };

  meta.maintainers = with maintainers; [ diogotcorreia ];

}
