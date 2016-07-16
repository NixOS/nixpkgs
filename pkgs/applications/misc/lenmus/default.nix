{ stdenv, pkgconfig, fetchFromGitHub
, cmake, boost
, portmidi, sqlite
, freetype, libpng, pngpp, zlib
, wxGTK30, wxsqlite3
}:

stdenv.mkDerivation rec {
  name = "lenmus-${version}";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "lenmus";
    repo = "lenmus";
    rev = "Release_${version}";
    sha256 = "03xar8x38x20cns2gnv34jp0hw0k16sa62kkfhka9iiiw90wfyrp";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "DESTINATION \"/usr/share" "DESTINATION \"$out/share"
  '';

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
    homepage = "http://www.lenmus.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers;  [ ramkromberg ];
    platforms = with platforms; linux;
  };
}
