{
  k3sVersion = "1.27.1+k3s1";
  k3sCommit = "bc5b42c27908ab430101eff0db0a0b22f870bd7a";
  k3sRepoSha256 = "1xj3blfayrsfbcsljjdaswy49hhz8yiwf1d85arnsgbn8fidswpm";
  k3sVendorSha256 = "sha256-+sM2fjS88kxMQzra2t+jU1IaKCoJpW7p3w7lCOv5mMU=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.1";
  k3sRootSha256 = "0724yx3zk89m2239fmdgwzf9w672pik71xqrvgb7pdmknmmdn9f4";
  k3sCNIVersion = "1.1.1-k3s1";
  k3sCNISha256 = "14mb3zsqibj1sn338gjmsyksbm0mxv9p016dij7zidccx2rzn6nl";
  containerdVersion = "1.6.19-k3s1";
  containerdSha256 = "12dwqh77wplg30kdi73d90qni23agw2cwxjd2p5lchq86mpmmwwr";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
