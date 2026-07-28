{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "myman";
  version = "0.7.0";

  src = fetchurl {
    url = "https://sourceforge.net/projects/myman/files/myman/myman-${finalAttrs.version}/myman-${finalAttrs.version}.tar.gz";
    hash = "sha512-elJo+pqSdcjUa1fPcU6InCIVgaXL4Zs4jmpgI2Z/mUH3ZK9r5H+/HxGkMPFJ+/anoLtb4t2SsWwHAg+d6PyYtg==";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  buildInputs = [ ncurses ];

  configureFlags = [
    "--with-xterm"
    "--with-rxvt"
    "--with-kterm"
    "--with-ncurses"
  ];

  meta = {
    description = "Pacman clone with an ncurses and a 'graphic' interface";
    homepage = "http://myman.sourceforge.net/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ silverhadch ];
    platforms = lib.platforms.unix;
    mainProgram = "myman";
  };
})
