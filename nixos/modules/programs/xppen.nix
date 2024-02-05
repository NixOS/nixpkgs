{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.programs.xppen;
in

{
  options.programs.xppen = {
    enable = mkEnableOption (lib.mdDoc "XPPen PenTablet application");
    package = mkPackageOption pkgs "xppen" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    services.udev.packages = [ cfg.package ];

    system.activationScripts.xppen.text = with pkgs; ''
      install -m 755 -d "/var/lib/pentablet/conf/xppen"

      readarray -d "" files < <(find ${xppen}/usr/lib/pentablet/conf -type f -print0)

      for file in "''${files[@]}"; do
        file_new="/var''${file#${xppen + "/usr"}}"
        if [ ! -f $file_new ]; then
          install -m 666 "''$file" "''$file_new"
        fi
      done
    '';
  };
}
