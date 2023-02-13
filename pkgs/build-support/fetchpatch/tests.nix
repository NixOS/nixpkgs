{ testers, fetchpatch, ... }:

let
  isFetchpatch2 = fetchpatch.version == 2;
in

{
  simple = testers.invalidateFetcherByDrvHash fetchpatch {
    url = "https://github.com/facebook/zstd/pull/2724/commits/e1f85dbca3a0ed5ef06c8396912a0914db8dea6a.patch";
    sha256 = if isFetchpatch2 then "sha256-01BrkHLye4KOdqCw3tv7AJzIF6578pl2fl270TJFTmw=" else "sha256-PuYAqnJWAE+L9bsroOnnBGJhERW8LHrGSLtIEkKU9vg=";
  };

  relative = testers.invalidateFetcherByDrvHash fetchpatch {
    url = "https://github.com/boostorg/math/commit/7d482f6ebc356e6ec455ccb5f51a23971bf6ce5b.patch";
    relative = "include";
    sha256 = if isFetchpatch2 then "sha256-1TtmuKeNIl/Yp+sfzBMR8Ue78tPIgjqGgjasa5IN52o=" else "sha256-KlmIbixcds6GyKYt1fx5BxDIrU7msrgDdYo9Va/KJR4=";
  };

  full = testers.invalidateFetcherByDrvHash fetchpatch {
    url = "https://github.com/boostorg/math/commit/7d482f6ebc356e6ec455ccb5f51a23971bf6ce5b.patch";
    relative = "test";
    stripLen = 1;
    extraPrefix = "foo/bar/";
    excludes = [ "foo/bar/bernoulli_no_atomic_mp.cpp" ];
    revert = true;
    sha256 = if isFetchpatch2 then "sha256-+UKmEbr2rIAweCav/hR/7d4ZrYV84ht/domTrHtm8sM=" else "sha256-+UKmEbr2rIAweCav/hR/7d4ZrYV84ht/domTrHtm8sM=";
  };
}
