# collection of contract templates, defined in `lib` so we can still build the manual.
# declarations of individual contracts follow the type in `./template-type.nix`.
{ lib, ... }:
let
  inherit (lib) mkOption;
in
lib.mapAttrs
  (
    _: path:
    # type-check contracts defined in `lib/contracts/templates`.
    lib.evalOption (mkOption {
      type = lib.contract.templateType;
    }) (import path { inherit lib; })
  )
  {
    fileSecrets = ./file-secrets.nix;
  }
