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
    version = "1245";

    src = fetchFromGitHub {
      owner = "yuzu-emu";
      repo = "yuzu-mainline";
      rev = "mainline-0-${version}";
      sha256 = "sha256-lWXlY1KQC067MvCRUFhmr0c7KDrHDuwJOhIWMKw1f+A=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  early-access = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-ea";
    version = "2945";

    src = fetchFromGitHub {
      owner = "pineappleEA";
      repo = "pineapple-src";
      rev = "EA-${version}";
      sha256 = "sha256-/051EtQxhB5oKH/JxZZ2AjnxOBcRxCBIwd4Qr8lq7Ok=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
