{ lib, stdenv, callPackage }:

let
  k3s_builder = import ./builder.nix;
in
{
  k3s_1_26 = (callPackage k3s_builder { }) {
    k3sVersion = "1.26.4+k3s1";
    k3sCommit = "8d0255af07e95b841952563253d27b0d10bd72f0";
    k3sRepoSha256 = "0qlszdnlsvj3hzx2p0wl3zhaw908w8a62z6vlf2g69a3c75f55cs";
    k3sVendorSha256 = "sha256-JXTsZYtTspu/pWMRSS2BcegktawBJ6BK7YEKbz1J/ao=";
    chartVersions = import ./1_26/chart-versions.nix;
    k3sRootVersion = "0.12.1";
    k3sRootSha256 = "0724yx3zk89m2239fmdgwzf9w672pik71xqrvgb7pdmknmmdn9f4";
    k3sCNIVersion = "1.1.1-k3s1";
    k3sCNISha256 = "14mb3zsqibj1sn338gjmsyksbm0mxv9p016dij7zidccx2rzn6nl";
    containerdVersion = "1.6.19-k3s1";
    containerdSha256 = "12dwqh77wplg30kdi73d90qni23agw2cwxjd2p5lchq86mpmmwwr";
    criCtlVersion = "1.26.0-rc.0-k3s1";
  };

  # 1_27 can be built with the same builder as 1_26
  k3s_1_27 = (callPackage k3s_builder { }) (import ./1_27/versions.nix) // {
    updateScript = ./1_27/update-script.sh;
  };
}
