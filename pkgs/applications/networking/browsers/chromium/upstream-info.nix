{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-DX0J3xeOK4Dy4BAjbrbu1rnIkmF8nlmy9tMaQhLsFcU=";
      hash_darwin_aarch64 =
        "sha256-hRJeaeQS30srO5M1Gi43VYR/KrjNAhH0XozkEzvcbA0=";
      hash_linux = "sha256-CcBQhIsK7mL7VNJCs6ynhrQeXPuB793DysyV1nj90mM=";
      version = "125.0.6422.76";
    };
    deps = {
      gn = {
        hash = "sha256-lrVAb6La+cvuUCNI90O6M/sheOEVFTjgpfA3O/6Odp0=";
        rev = "d823fd85da3fb83146f734377da454473b93a2b2";
        url = "https://gn.googlesource.com/gn";
        version = "2024-04-10";
      };
    };
    hash = "sha256-m7WeRloS6tGH2AwhkNicpqThUQmS+9w2xFS2dbmu1vw=";
    version = "125.0.6422.76";
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
        hash = "sha256-bGc8hQnuiGot0kThSAi4AFAwmvrNPs1bR7oZx2XoAGo=";
        rev = "125.0.6422.76-1";
      };
    };
    hash = "sha256-m7WeRloS6tGH2AwhkNicpqThUQmS+9w2xFS2dbmu1vw=";
    version = "125.0.6422.76";
  };
}
