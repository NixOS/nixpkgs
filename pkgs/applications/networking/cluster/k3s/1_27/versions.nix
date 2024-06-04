{
  k3sVersion = "1.27.14+k3s1";
  k3sCommit = "b0b34e4d927369147a37f95ee8ba6441e4b4102b";
  k3sRepoSha256 = "0vvglvh8hl83jrpn9i2fgbck6cp7fbbwn292w76nmckmpclm47ap";
  k3sVendorHash = "sha256-eDzBpvaK1rHp28A5zvSsxnk0CNhy4oBSifBT98M7JWc=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.15-k3s1.27";
  containerdSha256 = "0bjxw174prhq8izmgrmpyljfxzrj0lh5d0w04g3lyn0rp3kwxqsl";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
