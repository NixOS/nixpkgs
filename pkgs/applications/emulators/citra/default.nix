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
    version = "1765";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-nightly";
      rev = "nightly-${version}";
      sha256 = "0d3dfh63cmsy5idbypdz3ibydmb4a35sfv7qmxxlcpc390pp9cvq";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  canary = libsForQt5.callPackage ./generic.nix rec {
    pname = "citra-canary";
    version = "2146";

    src = fetchFromGitHub {
      owner = "citra-emu";
      repo = "citra-canary";
      rev = "canary-${version}";
      sha256 = "1wnym0nklngimf5gaaa2703nz4g5iy572wlgp88h67rrh9b4f04r";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
