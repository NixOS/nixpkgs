{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  libzip,
  range-v3,
}:

stdenv.mkDerivation {
  pname = "cnpypp";
  version = "0-unstable-2025-06-22";

  src = fetchFromGitHub {
    owner = "mreininghaus";
    repo = "cnpypp";
    rev = "c6cd4e2078e4f39e862720b66fb211c45577c510";
    hash = "sha256-aV57931nis0W2cwCNeMjQDip9Au7K76VpC/BqACnT5M=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    libzip
    range-v3
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CNPYPP_SPAN_IMPL" "BOOST")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    ./example1
    ./example2
    ./example_c
    ./range_example
    ./range_zip_example
    ./npz_speedtest

    runHook postCheck
  '';

  meta = {
    description = "C++17 library that allows to read and write NumPy data files";
    homepage = "https://github.com/mreininghaus/cnpypp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    platforms = lib.platforms.all;
  };
}
