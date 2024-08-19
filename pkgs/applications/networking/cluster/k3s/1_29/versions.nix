{
  k3sVersion = "1.29.7+k3s1";
  k3sCommit = "f246bbc390a05f45431e49617b58013fe06a460d";
  k3sRepoSha256 = "0fv628rxxavqmb2gv0ncsx4m8ghn3v6ddn2n06x8q4ar27d9gijg";
  k3sVendorHash = "sha256-pAOyGgEaO6ewNv+6yhDt83NZl95rmLseFUs4vlXNH6Q=";
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
