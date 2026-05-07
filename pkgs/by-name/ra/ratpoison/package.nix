{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  fontconfig,
  freetype,
  libx11,
  libxft,
  libxi,
  libxpm,
  libxrandr,
  libxt,
  libxtst,
  perl,
  pkg-config,
  readline,
  texinfo,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ratpoison";
  version = "1.4.10-beta";

  src = fetchgit {
    url = "https://git.savannah.nongnu.org/git/ratpoison.git";
    rev = "a34577dd8662d2cb3f617e187f9f60288d71ccbd";
    hash = "sha256-FnkfaabXDS5V03u6ZVuX3sRcYk2/mSsKx7Hb6/xndPo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
  ];

  buildInputs = [
    fontconfig
    freetype
    libx11
    libxft
    libxi
    libxpm
    libxrandr
    libxt
    libxtst
    perl
    readline
    xorgproto
  ];

  outputs = [
    "out"
    "contrib"
    "man"
    "doc"
    "info"
  ];

  strictDeps = true;

  configureFlags = [
    "--enable-history"
  ];

  postInstall = ''
    mkdir -p $contrib/{bin,share}
    mv $out/bin/rpws $contrib/bin
    mv $out/share/ratpoison $contrib/share
  '';

  meta = {
    homepage = "https://www.nongnu.org/ratpoison/";
    description = "Simple mouse-free tiling window manager";
    longDescription = ''
      Ratpoison is a simple window manager with no fat library
      dependencies, no fancy graphics, no window decorations, and no
      rodent dependence.  It is largely modelled after GNU Screen which
      has done wonders in the virtual terminal market.

      The screen can be split into non-overlapping frames.  All windows
      are kept maximized inside their frames to take full advantage of
      your precious screen real estate.

      All interaction with the window manager is done through keystrokes.
      Ratpoison has a prefix map to minimize the key clobbering that
      cripples Emacs and other quality pieces of software.
    '';
    license = lib.licenses.gpl2Plus;
    mainProgram = "ratpoison";
    maintainers = with lib.maintainers; [ danrobi11 ];
    inherit (libX11.meta) platforms;
  };
})
