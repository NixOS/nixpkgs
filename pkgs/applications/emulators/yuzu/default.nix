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
    version = "1092";

    src = fetchFromGitHub {
      owner = "yuzu-emu";
      repo = "yuzu-mainline";
      rev = "mainline-0-${version}";
      sha256 = "1avcq924q0r8pfv1s0a88iyii7yixcxpb3yhlj0xg9zqnwp9r23y";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  early-access = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-ea";
    version = "2841";

    src = fetchFromGitHub {
      owner = "pineappleEA";
      repo = "pineapple-src";
      rev = "EA-${version}";
      sha256 = "16lrq9drv0x7gs1siq37m4zmh6d2g3vhnw9qcqajr9p0vmlpnh6l";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
