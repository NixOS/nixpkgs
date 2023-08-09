{
  k3sVersion = "1.27.4+k3s1";
  k3sCommit = "36645e7311e9bdbbf2adb79ecd8bd68556bc86f6";
  k3sRepoSha256 = "0nvh66c4c01kcz63vk2arh0cd9kcss7c83r92ds6f15x1fxv1w3z";
  k3sVendorSha256 = "sha256-azHl2jv/ioI7FVWpgtp7a1dmO9Dlr4CnRmGCIh5Biyg=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.2.0-k3s1";
  k3sCNISha256 = "0hzcap4vbl94zsiqc66dlwjgql50gw5g6f0adag0p8yqwcy6vaw2";
  containerdVersion = "1.7.1-k3s1";
  containerdSha256 = "00k7nkclfxwbzcgnn8s7rkrxyn0zpk57nyy18icf23wsj352gfrn";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
