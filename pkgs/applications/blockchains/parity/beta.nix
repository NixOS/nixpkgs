let
  version     = "2.6.1";
  sha256      = "0yvscs2ivy08zla3jhirxhwwaqsn9j5ml4sqbgx6h5rh19c941vh";
  cargoSha256 = "1s3c44cggajrmc504klf4cyb1s4l5ny48yihs9c3fc0n8d064017";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
