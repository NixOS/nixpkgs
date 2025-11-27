{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.slimserver;

in
{
  options = {

    services.slimserver = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable slimserver.
        '';
      };

      package = lib.mkPackageOption pkgs "slimserver" { };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/slimserver";
        description = ''
          The directory where slimserver stores its state, tag cache,
          playlists etc.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - slimserver slimserver - -"
    ];

    systemd.services.slimserver = {
      after = [ "network.target" ];
      description = "Slim Server for Logitech Squeezebox Players";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "slimserver";
        # Issue 40589: Disable broken image/video support (audio still works!)
        ExecStart = "${lib.getExe cfg.package} --logdir ${cfg.dataDir}/logs --prefsdir ${cfg.dataDir}/prefs --cachedir ${cfg.dataDir}/cache --noimage --novideo";
        # Allow only IPv4 since slimserver breaks with IPv6
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_UNIX"
        ];
      };
    };

    users = {
      users.slimserver = {
        description = "Slimserver daemon user";
        home = cfg.dataDir;
        group = "slimserver";
        isSystemUser = true;
      };
      groups.slimserver = { };
    };
  };

}
