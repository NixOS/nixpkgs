{ stdenv, fetchurl, unzip, zlib, python3, parallel }:

stdenv.mkDerivation rec {
  pname = "last";
  version = "1145";

  src = fetchurl {
    url = "http://last.cbrc.jp/last-${version}.zip";
    sha256 = "0g54nmxxrirgid1i1k5i6rf7vnjpk9548sy06yqb4fj7vdzqgq99";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ zlib python3 ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postFixup = ''
    for f in $out/bin/parallel-* ; do
      sed -i 's|parallel |${parallel}/bin/parallel |' $f
    done
  '';

  meta = with stdenv.lib; {
    description = "Genomic sequence aligner";
    homepage = "http://last.cbrc.jp/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
