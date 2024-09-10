{ config, lib, pkgs, ... }:

with lib;

let
  inherit (lib) mkEnableOption mkPackageOptionMD mkOption;
  cfg = config.services.matrix-zulip-bridge;
  yaml = pkgs.formats.yaml { };
  settingsFile = yaml.generate "matrix-zulip-bridge.yaml" cfg.settings;
in
{
  meta.maintainers = [ lib.maintainers.raitobezarius ];
  options.services.matrix-zulip-bridge = {
    enable = mkEnableOption "matrix-zulip-bridge, a puppeteering Matrix<->Zulip bridge";
    package = mkPackageOptionMD pkgs "matrix-zulip-bridge" { };
    secretsFile = mkOption {
      type = types.path;
      description = ''
        A file containing multiple environment variable
        declarations that contains secrets which will
        be substituted in the YAML configuration file.
      '';
    };

    settings = mkOption {
      type = yaml.type;
      default = {};
      description = ''
        Configuration for the Matrix<->Zulip bridge.
      '';
    };

    homeserver = mkOption {
      type = types.str;
      description = ''
        Homeserver which installed the appservice.
      '';
    };

    bridgeOwner = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        MXID of the bridge administrator.
        If none is provided, the first user to talk to the bridge is admin.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.matrix-zulip-bridge = {
      description = "matrix-zulip-bridge - a puppeteering Matrix<->Zulip bridge";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        umask 0077
        ${lib.getExe pkgs.envsubst} -i ${settingsFile} -o ''${RUNTIME_DIRECTORY}/config.yml
      '';

      serviceConfig =
      let
        extraArgs = lib.optional (cfg.bridgeOwner != null) "-o ${cfg.bridgeOwner}";
      in
      {
        EnvironmentFile = [ cfg.secretsFile ];
        ExecStart = "${cfg.package}/bin/matrix-zulip-bridge -c \${RUNTIME_DIRECTORY}/config.yml ${lib.concatStringsSep " " extraArgs} ${cfg.homeserver}";
        DynamicUser = true;
        StateDirectory = "matrix-zulip-bridge";
        RuntimeDirectory = "matrix-zulip-bridge";
        Restart = "on-failure";
        RestartSec = "30s";
      };
    };
  };
}
