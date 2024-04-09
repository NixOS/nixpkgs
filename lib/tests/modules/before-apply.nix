{ options, lib, ... }:

# Tests wheter a apply function properly generates the `beforeApply` option attribute

{
  options = {
    optionWithoutApply = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };

    optionWithApply = lib.mkOption {
      default = false;
      type = lib.types.bool;
      apply = x: !x;
    };

    okChecks = lib.mkOption {};
  };
  config.okChecks = builtins.addErrorContext "while evaluating the assertions" (
    assert options.optionWithoutApply.beforeApply == options.optionWithoutApply.value;
    assert options.optionWithApply.beforeApply == !options.optionWithApply.value;
  true);
}
