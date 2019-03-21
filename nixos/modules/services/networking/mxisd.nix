{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mxisd;

  server = optionalAttrs (cfg.server.name != null) { inherit (cfg.server) name; }
        // optionalAttrs (cfg.server.port != null) { inherit (cfg.server) port; };

  baseConfig = {
    matrix.domain = cfg.matrix.domain;
    key.path = "${cfg.dataDir}/signing.key";
    storage = {
      provider.sqlite.database = "${cfg.dataDir}/mxisd.db";
    };
  } // optionalAttrs (server != {}) { inherit server; };

  # merges baseConfig and extraConfig into a single file
  fullConfig = recursiveUpdate baseConfig cfg.extraConfig;

  configFile = pkgs.writeText "mxisd-config.yaml" (builtins.toJSON fullConfig);

in {
  options = {
    services.mxisd = {
      enable = mkEnableOption "mxisd matrix federated identity server";

      package = mkOption {
        type = types.package;
        default = pkgs.mxisd;
        defaultText = "pkgs.mxisd";
        description = "The mxisd package to use";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/mxisd";
        description = "Where data mxisd uses resides";
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        description = "Extra options merged into the mxisd configuration";
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
            Public hostname of mxisd, if different from the Matrix domain.
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
    users.users = [
      {
        name = "mxisd";
        group = "mxisd";
        home = cfg.dataDir;
        createHome = true;
        shell = "${pkgs.bash}/bin/bash";
        uid = config.ids.uids.mxisd;
      }
    ];

    users.groups = [
      {
        name = "mxisd";
        gid = config.ids.gids.mxisd;
      }
    ];

    systemd.services.mxisd = {
      description = "a federated identity server for the matrix ecosystem";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # mxisd / spring.boot needs the configuration to be named "application.yaml"
      preStart = ''
        config=${cfg.dataDir}/application.yaml
        cp ${configFile} $config
        chmod 444 $config
      '';

      serviceConfig = {
        Type = "simple";
        User = "mxisd";
        Group = "mxisd";
        ExecStart = "${cfg.package}/bin/mxisd --spring.config.location=${cfg.dataDir}/ --spring.profiles.active=systemd --java.security.egd=file:/dev/./urandom";
        WorkingDirectory = cfg.dataDir;
        PermissionsStartOnly = true;
        SuccessExitStatus = 143;
        Restart = "on-failure";
      };
    };
  };
}
