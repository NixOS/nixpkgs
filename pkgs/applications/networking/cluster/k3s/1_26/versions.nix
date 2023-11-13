{
  k3sVersion = "1.26.6+k3s1";
  k3sCommit = "3b1919b0d55811707bd1168f0abf11cccc656c26";
  k3sRepoSha256 = "1g82bkq4w0jpfn1fanj1d24bj46rw908wk50p3cm47rqiqlys72y";
  k3sVendorHash = "sha256-+a9/q5a28zA9SmAdp2IItHR1MdJvlbMW5796bHTfKBw=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.12.2";
  k3sRootSha256 = "1gjynvr350qni5mskgm7pcc7alss4gms4jmkiv453vs8mmma9c9k";
  k3sCNIVersion = "1.2.0-k3s1";
  k3sCNISha256 = "0hzcap4vbl94zsiqc66dlwjgql50gw5g6f0adag0p8yqwcy6vaw2";
  containerdVersion = "1.7.1-k3s1";
  containerdSha256 = "00k7nkclfxwbzcgnn8s7rkrxyn0zpk57nyy18icf23wsj352gfrn";
  criCtlVersion = "1.26.0-rc.0-k3s1";
}
