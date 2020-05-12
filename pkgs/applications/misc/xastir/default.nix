{ stdenv, fetchFromGitHub, autoreconfHook
, curl, db, libgeotiff
, libXpm, libXt, motif, pcre
, perl, proj, rastermagick, shapelib
}:

stdenv.mkDerivation rec {
  pname = "xastir";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "Release-${version}";
    sha256 = "sha256-IdlRScAy7tCyVCElCceY4PvqPXWfZZ35f+MwCo3nO3s=";
  };

  buildInputs = [
    autoreconfHook
    curl db libgeotiff
    libXpm libXt motif pcre
    perl proj rastermagick shapelib
  ];

  configureFlags = [ "--with-motif-includes=${motif}/include" ];

  postPatch = "patchShebangs .";

  meta = with stdenv.lib; {
    description = "Graphical APRS client";
    homepage = "https://xastir.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
    platforms   = platforms.linux;
  };
}
