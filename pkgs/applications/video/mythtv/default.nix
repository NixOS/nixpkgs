{ stdenv, mkDerivation, fetchFromGitHub, which, qtbase, qtwebkit, qtscript, xlibsWrapper
, libpulseaudio, fftwSinglePrec , lame, zlib, libGLU_combined, alsaLib, freetype
, perl, pkgconfig , libsamplerate, libbluray, lzo, libX11, libXv, libXrandr, libXvMC, libXinerama, libXxf86vm
, libXmu , yasm, libuuid, taglib, libtool, autoconf, automake, file, exiv2, linuxHeaders
, libXNVCtrl, enableXnvctrl ? false
}:

mkDerivation rec {
  pname = "mythtv";
  version = "30.0";

  src = fetchFromGitHub {
    owner = "MythTV";
    repo = "mythtv";
    rev = "v${version}";
    sha256 = "1pfzjb07xwd3mfgmbr4kkiyfyvwy9fkl13ik7bvqds86m0ws5bw4";
  };

  patches = [
    # Fixes build with exiv2 0.27.1.
    ./exiv2.patch
    # Disables OS detection used while checking for xnvctrl support.
    ./disable-os-detection.patch
  ];

  setSourceRoot = ''sourceRoot=$(echo */mythtv)'';

  buildInputs = [
    freetype qtbase qtwebkit qtscript lame zlib xlibsWrapper libGLU_combined
    perl libsamplerate libbluray lzo alsaLib libpulseaudio fftwSinglePrec libX11 libXv libXrandr libXvMC
    libXmu libXinerama libXxf86vm libXmu libuuid taglib exiv2
  ] ++ stdenv.lib.optional enableXnvctrl libXNVCtrl;
  nativeBuildInputs = [ pkgconfig which yasm libtool autoconf automake file ];

  configureFlags = 
    [ "--dvb-path=${linuxHeaders}/include" ]
    ++ stdenv.lib.optionals (!enableXnvctrl) [  "--disable-xnvctrl" ];

  meta = with stdenv.lib; {
    homepage = https://www.mythtv.org/;
    description = "Open Source DVR";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
