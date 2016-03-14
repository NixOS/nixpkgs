{ stdenv, fetchurl, perl, mlton }:

stdenv.mkDerivation rec {
  name = "metis-prover-${version}";
  version = "2.3.20160102";

  src = fetchurl {
    url = "http://www.gilith.com/software/metis/metis.tar.gz";
    sha256 = "13csr90i9lsxdyzxqiwgi98pa7phfl28drjcv4qdjhzi71wcdc66";
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
