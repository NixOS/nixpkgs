{ lib
, stdenv
, fetchhg
, autoreconfHook
, fltk
, libXcursor
, libXi
, libXinerama
, libjpeg
, libpng
, mbedtls_2
, openssl
, perl
, pkg-config
, which
}:

stdenv.mkDerivation {
  pname = "dillo";
  version = "unstable-2021-02-09";

  src = fetchhg {
    url = "https://hg.sr.ht/~seirdy/dillo-mirror";
    rev = "67b70f024568b505633524be61fcfbde5337849f";
    sha256 = "sha256-lbn5u9oEL0zt9yBhznBS9Dz9/6kSwRDJeNXKEojty1g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
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

  # Workaround build failure on -fno-common toolchains:
  #   ld: main.o:/build/dillo-3.0.5/dpid/dpid.h:64: multiple definition of `sock_set';
  #     dpid.o:/build/dillo-3.0.5/dpid/dpid.h:64: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  configureFlags = [ "--enable-ssl=yes" ];

  meta = with lib; {
    homepage = "https://hg.sr.ht/~seirdy/dillo-mirror";
    description = "A fast graphical web browser with a small footprint";
    longDescription = ''
      Dillo is a small, fast web browser, tailored for older machines.
    '';
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
