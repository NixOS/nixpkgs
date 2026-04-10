{
  config,
  extendModules,
  lib,
  pkgs,
  ...
}:

let
  umlVariant = extendModules {
    modules = [
      ./uml-vm.nix
      ./qemu-vm.nix
    ];
  };
in

{
  options = {
    virtualisation = {
      umlVariant = lib.mkOption {
        description = ''
          Machine configurations for use with User-Mode Linux
        '';
        inherit (umlVariant) type;
        default = { };
        visible = "shallow";
      };
    };
  };
  config = {
    system = {
      build = {
        uml-loader = lib.mkDefault config.virtualisation.umlVariant.system.build.uml-loader;
      };
    };
  };

  # uses extendModules
  meta.buildDocsInSandbox = false;
}
