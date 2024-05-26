{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-1gi+hWrVL+mBB8pHMXnX/8kzRCQqGuut/+wO/9yBABs=";
      hash_darwin_aarch64 =
        "sha256-skYFjXBvv+2u/K770Dd3uxFYFer6GGx/EgWfAgzE9pI=";
      hash_linux = "sha256-67rXlDJeDSpcpEhNQq0rVS2bSWPy3GXVnTo6dwKAnZU=";
      version = "125.0.6422.78";
    };
    deps = {
      gn = {
        hash = "sha256-lrVAb6La+cvuUCNI90O6M/sheOEVFTjgpfA3O/6Odp0=";
        rev = "d823fd85da3fb83146f734377da454473b93a2b2";
        url = "https://gn.googlesource.com/gn";
        version = "2024-04-10";
      };
    };
    hash = "sha256-EA8TzemtndFb8qAp4XWNjwWmNRz/P4Keh3k1Cn9qLEU=";
    version = "125.0.6422.112";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-lrVAb6La+cvuUCNI90O6M/sheOEVFTjgpfA3O/6Odp0=";
        rev = "d823fd85da3fb83146f734377da454473b93a2b2";
        url = "https://gn.googlesource.com/gn";
        version = "2024-04-10";
      };
      ungoogled-patches = {
        hash = "sha256-vHnXIrDdHGIe8byb41CiEWq3FPTecKg006dU7+iESKA=";
        rev = "125.0.6422.112-1";
      };
    };
    hash = "sha256-EA8TzemtndFb8qAp4XWNjwWmNRz/P4Keh3k1Cn9qLEU=";
    version = "125.0.6422.112";
  };
}
