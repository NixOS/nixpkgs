let
  version     = "1.10.7";
  sha256      = "0syhvr4n9zyxhx20xln7sf70ljzj6ab36xjz4710ivnwwz2pjajf";
  cargoSha256 = "0zwk8xv71s7xkwvssh27772qfb23yhq5jlcny617qik6bwpcdh6b";
  patches     = [ ./patches/vendored-sources-1.10.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
