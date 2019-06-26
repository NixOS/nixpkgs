let
  version     = "2.5.3";
  sha256      = "04z38ba4f1kmaa3d9b4gqz7dwr5blbppnkngw758xdm56772hfmj";
  cargoSha256 = "03dlzl96g8k02lifymwp1xs0b2mrnj5c1xzpwp014ijqlnzcfgsv";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
