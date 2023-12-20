{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-ThsKOOLNcmFTUnLirSHea9wzw+FyC3v7I/5ghbz8GAg=";
      hash_darwin_aarch64 =
        "sha256-UVBLCo8Lkbnt882PeTMnO8lxam42mIDkEN28Ps8E0a8=";
      hash_linux = "sha256-X8bia1BaLQm5WKn5vdShpQ4A7sPNZ8lgmeXoYj2earc=";
      version = "120.0.6099.71";
    };
    deps = {
      gn = {
        hash = "sha256-dwluGOfq05swtBM5gg4a6gY3IpFHaKKkD0TV1XW7c7k=";
        rev = "e4702d7409069c4f12d45ea7b7f0890717ca3f4b";
        url = "https://gn.googlesource.com/gn";
        version = "2023-10-23";
      };
    };
    hash = "sha256-Zbo8xvOfvJVkjdqBaApK6hekmuRKHuYWRBTZTpqcOSM=";
    hash_deb_amd64 = "sha256-ScFJQB9fY1cWHtFO8GpQ8yuCLaO1AvyAV5lbnqSrPCs=";
    version = "120.0.6099.109";
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
        hash = "sha256-wiW1w+HVPpEjROuE3yhYuGiZSwI8z5+k1CFnVZ0HtME=";
        rev = "120.0.6099.109-1";
      };
    };
    hash = "sha256-Zbo8xvOfvJVkjdqBaApK6hekmuRKHuYWRBTZTpqcOSM=";
    hash_deb_amd64 = "sha256-ScFJQB9fY1cWHtFO8GpQ8yuCLaO1AvyAV5lbnqSrPCs=";
    version = "120.0.6099.109";
  };
}
