{
  k3sVersion = "1.32.11+k3s1";
  k3sCommit = "8119508834f2503e3c7bace3125f5db6b038d377";
  k3sRepoSha256 = "0fni4sh3a5flyrli7xxd9zxj9sh75kv79msy3zkfbgjxqz7rg4v9";
  k3sVendorHash = "sha256-8gzvad5Cpkatc8158m9FBGnkGEbajn30alSPlzhor0E=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.8.0-k3s1";
  k3sCNISha256 = "04xig5spp81l81781ixmk99ghiz8lk0p16zhcbja5mslfdjmc7vg";
  containerdVersion = "2.1.5-k3s1.32";
  containerdSha256 = "1fzld9q0ycfg9b3054qg70mif1p6i7xqikcbabrmxapk81fy83kn";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.31.0-k3s2";
  flannelVersion = "v0.27.4";
  flannelPluginVersion = "v1.8.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s2.32";
  helmJobVersion = "v0.9.12-build20251215";
}
