pkgargs@{ stdenv, lib, haskellPackages, writeText, gawk }:
let
  generic-fetcher =
    import ./generic-fetcher.nix pkgargs;
in

args@{ layerDigest, ... }:

generic-fetcher ({
  fetcher = "hocker-layer";
  name    = "docker-layer-${layerDigest}.tar.gz";
  tag     = "unused";
} // args)
