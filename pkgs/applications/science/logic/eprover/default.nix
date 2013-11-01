{ stdenv, fetchurl, which, texLive }:
let
  s = # Generated upstream information
  rec {
    baseName="eprover";
    version="1.8";
    name="${baseName}-${version}";
    hash="0bl4dr7k6simwdvdyxhnjkiz4nm5y0nr8bfhc34zk0360i9m6sk3";
    url="http://www4.in.tum.de/~schulz/WORK/E_DOWNLOAD/V_1.8/E.tgz";
    sha256="0bl4dr7k6simwdvdyxhnjkiz4nm5y0nr8bfhc34zk0360i9m6sk3";
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
