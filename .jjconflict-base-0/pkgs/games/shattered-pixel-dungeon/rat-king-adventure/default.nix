{
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "rat-king-adventure";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Rat-King-Adventure";
    rev = version;
    hash = "sha256-fuCDzY6DWspLhajB/Z8mS2oEegFPpgRCwQWy8n3V7P0=";
  };

  desktopName = "Rat King Adventure";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Rat-King-Adventure";
    downloadPage = "https://github.com/TrashboxBobylev/Rat-King-Adventure/releases";
    description = "An expansive fork of RKPD2, itself a fork of the Shattered Pixel Dungeon roguelike";
  };
}
