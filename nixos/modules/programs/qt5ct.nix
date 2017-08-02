{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = [ maintainers.romildo ];

  ###### interface
  options = {
    programs.qt5ct = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable the Qt5 Configuration Tool (qt5ct), a
          program that allows users to configure Qt5 settings (theme,
          font, icons, etc.) under desktop environments or window
          manager without Qt integration.

          Official home page: <link xlink:href="https://sourceforge.net/projects/qt5ct/">https://sourceforge.net/projects/qt5ct/</link>
        '';
      };
    };
  };

  ###### implementation
  config = mkIf config.programs.qt5ct.enable {
    environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";
    environment.systemPackages = with pkgs; [ qt5ct libsForQt5.qtstyleplugins ];
  };
}
