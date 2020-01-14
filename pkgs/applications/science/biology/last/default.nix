{ stdenv, fetchurl, unzip, zlib, python3, parallel }:

stdenv.mkDerivation rec {
  pname = "last";
  version = "1045";

  src = fetchurl {
    url = "http://last.cbrc.jp/last-${version}.zip";
    sha256 = "0x2wrm52ca935n3yc486m8yy59ap34w1x9h3csjca3jab5agnjkc";
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
