{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  macfg = cfg.man;

  inherit (import ./helpers.nix { inherit lib; }) repoOpts;
in {
  options = {
    services.sourcehut.man = {
      repos = mkOption {
        type = types.submodule repoOpts;
        default = { path = "/var/lib/man"; user = "man"; };
        description = ''
          Configuration for git repositories on disk.
        '';
      };
    };
  };

  config = mkIf macfg.enable {
    users = {
      users = [
        { name = macfg.user;
          group = macfg.user;
          home = "${macfg.statePath}/home";
          description = "man.sr.ht user"; }
        { name = macfg.repos.user;
          group = macfg.repos.user;
          home = "${macfg.statePath}/home";
          description = "man.sr.ht man user"; } ];

      groups = [
        { name = macfg.user; }
        { name = macfg.repos.user; } ];
    };

    systemd.services = {
      "man.sr.ht" = {
        after = [ "postgresql.service" "network.target" ];
        requires = [ "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];

        description = "man.sr.ht website service";

        script = ''
          gunicorn mansrht.app:app \
            -b ${cfg.address}:${toString macfg.port}
        '';
      };
    };
  };
}
