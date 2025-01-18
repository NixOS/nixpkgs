{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n2048";
  version = "0.1";

  src = fetchurl {
    url = "http://www.dettus.net/n2048/n2048_v${finalAttrs.version}.tar.gz";
    hash = "sha256-c4bHWmdQuwyRXIm/sqw3p71pMv6VLAzIuUTaDHIWn6A=";
  };

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
    ];
  };

  buildInputs = [
    ncurses
  ];

  makeFlags = [
    "DESTDIR=$(out)"
  ];

  preInstall = ''
    mkdir -p "$out"/{share/man,bin}
  '';

  meta = with lib; {
    description = "Console implementation of 2048 game";
    mainProgram = "n2048";
    license = licenses.bsd2;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "http://www.dettus.net/n2048/";
  };
})
