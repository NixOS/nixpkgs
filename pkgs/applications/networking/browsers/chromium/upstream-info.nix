{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-ahwPSPoB2h6Zq4ePbvSmYs3WNc+MpBXQYyYLf0ZS3ss=";
      hash_darwin_aarch64 =
        "sha256-NVqr/i4S4XP+z0+YT6CuDnmyN4GtS6ttyJDOQ05KB+0=";
      hash_linux = "sha256-PKuhfBw5FblCUQ60yeQC0McvYu7gPfwwIW1ysN/MwVA=";
      version = "125.0.6422.60";
    };
    deps = {
      gn = {
        hash = "sha256-lrVAb6La+cvuUCNI90O6M/sheOEVFTjgpfA3O/6Odp0=";
        rev = "d823fd85da3fb83146f734377da454473b93a2b2";
        url = "https://gn.googlesource.com/gn";
        version = "2024-04-10";
      };
    };
    hash = "sha256-ewX7oRna7IYCXhAe98HS5HbS1psIEAguhZJ1ymK+dPE=";
    version = "125.0.6422.60";
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
        hash = "sha256-I3RQBa4LLuOdZQFKHIqePj9Ozw61dsuAOctqN1abij0=";
        rev = "125.0.6422.60-1";
      };
    };
    hash = "sha256-ewX7oRna7IYCXhAe98HS5HbS1psIEAguhZJ1ymK+dPE=";
    version = "125.0.6422.60";
  };
}
