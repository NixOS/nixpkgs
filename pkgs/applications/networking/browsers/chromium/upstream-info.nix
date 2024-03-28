{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-sB6gH5k5zK1IIctBTXQpxlgmLEoIatcLDYO+WIFaYxA=";
      hash_darwin_aarch64 =
        "sha256-sikyGQG0Y14eNjT3f/Z50cPmm38T58X7zQIGopXOHOs=";
      hash_linux = "sha256-2WZmRXyvxN3hXeOoPQXL6lU6Xki9iUmTdETRxOkIYD0=";
      version = "123.0.6312.86";
    };
    deps = {
      gn = {
        hash = "sha256-JvilCnnb4laqwq69fay+IdAujYC1EHD7uWpkF/C8tBw=";
        rev = "d4f94f9a6c25497b2ce0356bb99a8d202c8c1d32";
        url = "https://gn.googlesource.com/gn";
        version = "2024-02-19";
      };
    };
    hash = "sha256-b72MiRv4uxolKE92tK224FvyA56NM3FcCjijkc9m3ro=";
    hash_deb_amd64 = "sha256-JsEJw8aEptesRiCtIrfHRQu1xq27TzHSmUr+dsvnV7o=";
    version = "123.0.6312.86";
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
