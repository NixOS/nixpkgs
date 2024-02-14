{
  k3sVersion = "1.28.6+k3s1";
  k3sCommit = "39a0001575780fffa6aae0271f4cb4ce7413aac8";
  k3sRepoSha256 = "1bhbpbgs02gh5y7pgn6vmanacrz3p0b2gq3w2kqpb11bijp2alld";
  k3sVendorHash = "sha256-Mo+gZ+NOZqd3CP/Z02LfO4dHyEuRhabZVAU60GofOMo=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "0zma9g4wvdnhs9igs03xlx15bk2nq56j73zns9xgqmfiixd9c9av";
  containerdVersion = "1.7.11-k3s2";
  containerdSha256 = "0279sil02wz7310xhrgmdbc0r2qibj9lafy0i9k24jdrh74icmib";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
