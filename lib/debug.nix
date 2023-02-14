/* Collection of functions useful for debugging
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
    isInt
    attrNames
    isList
    isAttrs
    substring
    addErrorContext
    attrValues
    concatLists
    concatStringsSep
    const
    elem
    generators
    head
    id
    isDerivation
    isFunction
    mapAttrs
    trace;
in

rec {

  # -- TRACING --

  /* Conditionally trace the supplied message, based on a predicate.

     Type: traceIf :: bool -> string -> a -> a

     Example:
       traceIf true "hello" 3
       trace: hello
       => 3
  */
  traceIf =
    # Predicate to check
    pred:
    # Message that should be traced
    msg:
    # Value to return
    x: if pred then trace msg x else x;

  /* Trace the supplied value after applying a function to it, and
     return the original value.

     Type: traceValFn :: (a -> b) -> a -> a

     Example:
       traceValFn (v: "mystring ${v}") "foo"
       trace: mystring foo
       => "foo"
  */
  traceValFn =
    # Function to apply
    f:
    # Value to trace and return
    x: trace (f x) x;

  /* Trace the supplied value and return it.

     Type: traceVal :: a -> a

     Example:
       traceVal 42
       # trace: 42
       => 42
  */
  traceVal = traceValFn id;

  /* `builtins.trace`, but the value is `builtins.deepSeq`ed first.

     Type: traceSeq :: a -> b -> b

     Example:
       trace { a.b.c = 3; } null
       trace: { a = <CODE>; }
       => null
       traceSeq { a.b.c = 3; } null
       trace: { a = { b = { c = 3; }; }; }
       => null
  */
  traceSeq =
    # The value to trace
    x:
    # The value to return
    y: trace (builtins.deepSeq x x) y;

  /* Like `traceSeq`, but only evaluate down to depth n.
     This is very useful because lots of `traceSeq` usages
     lead to an infinite recursion.

     Example:
       traceSeqN 2 { a.b.c = 3; } null
       trace: { a = { b = {…}; }; }
       => null
   */
  traceSeqN = depth: x: y:
    let snip = v: if      isList  v then noQuotes "[…]" v
                  else if isAttrs v then noQuotes "{…}" v
                  else v;
        noQuotes = str: v: { __pretty = const str; val = v; };
        modify = n: fn: v: if (n == 0) then fn v
                      else if isList  v then map (modify (n - 1) fn) v
                      else if isAttrs v then mapAttrs
                        (const (modify (n - 1) fn)) v
                      else v;
    in trace (generators.toPretty { allowPrettyValues = true; }
               (modify depth snip x)) y;

  /* A combination of `traceVal` and `traceSeq` that applies a
     provided function to the value to be traced after `deepSeq`ing
     it.
  */
  traceValSeqFn =
    # Function to apply
    f:
    # Value to trace
    v: traceValFn f (builtins.deepSeq v v);

  /* A combination of `traceVal` and `traceSeq`. */
  traceValSeq = traceValSeqFn id;

  /* A combination of `traceVal` and `traceSeqN` that applies a
  provided function to the value to be traced. */
  traceValSeqNFn =
    # Function to apply
    f:
    depth:
    # Value to trace
    v: traceSeqN depth (f v) v;

  /* A combination of `traceVal` and `traceSeqN`. */
  traceValSeqN = traceValSeqNFn id;

  /* Trace the input and output of a function `f` named `name`,
  both down to `depth`.

  This is useful for adding around a function call,
  to see the before/after of values as they are transformed.

     Example:
       traceFnSeqN 2 "id" (x: x) { a.b.c = 3; }
       trace: { fn = "id"; from = { a.b = {…}; }; to = { a.b = {…}; }; }
       => { a.b.c = 3; }
  */
  traceFnSeqN = depth: name: f: v:
    let res = f v;
    in lib.traceSeqN
        (depth + 1)
        {
          fn = name;
          from = v;
          to = res;
        }
        res;


  # -- TESTING --

  /* Evaluate a set of tests.  A test is an attribute set `{expr,
     expected}`, denoting an expression and its expected result.  The
     result is a list of failed tests, each represented as `{name,
     expected, actual}`, denoting the attribute name of the failing
     test and its expected and actual results.

     Used for regression testing of the functions in lib; see
     tests.nix for an example. Only tests having names starting with
     "test" are run.

     Add attr { tests = ["testName"]; } to run these tests only.
  */
  runTests =
    # Tests to run
    tests: concatLists (attrValues (mapAttrs (name: test:
    let testsToRun = if tests ? tests then tests.tests else [];
    in if (substring 0 4 name == "test" ||  elem name testsToRun)
       && ((testsToRun == []) || elem name tests.tests)
       && (test.expr != test.expected)

      then [ { inherit name; expected = test.expected; result = test.expr; } ]
      else [] ) tests));

  /* Create a test assuming that list elements are `true`.

     Example:
       { testX = allTrue [ true ]; }
  */
  testAllTrue = expr: { inherit expr; expected = map (x: true) expr; };


  # -- DEPRECATED --

  traceShowVal = _:
    throw ( "`traceShowVal` is deprecated "
          + "and will be removed in release 23.05. "
          + "Please use `FILL IN`." );
  traceShowValMarked = _:
    throw ( "`traceShowValMarked` is deprecated "
          + "and will be removed in release 23.05. "
          + "Please use `FILL IN`." );

  attrNamesToStr =  _:
    throw ( "`attrNamesToStr` is deprecated "
          + "and will be removed in release 23.05. "
          + "Please use more specific concatenation "
          + "for your uses (`lib.concat(Map)StringsSep`)." );

  showVal = _:
    throw ( "`showVal` is deprecated "
          + "and will be removed in release 23.05. "
          + "please use `traceSeqN`" );

  traceXMLVal = _:
    throw ( "`traceXMLVal` is deprecated "
          + "and will be removed in release 23.05. "
          + "Please use `traceValFn builtins.toXML`." );
  traceXMLValMarked = _:
    throw ( "`traceXMLValMarked` is deprecated "
          + "and will be removed in release 23.05. "
          + "Please use `traceValFn (x: str + builtins.toXML x)`." );

  traceCall  = _:
    throw ( "`traceCall` is deprecated "
          + "and will be removed in release 23.05. "
          + "Please use `FILL IN`." );

  traceCall2 = _:
    throw ( "`traceCall2` is deprecated "
          + "and will be removed in release 23.05. "
          + "Please use `FILL IN`." );

  traceCall3 = _:
    throw ( "`traceCall3` is deprecated "
          + "and will be removed in release 23.05. "
          + "Please use `FILL IN`." );

  traceValIfNot = _:
    throw ( "`traceValIfNot` is deprecated "
          + "and will be removed in release 23.05. "
          + "Please use `if/then/else` and `traceValSeq 1`.");


  addErrorContextToAttrs = _:
    throw ( "`addErrorContextToAttrs` is deprecated "
          + "and will be removed in release 23.05. "
          + "Please use `builtins.addErrorContext` directly." );

  traceCallXml = _:
    throw ( "`traceCallXml` is deprecated "
          + "and will be removed in release 23.05. "
          );
}
