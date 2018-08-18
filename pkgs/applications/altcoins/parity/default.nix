let
  version     = "1.11.8";
  sha256      = "0qk5vl8ql3pr9pz5iz7whahwqi1fcbsf8kphn6z4grgc87id7b19";
  cargoSha256 = "0p2idd36cyzp2ax81k533bdma4hz0ws2981qj2s7jnhvmj4941l8";
  patches     = [ ./patches/vendored-sources-1.11.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
