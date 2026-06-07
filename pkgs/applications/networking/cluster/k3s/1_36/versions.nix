{
  k3sVersion = "1.36.1+k3s1";
  k3sCommit = "a9663261a7ff40522542485a6b2f81916b6d72f9";
  k3sRepoSha256 = "0788034bw5pl8ikfb16fvdhl8a3dhhfasrbafir6s9fb8q9h3z4z";
  k3sVendorHash = "sha256-jX/qoRhVLZy/25fdhp5NOiRSGEatV/acBbSpjhutAzU=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.2.3-k3s1";
  containerdSha256 = "0fn252icn082822r754i2bqd8rivhvjwkfk031a8g0vvw8rz46vj";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.36.0-k3s1";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s5";
  helmJobVersion = "v0.10.0-build20260513";
}
