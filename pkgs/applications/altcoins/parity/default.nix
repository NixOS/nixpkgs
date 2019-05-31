let
  version     = "2.4.6";
  sha256      = "0vfq1pyd92n60h9gimn4d5j56xanvl43sgxk9h2kb16amy0mmh3z";
  cargoSha256 = "04gi9vddahq1q207f83n3wriwdjnmmnby6mq4crdh7yx1p4b26m9";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
