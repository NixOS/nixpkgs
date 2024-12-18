{
  k3sVersion = "1.30.1+k3s1";
  k3sCommit = "80978b5b9a97908c5520c5ee51984e544e168859";
  k3sRepoSha256 = "085dmq49iwvlxpj9c528nfrvd67snkgpm5drj8ahfjv1nkjp0yy1";
  k3sVendorHash = "sha256-XtTahFaWnuHzKDI/U4d/j4C4gRxH163MCGEEM4hu/WM=";
  chartVersions = import ./chart-versions.nix;
  k3sRootVersion = "0.13.0";
  k3sRootSha256 = "1jq5f0lm08abx5ikarf92z56fvx4kjpy2nmzaazblb34lajw87vj";
  k3sCNIVersion = "1.4.0-k3s2";
  k3sCNISha256 = "17dg6jgjx18nrlyfmkv14dhzxsljz4774zgwz5dchxcf38bvarqa";
  containerdVersion = "1.7.15-k3s1";
  containerdSha256 = "18hlj4ixjk7wvamfd66xyc0cax2hs9s7yjvlx52afxdc73194y0f";
  criCtlVersion = "1.29.0-k3s1";
}
