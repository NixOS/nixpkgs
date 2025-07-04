pkgargs@{
  stdenv,
  lib,
  haskellPackages,
  writeText,
  gawk,
}:
let
  generic-fetcher = import ./generic-fetcher.nix pkgargs;
in

args@{
  repository ? "library",
  imageName,
  tag,
  ...
}:

generic-fetcher (
  {
    fetcher = "hocker-config";
    name = "${repository}_${imageName}_${tag}-config.json";
    tag = "unused";
  }
  // args
)
