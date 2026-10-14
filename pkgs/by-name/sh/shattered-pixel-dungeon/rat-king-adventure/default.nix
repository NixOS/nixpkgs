{
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "rat-king-adventure";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Rat-King-Adventure";
    rev = version;
    hash = "sha256-uT61XUzR5Eubmjglr4NRY/LFqmyvv6aIZxmnCt+VcbA=";
  };

  patches = [ ];

  desktopName = "Rat King Adventure";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Rat-King-Adventure";
    downloadPage = "https://github.com/TrashboxBobylev/Rat-King-Adventure/releases";
    description = "Expansive fork of RKPD2, itself a fork of the Shattered Pixel Dungeon roguelike";
  };
}
