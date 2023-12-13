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
    hash = "sha256-2IYdIhe299Fn5gtmLKxqIPqTYYEpCJqbXh3Vx8zN9Uo=";
    hash_deb_amd64 = "sha256-xHwBLIU1QoDM0swG2DzRJ7BY9ESiqOrm4SwvK0mfIZc=";
    version = "120.0.6099.71";
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
        hash = "sha256-S0Kt9M21zyjIozJuyy4kBDt07kJxXBR7SoNzdvf0iPI=";
        rev = "120.0.6099.71-1";
      };
    };
    hash = "sha256-2IYdIhe299Fn5gtmLKxqIPqTYYEpCJqbXh3Vx8zN9Uo=";
    hash_deb_amd64 = "sha256-xHwBLIU1QoDM0swG2DzRJ7BY9ESiqOrm4SwvK0mfIZc=";
    version = "120.0.6099.71";
  };
}
