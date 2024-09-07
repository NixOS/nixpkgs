{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, zlib
, llvmPackages
}:

stdenv.mkDerivation rec {
  pname = "iqtree";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "iqtree";
    repo = "iqtree2";
    rev = "v${version}";
    hash = "sha256-ld+9vPJRVHMEe5/igqRr6RkISY2ipfGkJFHDOSZuAmg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    eigen
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    llvmPackages.openmp
  ];

  meta = with lib; {
    homepage = "http://www.iqtree.org/";
    description = "Efficient and versatile phylogenomic software by maximum likelihood";
    mainProgram = "iqtree2";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ bzizou ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
