let
  version     = "1.10.0";
  sha256      = "0dmdd7qa8lww5bzcdn25nkyz6334irh8hw0y1j0yc2pmd2dny99g";
  cargoSha256 = "0whkjbaq40mqva1ayqnmz2ppqjrg35va93cypx1al41rsp1yc37m";
  patches     = [ ./patches/vendored-sources-1.10.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
