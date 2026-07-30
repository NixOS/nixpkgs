{
  lib,
  stdenv,
  fetchFromGitHub,
  chez,
  libuuid,
  lz4,
  ncurses,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schemesh";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "cosmos72";
    repo = "schemesh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sk2AZXd5kBR3Er8GeVm+10BaLwFL9k0v5Uk5CmuWv6o=";
  };

  buildInputs = [
    chez
    libuuid
    lz4
    ncurses
    zlib
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "A Unix shell and Lisp REPL, fused together";
    homepage = "https://github.com/cosmos72/schemesh";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sikmir ];
    platforms = lib.platforms.linux;
    mainProgram = "schemesh";
  };
})
