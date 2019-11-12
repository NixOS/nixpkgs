let
  version     = "2.6.4";
  sha256      = "11l93w97961zig4gqf345j9l20g0mjp7fayl1mdwdp14hhd5zk5g";
  cargoSha256 = "1q6cbms7j1h726bvq38npxkjkmz14b5ir9c4z7pb0jcy7gkplyxx";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
