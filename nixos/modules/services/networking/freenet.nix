{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.freenet;
  varDir = "/var/lib/freenet";
in
{
  options = {
    services.freenet = {
      enable = lib.mkEnableOption "Freenet daemon";

      nice = lib.mkOption {
        type = lib.types.ints.between (-20) 19;
        default = 10;
        description = "Set the nice level for the Freenet daemon";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.freenet = {
      description = "Freenet daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.getExe pkgs.freenet;
        User = "freenet";
        UMask = "0007";
        WorkingDirectory = varDir;
        Nice = cfg.nice;
      };
    };

    users.users.freenet = {
      group = "freenet";
      description = "Freenet daemon user";
      home = varDir;
      createHome = true;
      uid = config.ids.uids.freenet;
    };

    users.groups.freenet.gid = config.ids.gids.freenet;
  };

  meta.maintainers = with lib.maintainers; [ nagy ];
}
