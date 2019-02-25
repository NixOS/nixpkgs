# Bamf

{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {
    services.bamf = {
      enable = mkEnableOption "bamf";
    };
  };

  ###### implementation

  config = mkIf config.services.bamf.enable {
    services.dbus.packages = [ pkgs.bamf ];

    systemd.packages = [ pkgs.bamf ];

    environment.extraSetup = ''
      if [ -w $out/share/applications ]; then
          echo "Rebuilding bamf-2.index..."
          ${pkgs.bamf.update-index} $out/share/applications > $out/share/applications/bamf-2.index
      fi
    '';
  };
}
