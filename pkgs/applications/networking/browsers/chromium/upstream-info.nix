{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-QdL9KamluVX6kIIY6F7zxKL5l7clhsE7QWGWw4YRUtM=";
      hash_darwin_aarch64 =
        "sha256-GKqk6GMitz0uud65iPCUMdOtIEhmWyHPbtrO+V2f8XU=";
      hash_linux = "sha256-QKr2BjydiP5D3T5becwQHeFmK0LMrIFhbssDELqSEQM=";
      version = "122.0.6261.128";
    };
    deps = {
      gn = {
        hash = "sha256-UhdDsq9JyP0efGpAaJ/nLp723BbjM6pkFPcAnQbgMKY=";
        rev = "f99e015ac35f689cfdbf46e4eb174e5d2da78d8e";
        url = "https://gn.googlesource.com/gn";
        version = "2024-01-22";
      };
    };
    hash = "sha256-BzLSwDQrmKavh4s2uOSfP935NnB5+Hw7oD7YDbSWp2g=";
    hash_deb_amd64 = "sha256-SxdYfWhV3ZpiGWmagOM6JUfjAmU9pzFGDQDinXrweas=";
    version = "122.0.6261.128";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-UhdDsq9JyP0efGpAaJ/nLp723BbjM6pkFPcAnQbgMKY=";
        rev = "f99e015ac35f689cfdbf46e4eb174e5d2da78d8e";
        url = "https://gn.googlesource.com/gn";
        version = "2024-01-22";
      };
      ungoogled-patches = {
        hash = "sha256-YIJysusNifUPN3Ii2tCUSvHEe63RWlTrTdOt5KBVyK4=";
        rev = "122.0.6261.128-1";
      };
    };
    hash = "sha256-BzLSwDQrmKavh4s2uOSfP935NnB5+Hw7oD7YDbSWp2g=";
    hash_deb_amd64 = "sha256-SxdYfWhV3ZpiGWmagOM6JUfjAmU9pzFGDQDinXrweas=";
    version = "122.0.6261.128";
  };
}
