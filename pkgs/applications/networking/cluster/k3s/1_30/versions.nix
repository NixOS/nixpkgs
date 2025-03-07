{
  k3sVersion = "1.30.10+k3s1";
  k3sCommit = "b86a69470cd71af521a4b71499db74a600049f70";
  k3sRepoSha256 = "1k6msdfx9c4hwwq766yq99km48ck2p1ga2srrc13g17marn81vsr";
  k3sVendorHash = "sha256-HTUFv8WBIDiBQ860p3RiROF+kDzBekvgBAr2TJh036E=";
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
