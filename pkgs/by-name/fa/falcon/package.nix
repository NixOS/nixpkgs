{
  lib,
  stdenv,
  fetchFromGitHub,
<<<<<<< HEAD
  fetchpatch,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cmake,
  pkg-config,
  pcre,
  zlib,
  sqlite,
}:

stdenv.mkDerivation {
  pname = "falcon";
  version = "0-unstable-2023-11-19";

  src = fetchFromGitHub {
    owner = "falconpl";
    repo = "falcon";
    rev = "fc403c6e8c1f3d8c2a5a6ebce5db6f1b3e355808";
    hash = "sha256-0yLhwDVFNbfiW23hNxrvItCCkyaOvEbFSg1ZQuJvhIs=";
  };

<<<<<<< HEAD
  patches = [
    # part of https://github.com/falconpl/falcon/pull/11
    (fetchpatch {
      name = "bump-minimum-cmake-required-version.patch";
      url = "https://github.com/falconpl/falcon/commit/a1f4fa1607249b0356c2cd2c54134cb3dc2dc231.patch";
      hash = "sha256-oYLB+71/oan2MOyHTr/IpgDwik+T8ToP1q7AroaBq1g=";
    })
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    pcre
    zlib
    sqlite
  ];

<<<<<<< HEAD
  meta = {
    description = "Programming language with macros and syntax at once";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = with lib.platforms; unix;
=======
  meta = with lib; {
    description = "Programming language with macros and syntax at once";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = stdenv.cc.isClang;
  };
}
