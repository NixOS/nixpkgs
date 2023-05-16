{ fetchgit }:
{
  angle2 = fetchgit {
    url = "https://chromium.googlesource.com/angle/angle.git";
<<<<<<< HEAD
    rev = "8718783526307a3fbb35d4c1ad4e8101262a0d73";
    sha256 = "0c90q8f4syvwcayw58743sa332dcpkmblwh3ffkjqn5ygym04xji";
  };
  dng_sdk = fetchgit {
    url = "https://android.googlesource.com/platform/external/dng_sdk.git";
    rev = "c8d0c9b1d16bfda56f15165d39e0ffa360a11123";
    sha256 = "1nlq082aij7q197i5646bi4vd2il7fww6sdwhqisv2cs842nyfwm";
=======
    rev = "956ab4d9fab36be9929e63829475d4d69b2c681c";
    sha256 = "0fcw04wwkn3ixr9l9k0d32n78r9g72p31ii9i5spsq2d0wlylr38";
  };
  dng_sdk = fetchgit {
    url = "https://android.googlesource.com/platform/external/dng_sdk.git";
    rev = "96443b262250c390b0caefbf3eed8463ba35ecae";
    sha256 = "1rsr7njhj7c5p87hfznj069fdc3qqhvvnq9sa2rb8c4q849rlzx6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  piex = fetchgit {
    url = "https://android.googlesource.com/platform/external/piex.git";
    rev = "bb217acdca1cc0c16b704669dd6f91a1b509c406";
    sha256 = "05ipmag6k55jmidbyvg5mkqm69zfw03gfkqhi9jnjlmlbg31y412";
  };
  sfntly = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/googlei18n/sfntly.git";
<<<<<<< HEAD
    rev = "b55ff303ea2f9e26702b514cf6a3196a2e3e2974";
    sha256 = "1qi5rfzmwfrji46x95g6dsb03i1v26700kifl2hpgm3pqhr7afpz";
=======
    rev = "b18b09b6114b9b7fe6fc2f96d8b15e8a72f66916";
    sha256 = "0zf1h0dibmm38ldypccg4faacvskmd42vsk6zbxlfcfwjlqm6pp4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
