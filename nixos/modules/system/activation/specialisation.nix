{
  config,
  lib,
  extendModules,
  noUserModules,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    escapeShellArg
    hasInfix
    mapAttrs
    mapAttrsToList
    mkOption
    types
    ;

  # This attribute is responsible for creating boot entries for
  # child configuration. They are only (directly) accessible
  # when the parent configuration is boot default. For example,
  # you can provide an easy way to boot the same configuration
  # as you use, but with another kernel
  # !!! fix this
  children = mapAttrs (_: childConfig: childConfig.toplevel) config.specialisation;

in
{
  options = {
    isSpecialisation = mkOption {
      type = lib.types.bool;
      internal = true;
      default = false;
      description = "Whether this system is a specialisation of another.";
    };

    specialisation = mkOption {
      default = { };
      example = lib.literalExpression "{ fewJobsManyCores.configuration = { nix.settings = { core = 0; max-jobs = 1; }; }; }";
      description = ''
        Additional configurations to build. If
        `inheritParentConfig` is true, the system
        will be based on the overall system configuration.

        To switch to a specialised configuration
        (e.g. `fewJobsManyCores`) at runtime, run:

        ```
        sudo /run/current-system/specialisation/fewJobsManyCores/bin/switch-to-configuration test
        ```
      '';
      type = types.attrsOf (
        types.submodule (
          local@{ ... }:
          let
            extend = if local.config.inheritParentConfig then extendModules else noUserModules.extendModules;
          in
          {
            options.inheritParentConfig = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Include the entire system's configuration. Set to false to make a
                completely differently configured system.

                Only applies when `configuration` is built. It has no effect when
                `toplevel` is set to an externally-built system.
              '';
            };

            options.configuration = mkOption {
              default = { };
              description = ''
                Arbitrary NixOS configuration.

                Anything you can add to a normal NixOS configuration, you can add
                here, including imports and config values, although nested
                specialisations will be ignored.

                This is built and used as the specialisation's `toplevel` unless
                `toplevel` is set explicitly, in which case this is ignored.
              '';
              visible = "shallow";
              inherit (extend { modules = [ ./no-clone.nix ]; }) type;
            };

            options.toplevel = mkOption {
              type = types.package;
              default = local.config.configuration.system.build.toplevel;
              defaultText = lib.literalExpression "config.configuration.system.build.toplevel";
              description = ''
                The top-level system derivation symlinked into
                `specialisation/<name>` and whose bootspec is embedded into the
                parent system's `boot.json`. Defaults to this specialisation's
                built NixOS `configuration`.

                Override it to point at a system built outside the NixOS module
                system, as long as it produces an RFC-0125 bootspec
                (a `boot.json`) of its own. When overridden, `configuration` is
                not evaluated, so the specialisation need not be a NixOS system.
              '';
            };
          }
        )
      );
    };

  };

  config = {
    assertions = mapAttrsToList (name: _: {
      assertion = !hasInfix "/" name;
      message = ''
        Specialisation names must not contain forward slashes.
        Invalid specialisation name: ${name}
      '';
    }) config.specialisation;

    system.systemBuilderCommands = ''
      mkdir $out/specialisation
      ${concatStringsSep "\n" (
        mapAttrsToList (name: path: "ln -s ${path} $out/specialisation/${escapeShellArg name}") children
      )}
    '';
  };

  # uses extendModules to generate a type
  meta.buildDocsInSandbox = false;
}
