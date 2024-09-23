{
  k3sVersion = "1.29.8+k3s1";
  k3sCommit = "33fdc35dd67cf6c07989327e992fd26ed89b2449";
  k3sRepoSha256 = "0ky5f039nkhdj6y5v9yr6lk875l29c67j6kqc2dzdb3iqbwskcbr";
  k3sVendorHash = "sha256-VxVGBvpeKf/nuw09Llf85d4P8oCD2GvD1f0Mxt6fMj8=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.20-k3s1";
  containerdSha256 = "12ihr3z8vcglv5b0v9ris29zkkkdvjbcp3bf7ym71a0xdbg83s8i";
  criCtlVersion = "1.29.0-k3s1";
}
