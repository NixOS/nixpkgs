# NixOS contracts wrapper - imports the generic contracts module and seeds
# nixpkgs-shipped contract types so they appear in `config.contractTypes`
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
#     config.contractTypes = lib.contracts;
#   }
#
# This gives the system `config.contracts.*` with all nixpkgs contract types.
# To also support modular services, add a bridge module and a service manager
# integration; see `nixos/modules/system/service/` for the NixOS reference.
{ lib, ... }:
{
  imports = [ lib.contract.module ];
  meta.doc = ./contracts.md;
  config.contractTypes = lib.contracts;
}
