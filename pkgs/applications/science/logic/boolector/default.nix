{ stdenv, fetchurl, zlib, useV16 ? false }:

let
  v15 = rec {
    name    = "boolector-${version}";
    version = "1.5.118";
    src = fetchurl {
      url    = "http://fmv.jku.at/boolector/${name}-with-sat-solvers.tar.gz";
      sha256 = "17j7q02rryvfwgvglxnhx0kv8hxwy8wbhzawn48lw05i98vxlmk9";
    };
  };

  v16 = rec {
    name    = "boolector-${version}";
    version = "1.6.0";
    src = fetchurl {
      url    = "http://fmv.jku.at/boolector/${name}-with-sat-solvers.tar.gz";
      sha256 = "0jka4r6bc3i24axgdp6qbq6gjadwz9kvi11s2c5sbwmdnjd7cp85";
    };
  };

  boolectorPkg = if useV16 then v16 else v15;
  license = with stdenv.lib.licenses; if useV16 then unfreeRedistributable else gpl3;
in
stdenv.mkDerivation (boolectorPkg // {
  buildInputs = [
    zlib zlib.static (stdenv.lib.getOutput "static" stdenv.cc.libc)
  ];

  enableParallelBuilding = false;

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include
    cp boolector/boolector      $out/bin
    cp boolector/deltabtor      $out/bin
    cp boolector/synthebtor     $out/bin
    cp boolector/libboolector.a $out/lib
    cp boolector/boolector.h    $out/include
  '';

  meta = {
    inherit license;
    description = "An extremely fast SMT solver for bit-vectors and arrays";
    homepage    = "http://fmv.jku.at/boolector";
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
})
