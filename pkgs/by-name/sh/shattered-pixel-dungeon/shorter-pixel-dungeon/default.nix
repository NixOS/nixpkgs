{
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "shorter-pixel-dungeon";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Shorter-Pixel-Dungeon";
    rev = "Short-${version}";
    hash = "sha256-y4DKSdq0LofKxlAi6RoaF8q+QD5KrTcmCmx9cpBxGgs=";
  };

  desktopName = "Shorter Pixel Dungeon";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Shorter-Pixel-Dungeon";
    downloadPage = "https://github.com/TrashboxBobylev/Shorter-Pixel-Dungeon/releases";
    description = "Shorter fork of the Shattered Pixel Dungeon roguelike";
  };
}
