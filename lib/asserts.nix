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
  assertMsg = pred: msg:
    pred || builtins.throw msg;

  /* Specialized `assertMsg` for checking if val is one of the elements
     of a list. Useful for checking enums.

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
  assertOneOf = name: val: xs: assertMsg
    (lib.elem val xs)
    "${name} must be one of ${
      lib.generators.toPretty {} xs}, but is: ${
        lib.generators.toPretty {} val}";

}
