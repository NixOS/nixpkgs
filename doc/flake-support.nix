{ lib, imports, ... }:
{
  outputs.htmlDocs.nixpkgsManual = lib.mapAttrs (_: jobSet: jobSet.manual) imports.pkgs.jobs;
}
