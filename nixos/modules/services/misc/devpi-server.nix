{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.devpi-server;

  secretsFileName = "devpi-secret-file";

  stateDirName = "devpi";

  runtimeDir = "/run/${stateDirName}";
  serverDir = "/var/lib/${stateDirName}";
in
{
  options.services.devpi-server = {
    enable = lib.mkEnableOption "Devpi Server";

    package = lib.mkPackageOption pkgs "devpi-server" { };

    primaryUrl = lib.mkOption {
      type = lib.types.str;
      description = "Url for the primary node. Required option for replica nodes.";
    };

    replica = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Run node as a replica.
        Requires the secretFile option and the primaryUrl to be enabled.
      '';
    };

    secretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a shared secret file used for synchronization,
        Required for all nodes in a replica/primary setup.
      '';
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = ''
        domain/ip address to listen on
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3141;
      description = "The port on which Devpi Server will listen.";
    };

    openFirewall = lib.mkEnableOption "opening the default ports in the firewall for Devpi Server";
  };

  config = lib.mkIf cfg.enable {

    systemd.services.devpi-server = {
      enable = true;
      description = "devpi PyPI-compatible server";
      documentation = [ "https://devpi.net/docs/devpi/devpi/stable/+d/index.html" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      # Since at least devpi-server 6.10.0, devpi requires the secrets file to
      # have 0600 permissions.
      preStart =
        ''
          ${lib.optionalString (!isNull cfg.secretFile)
            "install -Dm 0600 \${CREDENTIALS_DIRECTORY}/devpi-secret ${runtimeDir}/${secretsFileName}"
          }

          if [ -f ${serverDir}/.nodeinfo ]; then
            # already initialized the package index, exit gracefully
            exit 0
          fi
          ${cfg.package}/bin/devpi-init --serverdir ${serverDir} ''
        + lib.optionalString cfg.replica "--role=replica --master-url=${cfg.primaryUrl}";

      serviceConfig = {
        LoadCredential = lib.mkIf (! isNull cfg.secretFile) [
          "devpi-secret:${cfg.secretFile}"
        ];
        Restart = "always";
        ExecStart =
          let
            args =
              [
                "--request-timeout=5"
                "--serverdir=${serverDir}"
                "--host=${cfg.host}"
                "--port=${builtins.toString cfg.port}"
              ]
              ++ lib.optionals (! isNull cfg.secretFile) [
                "--secretfile=${runtimeDir}/${secretsFileName}"
              ]
              ++ (
                if cfg.replica then
                  [
                    "--role=replica"
                    "--master-url=${cfg.primaryUrl}"
                  ]
                else
                  [ "--role=master" ]
              );
          in
          "${cfg.package}/bin/devpi-server ${lib.concatStringsSep " " args}";
        DynamicUser = true;
        StateDirectory = stateDirName;
        RuntimeDirectory = stateDirName;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    meta.maintainers = [ lib.maintainers.cafkafk ];
  };
}
