{ stdenv, fetchFromGitHub, autoreconfHook
, curl, db, gdal, libgeotiff
, libXpm, libXt, motif, pcre
, perl, proj, rastermagick, shapelib
}:

stdenv.mkDerivation rec {
  name = "xastir-${version}";
  version = "208";

  src = fetchFromGitHub {
    owner = "Xastir";
    repo = "Xastir";
    rev = "707f3aa8c7ca3e3fecd32d5a4af3f742437e5dce";
    sha256 = "1mm22vn3hws7dmg9wpaj4s0zkzb77i3aqa2ay3q6kqjkdhv25brl";
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
