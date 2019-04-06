{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  gcfg = cfg.git;
  macfg = cfg.man;

  rcfg = config.services.redis;
  inherit (import ./helpers.nix { inherit lib; }) repoOpts redisOpts;
in {
  options = {
    services.sourcehut.git = {
      redis = mkOption {
        type = types.submodule redisOpts;
        default = { hostname = rcfg.bind; port = rcfg.port; dbnumber = 1; };
        description = ''
          The redis connection used for the Celery worker.
        '';
      };

      # TODO: Undocumented...
      # NOTE: It looks like it automatically fetches the correct path already? But testing...
      shell = mkOption {
        type = types.path;
        default = "${gcfg.package}/bin/gitsrht-shell";
        description = ''
          ???
        '';
      };

      postUpdateScript = mkOption {
        type = types.path;
        default = "${gcfg.package}/bin/gitsrht-update-hook";
        description = ''
          A post-update script which is installed in every git repo.
        '';
      };

      repos = mkOption {
        type = types.submodule repoOpts;
        default = { path = "/var/lib/git"; user = "git"; };
        description = ''
          Configuration for git repositories on disk.
        '';
      };

      dispatch = mkOption {
        type = types.listOf types.str;
        default = singleton "${gcfg.package}/bin/gitsrht-keys=${gcfg.repos.user}:${gcfg.repos.user}";
        example = [
          "${gcfg.package}/bin/gitsrht-keys=${gcfg.repos.user}:${gcfg.repos.user}"
          "${macfg.package}/bin/mansrht-keys=${macfg.repos.user}:${macfg.repos.user}"
        ];
        description = ''
          The authorized keys hook uses this to dispatch to various handlers
          The format is a program to exec into as the key, and the user to match as the
          value. When someone tries to log in as this user, this program is executed
          and is expected to omit an AuthorizedKeys file.
        '';
      };
    };
  };

  config = mkIf gcfg.enable {
    # sshd refuses to run with `Unsafe AuthorizedKeysCommand ... bad ownership or modes for directory /nix/store`
    environment.etc."ssh/authorized_keys_command_gitsrht_dispatch" = {
      mode = "0755";
      text = ''
        #! ${pkgs.stdenv.shell}
        exec ${gcfg.package}/bin/gitsrht-dispatch $@
      '';
    };

    users = {
      users = [
        { name = gcfg.user;
          group = gcfg.user;
          extraGroups = singleton gcfg.repos.user;
          home = "${gcfg.statePath}/home";
          description = "git.sr.ht user"; }
        { name = gcfg.repos.user;
          group = gcfg.repos.user;
          home = "${gcfg.statePath}/home";
          description = "git.sr.ht git user"; } ];

      groups = [
        { name = gcfg.user; }
        { name = gcfg.repos.user; } ];
    };

    services = {
      cron.systemCronJobs = singleton "*/20 * * * * ${cfg.python}/bin/gitsrht-periodic";
      fcgiwrap.enable = true;

      openssh.extraConfig = ''
        AuthorizedKeysCommand /etc/ssh/authorized_keys_command_gitsrht_dispatch "%u" "%h" "%t" "%k"
        AuthorizedKeysCommandUser root
      '';
    };

    systemd.services."git.sr.ht" = {
      after = [ "redis.service" "postgresql.service" "network.target" ];
      requires = [ "redis.service" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      description = "git.sr.ht website service";

      script = ''
        gunicorn gitsrht.app:app \
          -b ${cfg.address}:${toString gcfg.port}
      '';
    };
  };
}
