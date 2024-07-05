{
  pkgs ? import <nixpkgs> { },
}:

pkgs.runCommandNoCC "nix-required-mounts-structured-attrs-no-features" { __structuredAttrs = true; }
  ''
    touch $out
  ''
