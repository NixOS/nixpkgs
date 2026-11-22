{
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "experienced-pixel-dungeon";
  version = "2.19";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Experienced-Pixel-Dungeon-Redone";
    tag = "ExpPD-${version}";
    hash = "sha256-O3FEHIOGe1sO8L4eDUF3NGXhB9LviLT8M6mGqpe42B4=";
  };

  desktopName = "Experienced Pixel Dungeon";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Experienced-Pixel-Dungeon-Redone";
    downloadPage = "https://github.com/TrashboxBobylev/Experienced-Pixel-Dungeon-Redone/releases";
    description = "Fork of the Shattered Pixel Dungeon roguelike without limits on experience and items";
  };
}
