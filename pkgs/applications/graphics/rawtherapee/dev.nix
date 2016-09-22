{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm2, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra_gtk2, fftw, expat, pcre, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "rawtherapee-git-2016-09-21";

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = "2d0e5e4feeac9801994d82c5931531f508deb2e9";
    sha256 = "1d9bi3b6cslm0rhhqf0rx47nlnsnky284vqsxyq3mss6bd8880xh";
  };

  buildInputs = [ pkgconfig cmake pixman libpthreadstubs gtkmm2 libXau libXdmcp
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
