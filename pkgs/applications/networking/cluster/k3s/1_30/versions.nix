{
  k3sVersion = "1.30.3+k3s1";
  k3sCommit = "f646604010affc6a1d3233a8a0870bca46bf80cf";
  k3sRepoSha256 = "1sqa4cx5rihrqcnriq7if7sm4hx73ma975yyr5k9nvhg71dvlig3";
  k3sVendorHash = "sha256-HMlYdWDUoELpwsfCtyCxVIcFULdvu5gna83lc79AUWc=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.14.0";
  k3sRootSha256 = "15cs9faw3jishsb5nhgmb5ldjc47hkwf7hz2126fp8ahf80m0fcl";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.17-k3s1";
  containerdSha256 = "1j61mbgx346ydvnjd8b07wf7nmvvplx28wi5jjdzi1k688r2hxpf";
  criCtlVersion = "1.29.0-k3s1";
}
