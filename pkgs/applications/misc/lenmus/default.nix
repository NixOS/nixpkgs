{ stdenv, pkgconfig, fetchFromGitHub
, cmake, boost
, portmidi, sqlite
, freetype, libpng, pngpp, zlib
, wxGTK30, wxsqlite3
}:

stdenv.mkDerivation rec {
  name = "lenmus-${version}";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "lenmus";
    repo = "lenmus";
    rev = "Release_${version}";
    sha256 = "1n639xr1qxx6rhqs0c6sjxp3bv8cwkmw1vfk1cji7514gj2a9v3p";
  };

  cmakeFlags = [
    "-DCMAKE_INSALL_PREFIX=$out"
  ];

  enableParallelBuilding = true;

  buildInputs = [
    pkgconfig
    cmake boost
    portmidi sqlite
    freetype libpng pngpp zlib
    wxGTK30 wxsqlite3
  ];

  meta = with stdenv.lib; {
    description = "LenMus Phonascus is a program for learning music";
    longDescription = ''
      LenMus Phonascus is a free open source program (GPL v3) for learning music.
      It allows you to focus on specific skills and exercises, on both theory and aural training.
      The different activities can be customized to meet your needs
    '';
    homepage = http://www.lenmus.org/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers;  [ ramkromberg ];
    platforms = with platforms; linux;
  };
}
