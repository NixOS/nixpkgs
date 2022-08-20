{ branch ? "mainline"
, libsForQt5
, fetchFromGitHub
, fetchurl
}:

let
  # Fetched from https://api.yuzu-emu.org/gamedb, last updated 2022-07-14
  # Please make sure to update this when updating yuzu!
  compat-list = fetchurl {
    name = "yuzu-compat-list";
    url = "https://web.archive.org/web/20220714160745/https://api.yuzu-emu.org/gamedb";
    sha256 = "sha256-anOmO7NscHDsQxT03+YbJEyBkXjhcSVGgKpDwt//GHw=";
  };
in {
  mainline = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-mainline";
    version = "1131";

    src = fetchFromGitHub {
      owner = "yuzu-emu";
      repo = "yuzu-mainline";
      rev = "mainline-0-${version}";
      sha256 = "0lh8s59hrysfjz69yr0f44s3l4aaznmclq0xfnyblsk0cw9ripf6";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  early-access = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-ea";
    version = "2901";

    src = fetchFromGitHub {
      owner = "pineappleEA";
      repo = "pineapple-src";
      rev = "EA-${version}";
      sha256 = "0jymm9sdsnayjaffmcbpjck4k2yslx8zid2vsm4jfdaajr244q2z";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
