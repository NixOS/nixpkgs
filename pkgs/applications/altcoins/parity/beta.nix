let
  version     = "1.10.2";
  sha256      = "1a1rbwlwi60nfv6m1rdy5baq5lcafc8nw96y45pr1674i48gkp0l";
  cargoSha256 = "0l3rjkinzppfq8fi8h24r35rb552fzzman5a6yk33wlsdj2lv7yh";
  patches     = [ ./patches/vendored-sources-1.10.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
