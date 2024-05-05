{
  lib,
  autoreconfHook,
  fetchhg,
  fltk,
  libXcursor,
  libXi,
  libXinerama,
  libjpeg,
  libpng,
  mbedtls_2,
  openssl,
  perl,
  pkg-config,
  stdenv,
  which,
}:

stdenv.mkDerivation {
  pname = "dillo";
  version = "3.0.5-unstable-2021-02-09";

  src = fetchhg {
    url = "https://hg.sr.ht/~seirdy/dillo-mirror";
    rev = "67b70f024568b505633524be61fcfbde5337849f";
    hash = "sha256-lbn5u9oEL0zt9yBhznBS9Dz9/6kSwRDJeNXKEojty1g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    fltk
    which
  ];

  buildInputs = [
    fltk
    libXcursor
    libXi
    libXinerama
    libjpeg
    libpng
    mbedtls_2
    openssl
    perl
  ];

  outputs = [ "out" "doc" "man" ];

  configureFlags = [
    (lib.enableFeature true "ssl")
  ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: main.o:/build/dillo-3.0.5/dpid/dpid.h:64: multiple definition of `sock_set';
  #     dpid.o:/build/dillo-3.0.5/dpid/dpid.h:64: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  strictDeps = true;

  meta = {
    homepage = "https://hg.sr.ht/~seirdy/dillo-mirror";
    description = "A fast graphical web browser with a small footprint";
    longDescription = ''
      Dillo is a small, fast web browser, tailored for older machines.
    '';
    mainProgram = "dillo";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
