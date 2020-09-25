/* Functions that generate widespread file
 * formats from nix data structures.
 *
 * They all follow a similar interface:
 * generator { config-attrs } data
 *
 * `config-attrs` are “holes” in the generators
 * with sensible default implementations that
 * can be overwritten. The default implementations
 * are mostly generators themselves, called with
 * their respective default values; they can be reused.
 *
 * Tests can be found in ./tests.nix
 * Documentation in the manual, #sec-generators
 */
{ lib }:
with (lib).trivial;
let
  libStr = lib.strings;
  libAttr = lib.attrsets;

  inherit (lib) isFunction;
in

rec {

  ## -- HELPER FUNCTIONS & DEFAULTS --

  /* Convert a value to a sensible default string representation.
   * The builtin `toString` function has some strange defaults,
   * suitable for bash scripts but not much else.
   */
  mkValueStringDefault = {}: v: with builtins;
    let err = t: v: abort
          ("generators.mkValueStringDefault: " +
           "${t} not supported: ${toPretty {} v}");
    in   if isInt      v then toString v
    # we default to not quoting strings
    else if isString   v then v
    # isString returns "1", which is not a good default
    else if true  ==   v then "true"
    # here it returns to "", which is even less of a good default
    else if false ==   v then "false"
    else if null  ==   v then "null"
    # if you have lists you probably want to replace this
    else if isList     v then err "lists" v
    # same as for lists, might want to replace
    else if isAttrs    v then err "attrsets" v
    # functions can’t be printed of course
    else if isFunction v then err "functions" v
    # Floats currently can't be converted to precise strings,
    # condition warning on nix version once this isn't a problem anymore
    # See https://github.com/NixOS/nix/pull/3480
    else if isFloat    v then libStr.floatToString v
    else err "this value is" (toString v);


  /* Generate a line of key k and value v, separated by
   * character sep. If sep appears in k, it is escaped.
   * Helper for synaxes with different separators.
   *
   * mkValueString specifies how values should be formatted.
   *
   * mkKeyValueDefault {} ":" "f:oo" "bar"
   * > "f\:oo:bar"
   */
  mkKeyValueDefault = {
    mkValueString ? mkValueStringDefault {}
  }: sep: k: v:
    "${libStr.escape [sep] k}${sep}${mkValueString v}";


  ## -- FILE FORMAT GENERATORS --


  /* Generate a key-value-style config file from an attrset.
   *
   * mkKeyValue is the same as in toINI.
   */
  toKeyValue = {
    mkKeyValue ? mkKeyValueDefault {} "=",
    listsAsDuplicateKeys ? false
  }:
  let mkLine = k: v: mkKeyValue k v + "\n";
      mkLines = if listsAsDuplicateKeys
        then k: v: map (mkLine k) (if lib.isList v then v else [v])
        else k: v: [ (mkLine k v) ];
  in attrs: libStr.concatStrings (lib.concatLists (libAttr.mapAttrsToList mkLines attrs));


  /* Generate an INI-style config file from an
   * attrset of sections to an attrset of key-value pairs.
   *
   * generators.toINI {} {
   *   foo = { hi = "${pkgs.hello}"; ciao = "bar"; };
   *   baz = { "also, integers" = 42; };
   * }
   *
   *> [baz]
   *> also, integers=42
   *>
   *> [foo]
   *> ciao=bar
   *> hi=/nix/store/y93qql1p5ggfnaqjjqhxcw0vqw95rlz0-hello-2.10
   *
   * The mk* configuration attributes can generically change
   * the way sections and key-value strings are generated.
   *
   * For more examples see the test cases in ./tests.nix.
   */
  toINI = {
    # apply transformations (e.g. escapes) to section names
    mkSectionName ? (name: libStr.escape [ "[" "]" ] name),
    # format a setting line from key and value
    mkKeyValue    ? mkKeyValueDefault {} "=",
    # allow lists as values for duplicate keys
    listsAsDuplicateKeys ? false
  }: attrsOfAttrs:
    let
        # map function to string for each key val
        mapAttrsToStringsSep = sep: mapFn: attrs:
          libStr.concatStringsSep sep
            (libAttr.mapAttrsToList mapFn attrs);
        mkSection = sectName: sectValues: ''
          [${mkSectionName sectName}]
        '' + toKeyValue { inherit mkKeyValue listsAsDuplicateKeys; } sectValues;
    in
      # map input to ini sections
      mapAttrsToStringsSep "\n" mkSection attrsOfAttrs;

  /* Generate a git-config file from an attrset.
   *
   * It has two major differences from the regular INI format:
   *
   * 1. values are indented with tabs
   * 2. sections can have sub-sections
   *
   * generators.toGitINI {
   *   url."ssh://git@github.com/".insteadOf = "https://github.com";
   *   user.name = "edolstra";
   * }
   *
   *> [url "ssh://git@github.com/"]
   *>   insteadOf = https://github.com/
   *>
   *> [user]
   *>   name = edolstra
   */
  toGitINI = attrs:
    with builtins;
    let
      mkSectionName = name:
        let
          containsQuote = libStr.hasInfix ''"'' name;
          sections = libStr.splitString "." name;
          section = head sections;
          subsections = tail sections;
          subsection = concatStringsSep "." subsections;
        in if containsQuote || subsections == [ ] then
          name
        else
          ''${section} "${subsection}"'';

      # generation for multiple ini values
      mkKeyValue = k: v:
        let mkKeyValue = mkKeyValueDefault { } " = " k;
        in concatStringsSep "\n" (map (kv: "\t" + mkKeyValue kv) (lib.toList v));

      # converts { a.b.c = 5; } to { "a.b".c = 5; } for toINI
      gitFlattenAttrs = let
        recurse = path: value:
          if isAttrs value then
            lib.mapAttrsToList (name: value: recurse ([ name ] ++ path) value) value
          else if length path > 1 then {
            ${concatStringsSep "." (lib.reverseList (tail path))}.${head path} = value;
          } else {
            ${head path} = value;
          };
      in attrs: lib.foldl lib.recursiveUpdate { } (lib.flatten (recurse [ ] attrs));

      toINI_ = toINI { inherit mkKeyValue mkSectionName; };
    in
      toINI_ (gitFlattenAttrs attrs);

  /* Generates JSON from an arbitrary (non-function) value.
    * For more information see the documentation of the builtin.
    */
  toJSON = {}: builtins.toJSON;


  /* YAML has been a strict superset of JSON since 1.2, so we
    * use toJSON. Before it only had a few differences referring
    * to implicit typing rules, so it should work with older
    * parsers as well.
    */
  toYAML = {}@args: toJSON args;

  /* Pretty print a value, akin to `builtins.trace`.
    * Should probably be a builtin as well.
    */
  toPretty =
    { # The maximum depth of recursion into attribute sets and lists. No limit if null
      recursionLimit ? null
      # The state transition function to be called for every resulting line. It takes two arguments:
      # - line: A string, this is the line that was generated and should be processed
      # - state: The state as returned by the previous invocation of this function
      #          (from the previous line, or initialState for invocation)
      #
      # The function should then return the new state, incorporating the given
      # line into it. The function may also abort printing by returning an
      # attribute set with a `return` attribute.
      #
      # The result of the toPretty call will be the state returned by the last
      # call to this transition function
      #
      # Examples:
      # - tracing lines:
      #     nextState = builtins.trace;
      # - tracing only 10 lines:
      #     nextState = line: left:
      #       if left == 0 then { return = null; }
      #       else builtins.trace line (left - 1)
      #     initialState = 10
      # - collecting a list of lines:
      #     nextState = line: list: list ++ [ line ]
      #     initialState = []
    , nextState ? line: state: if state == null then line else state + "\n" + line
      # The initial state for the transition function
    , initialState ? null
    }: let

      yield = line: state:
        if state ? return then state
        else nextState line state;

      go = buildup: state: depth: value: let

        indent = lib.concatStrings (lib.genList (_: "  ") depth);
        canRecurse = recursionLimit == null || depth < recursionLimit;
        printLiteral = lit: { buildup = buildup + lit; inherit state; };

        # FIXME: Handle escaping better
        printStr = str: let
          # Separate a string into its lines
          newlineSplits = lib.filter (r: ! lib.isList r) (builtins.split "\n" str);

          multilineResult = {
            state =
              builtins.foldl' (acc: el:
                yield (indent + "  " + el) acc
              ) (yield (buildup + "''") state) (lib.init newlineSplits);
            buildup =
              if lib.last newlineSplits == ""
              then "${indent}''"
              else "${indent}  ${lib.last newlineSplits}''";
          };
          singlelineResult = printLiteral ("\"" + libStr.escape [ "\"" ] str + "\"");
        in if lib.length newlineSplits > 1 then multilineResult else singlelineResult;

        printList = list:
          if list == [] then printLiteral "[ ]"
          else if ! canRecurse then
            if lib.length list == 1 then printLiteral "[ <1 element> ]"
            else printLiteral ("[ <" + toString (lib.length list) + " elements> ]")
          else {
            state = builtins.foldl' (acc: el:
                let start = go "${indent}  " acc (depth + 1) el;
                in yield start.buildup start.state
              ) (yield (buildup + "[") state) list;
            buildup = "${indent}]";
          };

        printAttrs = attrs:
          if attrs == {} then printLiteral "{ }"
          else if ! canRecurse then
            if lib.length (lib.attrNames attrs) == 1 then printLiteral "{ <1 attribute> }"
            else printLiteral ("{ <" + toString (lib.length (lib.attrNames attrs)) + " attributes> }")
          else {
            state = builtins.foldl' (acc: el:
                let start = go "${indent}  ${libStr.escapeNixIdentifier el} = " acc (depth + 1) attrs.${el};
                in yield (start.buildup + ";") start.state
              ) (yield (buildup + "{") state) (builtins.attrNames attrs);
            buildup = "${indent}}";
          };

        printFun = args:
          let
            # Move non-default arguments to the front
            argSort = a: b: if args.${a} == args.${b} then a < b else args.${b};
            sortedArgs = lib.sort argSort (lib.attrNames args);
            singleArg = name: if args.${name} then name + "?" else name;
            allArgs = lib.concatStringsSep ", " (map singleArg sortedArgs);
            result = if args == {} then "<function>" else "<function, args: {${allArgs}}>";
          in printLiteral result;

        eval = value: cont:
          let result = builtins.tryEval value; in
          if result.success then cont result.value
          else printLiteral "<failure>";

        result = eval (builtins.typeOf value) (type: {
          null = printLiteral "null";
          bool = printLiteral (if value then "true" else "false");
          int = printLiteral (toString value);
          float = printLiteral "~${toString value}";
          path = printLiteral (toString value);
          string = printStr value;
          lambda = printFun (builtins.functionArgs value);
          list = printList value;
          set =
            eval (value ? type && value.type == "derivation") (isDrv:
            if isDrv then eval "<derivation ${value.drvPath}>" printLiteral

            else eval (value ? __functor) (isFunctor:
            if isFunctor then eval (value.__functionArgs or {}) printFun

            else eval (value ? __toString || value ? outPath) (isStringCoercible:
            if isStringCoercible then eval (toString value) printStr

            else printAttrs value)));
        }.${type} or (throw "Type not implemented: ${type}"));

      in if state ? return then { inherit buildup state; } else result;

    in v:
      let res = go "" initialState 0 v;
      in yield res.buildup res.state;

  # PLIST handling
  toPlist = {}: v: let
    isFloat = builtins.isFloat or (x: false);
    expr = ind: x:  with builtins;
      if x == null  then "" else
      if isBool x   then bool ind x else
      if isInt x    then int ind x else
      if isString x then str ind x else
      if isList x   then list ind x else
      if isAttrs x  then attrs ind x else
      if isFloat x  then float ind x else
      abort "generators.toPlist: should never happen (v = ${v})";

    literal = ind: x: ind + x;

    bool = ind: x: literal ind  (if x then "<true/>" else "<false/>");
    int = ind: x: literal ind "<integer>${toString x}</integer>";
    str = ind: x: literal ind "<string>${x}</string>";
    key = ind: x: literal ind "<key>${x}</key>";
    float = ind: x: literal ind "<real>${toString x}</real>";

    indent = ind: expr "\t${ind}";

    item = ind: libStr.concatMapStringsSep "\n" (indent ind);

    list = ind: x: libStr.concatStringsSep "\n" [
      (literal ind "<array>")
      (item ind x)
      (literal ind "</array>")
    ];

    attrs = ind: x: libStr.concatStringsSep "\n" [
      (literal ind "<dict>")
      (attr ind x)
      (literal ind "</dict>")
    ];

    attr = let attrFilter = name: value: name != "_module" && value != null;
    in ind: x: libStr.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList
      (name: value: lib.optional (attrFilter name value) [
      (key "\t${ind}" name)
      (expr "\t${ind}" value)
    ]) x));

  in ''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
${expr "" v}
</plist>'';

}
