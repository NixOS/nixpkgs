{ stdenv, pkgconfig, fetchFromGitHub, fetchpatch
, cmake, boost
, portmidi, sqlite
, freetype, libpng, pngpp, zlib
, wxGTK30, wxsqlite3
}:

stdenv.mkDerivation rec {
  pname = "lenmus";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "lenmus";
    repo = "lenmus";
    rev = "Release_${version}";
    sha256 = "1n639xr1qxx6rhqs0c6sjxp3bv8cwkmw1vfk1cji7514gj2a9v3p";
  };

  enableParallelBuilding = true;

  patches = [
    (fetchpatch {
      url = "https://github.com/lenmus/lenmus/commit/421760d84694a0e6e72d0e9b1d4fd30a7e129c6f.patch";
      sha256 = "1z1wwh0pcr8w1zlr8swx99si9y2kxx5bmavgwvy6bvdhxgm58yqs";
    })
    (fetchpatch {
      url = "https://github.com/lenmus/lenmus/commit/6613d20d4051effc782203c9c6d92962a3f66b5f.patch";
      sha256 = "01vvzzpamv90jpqbbq1f2m2b4gb9xab9z70am8i41d90nqvg6agn";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
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
