{ stdenv, fetchurl, which, texLive }:

stdenv.mkDerivation {
  name = "EProver-1.4";

  src = fetchurl {
    name = "E-1.4.tar.gz";
    url = "http://www4.informatik.tu-muenchen.de/~schulz/WORK/E_DOWNLOAD/V_1.4/E.tgz";
    sha256 = "1hxkr21xqkkh4bzqip6qf70w9xvvb8p20zzkvyin631ffgvyvr93";
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
