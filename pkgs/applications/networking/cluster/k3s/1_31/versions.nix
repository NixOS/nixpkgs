{
  k3sVersion = "1.31.9+k3s1";
  k3sCommit = "812206503b2874c703dcc93c5d6baa5ffc745930";
  k3sRepoSha256 = "0cknigj3cx5ndh5n15nymzmr8xgsr7is5hbi923n6h2q5bjm12q4";
  k3sVendorHash = "sha256-ojzoxqtVYSmw5gZk+0W4V5ImRcXX451QauIFNR9j9eY=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "2.0.5-k3s1.32";
  containerdSha256 = "1la7ygx5caqfqk025wyrxmhjb0xbpkzwnxv52338p33g68sb3yb0";
  criCtlVersion = "1.31.0-k3s2";
}
