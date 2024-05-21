{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.services.devpi-server;

  secretsFileName = "devpi-secret-file";

  stateDirName = "devpi";

  runtimeDir = "/run/${stateDirName}";
  serverDir = "/var/lib/${stateDirName}";
in
{
  options.services.devpi-server = {
    enable = mkEnableOption "Devpi Server";

    package = mkPackageOption pkgs "devpi-server" { };

    primaryUrl = mkOption {
      type = types.str;
      description = "Url for the primary node. Required option for replica nodes.";
    };

    replica = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Run node as a replica.
        Requires the secretFile option and the primaryUrl to be enabled.
      '';
    };

    secretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to a shared secret file used for synchronization,
        Required for all nodes in a replica/primary setup.
      '';
    };

    host = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        domain/ip address to listen on
      '';
    };

    port = mkOption {
      type = types.port;
      default = 3141;
      description = "The port on which Devpi Server will listen.";
    };

    openFirewall = mkEnableOption "opening the default ports in the firewall for Devpi Server";
  };

  config = mkIf cfg.enable {

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
          cp ${cfg.secretFile} ${runtimeDir}/${secretsFileName}
          chmod 0600 ${runtimeDir}/*${secretsFileName}

          if [ -f ${serverDir}/.nodeinfo ]; then
            # already initialized the package index, exit gracefully
            exit 0
          fi
          ${cfg.package}/bin/devpi-init --serverdir ${serverDir} ''
        + strings.optionalString cfg.replica "--role=replica --master-url=${cfg.primaryUrl}";

      serviceConfig = {
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
          "${cfg.package}/bin/devpi-server ${concatStringsSep " " args}";
        DynamicUser = true;
        StateDirectory = stateDirName;
        RuntimeDirectory = stateDirName;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    meta.maintainers = [ cafkafk ];
  };
}
