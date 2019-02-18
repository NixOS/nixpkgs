{ stdenv, fetchFromGitHub, autoreconfHook
, curl, db, gdal, libgeotiff
, libXpm, libXt, motif, pcre
, perl, proj, rastermagick, shapelib
}:

stdenv.mkDerivation rec {
  pname = "xastir";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "Release-${version}";
    sha256 = "16zsgy3589snawr8f1fa22ymvpnjy6njvxmsck7q8p2xmmz2ry7r";
  };

  buildInputs = [
    autoreconfHook
    curl db gdal libgeotiff
    libXpm libXt motif pcre
    perl proj rastermagick shapelib
  ];

  configureFlags = [ "--with-motif-includes=${motif}/include" ];

  postPatch = "patchShebangs .";

  meta = with stdenv.lib; {
    description = "Graphical APRS client";
    homepage = https://xastir.org;
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
    platforms   = platforms.linux;
  };
}
