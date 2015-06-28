{ stdenv, fetchurl, which }:
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

  buildInputs = [ which ];

  preConfigure = "sed -e 's@^EXECPATH\\s.*@EXECPATH = '\$out'/bin@' -i Makefile.vars";

  buildPhase = "make install";

  installPhase = ''
    mkdir -p $out/bin
    make install
    echo eproof -xAuto --tstp-in --tstp-out '"$@"' > $out/bin/eproof-tptp
    chmod a+x $out/bin/eproof-tptp
  '';

  meta = {
    inherit (s) version;
    description = "Automated theorem prover for full first-order logic with equality";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.all;
  };
}
