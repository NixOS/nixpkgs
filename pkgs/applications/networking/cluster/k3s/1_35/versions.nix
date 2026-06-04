{
  k3sVersion = "1.35.5+k3s1";
  k3sCommit = "6a4781ad53ee5cad273bedcd9462ae36ac97d798";
  k3sRepoSha256 = "1m6sy7p5v3kkg66mzsna9c4d1f7ly843ii42zmb2a26vxa0dicx3";
  k3sVendorHash = "sha256-czE0ZJ9yWc3VSuPqjy4V+ViBGPriluMPmUK5aTk4DmY=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.9.1-k3s1";
  k3sCNISha256 = "1ggaz0p1c2k94car9d89a05smz3zx32sxn197b1l5kmjcnzdwadh";
  containerdVersion = "2.2.3-k3s1";
  containerdSha256 = "0fn252icn082822r754i2bqd8rivhvjwkfk031a8g0vvw8rz46vj";
  containerdPackage = "github.com/k3s-io/containerd/v2";
  criCtlVersion = "1.35.0-k3s2";
  flannelVersion = "v0.28.4";
  flannelPluginVersion = "v1.9.0-flannel1";
  kubeRouterVersion = "v2.6.3-k3s1";
  criDockerdVersion = "v0.3.19-k3s3";
  helmJobVersion = "v0.10.0-build20260513";
}
