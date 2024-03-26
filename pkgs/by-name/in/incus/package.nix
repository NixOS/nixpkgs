import ./generic.nix {
  hash = "sha256-tGuAS0lZvoYb+TvmCklQ8TADZhbm4w/lhdI0ycS4/0o=";
  version = "0.6.0";
  vendorHash = "sha256-+WmgLOEBJ/7GF596iiTgyTPxn8l+hE6RVqjLKfCi5rs=";
  patches = [
    # fix storage bug, fixed in > 0.6
    ./529.patch
  ];
}
