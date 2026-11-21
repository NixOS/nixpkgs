# Contract types that nixpkgs defines.
# They are in `lib`, so that each module system can use them.
# Each file has the `meta` and the `interface` of one contract type.
{ lib, ... }:
lib.mapAttrs (_: file: import file { inherit lib; }) {
  fileSecrets = ./file-secrets.nix;
}
