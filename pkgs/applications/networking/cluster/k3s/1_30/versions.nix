{
  k3sVersion = "1.30.2+k3s2";
  k3sCommit = "faeaf1b01b2a708a46cae2a67c1b4d381ee1ba6b";
  k3sRepoSha256 = "0hy0f44hj5n5nscr0p52dbklvj2ki2vs7k0cgh1r8xlg4p6fn1b0";
  k3sVendorHash = "sha256-Mj9Q3TgqZoJluG4/nyuw2WHnB3OJ+/mlV7duzWt1B1A=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.13.0";
  k3sRootSha256 = "1jq5f0lm08abx5ikarf92z56fvx4kjpy2nmzaazblb34lajw87vj";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.17-k3s1";
  containerdSha256 = "1j61mbgx346ydvnjd8b07wf7nmvvplx28wi5jjdzi1k688r2hxpf";
  criCtlVersion = "1.29.0-k3s1";
}
