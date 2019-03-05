let
  version     = "2.3.8";
  sha256      = "06byk9fh9hcxy6cvqf379l898ry0wr2lw7kw03z7w68gcfkrcxgv";
  cargoSha256 = "09rpmybasn71cb59myd0l19djy0j8cxs9m5d3l6nylhgpy8qilcg";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
