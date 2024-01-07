{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-20OgLWrtw2QwyfoehoU7WjmH3IoOG4k3dAya5U5c7Qc=";
      hash_darwin_aarch64 =
        "sha256-7aI141Ndtun3HglNKiW4+TTVgOVASnz98Rn1trgUgpo=";
      hash_linux = "sha256-gJ6xXhW87URDvpFP88KgLKmwoFDlqMN1Vj6L+bDdbSc=";
      version = "120.0.6099.109";
    };
    deps = {
      gn = {
        hash = "sha256-dwluGOfq05swtBM5gg4a6gY3IpFHaKKkD0TV1XW7c7k=";
        rev = "e4702d7409069c4f12d45ea7b7f0890717ca3f4b";
        url = "https://gn.googlesource.com/gn";
        version = "2023-10-23";
      };
    };
    hash = "sha256-lT1CCwYj0hT4tCJb689mZwNecUsEwcfn2Ot8r9LBT+M=";
    hash_deb_amd64 = "sha256-4BWLn0+gYNWG4DsolbY6WlTvXWl7tZIZrnqXlrGUGjQ=";
    version = "120.0.6099.199";
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
        hash = "sha256-B1MNo8BdjMOmTvIr4uu3kg/MO1t+YLQz2S23L4Cye3E=";
        rev = "120.0.6099.199-1";
      };
    };
    hash = "sha256-lT1CCwYj0hT4tCJb689mZwNecUsEwcfn2Ot8r9LBT+M=";
    hash_deb_amd64 = "sha256-4BWLn0+gYNWG4DsolbY6WlTvXWl7tZIZrnqXlrGUGjQ=";
    version = "120.0.6099.199";
  };
}
