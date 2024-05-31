{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-Zz2U5zQWScID7rAE6FmTADecs4zR430KZVen+hsl+KI=";
      hash_darwin_aarch64 =
        "sha256-NhnJdnrzTj8gQiyp4PzmXHx6ltsxUVrz0AL9x8nGibA=";
      hash_linux = "sha256-iyhxx7KIpGPMYgf/I1hLUK8M49kWmgTy+UOXf5WBEWY=";
      version = "125.0.6422.141";
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
