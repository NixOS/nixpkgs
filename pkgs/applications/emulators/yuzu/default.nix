{ branch ? "mainline"
, libsForQt5
, fetchFromGitHub
, fetchurl
}:

let
  # Mirror of https://api.yuzu-emu.org/gamedb, last updated 2023-04-01
  # Please make sure to update this when updating yuzu!
  compat-list = fetchurl {
    name = "yuzu-compat-list";
    url = "https://raw.githubusercontent.com/flathub/org.yuzu_emu.yuzu/43eab3333a82fe54916afa7f418161bdf751a5ad/compatibility_list.json";
    sha256 = "sha256-AVL7wEqEnjfTVxfF8Nd2Cm7cD9WvFGjk9kAlx4f6usE=";
  };
in {
  mainline = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-mainline";
    version = "1390";

    src = fetchFromGitHub {
      owner = "yuzu-emu";
      repo = "yuzu-mainline";
      rev = "mainline-0-${version}";
      sha256 = "sha256-XsB5jGRGRNkmuTqTqwWy8k+iEISP39sXBuHj/Oe5YS8=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };

  early-access = libsForQt5.callPackage ./generic.nix rec {
    pname = "yuzu-ea";
    version = "3493";

    src = fetchFromGitHub {
      owner = "pineappleEA";
      repo = "pineapple-src";
      rev = "EA-${version}";
      sha256 = "sha256-gELa/Q/A5H8UrBFEBr3btxinD9VdST0+FDFY0WlVl1U=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}.${branch}
