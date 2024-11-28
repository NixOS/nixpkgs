{ config, lib, pkgs, ... }:
let

  cfg = config.services.postsrsd;

in {

  ###### interface

  options = {

    services.postsrsd = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the postsrsd SRS server for Postfix.";
      };

      secretsFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/postsrsd/postsrsd.secret";
        description = "Secret keys used for signing and verification";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name for rewrite";
      };

      separator = lib.mkOption {
        type = lib.types.enum ["-" "=" "+"];
        default = "=";
        description = "First separator character in generated addresses";
      };

      # bindAddress = lib.mkOption { # uncomment once 1.5 is released
      #   type = lib.types.str;
      #   default = "127.0.0.1";
      #   description = "Socket listen address";
      # };

      forwardPort = lib.mkOption {
        type = lib.types.int;
        default = 10001;
        description = "Port for the forward SRS lookup";
      };

      reversePort = lib.mkOption {
        type = lib.types.int;
        default = 10002;
        description = "Port for the reverse SRS lookup";
      };

      timeout = lib.mkOption {
        type = lib.types.int;
        default = 1800;
        description = "Timeout for idle client connections in seconds";
      };

      excludeDomains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Origin domains to exclude from rewriting in addition to primary domain";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "postsrsd";
        description = "User for the daemon";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "postsrsd";
        description = "Group for the daemon";
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    services.postsrsd.domain = lib.mkDefault config.networking.hostName;

    users.users = lib.optionalAttrs (cfg.user == "postsrsd") {
      postsrsd = {
        group = cfg.group;
        uid = config.ids.uids.postsrsd;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "postsrsd") {
      postsrsd.gid = config.ids.gids.postsrsd;
    };

    systemd.services.postsrsd = {
      description = "PostSRSd SRS rewriting server";
      after = [ "network.target" ];
      before = [ "postfix.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.coreutils ];

      serviceConfig = {
        ExecStart = ''${pkgs.postsrsd}/sbin/postsrsd "-s${cfg.secretsFile}" "-d${cfg.domain}" -a${cfg.separator} -f${toString cfg.forwardPort} -r${toString cfg.reversePort} -t${toString cfg.timeout} "-X${lib.concatStringsSep "," cfg.excludeDomains}"'';
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
      };

      preStart = ''
        if [ ! -e "${cfg.secretsFile}" ]; then
          echo "WARNING: secrets file not found, autogenerating!"
          DIR="$(dirname "${cfg.secretsFile}")"
          install -m 750 -o ${cfg.user} -g ${cfg.group} -d "$DIR"
          install -m 600 -o ${cfg.user} -g ${cfg.group} <(dd if=/dev/random bs=18 count=1 | base64) "${cfg.secretsFile}"
        fi
      '';
    };

  };
}
