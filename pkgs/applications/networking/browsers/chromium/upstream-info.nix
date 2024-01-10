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
    hash = "sha256-+T2TOLwIwFxVDae7MFDZrjREGF+3Zx2xt/Dlu7uZggc=";
    hash_deb_amd64 = "sha256-0FB1gTbsjqFRy0ocE0w5ACtD9kSJ5AMnxg+qBxqCulc=";
    version = "120.0.6099.129";
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
        hash = "sha256-kVhAa/+RnYEGy7McysqHsb3ysPIILnxGXe6BTLbioQk=";
        rev = "120.0.6099.129-1";
      };
    };
    hash = "sha256-+T2TOLwIwFxVDae7MFDZrjREGF+3Zx2xt/Dlu7uZggc=";
    hash_deb_amd64 = "sha256-0FB1gTbsjqFRy0ocE0w5ACtD9kSJ5AMnxg+qBxqCulc=";
    version = "120.0.6099.129";
  };
}
