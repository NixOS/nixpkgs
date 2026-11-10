{
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "rat-king-adventure";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Rat-King-Adventure";
    rev = version;
    hash = "sha256-tWH4l2qVm10wJRZ9sH8B52e1VCDaRZXK4oWgUIYPqXw=";
  };

  patches = [ ];

  desktopName = "Rat King Adventure";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Rat-King-Adventure";
    downloadPage = "https://github.com/TrashboxBobylev/Rat-King-Adventure/releases";
    description = "Expansive fork of RKPD2, itself a fork of the Shattered Pixel Dungeon roguelike";
  };
}
