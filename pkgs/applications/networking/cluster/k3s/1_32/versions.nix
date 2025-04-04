{
  k3sVersion = "1.32.3+k3s1";
  k3sCommit = "079ffa8d99fb859cb8c001455e47efa65535d832";
  k3sRepoSha256 = "1cvd0668ca06ahhmkhrxwymfpssw75rjfv5n9yajzg1dmkv0cmrv";
  k3sVendorHash = "sha256-1Kd6gt1envXmzFAtwhjPe9LLsllt2bQ7sryamGcaLRs=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "2.0.4-k3s2";
  containerdSha256 = "0v34nh6q0plb50s95gzdkrdfbbch7dps15fmddh5h241yfms8sq6";
  criCtlVersion = "1.31.0-k3s2";
}
