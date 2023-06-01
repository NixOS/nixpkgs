{ branch
, qt6Packages
, fetchFromGitHub
, fetchurl
}:

let
  # Fetched from https://api.citra-emu.org/gamedb
  # Please make sure to update this when updating citra!
  compat-list = fetchurl {
    name = "citra-compat-list";
    url = "https://web.archive.org/web/20230512234055/https://api.citra-emu.org/gamedb/";
    hash = "sha256-J+zqtWde5NgK2QROvGewtXGRAWUTNSKHNMG6iu9m1fU=";
  };
in {
  nightly = qt6Packages.callPackage ./generic.nix rec {
    pname = "citra-nightly";
    version = "1907";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-nightly";
      rev = "nightly-${version}";
      sha256 = "l4pqok42/ybnRX90Qwhcgm2JR4/9C5bbCTk3j4QuWtw=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  canary = qt6Packages.callPackage ./generic.nix rec {
    pname = "citra-canary";
    version = "2484";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-canary";
      rev = "canary-${version}";
      sha256 = "IgCpqt3rKV9IqNstF4QwnJlE3hPH+BkIhaOvEmshh0U=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
