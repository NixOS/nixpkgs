# Functions and modules to use contracts.
# The contract types are in `./definitions`.
{ lib, ... }:
{
  # Module that routes requests from consumers to providers.
  module = ./module.nix;

  /**
    Whether a value is a contract, that is an attribute set with a `response`.

    Use it when an option accepts a contract or a value without a contract,
    for example `types.oneOf [ types.path contractType ]`,
    to find which of the two the user set.

    # Type

    ```
    isInstance :: a -> bool
    ```

    # Inputs

    `v`

    : 1\. The value to test

    # Example

    ```nix
    isInstance { response.path = "/run/secrets/a"; }
    # => true
    isInstance /run/secrets/a
    # => false
    ```
  */
  isInstance = v: lib.isAttrs v && v ? response;

  # Type of a contract type, with the options `meta`, `interface` and `mkContract`.
  # A contract type is not a module, for two reasons:
  # - The consumers and the providers import `interface` into each entry.
  #   In a module, `meta` is a definition of the option `meta`,
  #   thus each entry must declare a `meta` option, and contains the `meta` of the contract type.
  # - A module cannot contain functions such as `mkContract`,
  #   because the module system does not accept attributes that it does not know.
  definitionType = lib.types.submodule ./definition-type.nix;
}
