{
  lib,
  stdenv,
  fetchFromGitHub,
  aiger,
}:

stdenv.mkDerivation rec {
  pname = "lingeling";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "arminbiere";
    repo = "lingeling";
    tag = "rel-${version}";
    hash = "sha256-gVFznoptP9Ukux+1jbUpXZDPbc45EAdQ4UyeaD2cX0M=";
  };

  patches = [
    # Fix incompatible pointer type errors from GCC 15
    # https://github.com/arminbiere/lingeling/pull/11
    ./gcc-15.patch
  ];

  configurePhase = ''
    runHook preConfigure

    ./configure.sh

    # Rather than patch ./configure, just sneak in use of aiger here, since it
    # doesn't handle real build products very well (it works on a build-time
    # dir, not installed copy)... This is so we can build 'blimc'
    substituteInPlace ./makefile \
      --replace-fail 'targets: liblgl.a' 'targets: liblgl.a blimc'      \
      --replace-fail '$(AIGER)/aiger.o'  '${aiger.lib}/lib/libaiger.a'     \
      --replace-fail '$(AIGER)/aiger.h'  '${aiger.dev}/include/aiger.h' \
      --replace-fail '-I$(AIGER)'        '-I${aiger.dev}/include'

    runHook postConfigure
  '';

  installPhase = ''
    mkdir -p $out/bin $lib/lib $dev/include

    cp lglib.h  $dev/include
    cp liblgl.a $lib/lib

    cp lingeling plingeling treengeling ilingeling blimc $out/bin
  '';

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  meta = {
    description = "Fast SAT solver";
    homepage = "http://fmv.jku.at/lingeling/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
