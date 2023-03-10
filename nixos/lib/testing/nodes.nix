testModuleArgs@{ config, lib, hostPkgs, nodes, ... }:

let
  inherit (lib) mkOption mkForce optional types mapAttrs mkDefault mdDoc;

  system = hostPkgs.stdenv.hostPlatform.system;

  baseOS =
    import ../eval-config.nix {
      inherit system;
      inherit (config.node) specialArgs;
      modules = [ config.defaults ];
      baseModules = (import ../../modules/module-list.nix) ++
        [
          ./nixos-test-base.nix
          { key = "nodes"; _module.args.nodes = config.nodesCompat; }
          ({ config, ... }:
            {
              virtualisation.qemu.package = testModuleArgs.config.qemu.package;

              # Ensure we do not use aliases. Ideally this is only set
              # when the test framework is used by Nixpkgs NixOS tests.
              nixpkgs.config.allowAliases = false;
            })
          testModuleArgs.config.extraBaseModules
        ];
    };


in

{

  options = {
    node.type = mkOption {
      type = types.raw;
      default = baseOS.type;
      internal = true;
    };

    nodes = mkOption {
      type = types.lazyAttrsOf config.node.type;
      visible = "shallow";
      description = mdDoc ''
        An attribute set of NixOS configuration modules.

        The configurations are augmented by the [`defaults`](#test-opt-defaults) option.

        They are assigned network addresses according to the `nixos/lib/testing/network.nix` module.

        A few special options are available, that aren't in a plain NixOS configuration. See [Configuring the nodes](#sec-nixos-test-nodes)
      '';
    };

    defaults = mkOption {
      description = mdDoc ''
        NixOS configuration that is applied to all [{option}`nodes`](#test-opt-nodes).
      '';
      type = types.deferredModule;
      default = { };
    };

    extraBaseModules = mkOption {
      description = mdDoc ''
        NixOS configuration that, like [{option}`defaults`](#test-opt-defaults), is applied to all [{option}`nodes`](#test-opt-nodes) and can not be undone with [`specialisation.<name>.inheritParentConfig`](https://search.nixos.org/options?show=specialisation.%3Cname%3E.inheritParentConfig&from=0&size=50&sort=relevance&type=packages&query=specialisation).
      '';
      type = types.deferredModule;
      default = { };
    };

    node.specialArgs = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      description = mdDoc ''
        An attribute set of arbitrary values that will be made available as module arguments during the resolution of module `imports`.

        Note that it is not possible to override these from within the NixOS configurations. If you argument is not relevant to `imports`, consider setting {option}`defaults._module.args.<name>` instead.
      '';
    };

    nodesCompat = mkOption {
      internal = true;
      description = mdDoc ''
        Basically `_module.args.nodes`, but with backcompat and warnings added.

        This will go away.
      '';
    };
  };

  config = {
    _module.args.nodes = config.nodesCompat;
    nodesCompat =
      mapAttrs
        (name: config: config // {
          config = lib.warnIf (lib.isInOldestRelease 2211)
            "Module argument `nodes.${name}.config` is deprecated. Use `nodes.${name}` instead."
            config;
        })
        config.nodes;

    passthru.nodes = config.nodesCompat;
  };
}
