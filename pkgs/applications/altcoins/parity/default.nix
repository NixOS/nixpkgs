let
  version     = "2.2.9";
  sha256      = "0n9zk25ni4asfdqc4xh0gqp2446vxacqz7qcrmsngf8swvayvi16";
  cargoSha256 = "10lg0vzikzlj927hpn59x1dz9dvhcaqsl8nz14vj2iz42vfkcm7p";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
