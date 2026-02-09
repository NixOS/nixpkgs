{
  lib,
  stdenv,
  fetchFromGitLab,
  libao,
  libmodplug,
  libsamplerate,
  libsndfile,
  libvorbis,
  ncurses,
  which,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frotz";
  version = "2.55";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "DavidGriffith";
    repo = "frotz";
    rev = finalAttrs.version;
    hash = "sha256-XZjimskjupTtYdgfVaOS2QnQrDIBSwkJqxrffdjgZk0=";
  };

  postPatch = ''
    # Comment out debug flags
    substituteInPlace Makefile --replace-fail 'CFLAGS += -g' '#CFLAGS += -g'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Remove Homebrew-specific code that breaks Nix builds on macOS
    sed -i '/# On macOS.*Homebrew/,/SDL_CFLAGS.*_XOPEN_SOURCE/d' Makefile
    # Remove Homebrew lines from src/curses/Makefile but keep ifeq/endif structure
    substituteInPlace src/curses/Makefile \
      --replace-fail 'HOMEBREW_PREFIX ?= $(shell brew --prefix)' "" \
      --replace-fail 'CFLAGS += -I$(HOMEBREW_PREFIX)/include' ""
  '';

  nativeBuildInputs = [
    which
    pkg-config
  ];
  buildInputs = [
    libao
    libmodplug
    libsamplerate
    libsndfile
    libvorbis
    ncurses
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://davidgriffith.gitlab.io/frotz/";
    changelog = "https://gitlab.com/DavidGriffith/frotz/-/raw/${finalAttrs.version}/NEWS";
    description = "Z-machine interpreter for Infocom games and other interactive fiction";
    mainProgram = "frotz";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      nicknovitski
      ddelabru
    ];
    license = lib.licenses.gpl2Plus;
  };
})
