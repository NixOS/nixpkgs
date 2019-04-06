{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  hcfg = cfg.hg;

  inherit (import ./helpers.nix { inherit lib; }) repoOpts;
in {
  options = {
    services.sourcehut.hg = {
      # TODO: Undocumented configuration option that is needed
      changeGroupScript = mkOption {
        type = types.path;
        default = "${hcfg.package}/bin/hgsrht-hook-changegroup";
        description = ''
          ???
        '';
      };

      postUpdateScript = mkOption {
        type = types.path;
        default = "${hcfg.package}/bin/hgsrht-update-hook";
        description = ''
          A post-update script which is installed in every mercurial repo.
        '';
      };

      repos = mkOption {
        type = types.submodule repoOpts;
        default = { path = "/var/lib/hg"; user = "hg"; };
        description = ''
          Configuration for mercurial repositories on disk.
        '';
      };

      dispatch = mkOption {
        type = types.listOf types.str;
        default = singleton "${hcfg.package}/bin/hgsrht-keys=${hcfg.repos.user}:${hcfg.repos.user}";
        description = ''
          The authorized keys hook uses this to dispatch to various handlers
          The format is a program to exec into as the key, and the user to match as the
          value. When someone tries to log in as this user, this program is executed
          and is expected to omit an AuthorizedKeys file.
        '';
      };
    };
  };

  config = mkIf hcfg.enable {
    users = {
      users = [
        { name = hcfg.user;
          group = hcfg.user;
          home = "${hcfg.statePath}/home";
          description = "hg.sr.ht user"; }
        { name = hcfg.repos.user;
          group = hcfg.repos.user;
          home = "${hcfg.statePath}/home";
          description = "hg.sr.ht hg user"; } ];

      groups = [
        { name = hcfg.user; }
        { name = hcfg.repos.user; } ];
    };

    services.cron.systemCronJobs = singleton "*/20 * * * * ${cfg.python}/bin/hgsrht-periodic";

    systemd.services."hg.sr.ht" = {
      # TODO: Uses postgresql...
      after = [ "postgresql.service" "redis.service" "network.target" ];
      requires = [ "postgresql.service" "redis.service" ];
      wantedBy = [ "multi-user.target" ];

      description = "hg.sr.ht website service";

      script = ''
        gunicorn hgsrht.app:app \
          -b ${cfg.address}:${toString hcfg.port}
      '';
    };
  };
}
