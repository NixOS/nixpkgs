{
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "re-arranged-pixel-dungeon";
  version = "3.39.0";

  src = fetchFromGitHub {
    owner = "Hoto-Mocha";
    repo = "Re-ARranged-Pixel-Dungeon";
    # The GitHub release is named "$base_based_$version, the $base version may be changed in the future"
    rev = "v3.2.0_based_v${version}";
    hash = "sha256-ve/FqUXR24CdwLFuV4r2giylTB3/TpjTX0IL4c4wGfY=";
  };

  desktopName = "ReARranged Pixel Dungeon";

  meta = {
    homepage = "https://github.com/Hoto-Mocha/Re-ARranged-Pixel-Dungeon";
    downloadPage = "https://github.com/Hoto-Mocha/Re-ARranged-Pixel-Dungeon/releases";
    description = "A reworked version of ARranged Pixel Dungeonwhich is basically an extended version of Shattered Pixel Dungeon";
  };
}
