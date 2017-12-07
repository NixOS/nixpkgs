{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm2, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra_gtk2, fftw, expat, pcre, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "rawtherapee-git-2016-10-10";

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = "0821eea7b6a4ac2fce1fcf644e06078e161e41e3";
    sha256 = "1nwb6b1qrpdyigwig7bvr42lf7na1ngm0q2cislcvb2v1nmk6nlz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake pixman libpthreadstubs gtkmm2 libXau libXdmcp
    lcms2 libiptcdata libcanberra_gtk2 fftw expat pcre libsigcxx ];

  NIX_CFLAGS_COMPILE = "-std=gnu++11 -Wno-deprecated-declarations -Wno-unused-result";

  # Copy generated ReleaseInfo.cmake so we don't need git. File was
  # generated manually using `./tools/generateReleaseInfo` in the
  # source folder. Make sure to regenerate it when updating.
  preConfigure = ''
    cp ${./ReleaseInfo.cmake} ./ReleaseInfo.cmake
  '';

  enableParallelBuilding = true;

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = http://www.rawtherapee.com/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric jcumming mahe the-kenny ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
