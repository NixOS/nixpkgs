{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, curl, db, libgeotiff
, xorg, motif, pcre
<<<<<<< HEAD
, perl, proj, graphicsmagick, shapelib
=======
, perl, proj, rastermagick, shapelib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libax25
}:

stdenv.mkDerivation rec {
  pname = "xastir";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "Release-${version}";
    hash = "sha256-hRe0KO1lWOv3hNNDMS70t+X1rxuhNlNKykmo4LEU+U0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl db libgeotiff
    xorg.libXpm xorg.libXt motif pcre
<<<<<<< HEAD
    perl proj graphicsmagick shapelib
=======
    perl proj rastermagick shapelib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libax25
  ];

  configureFlags = [ "--with-motif-includes=${motif}/include" ];

  postPatch = "patchShebangs .";

  meta = with lib; {
    description = "Graphical APRS client";
    homepage = "https://xastir.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
    platforms   = platforms.linux;
  };
}
