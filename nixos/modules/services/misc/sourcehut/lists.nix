{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  lcfg = cfg.lists;

  rcfg = config.services.redis;
  inherit (import ./helpers.nix { inherit lib; }) redisOpts;
in {
  options = {
    services.sourcehut.lists = {
      redis = mkOption {
        type = types.submodule redisOpts;
        default = { hostname = rcfg.bind; port = rcfg.port; dbnumber = 0; };
        description = ''
          The redis connection used for the Celery worker.
        '';
      };

      postingDomain = mkOption {
        type = types.str;
        default = "lists.sr.ht.local";
        description = ''
          The domain that incoming email should be sent to. Forward mail sent here to
          the LTMP socket.
        '';
      };

      worker.socket.path = mkOption {
        type = types.path;
        default = "/tmp/lists.sr.ht-lmtp.sock";
        description = ''
          Path for the lmtp daemon's unix socket. Direct incoming mail to this socket.
        '';
      };

      worker.socket.group = mkOption {
        type = types.str;
        default = "postfix";
        description = ''
          The lmtp daemon will make the unix socket group-read/write for users in this
          group.
        '';
      };

      worker.mimeTypes.permit = mkOption {
        type = types.listOf types.str;
        default = [ "text/*" "application/pgp-signature" "application/pgp-keys" ];
        description = ''
          List of Content-Types to permit. Messages with Content-Types
          not included in this list are rejected. Multipart messages are always
          supported, and each part is checked against this list.

          Uses fnmatch for wildcard expansion.
        '';
      };

      worker.mimeTypes.reject = mkOption {
        type = types.listOf types.str;
        default = [ "text/html" ];
        description = ''
          List of Content-Types to reject. Messages with Content-Types
          included in this list are rejected. Multipart messages are always supported,
          and each part is checked against this list.

          Uses fnmatch for wildcard expansion.
        '';
      };

      worker.rejectUrl = mkOption {
        type = types.str;
        default = "https://man.sr.ht/lists.sr.ht/how-to-send.md";
        description = ''
          Link to include in the rejection message where senders can get help
          correcting their email.
        '';
      };

      worker.extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration for lists.sr.ht::worker.
        '';
      };
    };
  };

  config = mkIf lcfg.enable {
    users = {
      users = [
        { name = lcfg.user;
          group = lcfg.user;
          description = "lists.sr.ht user"; } ];

      groups = [
        { name = lcfg.user; } ];
    };

    systemd.services = {
      "lists.sr.ht" = {
        after = [ "redis.service" "postgresql.service" "network.target" ];
        requires = [ "redis.service" "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];

        description = "lists.sr.ht website service";

        script = ''
          gunicorn listssrht.app:app \
            -b ${cfg.address}:${toString lcfg.port}
        '';
      };
    };
  };
}
