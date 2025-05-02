{
  k3sVersion = "1.28.9+k3s1";
  k3sCommit = "289a1a3edbc0f6ee5a7f91bf96aa1ed1b743bd1f";
  k3sRepoSha256 = "0kms6r10k6v037r5lxxrp90bnynrgyrn61kqnzy2f5avny4blikh";
  k3sVendorHash = "sha256-iUp2Maua3BnrC4Jq2ij0uOW5gYYZfz6e+TEdDtN0PT8=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.15-k3s1";
  containerdSha256 = "18hlj4ixjk7wvamfd66xyc0cax2hs9s7yjvlx52afxdc73194y0f";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
