{
  k3sVersion = "1.29.3+k3s1";
  k3sCommit = "8aecc26b0f167d5e9e4e9fbcfd5a471488bf5957";
  k3sRepoSha256 = "12285mhwi6cifsw3gjxxmd1g2i5f7vkdgzdc6a78rkvnx7z1j3p3";
  k3sVendorHash = "sha256-pID2h/rvvKyfHWoglYPbbliAby+9R2zoh7Ajd36qjVQ=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.11-k3s2";
  containerdSha256 = "0279sil02wz7310xhrgmdbc0r2qibj9lafy0i9k24jdrh74icmib";
  criCtlVersion = "1.29.0-k3s1";
}
