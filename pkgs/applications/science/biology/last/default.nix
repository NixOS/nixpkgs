{ lib, stdenv, fetchFromGitLab, unzip, zlib, python3, parallel }:

stdenv.mkDerivation rec {
  pname = "last";
  version = "1260";

  src = fetchFromGitLab {
    owner = "mcfrith";
    repo = "last";
    rev = version;
    sha256 = "sha256-bJNvoHr2sQYtiC3tr1GA0T0kRhDyx6hU3OOSTvKUSCs=";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ zlib python3 ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postFixup = ''
    for f in $out/bin/parallel-* ; do
      sed -i 's|parallel |${parallel}/bin/parallel |' $f
    done
  '';

  meta = with lib; {
    description = "Genomic sequence aligner";
    homepage = "http://last.cbrc.jp/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
