{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-Mdm+aOd8czNX7oJcNCSdu5TFwIlh5Y37OLdiPpOD+mk=";
      hash_darwin_aarch64 =
        "sha256-ZF8nfAXX99I4x6RUEvQkiXZ/SMugXYYyzgC1SzcE1OE=";
      hash_linux = "sha256-DIC7Ew7aCvtYMVXVXsnMItdeLPDdkNZXZH35I0ZdWEs=";
      version = "122.0.6261.57";
    };
    deps = {
      gn = {
        hash = "sha256-UhdDsq9JyP0efGpAaJ/nLp723BbjM6pkFPcAnQbgMKY=";
        rev = "f99e015ac35f689cfdbf46e4eb174e5d2da78d8e";
        url = "https://gn.googlesource.com/gn";
        version = "2024-01-22";
      };
    };
    hash = "sha256-VvurD1r89dI0ahaVDQ3yinGlHOfzzm7TkL09tF4nebE=";
    hash_deb_amd64 = "sha256-Q3AUKzUsRzW00+WLhuri86QzBGk/rlq5Hk+NdoRbbM4=";
    version = "122.0.6261.57";
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
