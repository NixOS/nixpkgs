{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm2, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra_gtk2, fftw, expat, pcre, libsigcxx
, mercurial  # Not really needed for anything, but it fails if it does not find 'hg'
}:

stdenv.mkDerivation rec {
  name = "rawtherapee-4.2";

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = "4.2";
    sha256 = "1v4px239vlmk9l8wbzlvlyni4ns12icxmgfz21m86jkd10pj5dgr";
  };

  buildInputs = [ pkgconfig cmake pixman libpthreadstubs gtkmm2 libXau libXdmcp
    lcms2 libiptcdata mercurial libcanberra_gtk2 fftw expat pcre libsigcxx ];

  patchPhase = ''
    patch -p1 < ${./sigc++_fix.patch}
  '';

  NIX_CFLAGS_COMPILE = "-std=gnu++11 -Wno-deprecated-declarations -Wno-unused-result";

  enableParallelBuilding = true;

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = http://www.rawtherapee.com/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric jcumming mahe the-kenny ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
