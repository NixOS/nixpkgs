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
    url = "https://web.archive.org/web/20231111133415/https://api.citra-emu.org/gamedb";
    hash = "sha256-J+zqtWde5NgK2QROvGewtXGRAWUTNSKHNMG6iu9m1fU=";
  };
in {
  nightly = qt6Packages.callPackage ./generic.nix rec {
    pname = "citra-nightly";
    version = "2070";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-nightly";
      rev = "nightly-${version}";
      sha256 = "1rmc7dk7wzmxgkq7xsmx9wscszhcfr3mkvnykwgamrcb9bm8p5rb";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  canary = qt6Packages.callPackage ./generic.nix rec {
    pname = "citra-canary";
    version = "2740";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-canary";
      rev = "canary-${version}";
      sha256 = "0m11xy0ad9sy7zsnwnb7vad3g0g78v747a1abp612ybg0aczwf9l";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
