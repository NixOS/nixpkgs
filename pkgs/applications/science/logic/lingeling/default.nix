{ stdenv, fetchFromGitHub
, aiger
}:

stdenv.mkDerivation {
  pname = "lingeling";
  # This is the version used in satcomp2018, which was
  # relicensed, and also known as version 'bcj'
  version = "pre1_03b4860d";

  src = fetchFromGitHub {
    owner  = "arminbiere";
    repo   = "lingeling";
    rev    = "03b4860d14016f42213ea271014f2f13d181f504";
    sha256 = "1lw1yfy219p7rrk88sbq4zl24b70040zapbjdrpv5a6i0jsblksx";
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

  outputs = [ "out" "dev" "lib" ];

  meta = with stdenv.lib; {
    description = "Fast SAT solver";
    homepage    = http://fmv.jku.at/lingeling/;
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
