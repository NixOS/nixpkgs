{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.xdg-desktop-portal;

  # Red herring
  # Failed to load RealtimeKit property: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name org.freedesktop.RealtimeKit1 was not provided by any .service files
  # Maybe a red herring, enabling PipeWire doesn't fix the location test.
  # Failed connect to PipeWire: Couldn't connect to PipeWire
  testConfig = {
    environment.variables = {
      TEST_IN_CI = 1;
      XDG_DATA_DIRS = "${pkgs.xdg-desktop-portal.installedTests}/share/installed-tests/xdg-desktop-portal/share";
    };
    # Broken, see comment in the package file.
    #services.geoclue2 = {
    #  enable = true;
    #  enableDemoAgent = true;
    #};
    #location.provider = "geoclue2";
  };
}
