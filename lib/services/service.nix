# Non-module arguments
# These are separate from the module arguments to avoid implicit dependencies.
# This makes service modules self-contains, allowing mixing of Nixpkgs versions.
#
# Portable service base module - imported into every modular service's module system.
#
# Defines the core service interface (`process.argv`, sub-`services`, `configData`)
# and imports the contracts module. This is system-agnostic: it works regardless of
# whether the containing system is NixOS, home-manager, or similar systems.
#
# Contract state propagates from parent services to sub-services automatically,
# with `_upstreamContracts.*.results` scoped to each service's own entries.
#
# Service-manager-specific options (systemd units, launchd plists, etc.) are added
# via `extraRootModules` in `lib/services/lib.nix`'s `configure` function, not here.
{ pkgs }:

# The module
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  pathOrStr = types.coercedTo types.path (x: "${x}") types.str;
in
{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";
  imports = [
    ../../modules/generic/meta-maintainers.nix
    ../../nixos/modules/misc/assertions.nix
    (lib.modules.importApply ./config-data.nix { inherit pkgs; })
    lib.contract.module
  ];
  options = {
    services = mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = [
            (lib.modules.importApply ./service.nix { inherit pkgs; })
            # Propagate contract state to sub-services. Scope `_upstreamContracts`
            # so sub-service results are accessible via just `${name}`.
            (
              { name, ... }:
              {
                config = {
                  inherit (config) contractTypes;
                  _upstreamContracts = lib.mapAttrs (
                    _: contract:
                    contract
                    // {
                      results = contract.results.${name} or { };
                    }
                  ) config._upstreamContracts;
                };
              }
            )
          ];
        }
      );
      description = ''
        A collection of [modular services](https://nixos.org/manual/nixos/unstable/#modular-services) that are configured in one go.

        You could consider the sub-service relationship to be an ownership relation.
        It **does not** automatically create any other relationship between services (e.g. systemd slices), unless perhaps such a behavior is explicitly defined and enabled in another option.
      '';
      default = { };
      visible = "shallow";
    };
    process = {
      argv = lib.mkOption {
        type = types.listOf pathOrStr;
        example = lib.literalExpression ''[ (lib.getExe config.package) "--nobackground" ]'';
        description = ''
          Command filename and arguments for starting this service.
          This is a raw command-line that should not contain any shell escaping.
          If expansion of environmental variables is required then use
          a shell script or `importas` from `pkgs.execline`.
        '';
      };
    };
  };
}
