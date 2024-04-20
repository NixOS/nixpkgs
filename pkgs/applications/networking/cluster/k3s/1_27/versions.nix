{
  k3sVersion = "1.27.12+k3s1";
  k3sCommit = "78ad57567c9eb1fd1831986f5fd7b4024add1767";
  k3sRepoSha256 = "1j6xb3af4ypqq5m6a8x2yc2515zvlgqzfsfindjm9cbmq5iisphq";
  k3sVendorHash = "sha256-65cmpRwD9C+fcbBSv1YpeukO7bfGngsLv/rk6sM59gU=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.11-k3s2.27";
  containerdSha256 = "0xjxc5dgh3drk2glvcabd885damjffp9r4cs0cm1zgnrrbhlipra";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
