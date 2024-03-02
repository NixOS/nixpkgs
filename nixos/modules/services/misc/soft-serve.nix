{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.soft-serve;
  configFile = format.generate "config.yaml" cfg.settings;
  format = pkgs.formats.yaml { };
  docUrl = "https://charm.sh/blog/self-hosted-soft-serve/";
  stateDir = "/var/lib/soft-serve";
in
{
  options = {
    services.soft-serve = {
      enable = mkEnableOption "soft-serve";

      package = mkPackageOption pkgs "soft-serve" { };

      settings = mkOption {
        type = format.type;
        default = { };
        description = mdDoc ''
          The contents of the configuration file for soft-serve.

          See <${docUrl}>.
        '';
        example = literalExpression ''
          {
            name = "dadada's repos";
            log_format = "text";
            ssh = {
              listen_addr = ":23231";
              public_url = "ssh://localhost:23231";
              max_timeout = 30;
              idle_timeout = 120;
            };
            stats.listen_addr = ":23233";
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      # The config file has to be inside the state dir
      "L+ ${stateDir}/config.yaml - - - - ${configFile}"
    ];

    systemd.services.soft-serve = {
      description = "Soft Serve git server";
      documentation = [ docUrl ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.SOFT_SERVE_DATA_PATH = stateDir;

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        Restart = "always";
        ExecStart = "${getExe cfg.package} serve";
        StateDirectory = "soft-serve";
        WorkingDirectory = stateDir;
        RuntimeDirectory = "soft-serve";
        RuntimeDirectoryMode = "0750";
        ProcSubset = "pid";
        ProtectProc = "invisible";
        UMask = "0027";
        CapabilityBoundingSet = "";
        ProtectHome = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RemoveIPC = true;
        PrivateMounts = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation @debug @keyring @module @mount @obsolete @privileged @raw-io @reboot @setuid @swap"
        ];
      };
    };
  };

  meta.maintainers = [ maintainers.dadada ];
}
