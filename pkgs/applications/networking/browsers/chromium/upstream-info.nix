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
    hash = "sha256-yqk0bh68onWqML20Q8eDsTT9o+eKtta7kS9HL74do6Q=";
    hash_deb_amd64 = "sha256-MxIyOXssQ1Ke5WZbBbB4FpDec+rn46m8+PbMdmxaQCA=";
    version = "120.0.6099.216";
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
        hash = "sha256-qB1OrsfRCWfobKAAfcYJFmKc36ofF+VmjqPNbIPugJA=";
        rev = "120.0.6099.216-1";
      };
    };
    hash = "sha256-yqk0bh68onWqML20Q8eDsTT9o+eKtta7kS9HL74do6Q=";
    hash_deb_amd64 = "sha256-MxIyOXssQ1Ke5WZbBbB4FpDec+rn46m8+PbMdmxaQCA=";
    version = "120.0.6099.216";
  };
}
