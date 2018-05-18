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
  inherit (builtins) trace isAttrs isList isInt
          head substring attrNames;
  inherit (lib) id elem isFunction;
in

rec {

  # -- TRACING --

  /* Trace msg, but only if pred is true.

     Example:
       traceIf true "hello" 3
       trace: hello
       => 3
  */
  traceIf = pred: msg: x: if pred then trace msg x else x;

  /* Trace the value and also return it.

     Example:
       traceValFn (v: "mystring ${v}") "foo"
       trace: mystring foo
       => "foo"
  */
  traceValFn = f: x: trace (f x) x;
  traceVal = traceValFn id;

  /* `builtins.trace`, but the value is `builtins.deepSeq`ed first.

     Example:
       trace { a.b.c = 3; } null
       trace: { a = <CODE>; }
       => null
       traceSeq { a.b.c = 3; } null
       trace: { a = { b = { c = 3; }; }; }
       => null
  */
  traceSeq = x: y: trace (builtins.deepSeq x x) y;

  /* Like `traceSeq`, but only evaluate down to depth n.
     This is very useful because lots of `traceSeq` usages
     lead to an infinite recursion.

     Example:
       traceSeqN 2 { a.b.c = 3; } null
       trace: { a = { b = {…}; }; }
       => null
   */
  traceSeqN = depth: x: y: with lib;
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

  /* A combination of `traceVal` and `traceSeq` */
  traceValSeqFn = f: v: traceVal f (builtins.deepSeq v v);
  traceValSeq = traceValSeqFn id;

  /* A combination of `traceVal` and `traceSeqN`. */
  traceValSeqNFn = f: depth: v: traceSeqN depth (f v) v;
  traceValSeqN = traceValSeqNFn id;


  # -- TESTING --

  /* Evaluate a set of tests.  A test is an attribute set {expr,
     expected}, denoting an expression and its expected result.  The
     result is a list of failed tests, each represented as {name,
     expected, actual}, denoting the attribute name of the failing
     test and its expected and actual results.  Used for regression
     testing of the functions in lib; see tests.nix for an example.
     Only tests having names starting with "test" are run.
     Add attr { tests = ["testName"]; } to run these test only
  */
  runTests = tests: lib.concatLists (lib.attrValues (lib.mapAttrs (name: test:
    let testsToRun = if tests ? tests then tests.tests else [];
    in if (substring 0 4 name == "test" ||  elem name testsToRun)
       && ((testsToRun == []) || elem name tests.tests)
       && (test.expr != test.expected)

      then [ { inherit name; expected = test.expected; result = test.expr; } ]
      else [] ) tests));

  # create a test assuming that list elements are true
  # usage: { testX = allTrue [ true ]; }
  testAllTrue = expr: { inherit expr; expected = map (x: true) expr; };


  # -- DEPRECATED --

  traceShowVal = x: trace (showVal x) x;
  traceShowValMarked = str: x: trace (str + showVal x) x;

  attrNamesToStr = a:
    trace ( "Warning: `attrNamesToStr` is deprecated "
          + "and will be removed in the next release. "
          + "Please use more specific concatenation "
          + "for your uses (`lib.concat(Map)StringsSep`)." )
    (lib.concatStringsSep "; " (map (x: "${x}=") (attrNames a)));

  showVal = with lib;
    trace ( "Warning: `showVal` is deprecated "
          + "and will be removed in the next release, "
          + "please use `traceSeqN`" )
    (let
      modify = v:
        let pr = f: { __pretty = f; val = v; };
        in   if isDerivation v then pr
          (drv: "<δ:${drv.name}:${concatStringsSep ","
                                 (attrNames drv)}>")
        else if [] ==   v then pr (const "[]")
        else if isList  v then pr (l: "[ ${go (head l)}, … ]")
        else if isAttrs v then pr
          (a: "{ ${ concatStringsSep ", " (attrNames a)} }")
        else v;
      go = x: generators.toPretty
        { allowPrettyValues = true; }
        (modify x);
    in go);

  traceXMLVal = x:
    trace ( "Warning: `traceXMLVal` is deprecated "
          + "and will be removed in the next release. "
          + "Please use `traceValFn builtins.toXML`." )
    (trace (builtins.toXML x) x);
  traceXMLValMarked = str: x:
    trace ( "Warning: `traceXMLValMarked` is deprecated "
          + "and will be removed in the next release. "
          + "Please use `traceValFn (x: str + builtins.toXML x)`." )
    (trace (str + builtins.toXML x) x);

  # trace the arguments passed to function and its result
  # maybe rewrite these functions in a traceCallXml like style. Then one function is enough
  traceCall  = n: f: a: let t = n2: x: traceShowValMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a));
  traceCall2 = n: f: a: b: let t = n2: x: traceShowValMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a) (t "arg 2" b));
  traceCall3 = n: f: a: b: c: let t = n2: x: traceShowValMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a) (t "arg 2" b) (t "arg 3" c));

  traceValIfNot = c: x:
    trace ( "Warning: `traceValIfNot` is deprecated "
          + "and will be removed in the next release. "
          + "Please use `if/then/else` and `traceValSeq 1`.")
    (if c x then true else traceSeq (showVal x) false);


  addErrorContextToAttrs = attrs:
    trace ( "Warning: `addErrorContextToAttrs` is deprecated "
          + "and will be removed in the next release. "
          + "Please use `builtins.addErrorContext` directly." )
    (lib.mapAttrs (a: v: lib.addErrorContext "while evaluating ${a}" v) attrs);

  # example: (traceCallXml "myfun" id 3) will output something like
  # calling myfun arg 1: 3 result: 3
  # this forces deep evaluation of all arguments and the result!
  # note: if result doesn't evaluate you'll get no trace at all (FIXME)
  #       args should be printed in any case
  traceCallXml = a:
    trace ( "Warning: `traceCallXml` is deprecated "
          + "and will be removed in the next release. "
          + "Please complain if you use the function regularly." )
    (if !isInt a then
      traceCallXml 1 "calling ${a}\n"
    else
      let nr = a;
      in (str: expr:
          if isFunction expr then
            (arg:
              traceCallXml (builtins.add 1 nr) "${str}\n arg ${builtins.toString nr} is \n ${builtins.toXML (builtins.seq arg arg)}" (expr arg)
            )
          else
            let r = builtins.seq expr expr;
            in trace "${str}\n result:\n${builtins.toXML r}" r
      ));
}
