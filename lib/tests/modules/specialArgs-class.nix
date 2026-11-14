{ lib, ... }:
{
  options = {
    sub = {
      nixos = lib.mkOption {
        type = lib.types.submoduleWith {
          class = "nixos";
          modules = [
            ./expose-module-class.nix
          ];
        };
        default = { };
      };

      conditionalImportAsNixos = lib.mkOption {
        type = lib.types.submoduleWith {
          class = "nixos";
          modules = [
            ./polymorphic-module.nix
          ];
        };
        default = { };
      };

      conditionalImportAsDarwin = lib.mkOption {
        type = lib.types.submoduleWith {
          class = "darwin";
          modules = [
            ./polymorphic-module.nix
          ];
        };
        default = { };
      };
    };
  };
  config = {
    _module.freeformType = lib.types.anything;

    nixos = lib.evalModules {
      class = "nixos";
      modules = [ ./expose-module-class.nix ];
    };

    conditionalImportAsNixos = lib.evalModules {
      class = "nixos";
      modules = [ ./polymorphic-module.nix ];
    };

    conditionalImportAsDarwin = lib.evalModules {
      class = "darwin";
      modules = [ ./polymorphic-module.nix ];
    };
  };
}
