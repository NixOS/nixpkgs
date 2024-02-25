{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-qo7eiMC4MR4pskSim6twkC2QDeqe3qfZsIEe5mjS7jg=";
      hash_darwin_aarch64 =
        "sha256-RHqu0wNeAx34LTkVgNjBfXrSWvZ1G7OkNAIGA4WUhmw=";
      hash_linux = "sha256-K4QeHFp520Z3KjefvVsJf8V7gz7gTf2BCSW4Jxz/H9M=";
      version = "122.0.6261.69";
    };
    deps = {
      gn = {
        hash = "sha256-UhdDsq9JyP0efGpAaJ/nLp723BbjM6pkFPcAnQbgMKY=";
        rev = "f99e015ac35f689cfdbf46e4eb174e5d2da78d8e";
        url = "https://gn.googlesource.com/gn";
        version = "2024-01-22";
      };
    };
    hash = "sha256-uEN1hN6DOLgw4QDrMBZdiLLPx+yKQc5MimIf/vbCC84=";
    hash_deb_amd64 = "sha256-k3/Phs72eIMB6LAU4aU0+ze/cRu6KlRhpBshKhmq9N4=";
    version = "122.0.6261.69";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-UhdDsq9JyP0efGpAaJ/nLp723BbjM6pkFPcAnQbgMKY=";
        rev = "f99e015ac35f689cfdbf46e4eb174e5d2da78d8e";
        url = "https://gn.googlesource.com/gn";
        version = "2024-01-22";
      };
      ungoogled-patches = {
        hash = "sha256-G+agHdsssYhsyi4TgJUJBqMEnEgQ7bYeqpTqmonXI6I=";
        rev = "122.0.6261.69-1";
      };
    };
    hash = "sha256-uEN1hN6DOLgw4QDrMBZdiLLPx+yKQc5MimIf/vbCC84=";
    hash_deb_amd64 = "sha256-k3/Phs72eIMB6LAU4aU0+ze/cRu6KlRhpBshKhmq9N4=";
    version = "122.0.6261.69";
  };
}
