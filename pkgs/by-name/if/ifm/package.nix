{
  lib,
  stdenv,
  fetchFromSourcehut,
  autoreconfHook,
  bison,
  flex,
  help2man,
  perl,
  tk,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ifm";
  version = "5.5";

  src = fetchFromSourcehut {
    owner = "~zondo";
    repo = "ifm";
    tag = finalAttrs.version;
    hash = "sha256-RA0F8hccVJTq/F4l27CwhxynTqVuLJaYBiUfd/UfvPc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    help2man
    python3
  ];

  buildInputs = [
    perl
    tk
  ]; # perl and wish are not run but written as shebangs.

  # Workaround build failure on -fno-common toolchains:
  #   ld: libvars.a(vars-freeze-lex.o):src/libvars/vars-freeze-lex.l:23:
  #     multiple definition of `line_number'; ifm-main.o:src/ifm-main.c:46: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  enableParallelBuilding = false; # ifm-scan.l:16:10: fatal error: ifm-parse.h: No such file or directory

  meta = {
    homepage = "https://bitbucket.org/zondo/ifm";
    description = "Interactive fiction mapper";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
