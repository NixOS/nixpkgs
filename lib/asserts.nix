{ lib }:

rec {

  /* Print a trace message if pred is false.
     Intended to be used to augment asserts with helpful error messages.

     Example:
       assertMsg false "nope"
       => false
       stderr> trace: nope

       assert (assertMsg ("foo" == "bar") "foo is not bar, silly"); ""
       stderr> trace: foo is not bar, silly
       stderr> assert failed at …

     Type:
       assertMsg :: Bool -> String -> Bool
  */
  # TODO(Profpatsch): add tests that check stderr
  assertMsg =
    # Condition under which the `msg` should not be printed
    pred:
    # Message to print
    msg:
    if pred
    then true
    else builtins.trace msg false;

  /* Specialized `assertMsg` for checking if val is one of the elements
     of a list. Useful for checking enums.

     Example:
       let sslLibrary = "libressl"
       in assertOneOf "sslLibrary" sslLibrary [ "openssl" "bearssl" ]
       => false
       stderr> trace: sslLibrary must be one of "openssl", "bearssl", but is: "libressl"

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
