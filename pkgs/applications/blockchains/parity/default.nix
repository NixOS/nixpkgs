let
  version     = "2.5.9";
  sha256      = "06gmfw5l8n5i35dimsmj6dn0fxhbp53zjrdvbkff63r5kfqnwnx2";
  cargoSha256 = "1kdy0bnmyqx4rhpq0a8gliy6mws68n035kfkxrfa6cxr2cn53dyb";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
