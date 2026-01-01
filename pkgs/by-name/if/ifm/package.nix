{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchFromSourcehut,
=======
  fetchzip,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  autoreconfHook,
  bison,
  flex,
  help2man,
  perl,
  tk,
<<<<<<< HEAD
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
=======
}:

stdenv.mkDerivation {
  pname = "ifm";
  version = "2015-11-08";

  src = fetchzip {
    url = "https://bitbucket.org/zondo/ifm/get/dca0774e4d3a.zip";
    sha256 = "14af21qjd5jvsscm6vxpsdrnipdr33g6niagzmykrhyfhwcbjahi";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    help2man
<<<<<<< HEAD
    python3
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://bitbucket.org/zondo/ifm";
    description = "Interactive fiction mapper";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
=======
  meta = with lib; {
    homepage = "https://bitbucket.org/zondo/ifm";
    description = "Interactive fiction mapper";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
