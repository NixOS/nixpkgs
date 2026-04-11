{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  libx11,
  bzip2,
  zlib,
  brotli,
  zstd,
  xz,
  openssl,
  autoreconfHook,
  gettext,
  pkg-config,
  libev,
  gpm,
  libidn,
  tre,
  expat,
  # Incompatible licenses, LGPLv3 - GPLv2
  enableGuile ? false,
  guile ? null,
  enablePython ? false,
  python ? null,
  enablePerl ? (!stdenv.hostPlatform.isDarwin) && (stdenv.hostPlatform == stdenv.buildPlatform),
  perl ? null,
  # re-add javascript support when upstream supports modern spidermonkey
}:

assert enableGuile -> guile != null;
assert enablePython -> python != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "elinks";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "rkd77";
    repo = "elinks";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eFH42PCMF3HPvNqcaXOyIM6AAr3RusgxiRlUa2X8B9U=";
  };

  buildInputs = [
    ncurses
    libx11
    bzip2
    zlib
    brotli
    zstd
    xz
    openssl
    libidn
    tre
    expat
    libev
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux gpm
  ++ lib.optional enableGuile guile
  ++ lib.optional enablePython python
  ++ lib.optional enablePerl perl;

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkg-config
  ];

  configureFlags = [
    "--enable-finger"
    "--enable-html-highlight"
    "--enable-gopher"
    "--enable-gemini"
    "--enable-cgi"
    "--enable-bittorrent"
    "--enable-nntp"
    "--enable-256-colors"
    "--enable-true-color"
    "--with-brotli"
    "--with-lzma"
    "--with-libev"
    "--with-terminfo"
  ]
  ++ lib.optional enableGuile "--with-guile"
  ++ lib.optional enablePython "--with-python"
  ++ lib.optional enablePerl "--with-perl";

  meta = {
    description = "Full-featured text-mode web browser";
    mainProgram = "elinks";
    homepage = "https://github.com/rkd77/elinks";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      iblech
    ];
  };
})
