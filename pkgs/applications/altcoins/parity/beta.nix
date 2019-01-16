let
  version     = "2.3.0";
  sha256      = "0v79nz19riaga6iwj6m59fq8adm5llrkq61xizriz30rw8rkk04z";
  cargoSha256 = "01vdrfqh2nlghbgnbb7qmrazsjmynrb9542qrgchxq589wasb4j2";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
