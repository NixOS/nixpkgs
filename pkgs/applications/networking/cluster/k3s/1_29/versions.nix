{
  k3sVersion = "1.29.6+k3s1";
  k3sCommit = "83ae095ab9197f168a6bd3f6bd355f89bce39a9c";
  k3sRepoSha256 = "0gv7xh08mhgc2cyzpsvdi69xknifcpdy6znbim6r3r4lbcw2bkl9";
  k3sVendorHash = "sha256-OiZLUjQUCwso+NHg3aOrXx6/HSFOfwtzwVmLr/Fjfpw=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.13.0";
  k3sRootSha256 = "1jq5f0lm08abx5ikarf92z56fvx4kjpy2nmzaazblb34lajw87vj";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.17-k3s1";
  containerdSha256 = "1j61mbgx346ydvnjd8b07wf7nmvvplx28wi5jjdzi1k688r2hxpf";
  criCtlVersion = "1.29.0-k3s1";
}
