{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.g3proxy;

  inherit (lib)
    mkPackageOption
    mkEnableOption
    mkOption
    mkIf
    literalExpression
    ;

  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.g3proxy = {
    enable = mkEnableOption "g3proxy, a generic purpose forward proxy";

    package = mkPackageOption pkgs "g3proxy" { };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
      example = literalExpression ''
        {
          server = [{
            name = "test";
            escaper = "default";
            type = "socks_proxy";
            listen = {
              address = "[::]:10086";
            };
          }];
        }
      '';
      description = ''
        Settings of g3proxy.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.g3proxy = {
      description = "g3proxy server";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart =
          let
            g3proxy-yaml = settingsFormat.generate "g3proxy.yaml" cfg.settings;
          in
          "${lib.getExe cfg.package} --config-file ${g3proxy-yaml} --systemd --control-dir %t/g3proxy";

        WorkingDirectory = "/var/lib/g3proxy";
        StateDirectory = "g3proxy";
        RuntimeDirectory = "g3proxy";
        DynamicUser = true;

        RuntimeDirectoryMode = "0755";
        PrivateTmp = true;
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectSystem = "strict";
        ProcSubset = "pid";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RemoveIPC = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictSUIDSGID = true;
      };
    };
  };
}
