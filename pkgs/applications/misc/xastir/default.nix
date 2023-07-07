{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, curl, db, libgeotiff
, xorg, motif, pcre
, perl, proj, rastermagick, shapelib
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
    perl proj rastermagick shapelib
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
