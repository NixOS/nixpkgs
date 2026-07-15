{
  pkgs ? import <nixpkgs> { },
}:

pkgs.runCommand "nix-required-mounts-structured-attrs-no-features" { __structuredAttrs = true; } ''
  touch $out
''
