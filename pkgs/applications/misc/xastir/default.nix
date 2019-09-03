{ stdenv, fetchFromGitHub, autoreconfHook
, curl, db, libgeotiff
, libXpm, libXt, motif, pcre
, perl, proj, rastermagick, shapelib
}:

stdenv.mkDerivation rec {
  pname = "xastir";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "Release-${version}";
    sha256 = "14f908jy5jzvgm1h1sr47hjqjq3q2nq91byhimk84kj044fn21w9";
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
    homepage = https://xastir.org;
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
    platforms   = platforms.linux;
  };
}
