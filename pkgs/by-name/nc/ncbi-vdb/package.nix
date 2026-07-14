{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  doxygen,
  flex,
  graphviz,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncbi-vdb";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "ncbi";
    repo = "ncbi-vdb";
    tag = finalAttrs.version;
    hash = "sha256-A6Pjy1dEkCHy1B6LrWwVs8Et41POvdK4Upsyp4JUnaU=";
  };

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    flex
    graphviz
    python3
  ];

  meta = {
    homepage = "https://github.com/ncbi/ncbi-vdb";
    description = "Libraries for the INSDC Sequence Read Archives";
    license = lib.licenses.ncbiPd;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.unix;
  };
})
