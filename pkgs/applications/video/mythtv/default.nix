{ stdenv, fetchurl, which, qt4, xlibsWrapper, libpulseaudio, fftwSinglePrec
, lame, zlib, mesa, alsaLib, freetype, perl, pkgconfig
, libX11, libXv, libXrandr, libXvMC, libXinerama, libXxf86vm, libXmu
, yasm, libuuid, taglib, libtool, autoconf, automake, file
}:

stdenv.mkDerivation rec {
  name = "mythtv-${version}";
  version = "0.27.4";

  src = fetchurl {
    url = "https://github.com/MythTV/mythtv/archive/v${version}.tar.gz";
    sha256 = "0nrn4fbkkzh43n7jgbv21i92sb4z4yacwj9yj6m3hjbffzy4ywqz";
  };

  sourceRoot = "${name}/mythtv";

  buildInputs = [
    freetype qt4 lame zlib xlibsWrapper mesa perl alsaLib libpulseaudio fftwSinglePrec
    libX11 libXv libXrandr libXvMC libXmu libXinerama libXxf86vm libXmu
    libuuid taglib
  ];
  nativeBuildInputs = [ pkgconfig which yasm libtool autoconf automake file ];

  meta = with stdenv.lib; {
    homepage = https://www.mythtv.org/;
    description = "Open Source DVR";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
