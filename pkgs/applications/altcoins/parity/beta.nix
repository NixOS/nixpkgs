let
  version     = "1.9.4";
  sha256      = "00b6wsyc2chmdkhfhi9h1i06hpcjj2abcx3qdc6k39clgha0081f";
  cargoSha256 = "0pyb1mpykdp6i7c30lm5fprrxg3zanak44g28cygzli3l9l3xiy3";
  patches     = [ ./patches/vendored-sources-1.9.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
