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
    hash = "sha256-C17TPDVFW3+cHO1tcEghjI6H59TVPm9hdCrF2s5NI68=";
    hash_deb_amd64 = "sha256-zmnBi4UBx52fQKHHJuUaCMuDJl7ntQzhG6h/yH7YPNU=";
    version = "123.0.6312.105";
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
        hash = "sha256-81SoZBOAAV0cAVzz3yOzBstRW3vWjmkFoFNjYdPnme4=";
        rev = "123.0.6312.105-1";
      };
    };
    hash = "sha256-C17TPDVFW3+cHO1tcEghjI6H59TVPm9hdCrF2s5NI68=";
    hash_deb_amd64 = "sha256-zmnBi4UBx52fQKHHJuUaCMuDJl7ntQzhG6h/yH7YPNU=";
    version = "123.0.6312.105";
  };
}
