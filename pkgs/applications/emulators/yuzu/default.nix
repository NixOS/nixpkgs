{ branch ? "mainline"
, libsForQt5
, fetchFromGitHub
}:

let
  # Fetched from https://api.yuzu-emu.org/gamedb, last updated 2022-03-23.
  # Please make sure to update this when updating yuzu!
  compat-list = ./compatibility-list.json;
in {
  mainline = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-mainline";
    version = "992";

    src = fetchFromGitHub {
      owner = "yuzu-emu";
      repo = "yuzu-mainline";
      rev = "mainline-0-${version}";
      sha256 = "1x3fwwdw86jvygbzy9k99j6avfsd867ywm2x25izw10jznpsaixs";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  early-access = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-ea";
    version = "2690";

    src = fetchFromGitHub {
      owner = "pineappleEA";
      repo = "pineapple-src";
      rev = "EA-${version}";
      sha256 = "0zm06clbdh9cccq9932q9v976q7sjknynkdvvp04h1wcskmrxi3c";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
