{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // {
  version = "1.4.111";
  sha256s = {
    "x86_64-linux" = "0bw3ds3ndcnkry5mpv645z2bfi5z387bh0f7b35blxq1yv93r83f";
    "i686-linux"   = "1qwaj7l7nsd4afx7ksb4b1c22mki9qa40803v9x1a8bhbdfhkczk";
  };
})
