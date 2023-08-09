{ lib }:

rec {

  /* Throw if pred is false, else return pred.
     Intended to be used to augment asserts with helpful error messages.

     Example:
       assertMsg false "nope"
       stderr> error: nope

       assert assertMsg ("foo" == "bar") "foo is not bar, silly"; ""
       stderr> error: foo is not bar, silly

     Type:
       assertMsg :: Bool -> String -> Bool
  */
  # TODO(Profpatsch): add tests that check stderr
  assertMsg =
    # Predicate that needs to succeed, otherwise `msg` is thrown
    pred:
    # Message to throw in case `pred` fails
    msg:
    pred || builtins.throw msg;

  /* Specialized `assertMsg` for checking if `val` is one of the elements
     of the list `xs`. Useful for checking enums.

     Example:
       let sslLibrary = "libressl";
       in assertOneOf "sslLibrary" sslLibrary [ "openssl" "bearssl" ]
       stderr> error: sslLibrary must be one of [
       stderr>   "openssl"
       stderr>   "bearssl"
       stderr> ], but is: "libressl"

     Type:
       assertOneOf :: String -> ComparableVal -> List ComparableVal -> Bool
  */
  assertOneOf =
    # The name of the variable the user entered `val` into, for inclusion in the error message
    name:
    # The value of what the user provided, to be compared against the values in `xs`
    val:
    # The list of valid values
    xs:
    assertMsg
    (lib.elem val xs)
    "${name} must be one of ${
      lib.generators.toPretty {} xs}, but is: ${
        lib.generators.toPretty {} val}";

}
