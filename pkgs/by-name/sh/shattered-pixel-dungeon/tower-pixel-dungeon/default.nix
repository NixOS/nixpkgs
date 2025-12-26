{
  lib,
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "tower-pixel-dungeon";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "FixAkaTheFix";
    repo = "Tower-Pixel-Dungeon";
    tag = "TPDv${lib.replaceStrings [ "." ] [ "" ] version}";
    hash = "sha256-8q1Wt+FXhw58+fK9WMiAcwNrwJfBa5oRBztFmfQz0Uk=";
  };

  sourceRoot = src.name + "/pixel-towers-master";

  desktopName = "Tower Pixel Dungeon";

  patches = [ ];

  # Sprite sources (Paint.NET files) and other files interfere with the build process.
  postPatch = ''
    rm core/src/main/assets/{levelsplashes,sprites}/*.pdn
  '';

  meta = {
    homepage = "https://github.com/FixAkaTheFix/Tower-Pixel-Dungeon";
    downloadPage = "https://github.com/FixAkaTheFix/Tower-Pixel-Dungeon/releases";
    description = "Turn-based tower defense game based on Shattered Pixel Dungeon";
  };
}
