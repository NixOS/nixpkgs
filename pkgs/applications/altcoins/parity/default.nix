let
  version     = "2.2.7";
  sha256      = "0bxq4z84vsb8hmbscr41xiw11m9xg6if231v76c2dmkbyqgpqy8p";
  cargoSha256 = "1izwqg87qxhmmkd49m0k09i7r05sfcb18m5jbpvggjzp57ips09r";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
