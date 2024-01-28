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
    hash = "sha256-2TMTLCqoCxdy9PDlZIUa/5oXjmim1T2/LJu+3/Kf4fQ=";
    hash_deb_amd64 = "sha256-9vPQAiZPw60oILm0He4Iz9lOc+WvtHCBE9CHA1ejc7s=";
    version = "121.0.6167.85";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-dwluGOfq05swtBM5gg4a6gY3IpFHaKKkD0TV1XW7c7k=";
        rev = "e4702d7409069c4f12d45ea7b7f0890717ca3f4b";
        url = "https://gn.googlesource.com/gn";
        version = "2023-10-23";
      };
      ungoogled-patches = {
        hash = "sha256-feMWYdxQSgn1ZTdnXTYHUBi3pV1fsaAcKjbf+qHzYnU=";
        rev = "120.0.6099.224-1";
      };
    };
    hash = "sha256-HFQ7QAL4hcux3jmMmLYFNym3sfWR1o1hWV75bokID4I=";
    hash_deb_amd64 = "sha256-dFllEHRYH3yAPg3uaaCzdpiZxSLENEwmtIb/gg53/ZU=";
    version = "120.0.6099.224";
  };
}
