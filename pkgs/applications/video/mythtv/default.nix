{ stdenv, fetchFromGitHub, which, qtbase, qtwebkit, qtscript, xlibsWrapper
, libpulseaudio, fftwSinglePrec , lame, zlib, libGLU_combined, alsaLib, freetype
, perl, pkgconfig , libX11, libXv, libXrandr, libXvMC, libXinerama, libXxf86vm
, libXmu , yasm, libuuid, taglib, libtool, autoconf, automake, file, exiv2
, linuxHeaders, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "mythtv";
  version = "29.1";

  src = fetchFromGitHub {
    owner = "MythTV";
    repo = "mythtv";
    rev = "v${version}";
    sha256 = "0pjxv4bmq8h285jsr02svgaa03614arsyk12fn9d4rndjsi2cc3x";
  };

  patches = [
    # Fixes build with exiv2 0.27.1.
    (fetchpatch {
      name = "004-exiv2.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/004-exiv2.patch?h=mythtv&id=76ea37f8556805b205878772ad7874e487c0d946";
      sha256 = "0mh542f53qgky0w3s2bv0gmcxzvmb10834z3cfff40fby2ffr6k8";
    })
  ];

  setSourceRoot = ''sourceRoot=$(echo */mythtv)'';

  buildInputs = [
    freetype qtbase qtwebkit qtscript lame zlib xlibsWrapper libGLU_combined
    perl alsaLib libpulseaudio fftwSinglePrec libX11 libXv libXrandr libXvMC
    libXmu libXinerama libXxf86vm libXmu libuuid taglib exiv2
  ];
  nativeBuildInputs = [ pkgconfig which yasm libtool autoconf automake file ];

  configureFlags = [ "--dvb-path=${linuxHeaders}/include" ];

  meta = with stdenv.lib; {
    homepage = https://www.mythtv.org/;
    description = "Open Source DVR";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
