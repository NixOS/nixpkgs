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
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "ncbi";
    repo = "ncbi-vdb";
    tag = finalAttrs.version;
    hash = "sha256-ccKJF6Ank/hyADnDwN0qoQbb0BniXlz/Fgnc1IXq0P0=";
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
