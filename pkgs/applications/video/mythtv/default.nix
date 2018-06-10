{ stdenv, fetchFromGitHub, which, qtbase, qtwebkit, qtscript, xlibsWrapper
, libpulseaudio, fftwSinglePrec , lame, zlib, libGLU_combined, alsaLib, freetype
, perl, pkgconfig , libX11, libXv, libXrandr, libXvMC, libXinerama, libXxf86vm
, libXmu , yasm, libuuid, taglib, libtool, autoconf, automake, file, exiv2
, linuxHeaders
}:

stdenv.mkDerivation rec {
  name = "mythtv-${version}";
  version = "29.1";

  src = fetchFromGitHub {
    owner = "MythTV";
    repo = "mythtv";
    rev = "v${version}";
    sha256 = "0pjxv4bmq8h285jsr02svgaa03614arsyk12fn9d4rndjsi2cc3x";
  };

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
