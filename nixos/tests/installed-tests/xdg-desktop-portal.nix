{
  lib,
  pkgs,
  makeInstalledTest,
  ...
}:

makeInstalledTest {
  tested = pkgs.xdg-desktop-portal;

  testConfig = {
    environment.variables = {
      GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" [
        pkgs.glib.out
        pkgs.umockdev.out
      ];
      # need to set this ourselves, because the tests will set LD_PRELOAD=libumockdev-preload.so,
      # which can't be found because it's not in default rpath
      LD_PRELOAD = "${pkgs.umockdev.out}/lib/libumockdev-preload.so";
      XDP_TEST_IN_CI = 1;
    };
    environment.systemPackages = with pkgs; [
      umockdev
      wireless-regdb
    ];
    services.geoclue2 = {
      enable = true;
      enableDemoAgent = true;
    };
    location.provider = "geoclue2";
  };
}
