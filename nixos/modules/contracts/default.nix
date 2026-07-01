# NixOS contracts wrapper - imports the generic contracts module and seeds
# nixpkgs-shipped contract types so they appear in `config.contractDefinitions`
# alongside any user-defined types.
#
# `lib.contracts` are also used as a fallback directly in `contracts` option
# generation (see `lib/contracts/module.nix`), making this module safe for
# the docs build sandbox.
#
# To add contracts support to another module system (home-manager, nix-darwin),
# create an equivalent module:
#
#   { lib, ... }:
#   {
#     imports = [ lib.contract.module ];
#     config.contractDefinitions = lib.mapAttrs (_: contract: {
#       inherit (contract) meta interface behaviorTest;
#     }) lib.contracts;
#   }
#
# This gives the system `config.contracts.*` with all nixpkgs contract types.
# To also support modular services, add a bridge module and a service manager
# integration; see `nixos/modules/system/service/` for the NixOS reference.
{ lib, ... }:
{
  imports = [ lib.contract.module ];
  meta.doc = ./contracts.md;
  # Seed nixpkgs-shipped contract types so they appear in `config.contractDefinitions`
  # alongside any user-defined types.
  # Only settable fields are listed here; `_mkProviderType` and `mkContract` are
  # `readOnly` options whose defaults must not be overridden from config.
  config.contractDefinitions = lib.mapAttrs (_: contract: {
    inherit (contract) meta interface behaviorTest;
  }) lib.contracts;
}
