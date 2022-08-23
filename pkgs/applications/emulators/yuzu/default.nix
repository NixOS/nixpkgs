{ branch ? "mainline"
, libsForQt5
, fetchFromGitHub
, fetchurl
}:

let
  # Mirror of https://api.yuzu-emu.org/gamedb, last updated 2022-08-13
  # Please make sure to update this when updating yuzu!
  compat-list = fetchurl {
    name = "yuzu-compat-list";
    url = "https://raw.githubusercontent.com/flathub/org.yuzu_emu.yuzu/d83401d2ee3fd5e1922e31baed1f3bdb1c0f036c/compatibility_list.json";
    sha256 = "sha256-anOmO7NscHDsQxT03+YbJEyBkXjhcSVGgKpDwt//GHw=";
  };
in {
  mainline = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-mainline";
    version = "1137";

    src = fetchFromGitHub {
      owner = "yuzu-emu";
      repo = "yuzu-mainline";
      rev = "mainline-0-${version}";
      sha256 = "sha256-DLU5hmjTnlpRQ6sbcU7as/KeI9dDJAFUzVLciql5niE=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  early-access = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-ea";
    version = "2907";

    src = fetchFromGitHub {
      owner = "pineappleEA";
      repo = "pineapple-src";
      rev = "EA-${version}";
      sha256 = "sha256-spPW2/qeVyd1P1/Z2lcuA69igS3xV4KtcJ59yf9X4JI=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
