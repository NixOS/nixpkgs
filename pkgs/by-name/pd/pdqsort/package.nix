{
  lib,
  stdenvNoCC,
  stdenv, # for tests
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pdqsort";
  version = "0-unstable-2021-03-14";

  src = fetchFromGitHub {
    owner = "orlp";
    repo = "pdqsort";
    rev = "b1ef26a55cdb60d236a5cb199c4234c704f46726";
    hash = "sha256-xn3Jjn/jxJBckpg1Tx3HHVAWYPVTFMiDFiYgB2WX7Sc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -r *.h $out/include/

    runHook postInstall
  '';

  # The benchmark takes too long to run as a regular checkPhase here.
  passthru.tests.bench = stdenv.mkDerivation {
    pname = "pdqsort-bench";

    inherit (finalAttrs) version src;

    doCheck = true;
    checkPhase = ''
      c++ bench/bench.cpp -o bench/bench
      ./bench/bench > $out
    '';

    meta.platforms = lib.platforms.x86_64;
  };

  meta = {
    description = "Novel sorting algorithm that combines the fast average case of randomized quicksort with the fast worst case of heapsort";
    homepage = "https://github.com/orlp/pdqsort";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
