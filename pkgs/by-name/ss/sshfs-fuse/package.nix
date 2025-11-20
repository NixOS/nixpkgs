{
  lib,
  callPackage,
  fetchpatch,
}:

let
  mkSSHFS = args: callPackage (import ./common.nix args) { };
in
mkSSHFS {
  version = "3.7.3";
  sha256 = "0s2hilqixjmv4y8n67zaq374sgnbscp95lgz5ignp69g3p1vmhwz";
  # Fix build with macFUSE + libfuse 3.x
  patches = [
    (fetchpatch {
      url = "https://github.com/libfuse/sshfs/commit/b1715a5a62d2747a410409926c4b2d13ae16255d.patch";
      hash = "sha256-9Pm6YbYU+IVCI9fuAJVRuNSWsIUh+ERcLrcsJhvs5tU=";
    })
    (fetchpatch {
      url = "https://github.com/libfuse/sshfs/commit/a9eb71cb1cfd1ae2bb9bd58e2405fde9bb9f5e75.patch";
      hash = "sha256-3B672WbFaz6XyhMxJjx5ShbD3Pts7sV26znz1DSt1rE=";
    })
    (fetchpatch {
      url = "https://github.com/libfuse/sshfs/commit/ed0825440c48895b7e20cc1440bbafd8d9c88eb8.patch";
      hash = "sha256-3skZIslqDZKUaux3vKijfMztrTFbi1XgWmTHQS0dpDo=";
    })
    (fetchpatch {
      url = "https://github.com/libfuse/sshfs/commit/ccb6821019c19600110af6750e0d2395a9401617.patch";
      hash = "sha256-zHKlk+Zc1DZiOOQwYsbSoXqcnY+da9LnnoXaTVNldOo=";
    })
  ];
  platforms = lib.platforms.darwin ++ lib.platforms.linux;
}
