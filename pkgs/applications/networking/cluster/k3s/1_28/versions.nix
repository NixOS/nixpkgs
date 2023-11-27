{
  k3sVersion = "1.28.3+k3s2";
  k3sCommit = "bbafb86e91ae3682a1811119d136203957df9061";
  k3sRepoSha256 = "sha256-01uPKa3/d6awr44bqS0YlYMI38q33GHJo2K4ZS76c20=";
  k3sVendorHash = "sha256-DHj2rFc/ZX22uvr3HuZr0EvM2gbZSndPtNa5FYqv08o=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "sha256-M7Gkaq1I71HIjrNKousjWlN1GLunvqlriRaDMvK2Xr4=";
  k3sCNIVersion = "1.3.0-k3s1";
  k3sCNISha256 = "sha256-WyWWWo/RVfx60vaPI03BVsxVQqd9AP1i0tC2zclLqn4=";
  containerdVersion = "1.7.7-k3s1";
  containerdSha256 = "sha256-shM8wJgMzSE6jrMADoG89lNAR2lBKj/6AzoMppZTvSE=";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
