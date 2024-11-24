{ lib, stdenv, fetchurl, picosat }:

stdenv.mkDerivation rec {
  pname = "aiger";
  version = "1.9.9";

  src = fetchurl {
    url    = "https://fmv.jku.at/aiger/${pname}-${version}.tar.gz";
    sha256 = "1ish0dw0nf9gyghxsdhpy1jjiy5wp54c993swp85xp7m6vdx6l0y";
  };

  patches = [
    # Fix implicit declaration of `isatty`, which is an error with newer versions of clang.
    ./fix-missing-header.patch
  ];

  enableParallelBuilding = true;

  configurePhase = ''
    # Set up picosat, so we can build 'aigbmc'
    mkdir ../picosat
    ln -s ${picosat}/include/picosat/picosat.h ../picosat/picosat.h
    ln -s ${picosat}/lib/picosat.o             ../picosat/picosat.o
    ln -s ${picosat}/share/picosat.version     ../picosat/VERSION
    ./configure.sh
  '';

  installPhase = ''
    mkdir -p $out/bin $dev/include $lib/lib

    # Do the installation manually, as the Makefile has odd
    # cyrillic characters, and this is easier than adding
    # a whole .patch file.
    BINS=( \
      aigand aigdd aigflip aigfuzz aiginfo aigjoin   \
      aigmiter aigmove aignm aigor aigreset aigsim   \
      aigsplit aigstrip aigtoaig aigtoblif aigtocnf  \
      aigtodot aigtosmv aigunconstraint aigunroll    \
      andtoaig bliftoaig smvtoaig soltostim wrapstim \
      aigbmc aigdep
    )

    for x in ''${BINS[*]}; do
      install -m 755 -s $x $out/bin/$x
    done

    cp -v aiger.o $lib/lib
    cp -v aiger.h $dev/include
  '';

  outputs = [ "out" "dev" "lib" ];

  meta = {
    description = "And-Inverter Graph (AIG) utilities";
    homepage    = "https://fmv.jku.at/aiger/";
    license     = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms   = lib.platforms.unix;
  };
}
