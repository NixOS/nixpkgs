{ fetchpatch }:
{
  hash = "sha256-tGuAS0lZvoYb+TvmCklQ8TADZhbm4w/lhdI0ycS4/0o=";
  version = "0.6.0";
  vendorHash = "sha256-+WmgLOEBJ/7GF596iiTgyTPxn8l+hE6RVqjLKfCi5rs=";
  patches = [
    (fetchpatch {
      url = "https://github.com/lxc/incus/pull/529.patch";
      hash = "sha256-2aaPrzW/LVJidWeom0rqYOGpT2gvuV1yHLJN/TwQ1fk=";
    })
  ];
}
