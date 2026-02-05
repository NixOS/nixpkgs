{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  qtbase,
  qtwebkit,
  qtscript,
  libpulseaudio,
  fftwSinglePrec,
  lame,
  zlib,
  libGLU,
  libGL,
  alsa-lib,
  freetype,
  perl,
  pkg-config,
  libsamplerate,
  libbluray,
  lzo,
  libX11,
  libXv,
  libXrandr,
  libXvMC,
  libXinerama,
  libXxf86vm,
  libXmu,
  yasm,
  libuuid,
  taglib,
  libtool,
  autoconf,
  automake,
  file,
  wrapQtAppsHook,
  exiv2,
  linuxHeaders,
  soundtouch,
  libzip,
  libhdhomerun,
  withWebKit ? false,
}:

stdenv.mkDerivation rec {
  pname = "mythtv";
  version = "35.0";

  src = fetchFromGitHub {
    owner = "MythTV";
    repo = "mythtv";
    tag = "v${version}";
    hash = "sha256-4mWtPJi2CBoek8LWEfdFxe1ybomAOCTWBTKExMm7nLU=";
  };

  patches = [
    # Disable sourcing /etc/os-release
    ./dont-source-os-release.patch
  ];

  setSourceRoot = "sourceRoot=$(echo */mythtv)";

  buildInputs = [
    freetype
    qtbase
    qtscript
    lame
    zlib
    libGLU
    libGL
    perl
    libsamplerate
    libbluray
    lzo
    alsa-lib
    libpulseaudio
    fftwSinglePrec
    libX11
    libXv
    libXrandr
    libXvMC
    libXmu
    libXinerama
    libXxf86vm
    libXmu
    libuuid
    taglib
    exiv2
    soundtouch
    libzip
    libhdhomerun
  ]
  ++ lib.optional withWebKit qtwebkit;
  nativeBuildInputs = [
    pkg-config
    which
    yasm
    libtool
    autoconf
    automake
    file
    wrapQtAppsHook
  ];

  configureFlags = [ "--dvb-path=${linuxHeaders}/include" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.mythtv.org/";
    description = "Open Source DVR";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
