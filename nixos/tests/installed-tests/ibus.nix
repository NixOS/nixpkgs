{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.ibus;

  testConfig = {
    i18n.supportedLocales = [ "all" ];
    i18n.inputMethod.enabled = "ibus";
    systemd.user.services.ibus-daemon = {
      serviceConfig.ExecStart = "${pkgs.ibus}/bin/ibus-daemon --xim --verbose";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
  };

  withX11 = true;
}
