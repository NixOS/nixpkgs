{ stdenv, fetchurl, perl, mlton }:

stdenv.mkDerivation rec {
  name = "metis-prover-${version}";
  version = "2.3";

  src = fetchurl {
    url = "http://www.gilith.com/software/metis/metis.tar.gz";
    sha256 = "07wqhic66i5ip2j194x6pswwrxyxrimpc4vg0haa5aqv9pfpmxad";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = [ mlton ];

  patchPhase = "patchShebangs scripts/mlpp";

  buildPhase = "make mlton";

  installPhase = ''
    install -Dm0755 bin/mlton/metis $out/bin/metis
  '';

  meta = with stdenv.lib; {
    description = "Automatic theorem prover for first-order logic with equality";
    homepage = http://www.gilith.com/research/metis/;
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
