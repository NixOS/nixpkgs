{
  config,
  lib,
  extendModules,
  ...
}:

let
  forAllSystems = lib.genAttrs lib.systems.flakeExposed;
in
{
  options = {
    system = forAllSystems (
      system:
      lib.mkOption {
        description = ''
          Extra configuration when using `system.build.toplevelFor.${system}`
        '';
        inherit (extendModules { modules = [ { nixpkgs.system = lib.mkOverride 0 system; } ]; }) type;
        default = { };
        visible = "shallow";
      }
    );
  };

  config = {
    system.build.toplevelFor = forAllSystems (system: config.system.${system}.system.build.toplevel);
  };

  # uses extendModules to generate a type
  meta.buildDocsInSandbox = false;
}
