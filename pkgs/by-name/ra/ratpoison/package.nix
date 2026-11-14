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
  version = "1.4.9-unstable-2021-05-27";

  src = fetchgit {
    url = "https://git.savannah.nongnu.org/git/ratpoison.git";
    rev = "db94d4971d8dcae736cf5246ef7d0454aa345ac0";
    sha256 = "sha256-YRzSQVLZ1W4usRWi4xTTQweYj9tNslUidw02V47VkP4=";
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

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/getopt.h \
      --replace-fail "extern int getopt ();" \
                     "extern int getopt (int argc, char *const *argv, const char *shortopts);"
  '';

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
    maintainers = with lib.maintainers; [ vitrial ];
    inherit (libx11.meta) platforms;
  };
})
