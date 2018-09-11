/* Logging, tracing, etc. */

{ lib }:

let
  inherit (builtins) trace isAttrs isList isInt
          head substring attrNames;
  inherit (lib) config id elem isFunction;
in

rec {

  # -- Logging --

  DEBUG   = 0;
  INFO    = 1000;
  WARNING = 2000;
  ERROR   = 3000;

  showLogLevel = x:
    if      x >= ERROR   then "ERROR"
    else if x >= WARNING then "WARNING"
    else if x >= INFO    then "INFO"
    else "DEBUG";

  log = level: condition: msg: x:
    if      condition && level >= (config.throwLevel or ERROR)   then throw msg
    else if condition && level >= (config.traceLevel or WARNING) then trace "${showLogLevel level}: ${msg}" x
                                                                 else x;

  debug  = log DEBUG true;
  info   = log INFO true;
  warn   = log WARNING true;
  fail   = log ERROR true;

  deprecate =
    { silentBefore ? null
    , failingAfter ? null
    , what
    , ...} @ attrs:
    assert isNull silentBefore
        || isNull failingAfter
        || lib.versionOlder silentBefore failingAfter;
    assert attrs ? reason || attrs ? replacement;
    let
      current = config.configVersion or lib.trivial.release;

      explain = lib.concatStringsSep ", " (lib.concatLists [
        (lib.optional (attrs ? reason) attrs.reason)
        (lib.optional (attrs ? replacement) "please use `${attrs.replacement}` instead")
      ]);
      failMessage = "`${what}` is long deprecated and could be removed at any point without further warnings, ${explain}";
      warnMessage = "`${what}` is deprecated, ${explain}";
      warnReason  = "ERROR after ${failingAfter}:\n${warnMessage}";
      infoReason  = "WARNING after ${silentBefore}: ${warnReason}";
    in
    if      !isNull failingAfter && lib.versionAtLeast current failingAfter then lib.fail failMessage
    else if !isNull silentBefore && lib.versionAtLeast current silentBefore then lib.warn warnReason
                                                                            else lib.info infoReason;

  # -- Tracing --

  /* Functions useful for debugging broken nix expressions.

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
  traceValSeqFn = f: v: traceValFn f (builtins.deepSeq v v);
  traceValSeq = traceValSeqFn id;

  /* A combination of `traceVal` and `traceSeqN`. */
  traceValSeqNFn = f: depth: v: traceSeqN depth (f v) v;
  traceValSeqN = traceValSeqNFn id;

  # -- Tracing for asserts --

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
  assertMsg = pred: msg:
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
  assertOneOf = name: val: xs: assertMsg
    (lib.elem val xs)
    "${name} must be one of ${
      lib.generators.toPretty {} xs}, but is: ${
        lib.generators.toPretty {} val}";

  # -- DEPRECATED --

  traceShowVal = x: trace (showVal x) x;
  traceShowValMarked = str: x: trace (str + showVal x) x;

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
