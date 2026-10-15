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
}
