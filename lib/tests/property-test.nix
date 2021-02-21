
/*
This "property testing framework" leverages built-in asserts and traces in
an attempt to provide the best feedback it can give with the limitations
that:

- the test writing experience is weird
- only the first error is reported
- no shrinking
- no fuzzing

To use it, stick to this pattern:

    assert forceChecks (
      withItems "prefix" somePaths (prefix:
        withItems "other" somePaths (other:
          assert pathHasPrefix prefix other == alternatePathHasPrefix prefix other; {}
        )
      )
    );

Let's have a look why everything is there.

          assert pathHasPrefix prefix other == alternatePathHasPrefix prefix other; {}
          ^^^^^^
          reports the line number of the test failure, with an augmented stack
          trace that contains the values that triggered the failure


          assert pathHasPrefix prefix other == alternatePathHasPrefix prefix other; {}
                                                                                    ^^
          return non-bool, so we can detect when someone forgets
          the essential assert keyword


        withItems "other" somePaths (other:
        ^^^^^^^^^
        lets us do limited property testing, using examples instead of random generations


        withItems "other" somePaths (other:
                  ^^^^^^^
        names the example when it is printed in the stack trace, so you know for
        which values it failed


        withItems "other" somePaths (other:
                          ^^^^^^^^^  ^^^^^
        a list of examples to test with. `other` will have each of these values

      nesting of withItems:
      tests all possible combinations

    assert
    ^^^^^^
    while not essential, it's nice to reuse a syntax that doesn't produce
    O(n) indentation pyramids. Lists would qualify for this purpose but turned
    out to be messier.

    assert forceChecks (
           ^^^^^^^^^^^
    because we want to detect accidental omissions of `assert`, we can't
    normally return true, `forceChecks` forces its argument and then returns true.


*/

let
  lib = import ../.;
  inherit (builtins) concatMap seq addErrorContext;
  inherit (lib.generators) toPretty;

  forceChecks = x: builtins.seq x true;
  checkAssert = r: if r == true || r == false then throw "Please use assert expressions in forceChecks and withItems." else r;
  withItems = name: items: f:
    lib.foldl'
      (_prev: item: addErrorContext "while testing with ${name} = ${toPretty {} item}" (checkAssert (f item)))
      true
      items;

  # true iff the argument throws an exception
  throws = a: ! (builtins.tryEval a).success;

in {
  inherit forceChecks withItems throws;
}
