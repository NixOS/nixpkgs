let
  version     = "1.9.7";
  sha256      = "1h9rmyqkdv2v83g12dadgqflq1n1qqgd5hrpy20ajha0qpbiv3ph";
  cargoSha256 = "0ss5jw43850r8l34prai5vk1zd5d5fjyg4rcav1asbq6v683bww0";
  patches     = [ ./patches/vendored-sources-1.9.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
