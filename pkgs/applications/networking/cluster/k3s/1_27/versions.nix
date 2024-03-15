{
  k3sVersion = "1.27.11+k3s1";
  k3sCommit = "06d6bc80b469a61e5e90438b1f2639cd136a89e7";
  k3sRepoSha256 = "0qkm8yqs9p34kb5k2q0j5wiykj78qc12n65n0clas5by23jrqcqa";
  k3sVendorHash = "sha256-+z8pr30+28puv7yjA7ZvW++I0ipNEmen2OhCxFMzYOY=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.11-k3s2.27";
  containerdSha256 = "0xjxc5dgh3drk2glvcabd885damjffp9r4cs0cm1zgnrrbhlipra";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
