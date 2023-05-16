{ branch
<<<<<<< HEAD
, qt6Packages
=======
, libsForQt5
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, fetchurl
}:

let
<<<<<<< HEAD
  # Fetched from https://api.citra-emu.org/gamedb
  # Please make sure to update this when updating citra!
  compat-list = fetchurl {
    name = "citra-compat-list";
    url = "https://web.archive.org/web/20230807103651/https://api.citra-emu.org/gamedb/";
    hash = "sha256-J+zqtWde5NgK2QROvGewtXGRAWUTNSKHNMG6iu9m1fU=";
  };
in {
  nightly = qt6Packages.callPackage ./generic.nix rec {
    pname = "citra-nightly";
    version = "1963";
=======
  # Fetched from https://api.citra-emu.org/gamedb, last updated 2022-05-02
  # Please make sure to update this when updating citra!
  compat-list = fetchurl {
    name = "citra-compat-list";
    url = "https://web.archive.org/web/20220502114622/https://api.citra-emu.org/gamedb/";
    sha256 = "sha256-blIlaYaUQjw7Azgg+Dd7ZPEQf+ddZMO++Yxinwe+VG0=";
  };
in {
  nightly = libsForQt5.callPackage ./generic.nix rec {
    pname = "citra-nightly";
    version = "1873";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-nightly";
      rev = "nightly-${version}";
<<<<<<< HEAD
      sha256 = "0ggi1l8327s43xaxs616g0s9vmal6q7vsv69bn07gp71gchhcmyi";
=======
      sha256 = "1csn9n1s2mvxwk2mahwm8mc4zgn40im374hcsqgz8gaxjkmnx288";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

<<<<<<< HEAD
  canary = qt6Packages.callPackage ./generic.nix rec {
    pname = "citra-canary";
    version = "2573";
=======
  canary = libsForQt5.callPackage ./generic.nix rec {
    pname = "citra-canary";
    version = "2440";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-canary";
      rev = "canary-${version}";
<<<<<<< HEAD
      sha256 = "sha256-tQJ3WcqGcnW9dOiwDrBgL0n3UNp1DGQ/FjCR28Xjdpc=";
=======
      sha256 = "06f2qnvywyaf8jc43jrzjhfshj3k21ggk8wdrvd9wjsmrryvqgbz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
