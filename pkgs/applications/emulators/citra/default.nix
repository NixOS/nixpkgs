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
    version = "2043";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-nightly";
      rev = "nightly-${version}";
      sha256 = "sha256-26M3uzqp4rUMOhr619UooupZT11B03IJfamUPNkceQk=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  canary = qt6Packages.callPackage ./generic.nix rec {
    pname = "citra-canary";
    version = "2695";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-canary";
      rev = "canary-${version}";
      sha256 = "sha256-090er4aUGze8bk3DIFZoa+/6EcJhr4bim3nWgZHs1mo=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
