{ lib, mkDerivation, fetchFromGitHub, fetchpatch, which, qtbase, qtwebkit, qtscript
, libpulseaudio, fftwSinglePrec , lame, zlib, libGLU, libGL, alsa-lib, freetype
, perl, pkg-config , libsamplerate, libbluray, lzo, libX11, libXv, libXrandr, libXvMC, libXinerama, libXxf86vm
, libXmu , yasm, libuuid, taglib, libtool, autoconf, automake, file, exiv2, linuxHeaders
, soundtouch, libzip, libhdhomerun
, withWebKit ? false
}:

mkDerivation rec {
  pname = "mythtv";
  version = "32.0";

  src = fetchFromGitHub {
    owner = "MythTV";
    repo = "mythtv";
    rev = "v${version}";
    sha256 = "0i4fs3rbk1jggh62wflpa2l03na9i1ihpz2vsdic9vfahqqjxff1";
  };

  patches = [
    # Disable sourcing /etc/os-release
    ./dont-source-os-release.patch

    # Fix QMake variable substitution syntax - MythTV/mythtv#550
    (fetchpatch {
      name = "fix-qmake-var-syntax.patch";
      url = "https://github.com/MythTV/mythtv/commit/a8da7f7e7ec069164adbef65a8104adc9bb52e36.patch";
      stripLen = 1;
      hash = "sha256-JfRME00YNNjl6SKs1HBa0wBa/lR/Rt3zbQtWhsC36JM=";
    })

    # Bachport the build against binutils-2.41
    (fetchpatch {
      name = "binutils-2.41.patch";
      url = "https://github.com/MythTV/mythtv/commit/f9f9bba62ee2743c816cb2b9634b6b4397e5e2e3.patch";
      stripLen = 1;
      hash = "sha256-IcXgBtfqPZ42inYFe7l8mWvKUV13S/YEQAHcOFaDivI=";
    })
  ];

  setSourceRoot = "sourceRoot=$(echo */mythtv)";

  buildInputs = [
    freetype qtbase qtscript lame zlib libGLU libGL
    perl libsamplerate libbluray lzo alsa-lib libpulseaudio fftwSinglePrec libX11 libXv libXrandr libXvMC
    libXmu libXinerama libXxf86vm libXmu libuuid taglib exiv2 soundtouch libzip
    libhdhomerun
  ] ++ lib.optional withWebKit qtwebkit;
  nativeBuildInputs = [ pkg-config which yasm libtool autoconf automake file ];

  configureFlags =
    [ "--dvb-path=${linuxHeaders}/include" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.mythtv.org/";
    description = "Open Source DVR";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
