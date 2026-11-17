{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.ibus;

  testConfig = {
    # These input-method tests do not need GPU rendering. Use Cairo to avoid
    # probing unavailable Vulkan devices, whose warnings are fatal under GTest.
    environment.variables.GSK_RENDERER = "cairo";

    i18n.supportedLocales = [ "all" ];
    i18n.inputMethod = {
      enable = true;
      type = "ibus";
    };
    systemd.user.services.ibus-daemon = {
      path = [ pkgs.ibus ];
      script = "ibus-daemon --xim --verbose --panel=disable";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
  };

  preTestScript = ''
    machine.wait_for_unit("ibus-daemon.service", user="root", timeout=30)
  '';

  withX11 = true;
}
