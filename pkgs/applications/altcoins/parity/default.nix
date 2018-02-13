let
  version     = "1.8.9";
  sha256      = "0pqr85rlbi001swp16p5rqhmhqn0fbdb6cldg3idzplhnh82hhrp";
  cargoSha256 = "1d8j9hlnks0yph1l2ny7dw05ha0dg2w22sznms9xwz7rgh44k6c9";
  patches     = [ ./patches/vendored-sources-1.8.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
