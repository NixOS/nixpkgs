{
  k3sVersion = "1.29.6+k3s2";
  k3sCommit = "b4b156d9d14eeb475e789718b3a6b78aba00019e";
  k3sRepoSha256 = "0wagfh4vbvyi62np6zx7b4p6myn0xavw691y78rnbl32jckiy14f";
  k3sVendorHash = "sha256-o36gf3q7Vv+RoY681cL44rU2QFrdFW3EbRpw3dLcVTI=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.13.0";
  k3sRootSha256 = "1jq5f0lm08abx5ikarf92z56fvx4kjpy2nmzaazblb34lajw87vj";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.17-k3s1";
  containerdSha256 = "1j61mbgx346ydvnjd8b07wf7nmvvplx28wi5jjdzi1k688r2hxpf";
  criCtlVersion = "1.29.0-k3s1";
}
