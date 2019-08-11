let
  version     = "2.4.9";
  sha256      = "0pj3yyjzc3fq0r7g8j22anzqxvm377pbcy27np1g7ygkzapzb2v6";
  cargoSha256 = "1dxn00zxivmgk4a61nxwhjlv7fjsy2ngadyw0br1ssrkgz9k7af2";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
