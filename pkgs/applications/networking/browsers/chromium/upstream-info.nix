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
        hash = "sha256-eD3KORYYuIH+94+BgL+yFD5lTQFvj/MqPU9DPiHc98s=";
        rev = "7367b0df0a0aa25440303998d54045bda73935a5";
        url = "https://gn.googlesource.com/gn";
        version = "2023-11-28";
      };
      ungoogled-patches = {
        hash = "sha256-nJDLCVynuGFRIjLBV0NmC0zHeEDHjzFM16FKAv2QyNY=";
        rev = "121.0.6167.184-1";
      };
    };
    hash = "sha256-mLXBaW4KBieOiz2gRXfgA/KPdmUnNlpUIOqdj7CywcY=";
    hash_deb_amd64 = "sha256-UDgO1sJ7bggFTe7C36CnHYXjG9rM+ZqFCOzNyIDpQ0Y=";
    version = "121.0.6167.184";
  };
}
