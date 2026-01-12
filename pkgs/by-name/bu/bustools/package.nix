{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  testers,
  bustools,
}:

stdenv.mkDerivation rec {
  pname = "bustools";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "BUStools";
    repo = "bustools";
    rev = "v${version}";
    sha256 = "sha256-G+ZMoUmhINp18XKmXpdb5GT7YMsiK/XX2zrjt56CbLg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 2.8.12)' \
      'cmake_minimum_required(VERSION 3.5)'
  '';

  passthru.tests.version = testers.testVersion {
    package = bustools;
    command = "bustools version";
  };

  meta = {
    description = "Program for manipulating BUS files for single cell RNA-Seq datasets";
    longDescription = ''
      bustools is a program for manipulating BUS files for single cell RNA-Seq datasets. It can be used to error correct barcodes, collapse UMIs, produce gene count or transcript compatibility count matrices, and is useful for many other tasks. It is also part of the kallisto | bustools workflow for pre-processing single-cell RNA-seq data.
    '';
    homepage = "https://www.kallistobus.tools/";
    downloadPage = "https://bustools.github.io/download";
    changelog = "https://github.com/BUStools/bustools/releases/tag/v${version}";
    maintainers = [ lib.maintainers.dflores ];
    license = lib.licenses.bsd2;
    mainProgram = "bustools";
    platforms = lib.platforms.unix;
  };
}
