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

        output = mkProviderOptions { };
      };

      mkProvider =
        {
          outputDefaults ? { },
          providerOptions ? { },
        }:
        {
          input = mkConsumerOptions { };
        }
        // optionalAttrs (outputDefaults != { }) {
          output = mkProviderOptions outputDefaults;
        }
        // optionalAttrs (providerOptions != { }) {
          inherit providerOptions;
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
      inherit (importedModule) behaviorTest;
    };
in
{
}
