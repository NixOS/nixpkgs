{
  k3sVersion = "1.27.3+k3s1";
  k3sCommit = "fe9604cac119216e67f8bd5f14eb5608e3bcd3cf";
  k3sRepoSha256 = "09j940fcyg34ip04jjiwh5sv2l802jgvkpvlbnz4g6hdi7gipd8g";
  k3sVendorSha256 = "sha256-kodrl6fEsKPkxpOCfwzEONU2zhCHwg/xdyd+ajP26jc=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.2.0-k3s1";
  k3sCNISha256 = "0hzcap4vbl94zsiqc66dlwjgql50gw5g6f0adag0p8yqwcy6vaw2";
  containerdVersion = "1.7.1-k3s1";
  containerdSha256 = "00k7nkclfxwbzcgnn8s7rkrxyn0zpk57nyy18icf23wsj352gfrn";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
