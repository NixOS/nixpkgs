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
        hash = "sha256-JvilCnnb4laqwq69fay+IdAujYC1EHD7uWpkF/C8tBw=";
        rev = "d4f94f9a6c25497b2ce0356bb99a8d202c8c1d32";
        url = "https://gn.googlesource.com/gn";
        version = "2024-02-19";
      };
      ungoogled-patches = {
        hash = "sha256-vaL5lClzUzksjeJ/qneQ0uJ7IO5pJKBXa/cEgRx8s70=";
        rev = "123.0.6312.58-1";
      };
    };
    hash = "sha256-GrCYCUjxV16tinqrIqW4DQD51dKIgKNu2fLLz9Yqq7k=";
    hash_deb_amd64 = "sha256-z+UC7wUsWAX7kPIgk8S9ujW2n6HlUp0m3zHTvsAiTps=";
    version = "123.0.6312.58";
  };
}
