# collection of contract templates, defined in `lib` so we can still build the manual.
# declarations of individual contracts follow the type in `./definition-type.nix`.
{ lib, ... }:
lib.mapAttrs (
  _name: path:
  lib.evalOption (lib.mkOption {
    type = lib.contract.definitionType;
  }) (import path { inherit lib; })
) { fileSecrets = ./file-secrets.nix; }
