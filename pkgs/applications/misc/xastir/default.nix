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
    sha256 = "0yrvwy6hlc73gzwrsrczflyymyz0k33hj991ajrd1vijq14m3n91";
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
