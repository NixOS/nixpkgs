{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  fontconfig,
  freetype,
  libX11,
  libXft,
  libXi,
  libXpm,
  libXrandr,
  libXt,
  libXtst,
  perl,
  pkg-config,
  readline,
  texinfo,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ratpoison";
  version = "1.4.9";

  src = fetchurl {
    url = "mirror://savannah/ratpoison/ratpoison-${finalAttrs.version}.tar.xz";
    hash = "sha256-2Y+kvgJezKRTxAf/MRqzlJ8p8g1tir7fjwcWuF/I0fE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
  ];

  buildInputs = [
    fontconfig
    freetype
    libX11
    libXft
    libXi
    libXpm
    libXrandr
    libXt
    libXtst
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
    # >=1.4.9 requires this even with readline in inputs
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})
