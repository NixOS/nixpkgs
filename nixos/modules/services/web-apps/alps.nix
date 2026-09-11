{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.alps;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "alps" "port" ] ''
      Use `services.alps.settings.server.addr` instead.
    '')
    (lib.mkRemovedOptionModule [ "services" "alps" "bindIP" ] ''
      Use `services.alps.settings.server.addr` instead.
    '')
    (lib.mkRemovedOptionModule [ "services" "alps" "theme" ] ''
      Themes are no longer customizable.
    '')
    (lib.mkRemovedOptionModule [ "services" "alps" "imaps" "port" ] ''
      Use `services.alps.settings.provider.imap.server` instead.
    '')
    (lib.mkRemovedOptionModule [ "services" "alps" "imaps" "host" ] ''
      Use `services.alps.settings.provider.imap.server` instead.
    '')
    (lib.mkRemovedOptionModule [ "services" "alps" "smtps" "port" ] ''
      Use `services.alps.settings.smtp.server` instead.
    '')
    (lib.mkRemovedOptionModule [ "services" "alps" "smtps" "host" ] ''
      Use `services.alps.settings.smtp.server` instead.
    '')
    (lib.mkRemovedOptionModule [ "services" "alps" "args" ] ''
      Use `services.alps.settings` instead.
    '')
  ];

  options.services.alps = {
    enable = lib.mkEnableOption "alps";
    package = lib.mkPackageOption pkgs "alps" { };

    settings = lib.mkOption {
      description = ''
        The ALPS configuration, see <https://github.com/migadu/alps/blob/main/docs/CONFIGURATION.md> for documentation.

        Options containing secret data should be set to an attribute set
        containing the attribute `_secret` - a string pointing to a file
        containing the value the option should be set to.
      '';
      default = { };
      type = lib.types.submodule {
        freeformType = lib.types.toml;
        options = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];

    systemd.services.alps = {
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        RuntimeDirectory = "alps";
        ExecStartPre =
          let
            script = pkgs.writeShellScript "alps-pre-start" ''
              ${utils.genJqSecretsReplacementSnippet cfg.settings "/run/alps/config.json"}
              ${lib.getExe pkgs.remarshal} -f json -t toml /run/alps/config.json /run/alps/config.toml
              chown --reference=/run/alps /run/alps/config.json /run/alps/config.toml
            '';
          in
          "+${script}";
        ExecStart = [
          ""
          "${lib.getExe cfg.package} -config \${RUNTIME_DIRECTORY}/config.toml"
        ];

        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = [ "native" ];
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
      };
    };
  };
}
