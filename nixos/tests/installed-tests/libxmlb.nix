{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.libxmlb;

  testConfig = {
    environment.variables = {
      G_TEST_SRCDIR = "${pkgs.libxmlb.installedTests}/libexec/installed-tests/libxmlb";
    };
  };
}
