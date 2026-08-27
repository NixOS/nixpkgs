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

  postPatch = ''
    # https://github.com/cosmos72/schemesh/commit/696ba7c24737cd436bb4d8bfa9ec1ea517681403
    substituteInPlace c/dir.c --replace-fail PATH_MAX 1024
  '';

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # error initializing POSIX subsystem: dup2(0, tty_fd) failed with error Bad file descriptor
    ulimit -n 128
  '';

  buildInputs = [
    chez
    libuuid
    lz4
    ncurses
    zlib
  ];

  makeFlags = [ "prefix=$(out)" ];

  # Chez Scheme .so files are fasl (compiled Scheme) not ELF/Mach-O;
  # stripping them corrupts the fasl header, causing "incompatible fasl-object version"
  dontStrip = true;

  meta = {
    description = "A Unix shell and Lisp REPL, fused together";
    homepage = "https://github.com/cosmos72/schemesh";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sikmir ];
    platforms = lib.platforms.unix;
    mainProgram = "schemesh";
  };
})
