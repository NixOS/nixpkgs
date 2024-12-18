{ config, lib, pkgs, ... }:

with lib;

let

  isMa1sd =
    package:
    lib.hasPrefix "ma1sd" package.name;

  isMxisd =
    package:
    lib.hasPrefix "mxisd" package.name;

  cfg = config.services.mxisd;

  server = optionalAttrs (cfg.server.name != null) { inherit (cfg.server) name; }
        // optionalAttrs (cfg.server.port != null) { inherit (cfg.server) port; };

  baseConfig = {
    matrix.domain = cfg.matrix.domain;
    key.path = "${cfg.dataDir}/signing.key";
    storage = {
      provider.sqlite.database = if isMa1sd cfg.package
                                 then "${cfg.dataDir}/ma1sd.db"
                                 else "${cfg.dataDir}/mxisd.db";
    };
  } // optionalAttrs (server != {}) { inherit server; };

  # merges baseConfig and extraConfig into a single file
  fullConfig = recursiveUpdate baseConfig cfg.extraConfig;

  configFile = if isMa1sd cfg.package
               then pkgs.writeText "ma1sd-config.yaml" (builtins.toJSON fullConfig)
               else pkgs.writeText "mxisd-config.yaml" (builtins.toJSON fullConfig);

in {
  options = {
    services.mxisd = {
      enable = mkEnableOption "matrix federated identity server";

      package = mkPackageOption pkgs "ma1sd" { };

      environmentFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Path to an environment-file which may contain secrets to be
          substituted via `envsubst`.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/mxisd";
        description = "Where data mxisd/ma1sd uses resides";
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        description = "Extra options merged into the mxisd/ma1sd configuration";
      };

      matrix = {

        domain = mkOption {
          type = types.str;
          description = ''
            the domain of the matrix homeserver
          '';
        };

      };

      server = {

        name = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Public hostname of mxisd/ma1sd, if different from the Matrix domain.
          '';
        };

        port = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            HTTP port to listen on (unencrypted)
          '';
        };

      };

    };
  };

  config = mkIf cfg.enable {
    users.users.mxisd =
      {
        group = "mxisd";
        home = cfg.dataDir;
        createHome = true;
        shell = "${pkgs.bash}/bin/bash";
        uid = config.ids.uids.mxisd;
      };

    users.groups.mxisd =
      {
        gid = config.ids.gids.mxisd;
      };

    systemd.services.mxisd = {
      description = "a federated identity server for the matrix ecosystem";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = let
        executable = if isMa1sd cfg.package then "ma1sd" else "mxisd";
      in {
        Type = "simple";
        User = "mxisd";
        Group = "mxisd";
        EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        ExecStart = "${cfg.package}/bin/${executable} -c ${cfg.dataDir}/mxisd-config.yaml";
        ExecStartPre = "${pkgs.writeShellScript "mxisd-substitute-secrets" ''
          umask 0077
          ${pkgs.envsubst}/bin/envsubst -o ${cfg.dataDir}/mxisd-config.yaml \
            -i ${configFile}
        ''}";
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
      };
    };
  };
}
