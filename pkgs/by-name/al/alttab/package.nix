{
  lib,
  stdenv,
  coreutils,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  procps,
  ronn,
  libpng,
  uthash,
  which,
  libxrender,
  libxrandr,
  libxpm,
  libxmu,
  libxft,
  libx11,
  xdotool,
  xeyes,
  xprop,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.8.0";

  pname = "alttab";

  src = fetchFromGitHub {
    owner = "sagb";
    repo = "alttab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ICVP2kxGTLzo77DTn+5gbxdyWSO6RH9EgolfrM3cBVQ=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    ronn
  ];

  preConfigure = "./bootstrap.sh";

  buildInputs = [
    libpng
    uthash
    libx11
    libxft
    libxmu
    libxpm
    libxrandr
    libxrender
  ];

  enableParallelBuilding = true;

  doCheck = true;

  nativeCheckInputs = [
    coreutils
    procps
    python3Packages.xvfbwrapper
    which
    xdotool
    xeyes
    xprop
  ];

  meta = {
    homepage = "https://github.com/sagb/alttab";
    description = "X11 window switcher designed for minimalistic window managers or standalone X11 session";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "alttab";
  };
})
