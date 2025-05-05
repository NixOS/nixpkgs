{
  k3sVersion = "1.30.11+k3s1";
  k3sCommit = "c2662fbee6d24b3917cf078cbf2ff69cae501340";
  k3sRepoSha256 = "0zsl5p2dmj3mkcjxbrhsa40r8bhgcrql8r8cxach4nv6y7fcyan5";
  k3sVendorHash = "sha256-G7RUyFzg3B4X0tdKmD1ep9a4cnVkUmFqBP5t1s8uFLc=";
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
