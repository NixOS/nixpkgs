/**
  Renders documentation for modular services.
  For inclusion into documentation.nixos.extraModules.
*/
{
  lib,
  pkgs,
  config,
  ...
}:
let
  /**
    Causes a modular service's docs to be rendered.
    This is an intermediate solution until we have "native" service docs in some nicer form.
  */
  fakeSubmodule =
    module:
    lib.mkOption {
      type = lib.types.submoduleWith {
        # The variants are ordinary service modules, so they expect the same
        # arguments `system.services` provides. `pkgs` has to be a special
        # argument: the variants reach the pure half through
        # `imports = [ pkgs.<pkg>.services.<svc> ]`, and an argument that comes
        # from `_module.args` is not available that early.
        specialArgs = { inherit pkgs; };
        modules = [ module ];
      };
      description = "This is a [modular service](https://nixos.org/manual/nixos/unstable/#modular-services), which can be imported into a NixOS configuration using the [`system.services`](https://search.nixos.org/options?channel=unstable&show=system.services&query=modular+service) option.";
    };

  # `python-http-server` is a fixture for nixos/tests/modular-service-etc rather
  # than a service anyone would import, so it stays out of the manual.
  undocumented = [ "python-http-server" ];

  # Derived from the variant registry
  # (nixos/modules/system/service/modular/default.nix) rather than listed by
  # hand, so a newly registered service is documented without a second edit.
  #
  # Documenting the variants rather than the pure `pkgs.<pkg>.services.<svc>`
  # modules also covers the NixOS-specific half of each service, which is the
  # half a NixOS configuration gets.
  modularServicesModule = {
    options = lib.concatMapAttrs (
      package:
      lib.mapAttrs' (
        service: module:
        lib.nameValuePair "<imports = [ config.modularServices.${package}.${service} ]>" (
          fakeSubmodule module
        )
      )
    ) (lib.removeAttrs config.modularServices undocumented);
  };
in
{
  documentation.nixos.extraModules = [
    modularServicesModule
  ];
}
