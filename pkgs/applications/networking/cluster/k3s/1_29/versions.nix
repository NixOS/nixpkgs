{
  k3sVersion = "1.29.12+k3s1";
  k3sCommit = "ab3818c6169fb022c1fb74b8646d8d724a0f6030";
  k3sRepoSha256 = "10lmva3wwpzymm5lf65gg7ixbz5vdbpagb1ghbc4r8v50ack0cvf";
  k3sVendorHash = "sha256-s49GPwMPkF38NTj/aZ1aMliT/Msa1BMS9fmfqcp0//s=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.23-k3s2";
  containerdSha256 = "0lp9vxq7xj74wa7hbivvl5hwg2wzqgsxav22wa0p1l7lc1dqw8dm";
  criCtlVersion = "1.29.0-k3s1";
}
