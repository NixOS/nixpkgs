# collection of contract templates, defined in `lib` so we can still build the manual.
# declarations of individual contracts follow the type in `./definition-type.nix`.
{ lib, ... }:
lib.mapAttrs (_: path: import path { inherit lib; }) {
  fileSecrets = ./file-secrets.nix;
}
