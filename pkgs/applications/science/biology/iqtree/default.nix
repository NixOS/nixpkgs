{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, zlib
}:

stdenv.mkDerivation rec {
  pname = "iqtree";
  version = "2.2.0.4";

  src = fetchFromGitHub {
    owner = "iqtree";
    repo = "iqtree2";
    rev = "v${version}";
    sha256 = "sha256:0ickw1ldpvv2m66yzbvqfhn8k07qdkhbjrlqjs6vcf3s42j5c6pq";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost eigen zlib ];

  meta = with lib; {
    homepage = "http://www.iqtree.org/";
    description = "Efficient and versatile phylogenomic software by maximum likelihood";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ bzizou ];
  };
}
