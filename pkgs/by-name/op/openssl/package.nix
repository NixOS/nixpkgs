{
  mkPackageVariants,
  ...
}@args:

mkPackageVariants args {
  # intended version "policy":
  # - 1.1 as long as some package exists, which does not build without it
  #   (tracking issue: https://github.com/NixOS/nixpkgs/issues/269713)
  #   try to remove in 24.05 for the first time, if possible then
  # - latest 3.x LTS
  # - latest 3.x non-LTS as preview/for development
  #
  # - other versions in between only when reasonable need is stated for some package
  # - backport every security critical fix release e.g. 3.0.y -> 3.0.y+1 but no new version, e.g. 3.1 -> 3.2
  defaultVariant = p: p.v3_6;
}
