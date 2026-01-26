{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.hyphanet;
  varDir = "/var/lib/freenet";
in
{
  options = {
    services.hyphanet = {
      enable = lib.mkEnableOption "Hyphanet daemon";

      nice = lib.mkOption {
        type = lib.types.ints.between (-20) 19;
        default = 10;
        description = "Set the nice level for the Hyphanet daemon";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hyphanet = {
      description = "Hyphanet daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.getExe pkgs.hyphanet;
        User = "freenet";
        UMask = "0007";
        WorkingDirectory = varDir;
        Nice = cfg.nice;
      };
    };

    users.users.freenet = {
      group = "freenet";
      description = "Hyphanet daemon user";
      home = varDir;
      createHome = true;
      uid = config.ids.uids.freenet;
    };

    users.groups.freenet.gid = config.ids.gids.freenet;
  };

  meta.maintainers = with lib.maintainers; [ nagy ];
}
