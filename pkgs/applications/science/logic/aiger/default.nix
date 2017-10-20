{ stdenv, fetchurl, picosat }:

stdenv.mkDerivation rec {
  name = "aiger-${version}";
  version = "1.9.9";

  src = fetchurl {
    url    = "http://fmv.jku.at/aiger/${name}.tar.gz";
    sha256 = "1ish0dw0nf9gyghxsdhpy1jjiy5wp54c993swp85xp7m6vdx6l0y";
  };

  enableParallelBuilding = true;

  configurePhase = ''
    # Set up picosat, so we can build 'aigbmc'
    echo $(pwd)
    ls ..
    mkdir ../picosat
    ln -s ${picosat}/include/picosat/picosat.h ../picosat/picosat.h
    ln -s ${picosat}/lib/picosat.o             ../picosat/picosat.o
    ln -s ${picosat}/share/picosat.version     ../picosat/VERSION
    ls ..
    ./configure.sh
  '';

  installPhase = ''
    mkdir -p $out/bin

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
  '';

  meta = {
    description = "And-Inverter Graph (AIG) utilities";
    homepage    = http://fmv.jku.at/aiger/;
    license     = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
