{
  k3sVersion = "1.28.13+k3s1";
  k3sCommit = "47737e1c4c941325574e8aa14e4a3af2e596f696";
  k3sRepoSha256 = "1x66n36lxcvi5d9bdz0f1w2p24493rh3vbk1pskqd1f3v3fbv7kn";
  k3sVendorHash = "sha256-/knBr0l7dZ6lX9QpohyPNrFEi4WQpNM01zOE5bCIB2E=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.20-k3s2.28";
  containerdSha256 = "0jqqa9202d94qd7g8d5zy161snlsc42cdjpmp50w4j3pnp2i1cki";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
