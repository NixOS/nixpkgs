{
  k3sVersion = "1.29.15+k3s1";
  k3sCommit = "35a47239188444222067c25cc096346adb20401f";
  k3sRepoSha256 = "0vynlcnmhhf82hr2rv01km5jyp2c2zb7872nnd8kzdxdw3jcqp7x";
  k3sVendorHash = "sha256-+es8ua7JuDnUXej6hqE1ooFS81NhuoYYuA2+4CgUOmU=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "1.7.26-k3s1";
  containerdSha256 = "0snz0i7xmnvs8bj7140q0lsxqdv835hksvk36baw71w5mbm1w1xz";
  criCtlVersion = "1.29.0-k3s1";
}
