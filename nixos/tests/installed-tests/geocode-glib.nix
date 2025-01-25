{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  testConfig = {
    i18n.supportedLocales = [
      "en_US.UTF-8/UTF-8"
      # The tests require these locales.
      "en_GB.UTF-8/UTF-8"
      "cs_CZ.UTF-8/UTF-8"
      "sv_SE.UTF-8/UTF-8"
    ];
  };

  tested = pkgs.geocode-glib;
}
