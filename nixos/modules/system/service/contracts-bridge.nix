# Contracts bridge: collects `contracts.<type>.want` and `contracts.<type>.providers`
# from all modular services and merges them into the containing system's contract
# namespace. This is the NixOS reference implementation.
#
# Each service's `want` entries are auto-nested under the service's tree path
# (e.g. `want.myService.option` for a root service, `want.outer.inner.option`
# for a nested sub-service). This prevents collisions between independent services.
# Services set `want` without any manual prefix.
#
# To support modular services in another system (home-manager, nix-darwin),
# create an equivalent bridge that walks your system's service tree:
#
#   { config, lib, ... }:
#   let
#     portable-lib = import <nixpkgs/lib/services/lib.nix> { inherit lib; };
#   in
#   {
#     contracts = lib.mapAttrs (contractType: _: {
#       want = lib.mkMerge (
#         portable-lib.flattenMapServicesConfigToList (
#           loc: service:
#           let
#             want = service.contracts.${contractType}.want or { };
#             path = lib.filter (k: k != "services") loc;
#           in
#           if path == [ ] || want == { } then
#             lib.toList want
#           else
#             [ (lib.setAttrByPath path want) ]
#         ) [ ] config  # <- root of your service tree
#       );
#       providers = lib.mkMerge (
#         portable-lib.flattenMapServicesConfigToList (
#           _: service:
#             lib.mapAttrsToList (name: provider: {
#               ${name} = provider;
#             }) (service.contracts.${contractType}.providers or { })
#         ) [ ] config  # <- root of your service tree
#       );
#     }) config.contractTypes;
#   }
#
# The first argument to `flattenMapServicesConfigToList` should be the root
# of your service tree (for NixOS: `config.system`, which has `config.system.services`).

{ config, lib, ... }:
let
  portable-lib = import ../../../../lib/services/lib.nix { inherit lib; };
in
{
  contracts = lib.mapAttrs (contractType: _: {
    want = lib.mkMerge (
      portable-lib.flattenMapServicesConfigToList (
        loc: service:
        let
          want = service.contracts.${contractType}.want or { };
          # Service names from the tree path, e.g. ["services" "app" "services" "deep"] -> ["app" "deep"]
          path = lib.filter (k: k != "services") loc;
        in
        if path == [ ] || want == { } then lib.toList want else [ (lib.setAttrByPath path want) ]
      ) [ ] config.system
    );
    providers = lib.mkMerge (
      portable-lib.flattenMapServicesConfigToList (
        _: service:
        lib.mapAttrsToList (name: provider: {
          ${name} = provider;
        }) (service.contracts.${contractType}.providers or { })
      ) [ ] config.system
    );
  }) config.contractTypes;
}
