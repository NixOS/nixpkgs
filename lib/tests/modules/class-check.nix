{ lib, ... }: {
  options = {
    sub = {
      nixosOk = lib.mkOption {
        type = lib.types.submoduleWith {
          class = "nixos";
          modules = [ ];
        };
      };
      # Same but will have bad definition
      nixosFail = lib.mkOption {
        type = lib.types.submoduleWith {
          class = "nixos";
          modules = [ ];
        };
      };

      mergeFail = lib.mkOption {
        type = lib.types.submoduleWith {
          class = "nixos";
          modules = [ ];
        };
        default = { };
      };
    };
  };
  imports = [
    {
      options = {
        sub = {
          mergeFail = lib.mkOption {
            type = lib.types.submoduleWith {
              class = "darwin";
              modules = [ ];
            };
          };
        };
      };
    }
  ];
  config = {
    _module.freeformType = lib.types.anything;
    ok =
      lib.evalModules {
        class = "nixos";
        modules = [
          ./module-class-is-nixos.nix
        ];
      };

    fail =
      lib.evalModules {
        class = "nixos";
        modules = [
          ./module-class-is-nixos.nix
          ./module-class-is-darwin.nix
        ];
      };

    fail-anon =
      lib.evalModules {
        class = "nixos";
        modules = [
          ./module-class-is-nixos.nix
          { _file = "foo.nix#darwinModules.default";
            class = "darwin";
            config = {};
            imports = [];
          }
        ];
      };

    sub.nixosOk = { config = {}; class = "nixos"; };
    sub.nixosFail = { imports = [ ./module-class-is-darwin.nix ]; };
  };
}
