{
  pkgs ? (import ../ci { }).pkgs,
  nixpkgs ? { },
}:

let
  bundledModularServiceNames = import ../pkgs/top-level/modular-services-bundled.nix;
  bundledModularServiceModules = pkgs.lib.genAttrs bundledModularServiceNames (
    name: pkgs.${name}.services
  );
in
pkgs.callPackage ./doc-support/package.nix { inherit nixpkgs bundledModularServiceModules; }
