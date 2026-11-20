{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchDebianPatch,
  boost,
  cmake,
  libsForQt5,
  ocl-icd,
  opencl-headers,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "leela-zero";
  version = "0.17-unstable-2023-02-07";

  src = fetchFromGitHub {
    owner = "leela-zero";
    repo = "leela-zero";
    rev = "3ee6d20d0b36ae26120331c610926359cc5837de";
    hash = "sha256-JF25y471miw/0b7XXBURzK+4WBwZI5ZUP+36/cZUORo=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchDebianPatch {
      pname = finalAttrs.pname;
      version = "0.17";
      debianRevision = "1.3";
      patch = "boost1.90.patch";
      hash = "sha256-/vnRuRWlZl+pzJvjP6a/A9TaFNuCSkTZkd4h9zvZJis=";
    })
  ];

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

  meta = {
    description = "Go engine modeled after AlphaGo Zero";
    homepage = "https://github.com/gcp/leela-zero";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      omnipotententity
    ];
    platforms = lib.platforms.linux;
  };
})
