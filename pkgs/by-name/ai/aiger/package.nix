{
  lib,
  stdenv,
  fetchFromGitHub,
  picosat,
}:

stdenv.mkDerivation rec {
  pname = "aiger";
  version = "1.9.20";

  src = fetchFromGitHub {
    owner = "arminbiere";
    repo = "aiger";
    tag = "rel-${version}";
    hash = "sha256-ggkxITuD8phq3VF6tGc/JWQGBhTfPxBdnRobKswYVa4=";
  };

  enableParallelBuilding = true;

  configurePhase = ''
    # Set up picosat, so we can build 'aigbmc'
    mkdir ../picosat
    ln -s ${picosat}/include/picosat/picosat.h ../picosat/picosat.h
    ln -s ${picosat}/lib/picosat.o             ../picosat/picosat.o
    ln -s ${picosat}/share/picosat.version     ../picosat/VERSION
    ./configure.sh
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];
  postInstall = ''
    # test that installing picosat in configurePhase suceeded
    test -f $out/bin/aigbmc

    install -m 440 -Dt $lib/lib aiger.o
    install -m 440 -Dt $dev/include aiger.h
  '';

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  meta = {
    description = "And-Inverter Graph (AIG) utilities";
    homepage = "https://fmv.jku.at/aiger/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = lib.platforms.unix;
  };
}
