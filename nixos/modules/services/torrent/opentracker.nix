{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.opentracker;
in
{
  options.services.opentracker = {
    enable = lib.mkEnableOption "opentracker";

    package = lib.mkPackageOption pkgs "opentracker" { };

    extraOptions = lib.mkOption {
      type = lib.types.separatedString " ";
      description = ''
        Configuration Arguments for opentracker
        See <https://erdgeist.org/arts/software/opentracker/> for all params
      '';
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.opentracker = {
      description = "opentracker server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartIfChanged = true;
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/opentracker ${cfg.extraOptions}";
        PrivateTmp = true;
        WorkingDirectory = "/var/empty";
        # By default opentracker drops all privileges and runs in chroot after starting up as root.
      };
    };
  };
}
