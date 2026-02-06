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
  xnee,
  libxrender,
  libxrandr,
  libxpm,
  libxmu,
  libxft,
  libx11,
  xprop,
  xeyes,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.7.1";

  pname = "alttab";

  src = fetchFromGitHub {
    owner = "sagb";
    repo = "alttab";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-1+hk0OeSriXPyefv3wOgeiW781PL4VP5Luvt+RS5jmg=";
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
    xnee
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
