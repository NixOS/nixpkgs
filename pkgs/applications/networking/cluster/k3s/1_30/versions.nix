{
  k3sVersion = "1.30.12+k3s1";
  k3sCommit = "f9dbf16e17a6db90b64583316d9c321180e9c062";
  k3sRepoSha256 = "0d0kbbf6c6gv2s0w8m7br6vxcid48g8hirmszksd3g4brix3yxz2";
  k3sVendorHash = "sha256-FQu2Chk463c+/VYcOhfU8xIxm/ZNe1GumkEH/u2DIt0=";
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
