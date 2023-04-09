{ branch
, libsForQt5
, fetchFromGitHub
, fetchurl
}:

let
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

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-nightly";
      rev = "nightly-${version}";
      sha256 = "1csn9n1s2mvxwk2mahwm8mc4zgn40im374hcsqgz8gaxjkmnx288";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  canary = libsForQt5.callPackage ./generic.nix rec {
    pname = "citra-canary";
    version = "2440";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-canary";
      rev = "canary-${version}";
      sha256 = "06f2qnvywyaf8jc43jrzjhfshj3k21ggk8wdrvd9wjsmrryvqgbz";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
