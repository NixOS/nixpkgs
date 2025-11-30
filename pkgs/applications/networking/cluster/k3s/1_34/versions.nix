{
  k3sVersion = "1.34.2+k3s1";
  k3sCommit = "8dac81b2a24e78ce4cf951c7788ea6a8d4a59aa7";
  k3sRepoSha256 = "1nwh1aggxvjv99kz1zkklim7jqsn0d44g8905653gkfpk0givghq";
  k3sVendorHash = "sha256-IJi5gVxBsAjeQHi5rQpNRvWOXuNPx2Rtsy18VL+2Yxo=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.8.0-k3s1";
  k3sCNISha256 = "04xig5spp81l81781ixmk99ghiz8lk0p16zhcbja5mslfdjmc7vg";
  containerdVersion = "2.1.5-k3s1";
  containerdSha256 = "0n0g58d352i8wz0bqn87vgrd7z54j268cbmbp19fz68wmifm7fl8";
  criCtlVersion = "1.34.0-k3s2";
}
