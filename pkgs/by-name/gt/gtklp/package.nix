{
  lib,
  stdenv,
  autoreconfHook,
  cups,
  fetchurl,
  gettext,
  glib,
  gtk2,
  libtool,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtklp";
  version = "1.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/gtklp/gtklp-${finalAttrs.version}.src.tar.gz";
    hash = "sha256-vgdgkEJZX6kyA047LXA4zvM5AewIY/ztu1GIrLa1O6s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    cups
  ];

  buildInputs = [
    cups
    gettext
    glib
    gtk2
    libtool
    openssl
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];

  strictDeps = true;

  patches = [
    ./000-autoconf.patch
    ./001-format-parameter.patch
  ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: libgtklp.a(libgtklp.o):libgtklp/libgtklp.h:83: multiple definition of `progressBar';
  #     file.o:libgtklp/libgtklp.h:83: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postPatch = ''
    substituteInPlace include/defaults.h \
      --replace "netscape" "firefox" \
      --replace "http://localhost:631/sum.html#STANDARD_OPTIONS" \
                "http://localhost:631/help/"
  '';

  preInstall = ''
    install -D -m0644 -t $doc/share/doc AUTHORS BUGS ChangeLog README USAGE
  '';

  meta = {
    homepage = "https://gtklp.sirtobi.com";
    description = "GTK-based graphical frontend for CUPS";
    license = with lib.licenses; [ gpl2Only ];
    mainProgram = "gtklp";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
