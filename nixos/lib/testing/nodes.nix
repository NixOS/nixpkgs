testModuleArgs@{ config, lib, hostPkgs, nodes, ... }:

let
  inherit (lib) mkOption mkForce optional types mapAttrs mkDefault;

  system = hostPkgs.stdenv.hostPlatform.system;

  baseOS =
    import ../eval-config.nix {
      inherit system;
      inherit (config.node) specialArgs;
      modules = [ config.defaults ];
      baseModules = (import ../../modules/module-list.nix) ++
        [
          ./nixos-test-base.nix
          { key = "nodes"; _module.args.nodes = nodes; }
          ({ config, ... }:
            {
              virtualisation.qemu.package = testModuleArgs.config.qemu.package;

              # Ensure we do not use aliases. Ideally this is only set
              # when the test framework is used by Nixpkgs NixOS tests.
              nixpkgs.config.allowAliases = false;
            })
        ] ++ optional config.minimal ../../modules/testing/minimal-kernel.nix;
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
    };

    defaults = mkOption {
      description = ''
        NixOS configuration that is applied to all {option}`nodes`.
      '';
      type = types.deferredModule;
      default = { };
    };

    node.specialArgs = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
    };

    minimal = mkOption {
      type = types.bool;
      default = false;
    };

    nodesCompat = mkOption {
      internal = true;
    };
  };

  config = {
    _module.args.nodes = config.nodesCompat;
    nodesCompat =
      mapAttrs
        (name: config: config // {
          config = lib.warn
            "Module argument `nodes.${name}.config` is deprecated. Use `nodes.${name}` instead."
            config;
        })
        config.nodes;

    passthru.nodes = config.nodesCompat;
  };
}
