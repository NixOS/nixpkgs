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
    hash = "sha256-pZHa4YSJ4rK24f7dNUFeoyf6nDSQeY4MTR81YzPKCtQ=";
    hash_deb_amd64 = "sha256-cMoYBCuOYzXS7OzFvvBfSL80hBY/PcEv9kWGSx3mCKw=";
    version = "121.0.6167.139";
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
        hash = "sha256-W13YPijmdakEJiUd9iKH3V9LcKvL796QlyTrAb+yLMQ=";
        rev = "121.0.6167.139-1";
      };
    };
    hash = "sha256-pZHa4YSJ4rK24f7dNUFeoyf6nDSQeY4MTR81YzPKCtQ=";
    hash_deb_amd64 = "sha256-cMoYBCuOYzXS7OzFvvBfSL80hBY/PcEv9kWGSx3mCKw=";
    version = "121.0.6167.139";
  };
}
