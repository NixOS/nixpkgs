{ invalidateFetcherByDrvHash, fetchpatch, ... }:

{
  simple = invalidateFetcherByDrvHash fetchpatch {
    url = "https://github.com/facebook/zstd/pull/2724/commits/e1f85dbca3a0ed5ef06c8396912a0914db8dea6a.patch";
    sha256 = "sha256-PuYAqnJWAE+L9bsroOnnBGJhERW8LHrGSLtIEkKU9vg=";
  };
}
