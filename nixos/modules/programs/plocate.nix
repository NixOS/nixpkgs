{ config, lib, pkgs, ... }:

let
  cfg = config.programs.plocate;

  inherit (lib) mkEnableOption mkIf mkOption types;

in
{
  meta.maintainers = with lib.maintainers; [ peterhoeg ];

  options.toupstream.programs.plocate = {
    enable = mkEnableOption "plocate";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ package ];

    security.wrappers = {
      plocate = {
        source = "${lib.getBin package}/bin/plocate";
        owner = "root";
        group = "plocate";
      };
    };

    systemd = {
      packages = [ package ];

      timers.plocate-updatedb.wantedBy = [ "timers.target" ];

      tmpfiles.rules = [
        "d /var/lib/plocate 0775 root plocate -"
      ];
    };

    users.groups.plocate = { };
  };
}
