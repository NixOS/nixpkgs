{ stdenv, fetchurl, perl, mlton }:

stdenv.mkDerivation rec {
  name = "metis-prover-${version}";
  version = "2.3.20160101";

  src = fetchurl {
    url = "http://www.gilith.com/software/metis/metis.tar.gz";
    sha256 = "0wkh506ggwmfacwl19n84n1xi6ak4xhrc96d9pdkpk8zdwh5w58l";
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
    platforms = platforms.unix;
  };
}
