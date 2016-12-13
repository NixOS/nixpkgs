{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.postsrsd;

in {

  ###### interface

  options = {

    services.postsrsd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the postsrsd SRS server for Postfix.";
      };

      secretsFile = mkOption {
        type = types.path;
        default = "/var/lib/postsrsd/postsrsd.secret";
        description = "Secret keys used for signing and verification";
      };

      domain = mkOption {
        type = types.str;
        description = "Domain name for rewrite";
      };

      separator = mkOption {
        type = types.enum ["-" "=" "+"];
        default = "=";
        description = "First separator character in generated addresses";
      };

      # bindAddress = mkOption { # uncomment once 1.5 is released
      #   type = types.str;
      #   default = "127.0.0.1";
      #   description = "Socket listen address";
      # };

      forwardPort = mkOption {
        type = types.int;
        default = 10001;
        description = "Port for the forward SRS lookup";
      };

      reversePort = mkOption {
        type = types.int;
        default = 10002;
        description = "Port for the reverse SRS lookup";
      };

      timeout = mkOption {
        type = types.int;
        default = 1800;
        description = "Timeout for idle client connections in seconds";
      };

      excludeDomains = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Origin domains to exclude from rewriting in addition to primary domain";
      };

      user = mkOption {
        type = types.str;
        default = "postsrsd";
        description = "User for the daemon";
      };

      group = mkOption {
        type = types.str;
        default = "postsrsd";
        description = "Group for the daemon";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.postsrsd.domain = mkDefault config.networking.hostName;

    users.extraUsers = optionalAttrs (cfg.user == "postsrsd") (singleton
      { name = "postsrsd";
        group = cfg.group;
        uid = config.ids.uids.postsrsd;
      });

    users.extraGroups = optionalAttrs (cfg.group == "postsrsd") (singleton
      { name = "postsrsd";
        gid = config.ids.gids.postsrsd;
      });

    systemd.services.postsrsd = {
      description = "PostSRSd SRS rewriting server";
      after = [ "network.target" ];
      before = [ "postfix.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.coreutils ];

      serviceConfig = {
        ExecStart = ''${pkgs.postsrsd}/sbin/postsrsd "-s${cfg.secretsFile}" "-d${cfg.domain}" -a${cfg.separator} -f${toString cfg.forwardPort} -r${toString cfg.reversePort} -t${toString cfg.timeout} "-X${concatStringsSep "," cfg.excludeDomains}"'';
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
      };

      preStart = ''
        if [ ! -e "${cfg.secretsFile}" ]; then
          echo "WARNING: secrets file not found, autogenerating!"
          DIR="$(dirname "${cfg.secretsFile}")"
          if [ ! -d "$DIR" ]; then
            mkdir -p -m750 "$DIR"
            chown "${cfg.user}:${cfg.group}" "$DIR"
          fi
          dd if=/dev/random bs=18 count=1 | base64 > "${cfg.secretsFile}"
          chmod 600 "${cfg.secretsFile}"
        fi
        chown "${cfg.user}:${cfg.group}" "${cfg.secretsFile}"
      '';
    };

  };
}
