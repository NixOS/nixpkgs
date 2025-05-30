{
  k3sVersion = "1.33.1+k3s1";
  k3sCommit = "99d91538b1327da933356c318dc8040335fbb66c";
  k3sRepoSha256 = "1ncj30nid3x96irw2raxf1naa2jap1d0s1ygxsvfckblbb6rjnmx";
  k3sVendorHash = "sha256-jrPVY+FVZV9wlbik/I35W8ChcLrHlYbLAwUYU16mJLM=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.1";
  k3sRootSha256 = "0svbi42agqxqh5q2ri7xmaw2a2c70s7q5y587ls0qkflw5vx4sl7";
  k3sCNIVersion = "1.6.0-k3s1";
  k3sCNISha256 = "0g7zczvwba5xqawk37b0v96xysdwanyf1grxn3l3lhxsgjjsmkd7";
  containerdVersion = "2.0.5-k3s1";
  containerdSha256 = "1c3hv22zx8y94zwmv5r59bnwgqyhxd10zkinm0jrcvny32ijqdfj";
  criCtlVersion = "1.31.0-k3s2";
}
