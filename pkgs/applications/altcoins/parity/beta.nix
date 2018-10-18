let
  version     = "2.0.3";
  sha256      = "1yf3ln4ksk8613kqkpsh16cj8xwx761q6czy57rs8kfh7pgc2pzb";
  cargoSha256 = "1jayk4ngwbg0rv7x1slkl2z46czgy2hnfcxc0dhaz4xpbp2bjqq8";
  patches     = [ ./patches/vendored-sources-2.0.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
