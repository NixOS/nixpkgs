/**
  Renders documentation for contracts.
  For inclusion into documentation.nixos.extraModules.
*/
{ lib, pkgs, ... }:
let
  /**
    Causes a contracts docs to be rendered.
    This is an intermediate solution until we have "native" contracts docs in some nicer form.
  */
  fakeSubmodule =
    module:
    lib.mkOption {
      type = lib.types.submodule {
        options = module.allOptions;
      };
      inherit (module) description;
    };

  contractsModule = {
    _file = "${__curPos.file}:${toString __curPos.line}";
    options = {
      contracts = lib.mkOption {
        description = ''
          All [contracts](https://nixos.org/manual/nixos/unstable/#contracts) are found here.

          Create a consumer for a contract `<contract>` with:

          ```nix
          {
            options.<consumer>.<option> = lib.mkOption {
              type = lib.types.submodule {
                options = lib.contracts.<contracts>.mkConsumer {
                  // Fill out consumer option definitions
                };
              };
            };
          }
          ```

          Create a provider for a contract `<contract>` with:

          ```nix
          {
            options.<provider>.<option> = lib.mkOption {
              type = lib.types.submodule {
                options = lib.contracts.<contracts>.mkProvider {
                  // Fill out provider option definitions
                };
              };
            };
          }
          ```

          Associate a consumer and a provider:

          ```nix
          {
            <provider>.<option>.input = <consumer>.<option>.input;
            <consumer>.<option>.output = <provider>.<option>.output;

            // Some provider require specific options too:
            <provider>.<option>.providerOptions = {
              // Fill out provider specific options.
            };
          }
          ```
        '';
        type = lib.types.submodule {
          options = {
            filebackup = fakeSubmodule lib.contracts.filebackup;
          };
        };
      };
    };
  };
in
{
  documentation.nixos.extraModules = [
    contractsModule
  ];
}
