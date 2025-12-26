{
  k3sVersion = "1.32.10+k3s1";
  k3sCommit = "1c5d65cec8e24f5238e2e0b21f0dac8c2f8d5db5";
  k3sRepoSha256 = "0wfh2m55dxfvf3m74jrwvpc21xxc17gwbifnkl9nyd8kha271876";
  k3sVendorHash = "sha256-PedpbkyP3XZ8yLlFo/VGjPlImYGOk5ebPYGivPR2Izg=";
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
