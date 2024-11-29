{
  lib,
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "tower-pixel-dungeon";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "FixAkaTheFix";
    repo = "Tower-Pixel-Dungeon";
    rev = "TPDv${lib.replaceStrings [ "." ] [ "" ] version}";
    hash = "sha256-ZyqrrSuA++L7FOUj6Ytk2lld0YMY4B7WOCzpohOKhdU=";
  };

  sourceRoot = src.name + "/pixel-towers-master";

  desktopName = "Tower Pixel Dungeon";

  # Sprite sources (Paint.NET files) interfere with the build process.
  postPatch = ''
    rm core/src/main/assets/{levelsplashes,sprites}/*.pdn
  '';

  meta = {
    homepage = "https://github.com/FixAkaTheFix/Tower-Pixel-Dungeon";
    downloadPage = "https://github.com/FixAkaTheFix/Tower-Pixel-Dungeon/releases";
    description = "Turn-based tower defense game based on Shattered Pixel Dungeon";
  };
}
