{
  k3sVersion = "1.31.5+k3s1";
  k3sCommit = "56ec5dd4d012c1d77dc7f50f21f65183044c92e7";
  k3sRepoSha256 = "1926m0s380h2grqlar0pm7fyr71rjskq5wycrm1q97nypjxwpywh";
  k3sVendorHash = "sha256-EHHHrhRjvILDmNB/HxaqwwJTozvXyh/Py4t26xFc6bQ=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.23-k3s2";
  containerdSha256 = "0lp9vxq7xj74wa7hbivvl5hwg2wzqgsxav22wa0p1l7lc1dqw8dm";
  criCtlVersion = "1.31.0-k3s2";
}
