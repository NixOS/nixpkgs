{
  k3sVersion = "1.26.14+k3s1";
  k3sCommit = "c7e6922aa84369b3c0d28bb800e67bb162895a1c";
  k3sRepoSha256 = "1spvyyzk711g4ik1pv21xaasy7va5l5gcvbfkamfv4ijn0wz4mjx";
  k3sVendorHash = "sha256-ursq2Vq1J9MdkwDl3kKioxizhR46yo2urNc3VpwVH2A=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.11-k3s2.26";
  containerdSha256 = "0413a81kzb05xkklwyngg8g6a0w4icsi938rim69jmr2sijc89ww";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
