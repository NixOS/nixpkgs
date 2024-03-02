{lib, stdenv, fetchFromGitHub, zlib, python3, bzip2, xz}:

stdenv.mkDerivation rec {
  pname = "bedtools";
  version = "2.31.1";

  src = fetchFromGitHub {
    owner = "arq5x";
    repo = "bedtools2";
    rev = "v${version}";
    sha256 = "sha256-rrk+FSv1bGL0D1lrIOsQu2AT7cw2T4lkDiCnzil5fpg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    python3
  ];

  buildInputs = [ zlib bzip2 xz ];

  cxx = if stdenv.cc.isClang then "clang++" else "g++";
  cc = if stdenv.cc.isClang then "clang" else "gcc";
  buildPhase = "make prefix=$out SHELL=${stdenv.shell} CXX=${cxx} CC=${cc} -j $NIX_BUILD_CORES";
  installPhase = "make prefix=$out SHELL=${stdenv.shell} CXX=${cxx} CC=${cc} install";

  meta = with lib; {
    description = "A powerful toolset for genome arithmetic";
    license = licenses.gpl2;
    homepage = "https://bedtools.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.unix;
  };
}
