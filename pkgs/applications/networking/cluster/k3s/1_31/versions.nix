{
  k3sVersion = "1.31.14+k3s1";
  k3sCommit = "a2ef79f53538e58982857c1820469792d582e470";
  k3sRepoSha256 = "0rww4z63vf13g3rssqfmp9444bs1mzb1y6wddysqfxj8fm3kakwl";
  k3sVendorHash = "sha256-FBNHUk04m8El4oTyJMznv8eyT8DSt5Q3ypqL9qT/WDU=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.8.0-k3s1";
  k3sCNISha256 = "04xig5spp81l81781ixmk99ghiz8lk0p16zhcbja5mslfdjmc7vg";
  containerdVersion = "2.1.5-k3s1.32";
  containerdSha256 = "1fzld9q0ycfg9b3054qg70mif1p6i7xqikcbabrmxapk81fy83kn";
  criCtlVersion = "1.31.0-k3s2";
}
