{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-m5kuSeaK4v8GtjlqJOP3isN/o+9uOxPuSEegi0nYaOM=";
      hash_darwin_aarch64 =
        "sha256-9WQH8Z7v3PtFKHA6bsrXgCJDWevh1YPjPyDp7M/xhlI=";
      hash_linux = "sha256-dp060EKhFI4aRTBGLB8PyqeOj25Ov5Bd29KyESUDcwQ=";
      version = "129.0.6668.70";
    };
    deps = {
      gn = {
        hash = "sha256-8o3rDdojqVHMQCxI2T3MdJOXKlW3XX7lqpy3zWhJiaA=";
        rev = "d010e218ca7077928ad7c9e9cc02fe43b5a8a0ad";
        url = "https://gn.googlesource.com/gn";
        version = "2024-08-19";
      };
    };
    hash = "sha256-L9h9jbwEMcUi/cu7FP2O/6wD0Br/3SzWCazu7m9ua+o=";
    version = "129.0.6668.70";
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
        hash = "sha256-LKtkNFb0y1v+p6hInulR7CrRO5pPk5J5Jd4nlAwZRwI=";
        rev = "129.0.6668.70-1";
      };
    };
    hash = "sha256-L9h9jbwEMcUi/cu7FP2O/6wD0Br/3SzWCazu7m9ua+o=";
    version = "129.0.6668.70";
  };
}
