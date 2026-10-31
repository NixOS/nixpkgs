# The routing module finds the provider option from `module` and `contract`.
# Each provider adds a different number to the requests that it gets.
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (config.contracts) number;
  intOption = mkOption {
    type = types.submodule {
      options.value = mkOption { type = types.int; };
    };
  };
  # The responses of the provider `name`.
  respond =
    name: n:
    lib.mapAttrsRecursiveCond (v: !(v ? request)) (_: entry: {
      response.value = entry.request.value + n;
    }) number.providerRequests.${name};
  providerOption =
    name: n:
    mkOption {
      type = types.raw;
      default = respond name n;
    };
in
{
  imports = [ lib.contract.module ];

  options = {
    # The provider option is at the default path, `[ "number" ]`.
    services.one.number = providerOption "one" 1;
    # The provider option is at a different path.
    services.two.numbers = providerOption "two" 2;
    # `module` is the provider option.
    three = providerOption "three" 3;
    # The provider option is in the value of `module`.
    services.four = mkOption {
      type = types.raw;
      default.number = respond "four" 4;
    };
  };

  config = {
    contractTypes.number = {
      meta = {
        description = "A number.";
        maintainers = [ lib.maintainers.kiara ];
      };
      interface.options = {
        request = intOption;
        response = intOption;
      };
    };

    contracts.number = {
      want.consumer = lib.genAttrs [ "a" "b" "c" "d" ] (_: {
        request.value = 10;
      });
      providers = {
        one.module = options.services.one;
        two = {
          module = options.services.two;
          contract = [ "numbers" ];
        };
        three = {
          module = options.three;
          contract = [ ];
        };
        four.module = options.services.four;
      };
      instances.consumer = {
        a = config.contracts.number.providers.one;
        b = config.contracts.number.providers.two;
        c = config.contracts.number.providers.three;
        d = config.contracts.number.providers.four;
      };
    };
  };
}
