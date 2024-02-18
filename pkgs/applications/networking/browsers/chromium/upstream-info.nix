{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-IDPdjq3FpLy6Y9xkR15mzbIal8wjeQzzWtWuZ4uKmzA=";
      hash_darwin_aarch64 =
        "sha256-3Mol45MrvrSqrpkKy2Trt0JFNfV4ekXTxEveUUGmJm4=";
      hash_linux = "sha256-O8U4pZ76/N7q9bV7d0A+wlIqqaoz6WyfZQO4cIV2CIM=";
      version = "121.0.6167.85";
    };
    deps = {
      gn = {
        hash = "sha256-eD3KORYYuIH+94+BgL+yFD5lTQFvj/MqPU9DPiHc98s=";
        rev = "7367b0df0a0aa25440303998d54045bda73935a5";
        url = "https://gn.googlesource.com/gn";
        version = "2023-11-28";
      };
    };
    hash = "sha256-mLXBaW4KBieOiz2gRXfgA/KPdmUnNlpUIOqdj7CywcY=";
    hash_deb_amd64 = "sha256-UDgO1sJ7bggFTe7C36CnHYXjG9rM+ZqFCOzNyIDpQ0Y=";
    version = "121.0.6167.184";
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
