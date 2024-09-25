{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-303weqU04cCCwlLlSVnEyvKvHu09RjGFLmg5cf/exss=";
      hash_darwin_aarch64 =
        "sha256-TybJYKeMzm9FQp0Jqx82VF1OOiVSpS/QgNUEDlWG7Uc=";
      hash_linux = "sha256-D8aKGKnbFT6YUhyhZUuz/XhCrUVS+Y7I7GaI6Qfv2bE=";
      version = "129.0.6668.58";
    };
    deps = {
      gn = {
        hash = "sha256-8o3rDdojqVHMQCxI2T3MdJOXKlW3XX7lqpy3zWhJiaA=";
        rev = "d010e218ca7077928ad7c9e9cc02fe43b5a8a0ad";
        url = "https://gn.googlesource.com/gn";
        version = "2024-08-19";
      };
    };
    hash = "sha256-8dKWu2/ZKw5ZthH1s5wR+h9b0aIqlDhNsPUrlE9DMQg=";
    version = "129.0.6668.58";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-8o3rDdojqVHMQCxI2T3MdJOXKlW3XX7lqpy3zWhJiaA=";
        rev = "d010e218ca7077928ad7c9e9cc02fe43b5a8a0ad";
        url = "https://gn.googlesource.com/gn";
        version = "2024-08-19";
      };
      ungoogled-patches = {
        hash = "sha256-3BK1HZiQ9SnRuMMviC8gm9ZLiu8ImceBlcAp24/aYlM=";
        rev = "129.0.6668.58-1";
      };
    };
    hash = "sha256-8dKWu2/ZKw5ZthH1s5wR+h9b0aIqlDhNsPUrlE9DMQg=";
    version = "129.0.6668.58";
  };
}
