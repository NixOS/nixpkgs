{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-PmLV++FK6aCvdhNNhb2ZAmRLumr+VRFvN+7IByieEZk=";
      hash_darwin_aarch64 =
        "sha256-6Ys1EMSLmJNNaWdPeQiCT+bC0H7ABInVNzwXorGavn4=";
      hash_linux = "sha256-iimq37dcEcY2suW73a6lhgHuNaoqtzbAZCHkQP9ro/Y=";
      version = "123.0.6312.122";
    };
    deps = {
      gn = {
        hash = "sha256-JvilCnnb4laqwq69fay+IdAujYC1EHD7uWpkF/C8tBw=";
        rev = "d4f94f9a6c25497b2ce0356bb99a8d202c8c1d32";
        url = "https://gn.googlesource.com/gn";
        version = "2024-02-19";
      };
    };
    hash = "sha256-7H7h621AHPyhFYbaVFO892TtS+SP3Qu7cYUVk3ICL14=";
    hash_deb_amd64 = "sha256-tNkO1mPZg1xltBfoWeNhLekITtZV/WNgu//i2DJb17c=";
    version = "123.0.6312.122";
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
        hash = "sha256-ojKIAkJB/gfg6scCxUYNAGx4lsquAaCySBDcUCFLqSU=";
        rev = "d5773b0fb696ef107cc6df6a94cbe732c9e905f9";
      };
    };
    hash = "sha256-7H7h621AHPyhFYbaVFO892TtS+SP3Qu7cYUVk3ICL14=";
    hash_deb_amd64 = "sha256-tNkO1mPZg1xltBfoWeNhLekITtZV/WNgu//i2DJb17c=";
    version = "123.0.6312.122";
  };
}
