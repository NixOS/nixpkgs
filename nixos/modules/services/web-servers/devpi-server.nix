{ pkgs, lib, config, ... }:
with lib;
let
  serviceName = "devpi-server";
  cfg = config.services.${serviceName};
  serverDir = "/var/lib/devpi";
in {
  options.services.devpi-server = {
    enable = mkEnableOption (mdDoc "Devpi Server");

    primaryUrl = mkOption {
      type = types.str;
      description = mdDoc "Url for the primary node. Required option for replica nodes.";
    };

    replica = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Run node as a replica.
        Requires the secretFile option and the primaryUrl to be enabled.
      '';
    };

    secretFile = mkOption {
      type = types.str;
      description = mdDoc ''
        Path to a shared secret file used for synchronization,
        Required for all nodes in a replica/primary setup.
      '';
    };

    server.port = mkOption {
      type = types.port;
      default = 3141;
      description = mdDoc "The port on which Devpi Server will listen.";
    };
  };

  config = mkIf cfg.enable {

    systemd.services."${serviceName}" = {
      enable = true;
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      after    = [ "network-online.target" ];
      preStart = ''
        if [ -f ${serverDir}/.nodeinfo ]; then
          # already initialized the package index, exit gracefully
          exit 0
        fi
        ${pkgs.devpi-server}/bin/devpi-init --serverdir ${serverDir} '' +
        strings.optionalString cfg.replica
        "--role=replica --master-url=${cfg.primaryUrl}";

      serviceConfig = {
        Restart = "always";
        ExecStart = let
          args = [
            "--request-timeout=5"
            "--serverdir=${serverDir}"
            "--secretfile=\${CREDENTIALS_DIRECTORY}/devpi-secret-file"
          ] ++
          (if cfg.replica
          then [
             "--role=replica"
             "--master-url=${cfg.primaryUrl}"
           ]
           else [ "--role=master" ]);
        in
          "${pkgs.devpi-server}/bin/devpi-server ${concatStringsSep " " args}";
        DynamicUser = true;
        StateDirectory = "devpi";
        LoadCredential = [ "devpi-secret-file:${cfg.secretFile}" ];
      };
    };
  };
}
