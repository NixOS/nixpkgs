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
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "ncbi";
    repo = "ncbi-vdb";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-HBiheN8XfYYwmY5gw7j8qTczn6WZZNTzY2/fGtpgs/8=";
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
