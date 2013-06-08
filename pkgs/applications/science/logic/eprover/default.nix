{ stdenv, fetchurl, which, texLive }:
let
  s = # Generated upstream information
  rec {
    baseName="eprover";
    version="1.7";
    name="${baseName}-${version}";
    hash="1prkgjpg8lajcylz9nj2hfjxl3l42cqbfvilg30z9b5br14l36rh";
    url="http://www4.in.tum.de/~schulz/WORK/E_DOWNLOAD/V_1.7/E.tgz";
    sha256="1prkgjpg8lajcylz9nj2hfjxl3l42cqbfvilg30z9b5br14l36rh";
  };
in
stdenv.mkDerivation {
  inherit (s) name;

  src = fetchurl {
    name = "E-${s.version}.tar.gz";
    inherit (s) url sha256;
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
    inherit (s) version;
    description = "E automated theorem prover";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.all;
  };
}
