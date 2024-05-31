{
  k3sVersion = "1.27.13+k3s1";
  k3sCommit = "b23f142da8589854cc7ee45da08d96b5ad1ee1ff";
  k3sRepoSha256 = "052998644il0qra7cdpvmy007gw16k2rvyg418m1j02pm9a3zn10";
  k3sVendorHash = "sha256-rQZZnleRekkU1+I38LmFnnatZPuS+K1jbBwA+Dmc0jo=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.15-k3s1.27";
  containerdSha256 = "0bjxw174prhq8izmgrmpyljfxzrj0lh5d0w04g3lyn0rp3kwxqsl";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
