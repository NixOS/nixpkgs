{
  k3sVersion = "1.30.5+k3s1";
  k3sCommit = "9b586704a211264ca86b22f2a0b4617b00412235";
  k3sRepoSha256 = "1fzpkfbk2x9xw9js9ns15g84c7q93knwx7fdmdj4af3830kplnnr";
  k3sVendorHash = "sha256-fs9p6ywS5XCeJSF5ovDG40o+H4p4QmEJ0cvU5T9hwuA=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.5.1-k3s1";
  k3sCNISha256 = "1bkz78p77aiw64hdvmlgc5zir9x8zha8qprfaab48jxbcsj3dfi7";
  containerdVersion = "1.7.21-k3s2";
  containerdSha256 = "0kp93fhmw2kiy46hw3ag05z8xwhw7kqp4wcbhsxshsdf0929g539";
  criCtlVersion = "1.29.0-k3s1";
}
