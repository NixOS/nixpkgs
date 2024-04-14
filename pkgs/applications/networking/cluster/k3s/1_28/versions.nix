{
  k3sVersion = "1.28.8+k3s1";
  k3sCommit = "653dd61aaa2d0ef8bd83ac4dbc6d150dde792efc";
  k3sRepoSha256 = "0pf8xw1m56m2s8i99vxj4i2l7fz7388kiynwzfrck43jb7v7kbbw";
  k3sVendorHash = "sha256-wglwRW2RO9QJI6CRLgkVg5Upt6R0M3gX76zy0kT02ec=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.11-k3s2";
  containerdSha256 = "0279sil02wz7310xhrgmdbc0r2qibj9lafy0i9k24jdrh74icmib";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
