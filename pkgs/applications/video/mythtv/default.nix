{ lib, mkDerivation, fetchFromGitHub, which, qtbase, qtwebkit, qtscript, xlibsWrapper
, libpulseaudio, fftwSinglePrec , lame, zlib, libGLU, libGL, alsa-lib, freetype
, perl, pkg-config , libsamplerate, libbluray, lzo, libX11, libXv, libXrandr, libXvMC, libXinerama, libXxf86vm
, libXmu , yasm, libuuid, taglib, libtool, autoconf, automake, file, exiv2, linuxHeaders
}:

mkDerivation rec {
  pname = "mythtv";
  version = "31.0";

  src = fetchFromGitHub {
    owner = "MythTV";
    repo = "mythtv";
    rev = "v${version}";
    sha256 = "092w5kvc1gjz6jd2lk2jhcazasz2h3xh0i5iq80k8x3znyp4i6v5";
  };

  patches = [
    # Disables OS detection used while checking if enforce_wshadow should be disabled.
    ./disable-os-detection.patch
  ];

  setSourceRoot = "sourceRoot=$(echo */mythtv)";

  buildInputs = [
    freetype qtbase qtwebkit qtscript lame zlib xlibsWrapper libGLU libGL
    perl libsamplerate libbluray lzo alsa-lib libpulseaudio fftwSinglePrec libX11 libXv libXrandr libXvMC
    libXmu libXinerama libXxf86vm libXmu libuuid taglib exiv2
  ];
  nativeBuildInputs = [ pkg-config which yasm libtool autoconf automake file ];

  configureFlags =
    [ "--dvb-path=${linuxHeaders}/include" ];

  meta = with lib; {
    homepage = "https://www.mythtv.org/";
    description = "Open Source DVR";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
