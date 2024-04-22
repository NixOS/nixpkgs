{
  k3sVersion = "1.26.15+k3s1";
  k3sCommit = "132972364806998c35d250153e2af245f9ecf18d";
  k3sRepoSha256 = "13iwmjxyf71l2g66kxdivnj21bf9lmr5p4qlp8kmysm23w2badj9";
  k3sVendorHash = "sha256-xoscRchOK4p3d1DAnxbJq7oIvxIn1twePmOBDdfXzw8=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.11-k3s2.26";
  containerdSha256 = "0413a81kzb05xkklwyngg8g6a0w4icsi938rim69jmr2sijc89ww";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
