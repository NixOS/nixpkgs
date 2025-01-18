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
  libX11,
  libXau,
  libXdmcp,
  libXext,
  libXft,
  libXinerama,
  libXmu,
  libXpm,
  libjpeg,
  libpng,
  librsvg,
  pango,
  pkg-config,
  which,
  xorg,
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
    libX11
    libXau
    libXdmcp
    libXext
    libXft
    libXinerama
    libXmu
    libXpm
    libjpeg
    libpng
    librsvg
    pango
    xorg.libXrender
    xorgproto
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "http://joewing.net/projects/jwm/";
    description = "Joe's Window Manager is a light-weight X11 window manager";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
    mainProgram = "jwm";
  };
}
