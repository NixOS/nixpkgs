{
  lib,
  stdenv,
  fetchzip,
  autoreconfHook,
  bison,
  flex,
  help2man,
  perl,
  tk,
}:

stdenv.mkDerivation rec {
  pname = "ifm";
  version = "2015-11-08";

  src = fetchzip {
    url = "https://bitbucket.org/zondo/ifm/get/dca0774e4d3a.zip";
    sha256 = "14af21qjd5jvsscm6vxpsdrnipdr33g6niagzmykrhyfhwcbjahi";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    help2man
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

  meta = with lib; {
    homepage = "https://bitbucket.org/zondo/ifm";
    description = "Interactive fiction mapper";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
