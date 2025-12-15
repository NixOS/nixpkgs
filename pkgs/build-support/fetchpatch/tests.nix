{ testers, fetchpatch, ... }:

let
  isFetchpatch2 = fetchpatch.version == 2;
in

{
  simple = testers.invalidateFetcherByDrvHash fetchpatch {
    url = "https://github.com/facebook/zstd/pull/2724/commits/e1f85dbca3a0ed5ef06c8396912a0914db8dea6a.patch";
    sha256 =
      if isFetchpatch2 then
        "sha256-w4yU0wt64d0WkuBQPeGf8vn5TH6qSBJvNIgka9QK+/Q="
      else
        "sha256-PuYAqnJWAE+L9bsroOnnBGJhERW8LHrGSLtIEkKU9vg=";
  };

  relative = testers.invalidateFetcherByDrvHash fetchpatch {
    url = "https://github.com/boostorg/math/commit/7d482f6ebc356e6ec455ccb5f51a23971bf6ce5b.patch";
    relative = "include";
    sha256 =
      if isFetchpatch2 then
        "sha256-1TtmuKeNIl/Yp+sfzBMR8Ue78tPIgjqGgjasa5IN52o="
      else
        "sha256-KlmIbixcds6GyKYt1fx5BxDIrU7msrgDdYo9Va/KJR4=";
  };

  hunks = testers.invalidateFetcherByDrvHash fetchpatch {
    url = "https://github.com/openssh/openssh-portable/commit/35d5917652106aede47621bb3f64044604164043.patch";
    stripLen = 1;
    hunks = [
      2
      3
      4
      5
      6
      7
    ];
    sha256 =
      if isFetchpatch2 then
        "sha256-SXJALY4zC4y/ZV7uVglf+XB5cpC5tS4M8QDGlFRmcFM="
      else
        "sha256-MV7uGgA1ESMR7W6H5FjAIxKcpySdQjWB+L2zaHjd96M=";
  };

  full = testers.invalidateFetcherByDrvHash fetchpatch {
    url = "https://github.com/boostorg/math/commit/7d482f6ebc356e6ec455ccb5f51a23971bf6ce5b.patch";
    relative = "test";
    stripLen = 1;
    extraPrefix = "foo/bar/";
    excludes = [ "foo/bar/bernoulli_no_atomic_mp.cpp" ];
    # Should result in no change.
    hunks = [ "1-" ];
    revert = true;
    sha256 = "sha256-+UKmEbr2rIAweCav/hR/7d4ZrYV84ht/domTrHtm8sM=";
  };

  decode = testers.invalidateFetcherByDrvHash fetchpatch {
    name = "gcc.patch";
    url = "https://chromium.googlesource.com/aosp/platform/external/libchrome/+/f37ae3b1a873d74182a2ac31d96742ead9c1f523^!?format=TEXT";
    decode = "base64 -d";
    sha256 =
      if isFetchpatch2 then
        "sha256-oMvPlmzE51ArI+EvFxONXkqmNee39106/O1ikG0Bdso="
      else
        "sha256-SJHk8XrutqAyoIdORlhCpBCN626P+uzed7mjKz5eQYY=";
  };

  fileWithSpace = testers.invalidateFetcherByDrvHash fetchpatch {
    url = "https://github.com/jfly/annoying-filenames/commit/1e86a219f5fc9c4137b409bc9c38036f3922724b.patch";
    sha256 =
      if isFetchpatch2 then
        "sha256-RB6pjigoXtzHILkGFXYd3Lz2aM9DvO0NRmLdey1N6gg="
      else
        "sha256-aptUvVojqIIIVNuHqkl+C+dZBGFfs+1MUd0FNV+4j4E=";
  };

  fileWithApostrophe = testers.invalidateFetcherByDrvHash fetchpatch {
    url = "https://github.com/jfly/annoying-filenames/commit/8b6d8f8d7094ce646523b3369cfdf5030289c66c.patch";
    sha256 =
      if isFetchpatch2 then
        "sha256-CrQFmVvLEvWpo2ucVrWyLb5qk2GVOxyUbFN3hp9sV68="
      else
        "sha256-CrQFmVvLEvWpo2ucVrWyLb5qk2GVOxyUbFN3hp9sV68=";
  };
}
