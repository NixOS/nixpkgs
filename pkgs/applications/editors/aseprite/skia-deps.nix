{ fetchgit }:
{
  angle2 = fetchgit {
    url = "https://chromium.googlesource.com/angle/angle.git";
    rev = "956ab4d9fab36be9929e63829475d4d69b2c681c";
    sha256 = "0fcw04wwkn3ixr9l9k0d32n78r9g72p31ii9i5spsq2d0wlylr38";
  };
  dng_sdk = fetchgit {
    url = "https://android.googlesource.com/platform/external/dng_sdk.git";
    rev = "96443b262250c390b0caefbf3eed8463ba35ecae";
    sha256 = "1rsr7njhj7c5p87hfznj069fdc3qqhvvnq9sa2rb8c4q849rlzx6";
  };
  piex = fetchgit {
    url = "https://android.googlesource.com/platform/external/piex.git";
    rev = "bb217acdca1cc0c16b704669dd6f91a1b509c406";
    sha256 = "05ipmag6k55jmidbyvg5mkqm69zfw03gfkqhi9jnjlmlbg31y412";
  };
  sfntly = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/googlei18n/sfntly.git";
    rev = "b18b09b6114b9b7fe6fc2f96d8b15e8a72f66916";
    sha256 = "0zf1h0dibmm38ldypccg4faacvskmd42vsk6zbxlfcfwjlqm6pp4";
  };
}
