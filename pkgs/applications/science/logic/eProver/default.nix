{ stdenv, fetchurl, which, texLive }:

stdenv.mkDerivation {
  name = "EProver-1.2";

  src = fetchurl {
    name = "E-1.2.tar.gz";
    url = "http://www4.informatik.tu-muenchen.de/~schulz/WORK/E_DOWNLOAD/V_1.2/E.tgz";
    sha256 = "14sbpmh8vg376lrrq7i364aa8g5aacq344ihivxn6w4ydh9138nq";
  };

  buildInputs = [which texLive];

  preConfigure = "sed -e 's@^EXECPATH\\s.*@EXECPATH = '\$out'/bin@' -i Makefile.vars";

  buildPhase = "make install";

  # HOME=. allows to build missing TeX formats
  installPhase = ''
    mkdir -p $out/bin
    make install
    HOME=. make documentation
    mkdir -p $out/share/doc
    cp -r DOC $out/share/doc/EProver
    echo eproof -xAuto --tstp-in --tstp-out '"$@"' > $out/bin/eproof-tptp
    chmod a+x $out/bin/eproof-tptp
  '';

  meta = {
    description = "E automated theorem prover";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.all;
  };
}
