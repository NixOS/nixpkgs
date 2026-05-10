{
  k3sVersion = "1.34.7+k3s1";
  k3sCommit = "757f14939dd335fb5d7a839a9980382da9cdedf7";
  k3sRepoSha256 = "0f4mp23hnn5w5km0ymj66vpjjdh6m0xkrs87lfpm0gf2j9ba1vn5";
  k3sVendorHash = "sha256-MrWZp43SVKWboUs3RasZXBmZD3dDYWWZewKbXkJvsiA=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.2.3-k3s1";
  containerdSha256 = "0fn252icn082822r754i2bqd8rivhvjwkfk031a8g0vvw8rz46vj";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.34.0-k3s2";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s3";
  helmJobVersion = "v0.9.17-build20260422";
}
