let
  version     = "2.6.0";
  sha256      = "1v0wc6l09nr42ljlq5lq1dgignm53hq3pmrgp2sld9zfxy3vdy0x";
  cargoSha256 = "1bkcvziz0diy76nbcgykajpnp6akva0m7ka7q6w3s9k7awxjxkx3";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
