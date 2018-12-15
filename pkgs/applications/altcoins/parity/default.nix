let
  version     = "2.1.9";
  sha256      = "1xxpv2cxfcjwxfxkn2732y1wxh9rpiwmlb2ij09cg5nph669hy0v";
  cargoSha256 = "1v44l90bacw8d3ilnmrc49dxdpyckh7iamylkpa1pc0rrpiv5vy4";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
