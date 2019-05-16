let
  version     = "2.5.0";
  sha256      = "1dsckybjg2cvrvcs1bya03xymcm0whfxcb1v0vljn5pghyazgvhx";
  cargoSha256 = "0z7dmzpqg0qnkga7r4ykwrvz8ds1k9ik7cx58h2vnmhrhrddvizr";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
