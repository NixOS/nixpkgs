{
  lib,
  pkgs,
  config,
  utils,
  ...
}:
let
  inherit (lib)
    getExe
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.actual;
  dataDir = "/var/lib/actual";

  formatType = pkgs.formats.json { };
in
{
  options.services.actual = {
    enable = mkEnableOption "actual, a privacy focused app for managing your finances";
    package = mkPackageOption pkgs "actual-server" { };

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for the specified port.";
    };

    settings = mkOption {
      default = { };
      description = ''
        Server settings, refer to [the documentation](https://actualbudget.org/docs/config/) for available options.
        You can specify secret values in this configuration by setting `somevalue._secret = "/path/to/file"` instead of setting `somevalue` directly.
      '';
      type = types.submodule {
        freeformType = formatType.type;

        options = {
          hostname = mkOption {
            type = types.str;
            description = "The address to listen on";
            default = "::";
          };

          port = mkOption {
            type = types.port;
            description = "The port to listen on";
            default = 3000;
          };
        };

        config = {
          serverFiles = mkDefault "${dataDir}/server-files";
          userFiles = mkDefault "${dataDir}/user-files";
          dataDir = mkDefault dataDir;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.port ];

    systemd.services.actual = {
      description = "Actual server, a local-first personal finance app";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.ACTUAL_CONFIG_PATH = "/run/actual/config.json";

      preStart = ''
        # Generate config including secret values.
        ${utils.genJqSecretsReplacementSnippet cfg.settings "/run/actual/config.json"}
      '';

      serviceConfig = {
        ExecStart = getExe cfg.package;
        DynamicUser = true;
        User = "actual";
        Group = "actual";
        StateDirectory = "actual";
        RuntimeDirectory = "actual";
        WorkingDirectory = dataDir;
        LimitNOFILE = "1048576";
        PrivateTmp = true;
        PrivateDevices = true;
        StateDirectoryMode = "0700";
        Restart = "always";

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        #MemoryDenyWriteExecute = true; # Leads to coredump because V8 does JIT
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = [
    lib.maintainers.oddlama
    lib.maintainers.patrickdag
  ];
}
