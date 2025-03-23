{
  lib,
  stdenv,
  fetchurl,
  openssl,
  pkg-config,
  readline,
  zlib,
  libidn2,
  gmp,
  libiconv,
  libunistring,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "lftp";
  version = "4.9.3";

  src = fetchurl {
    urls = [
      "https://lftp.yar.ru/ftp/${pname}-${version}.tar.xz"
      "https://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/${pname}-${version}.tar.xz"
    ];
    sha256 = "sha256-lucZnXk1vjPPaxFh6VWyqrQKt37N8qGc6k/BGT9Fftw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    readline
    zlib
    libidn2
    gmp
    libiconv
    libunistring
    gettext
  ];

  hardeningDisable = lib.optional stdenv.hostPlatform.isDarwin "format";

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Required to build with clang 16 or `configure` will fail to detect several standard functions.
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  configureFlags = [
    "--with-openssl"
    "--with-readline=${readline.dev}"
    "--with-zlib=${zlib.dev}"
    "--without-expat"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "File transfer program supporting a number of network protocols";
    homepage = "https://lftp.yar.ru/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
