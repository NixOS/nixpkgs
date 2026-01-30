{ lib }:
let
  inherit (lib) optionalAttrs;

  mkContractFunctions =
    {
      mkConsumerOptions,
      mkProviderOptions,
    }:
    {
      mkConsumer = inputDefaults: {
        input = mkConsumerOptions inputDefaults;

        output = mkProviderOptions { } // {
          visible = "shallow";
        };
      };

      mkProvider =
        {
          outputDefaults ? { },
          providerOptions ? { },
        }:
        {
          input = mkConsumerOptions { } // {
            visible = "shallow";
          };
        }
        // optionalAttrs (outputDefaults != { }) {
          output = mkProviderOptions outputDefaults;
        }
        // optionalAttrs (providerOptions != { }) {
          inherit providerOptions;
        };

      # Used for documentation
      allOptions = {
        input = mkConsumerOptions { };
        output = mkProviderOptions { };
      };
    };

  importContract =
    module:
    let
      importedModule = import module { inherit lib; };
    in
    mkContractFunctions {
      inherit (importedModule) mkConsumerOptions mkProviderOptions;
    }
    // {
      inherit (importedModule) description behaviorTest;
    };
in
{
  filebackup = importContract ./filebackup.nix;
  secrets = importContract ./secrets.nix;
}
