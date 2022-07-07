{ branch ? "mainline"
, libsForQt5
, fetchFromGitHub
, fetchurl
}:

let
  # Fetched from https://api.yuzu-emu.org/gamedb, last updated 2022-05-12
  # Please make sure to update this when updating yuzu!
  compat-list = fetchurl {
    name = "yuzu-compat-list";
    url = "https://web.archive.org/web/20220512184801/https://api.yuzu-emu.org/gamedb";
    sha256 = "sha256-anOmO7NscHDsQxT03+YbJEyBkXjhcSVGgKpDwt//GHw=";
  };
in {
  mainline = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-mainline";
    version = "1014";

    src = fetchFromGitHub {
      owner = "yuzu-emu";
      repo = "yuzu-mainline";
      rev = "mainline-0-${version}";
      sha256 = "1x3d1fjssadv4kybc6mk153jlvncsfgm5aipkq5n5i8sr7mmr3nw";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  early-access = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-ea";
    version = "2725";

    src = fetchFromGitHub {
      owner = "pineappleEA";
      repo = "pineapple-src";
      rev = "EA-${version}";
      sha256 = "1nmcl9y9chr7cdvnra5zs1v42d3i801hmsjdlz3fmp15n04bcjmp";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
