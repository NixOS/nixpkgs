{ lib, ... }:
let
  inherit (lib) mkOption modules types;
  inherit (types) attrsOf listOf option submodule str;
  contractModule = mkOption {
    type = submodule {
      options = {
        meta = mkOption {
          description = ''
            Useful information about the contract and its maintenance.
          '';
          type = submodule {
            options = {
              description = mkOption {
                description = ''
                  Description of the contract.
                '';
                type = str;
              };
              maintainers = mkOption {
                description = ''
                  Maintainers of the contract.
                '';
                type = listOf str;
              };
            };
          };
        };
        input = mkOption {
          description = ''
            Input type of a contract.
          '';
          type = attrsOf option;
          apply = modules.mkContract;
        };
        output = mkOption {
          description = ''
            Output type of a contract.
          '';
          type = attrsOf option;
          apply = modules.mkContract;
        };
        behaviorTest = mkOption {
          # The type should be more precise of course.
          # There should actually be a NixOSTest type.
          # And we can probably do something fancy with the `input` and `output` modules.
          type = types.functionTo types.attrs;
        };
      };
    };
  };
in
# yields: attrsOf contractModule
lib.mapAttrs (_: path: modules.evalOption contractModule (import path { inherit lib; })) {
  fileSecrets = ./file-secrets.nix;
}
