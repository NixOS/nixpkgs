{ config, lib, pkgs, extendModules, noUserModules, ... }:

let
  inherit (lib)
    concatStringsSep
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
  children =
    mapAttrs
      (childName: childConfig: childConfig.configuration.system.build.toplevel)
      config.specialisation;

in
{
  config = {
    system.systemBuilderCommands = lib.mkIf (config.specialisation != { }) ''
      mkdir $out/specialisation
      ${concatStringsSep "\n"
      (mapAttrsToList (name: path: "ln -s ${path} $out/specialisation/${name}") children)}
    '';
  };

  options = {

    specialisation = mkOption {
      default = { };
      example = lib.literalExpression "{ fewJobsManyCores.configuration = { nix.buildCores = 0; nix.maxJobs = 1; }; }";
      description = ''
        Additional configurations to build. If
        <literal>inheritParentConfig</literal> is true, the system
        will be based on the overall system configuration.

        To switch to a specialised configuration
        (e.g. <literal>fewJobsManyCores</literal>) at runtime, run:

        <screen>
        <prompt># </prompt>sudo /run/current-system/specialisation/fewJobsManyCores/bin/switch-to-configuration test
        </screen>
      '';
      type = types.attrsOf (types.submodule (
        local@{ ... }:
        let
          extend =
            if local.config.inheritParentConfig
            then extendModules
            else noUserModules.extendModules;
        in
        {
          options.inheritParentConfig = mkOption {
            type = types.bool;
            default = true;
            description = "Include the entire system's configuration. Set to false to make a completely differently configured system.";
          };

          options.configuration = mkOption {
            default = { };
            description = ''
              Arbitrary NixOS configuration.

              Anything you can add to a normal NixOS configuration, you can add
              here, including imports and config values, although nested
              specialisations will be ignored.
            '';
            visible = "shallow";
            inherit (extend { modules = [ ./no-clone.nix ]; }) type;
          };
        }
      ));
    };
  };
}
