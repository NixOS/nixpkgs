{
  lib,
  stdenv,
  fetchFromGitHub,
  aiger,
}:

stdenv.mkDerivation {
  pname = "lingeling";
  # This is the version used in satcomp2020
  version = "pre1_708beb26";

  src = fetchFromGitHub {
    owner = "arminbiere";
    repo = "lingeling";
    rev = "708beb26a7d5b5d5e7abd88d6f552fb1946b07c1";
    sha256 = "1lb2g37nd8qq5hw5g6l691nx5095336yb2zlbaw43mg56hkj8357";
  };

  configurePhase = ''
    ./configure.sh

    # Rather than patch ./configure, just sneak in use of aiger here, since it
    # doesn't handle real build products very well (it works on a build-time
    # dir, not installed copy)... This is so we can build 'blimc'
    substituteInPlace ./makefile \
      --replace 'targets: liblgl.a' 'targets: liblgl.a blimc'      \
      --replace '$(AIGER)/aiger.o'  '${aiger.lib}/lib/aiger.o'     \
      --replace '$(AIGER)/aiger.h'  '${aiger.dev}/include/aiger.h' \
      --replace '-I$(AIGER)'        '-I${aiger.dev}/include'
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

  meta = with lib; {
    description = "Fast SAT solver";
    homepage = "http://fmv.jku.at/lingeling/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
