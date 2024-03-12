{ lib }:

rec {

  /**
    Throw if pred is false, else return pred.
    Intended to be used to augment asserts with helpful error messages.

    # Inputs

    `pred`

    : Predicate that needs to succeed, otherwise `msg` is thrown

    `msg`

    : Message to throw in case `pred` fails

    # Type

    ```
    assertMsg :: Bool -> String -> Bool
    ```

    # Examples
    :::{.example}
    ## `lib.asserts.assertMsg` usage example

    ```nix
    assertMsg false "nope"
    stderr> error: nope
    assert assertMsg ("foo" == "bar") "foo is not bar, silly"; ""
    stderr> error: foo is not bar, silly
    ```

    :::
  */
  # TODO(Profpatsch): add tests that check stderr
  assertMsg =
    pred:
    msg:
    pred || builtins.throw msg;

  /**
    Specialized `assertMsg` for checking if `val` is one of the elements
    of the list `xs`. Useful for checking enums.

    # Inputs

    `name`

    : The name of the variable the user entered `val` into, for inclusion in the error message

    `val`

    : The value of what the user provided, to be compared against the values in `xs`

    `xs`

    : The list of valid values

    # Type

    ```
    assertOneOf :: String -> ComparableVal -> List ComparableVal -> Bool
    ```

    # Examples
    :::{.example}
    ## `lib.asserts.assertOneOf` usage example

    ```nix
    let sslLibrary = "libressl";
    in assertOneOf "sslLibrary" sslLibrary [ "openssl" "bearssl" ]
    stderr> error: sslLibrary must be one of [
    stderr>   "openssl"
    stderr>   "bearssl"
    stderr> ], but is: "libressl"
    ```

    :::
  */
  assertOneOf =
    name:
    val:
    xs:
    assertMsg
    (lib.elem val xs)
    "${name} must be one of ${
      lib.generators.toPretty {} xs}, but is: ${
        lib.generators.toPretty {} val}";

  /**
    Specialized `assertMsg` for checking if every one of `vals` is one of the elements
    of the list `xs`. Useful for checking lists of supported attributes.

    # Inputs

    `name`

    : The name of the variable the user entered `val` into, for inclusion in the error message

    `vals`

    : The list of values of what the user provided, to be compared against the values in `xs`

    `xs`

    : The list of valid values

    # Type

    ```
    assertEachOneOf :: String -> List ComparableVal -> List ComparableVal -> Bool
    ```

    # Examples
    :::{.example}
    ## `lib.asserts.assertEachOneOf` usage example

    ```nix
    let sslLibraries = [ "libressl" "bearssl" ];
    in assertEachOneOf "sslLibraries" sslLibraries [ "openssl" "bearssl" ]
    stderr> error: each element in sslLibraries must be one of [
    stderr>   "openssl"
    stderr>   "bearssl"
    stderr> ], but is: [
    stderr>   "libressl"
    stderr>   "bearssl"
    stderr> ]
    ```

    :::
  */
  assertEachOneOf =
    name:
    vals:
    xs:
    assertMsg
    (lib.all (val: lib.elem val xs) vals)
    "each element in ${name} must be one of ${
      lib.generators.toPretty {} xs}, but is: ${
        lib.generators.toPretty {} vals}";
}
