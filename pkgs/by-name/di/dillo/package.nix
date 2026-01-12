{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  fltk,
  libjpeg,
  libpng,
  libwebp,
  libressl,
  mbedtls,
  openssl,
  pkg-config,
  stdenv,
  which,
  # Configurable options
  tlsLibrary ? "libressl",
}:

let
  ssl =
    {
      "libressl" = libressl;
      "mbedtls" = mbedtls;
      "openssl" = openssl;
    }
    .${tlsLibrary} or (throw "Unrecognized tlsLibrary option: ${tlsLibrary}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dillo";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "dillo-browser";
    repo = "dillo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9nJq20iW8/UI3GgXWje+46WDSu3/omd1PN/uTlYCOac=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    fltk
    which
  ];

  buildInputs = [
    libjpeg
    libpng
    libwebp
    ssl
    fltk
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];

  strictDeps = true;

  meta = {
    homepage = "https://dillo-browser.github.io/";
    description = "Fast graphical web browser with a small footprint";
    longDescription = ''
      Dillo is a fast and small graphical web browser with the following
      features:

      - Multi-platform, running on Linux, BSD, MacOS, Windows (via Cygwin) and
        even Atari.
      - Written in C and C++ with few dependencies.
      - Implements its own real-time rendering engine.
      - Low memory usage and fast rendering, even with large pages.
      - Uses the fast and bloat-free FLTK GUI library.
      - Support for HTTP, HTTPS, FTP and local files.
      - Extensible with plugins written in any language.
      - Is free software licensed with the GPLv3.
      - Helps authors to comply with web standards by using the bug meter.
    '';
    mainProgram = "dillo";
    maintainers = with lib.maintainers; [ fgaz ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
