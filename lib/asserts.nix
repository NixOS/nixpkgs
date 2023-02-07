{ lib }:

let
  inherit (lib.lists)
    all
    foldl'
    ;
in

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

  /*
  Assert that a condition holds for all elements of a list. If it doesn't,
  the first element violating the condition and its index will be given to
  construct an error message.

  Type:
    assertAll :: (a -> Bool) -> [a] -> (Int -> a -> String) -> Bool

  Example:
    assert assertAll (n: n != 2) [ 1 3 5 ] (i: n: "Number ${toString n} at index ${toString i} is two!")
    => true
    assert assertAll (n: n != 2) [ 1 2 3 ] (i: n: "Number ${toString n} at index ${toString i} is two!")
    => error: Number 2 at index 1 is two!
  */
  assertAll =
    # The condition to check on the list elements
    cond:
    # The list whose elements to check the condition on
    list:
    # In case an element violates the condition, this function gets called
    # with the element index and value, it should return an error message string
    msg:
    # Fast successful path
    if all cond list
    then true
    # Slower unsuccessful path
    else foldl' (i: elem:
      if cond elem
      then i + 1
      else throw (msg i elem)
    ) 0 list;

}
