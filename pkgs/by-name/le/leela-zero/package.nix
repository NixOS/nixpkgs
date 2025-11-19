{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  libsForQt5,
  ocl-icd,
  opencl-headers,
  zlib,
}:

stdenv.mkDerivation {
  pname = "leela-zero";
  version = "0.17-unstable-2023-02-07";

  src = fetchFromGitHub {
    owner = "gcp";
    repo = "leela-zero";
    rev = "3ee6d20d0b36ae26120331c610926359cc5837de";
    hash = "sha256-JF25y471miw/0b7XXBURzK+4WBwZI5ZUP+36/cZUORo=";
    fetchSubmodules = true;
  };

  buildInputs = [
    boost
    opencl-headers
    ocl-icd
    libsForQt5.qtbase
    zlib
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Go engine modeled after AlphaGo Zero";
    homepage = "https://github.com/gcp/leela-zero";
    license = licenses.gpl3Plus;
    maintainers = [
      maintainers.averelld
      maintainers.omnipotententity
    ];
    platforms = platforms.linux;
  };
}
