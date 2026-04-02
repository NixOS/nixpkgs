{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  expat,
  fontconfig,
  freetype,
  gettext,
  libx11,
  libxau,
  libxdmcp,
  libxext,
  libxft,
  libxinerama,
  libxmu,
  libxpm,
  libjpeg,
  libpng,
  librsvg,
  pango,
  pkg-config,
  which,
  libxrender,
  xorgproto,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "jwm";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "joewing";
    repo = "jwm";
    rev = "v${version}";
    hash = "sha256-odGqHdm8xnjEcXmpKMy51HEhbjcROLL3hRSdlbmTr2g=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    pkg-config
    which
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
    libx11
    libxau
    libxdmcp
    libxext
    libxft
    libxinerama
    libxmu
    libxpm
    libjpeg
    libpng
    librsvg
    pango
    libxrender
    xorgproto
  ];

  postPatch = ''
    sed -i '/AM_ICONV/i AC_CONFIG_MACRO_DIRS([m4])' configure.ac
  '';

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    homepage = "http://joewing.net/projects/jwm/";
    description = "Joe's Window Manager is a light-weight X11 window manager";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "jwm";
  };
}
