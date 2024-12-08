{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.xppen;
in

{
  options.programs.xppen = {
    enable = lib.mkEnableOption "XPPen PenTablet application";
    package = lib.mkPackageOption pkgs "xppen_4" {
      example = "pkgs.xppen_3";
      extraDescription = ''
        Use xppen_4 for newer and xppen_3 for older tablets.
        To check which version of the driver you need, go to
        https://www.xp-pen.com/download/ then select your tablet
        and look for the major version in the available files for Linux.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    environment.systemPackages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.services.xppen-create-config-dir = {
      restartTriggers = [ cfg.package ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        TimeoutSec = 60;
        ExecStart = pkgs.writeScript "xppen-create-config-dir" ''
          #!${pkgs.bash}/bin/bash
          install -m 777 -d "/var/lib/pentablet/conf/xppen"
          readarray -d "" files < <(find ${cfg.package}/usr/lib/pentablet/conf -type f -print0)
          for file in "''${files[@]}"; do
            file_new="/var''${file#${cfg.package + "/usr"}}"
            if [ ! -f $file_new ]; then
              install -m 666 "''$file" "''$file_new"
            fi
          done
        '';
      };
    };
  };
}
