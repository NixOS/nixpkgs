{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  testConfig = {
    i18n.supportedLocales = [
      "en_US.UTF-8/UTF-8"
      # The tests require this locale available.
      "en_GB.UTF-8/UTF-8"
    ];
  };

  tested = pkgs.geocode-glib;
}
