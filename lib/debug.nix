/**
  Collection of functions useful for debugging
  broken nix expressions.

  * `trace`-like functions take two values, print
    the first to stderr and return the second.
  * `traceVal`-like functions take one argument
    which both printed and returned.
  * `traceSeq`-like functions fully evaluate their
    traced value before printing (not just to “weak
    head normal form” like trace does by default).
  * Functions that end in `-Fn` take an additional
    function as their first argument, which is applied
    to the traced value before it is printed.
*/
{ lib }:
let
  inherit (lib)
    concatMapStringsSep
    isList
    isAttrs
    substring
    attrValues
    concatLists
    const
    elem
    foldl'
    generators
    id
    mapAttrs
    trace
    ;
in

rec {

  # -- TRACING --

  /**
    Conditionally trace the supplied message, based on a predicate.

    # Inputs

    `pred`

    : Predicate to check

    `msg`

    : Message that should be traced

    `x`

    : Value to return

    # Type

    ```
    traceIf :: bool -> string -> a -> a
    ```

    # Examples
    :::{.example}
    ## `lib.debug.traceIf` usage example

    ```nix
    traceIf true "hello" 3
    trace: hello
    => 3
    ```

    :::
  */
  traceIf =
    pred: msg: x:
    if pred then trace msg x else x;

  /**
    Trace the supplied value after applying a function to it, and
    return the original value.

    # Inputs

    `f`

    : Function to apply

    `x`

    : Value to trace and return

    # Type

    ```
    traceValFn :: (a -> b) -> a -> a
    ```

    # Examples
    :::{.example}
    ## `lib.debug.traceValFn` usage example

    ```nix
    traceValFn (v: "mystring ${v}") "foo"
    trace: mystring foo
    => "foo"
    ```

    :::
  */
  traceValFn = f: x: trace (f x) x;

  /**
    Trace the supplied value and return it.

    # Inputs

    `x`

    : Value to trace and return

    # Type

    ```
    traceVal :: a -> a
    ```

    # Examples
    :::{.example}
    ## `lib.debug.traceVal` usage example

    ```nix
    traceVal 42
    # trace: 42
    => 42
    ```

    :::
  */
  traceVal = traceValFn id;

  /**
    `builtins.trace`, but the value is `builtins.deepSeq`ed first.

    # Inputs

    `x`

    : The value to trace

    `y`

    : The value to return

    # Type

    ```
    traceSeq :: a -> b -> b
    ```

    # Examples
    :::{.example}
    ## `lib.debug.traceSeq` usage example

    ```nix
    trace { a.b.c = 3; } null
    trace: { a = <CODE>; }
    => null
    traceSeq { a.b.c = 3; } null
    trace: { a = { b = { c = 3; }; }; }
    => null
    ```

    :::
  */
  traceSeq = x: y: trace (builtins.deepSeq x x) y;

  /**
    Like `traceSeq`, but only evaluate down to depth n.
    This is very useful because lots of `traceSeq` usages
    lead to an infinite recursion.

    # Inputs

    `depth`

    : 1\. Function argument

    `x`

    : 2\. Function argument

    `y`

    : 3\. Function argument

    # Type

    ```
    traceSeqN :: Int -> a -> b -> b
    ```

    # Examples
    :::{.example}
    ## `lib.debug.traceSeqN` usage example

    ```nix
    traceSeqN 2 { a.b.c = 3; } null
    trace: { a = { b = {…}; }; }
    => null
    ```

    :::
  */
  traceSeqN =
    depth: x: y:
    let
      snip =
        v:
        if isList v then
          noQuotes "[…]" v
        else if isAttrs v then
          noQuotes "{…}" v
        else
          v;
      noQuotes = str: v: {
        __pretty = const str;
        val = v;
      };
      modify =
        n: fn: v:
        if (n == 0) then
          fn v
        else if isList v then
          map (modify (n - 1) fn) v
        else if isAttrs v then
          mapAttrs (const (modify (n - 1) fn)) v
        else
          v;
    in
    trace (generators.toPretty { allowPrettyValues = true; } (modify depth snip x)) y;

  /**
    A combination of `traceVal` and `traceSeq` that applies a
    provided function to the value to be traced after `deepSeq`ing
    it.

    # Inputs

    `f`

    : Function to apply

    `v`

    : Value to trace
  */
  traceValSeqFn = f: v: traceValFn f (builtins.deepSeq v v);

  /**
    A combination of `traceVal` and `traceSeq`.

    # Inputs

    `v`

    : Value to trace
  */
  traceValSeq = traceValSeqFn id;

  /**
    A combination of `traceVal` and `traceSeqN` that applies a
    provided function to the value to be traced.

    # Inputs

    `f`

    : Function to apply

    `depth`

    : 2\. Function argument

    `v`

    : Value to trace
  */
  traceValSeqNFn =
    f: depth: v:
    traceSeqN depth (f v) v;

  /**
    A combination of `traceVal` and `traceSeqN`.

    # Inputs

    `depth`

    : 1\. Function argument

    `v`

    : Value to trace
  */
  traceValSeqN = traceValSeqNFn id;

  /**
    Trace the input and output of a function `f` named `name`,
    both down to `depth`.

    This is useful for adding around a function call,
    to see the before/after of values as they are transformed.

    # Inputs

    `depth`

    : 1\. Function argument

    `name`

    : 2\. Function argument

    `f`

    : 3\. Function argument

    `v`

    : 4\. Function argument

    # Examples
    :::{.example}
    ## `lib.debug.traceFnSeqN` usage example

    ```nix
    traceFnSeqN 2 "id" (x: x) { a.b.c = 3; }
    trace: { fn = "id"; from = { a.b = {…}; }; to = { a.b = {…}; }; }
    => { a.b.c = 3; }
    ```

    :::
  */
  traceFnSeqN =
    depth: name: f: v:
    let
      res = f v;
    in
    lib.traceSeqN (depth + 1) {
      fn = name;
      from = v;
      to = res;
    } res;

  # -- TESTING --

  /**
    Evaluates a set of tests.

    A test is an attribute set `{expr, expected}`,
    denoting an expression and its expected result.

    The result is a `list` of __failed tests__, each represented as
    `{name, expected, result}`,

    - expected
      - What was passed as `expected`
    - result
      - The actual `result` of the test

    Used for regression testing of the functions in lib; see
    tests.nix for more examples.

    Important: Only attributes that start with `test` are executed.

    - If you want to run only a subset of the tests add the attribute `tests = ["testName"];`

    # Inputs

    `tests`

    : Tests to run

    # Type

    ```
    runTests :: {
      tests = [ String ];
      ${testName} :: {
        expr :: a;
        expected :: a;
      };
    }
    ->
    [
      {
        name :: String;
        expected :: a;
        result :: a;
      }
    ]
    ```

    # Examples
    :::{.example}
    ## `lib.debug.runTests` usage example

    ```nix
    runTests {
      testAndOk = {
        expr = lib.and true false;
        expected = false;
      };
      testAndFail = {
        expr = lib.and true false;
        expected = true;
      };
    }
    ->
    [
      {
        name = "testAndFail";
        expected = true;
        result = false;
      }
    ]
    ```

    :::
  */
  runTests =
    tests:
    concatLists (
      attrValues (
        mapAttrs (
          name: test:
          let
            testsToRun = if tests ? tests then tests.tests else [ ];
          in
          if
            (substring 0 4 name == "test" || elem name testsToRun)
            && ((testsToRun == [ ]) || elem name tests.tests)
            && (test.expr != test.expected)

          then
            [
              {
                inherit name;
                expected = test.expected;
                result = test.expr;
              }
            ]
          else
            [ ]
        ) tests
      )
    );

  /**
    Pretty-print a list of test failures.

    This takes an attribute set containing `failures` (a list of test failures
    produced by `runTests`) and pretty-prints each failing test, before
    throwing an error containing the raw test data as JSON.

    If the input list is empty, `null` is returned.

    # Inputs

    `failures`

    : A list of test failures (produced `runTests`), each containing `name`,
      `expected`, and `result` attributes.

    # Type

    ```
    throwTestFailures :: {
      failures = [
        {
          name :: String;
          expected :: a;
          result :: a;
        }
      ];
    }
    ->
    null
    ```

    # Examples
    :::{.example}

    ## `lib.debug.throwTestFailures` usage example

    ```nix
    throwTestFailures {
      failures = [
        {
          name = "testDerivation";
          expected = derivation {
            name = "a";
            builder = "bash";
            system = "x86_64-linux";
          };
          result = derivation {
            name = "b";
            builder = "bash";
            system = "x86_64-linux";
          };
        }
      ];
    }
    ->
    trace: FAIL testDerivation:
      Expected: <derivation a>
        Result: <derivation b>

    error:
           … while evaluating the file '...':

           … caused by explicit throw
             at /nix/store/.../lib/debug.nix:528:7:
              527|       in
              528|       throw (
                 |       ^
              529|         builtins.seq traceFailures (

           error: 1 tests failed:
           - testDerivation

           [{"expected":"/nix/store/xh7kyqp69mxkwspmi81a94m9xx74r8dr-a","name":"testDerivation","result":"/nix/store/503l84nir4zw57d1shfhai25bxxn16c6-b"}]
    null
    ```

    :::
  */
  throwTestFailures =
    {
      failures,
      description ? "tests",
      ...
    }:
    if failures == [ ] then
      null
    else
      let
        toPretty =
          value:
          # Thanks to @Ma27 for this:
          #
          # > The `unsafeDiscardStringContext` is useful when the `toPretty`
          # > stumbles upon a derivation that would be realized without it (I
          # > ran into the problem when writing a test for a flake helper where
          # > I creating a bunch of "mock" derivations for different systems
          # > and Nix then tried to build those when the error-string got
          # > forced).
          #
          # See: https://github.com/NixOS/nixpkgs/pull/416207#discussion_r2145942389
          builtins.unsafeDiscardStringContext (generators.toPretty { allowPrettyValues = true; } value);

        failureToPretty = failure: ''
          FAIL ${toPretty failure.name}:
          Expected:
          ${toPretty failure.expected}

          Result:
          ${toPretty failure.result}
        '';

        traceFailures = foldl' (_accumulator: failure: traceVal (failureToPretty failure)) null failures;
      in
      throw (
        builtins.seq traceFailures (
          "${builtins.toString (builtins.length failures)} ${description} failed:\n- "
          + (concatMapStringsSep "\n- " (failure: failure.name) failures)
          + "\n\n"
          + builtins.toJSON failures
        )
      );

  /**
    Create a test assuming that list elements are `true`.

    # Inputs

    `expr`

    : 1\. Function argument

    # Examples
    :::{.example}
    ## `lib.debug.testAllTrue` usage example

    ```nix
    { testX = allTrue [ true ]; }
    ```

    :::
  */
  testAllTrue = expr: {
    inherit expr;
    expected = map (x: true) expr;
  };
}
