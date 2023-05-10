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
 * Tests can be found in ./tests/misc.nix
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
    # convert derivations to store paths
    else if lib.isDerivation v then toString v
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
   * For more examples see the test cases in ./tests/misc.nix.
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

  /* Generate an INI-style config file from an attrset
   * specifying the global section (no header), and an
   * attrset of sections to an attrset of key-value pairs.
   *
   * generators.toINIWithGlobalSection {} {
   *   globalSection = {
   *     someGlobalKey = "hi";
   *   };
   *   sections = {
   *     foo = { hi = "${pkgs.hello}"; ciao = "bar"; };
   *     baz = { "also, integers" = 42; };
   * }
   *
   *> someGlobalKey=hi
   *>
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
   * For more examples see the test cases in ./tests/misc.nix.
   *
   * If you don’t need a global section, you can also use
   * `generators.toINI` directly, which only takes
   * the part in `sections`.
   */
  toINIWithGlobalSection = {
    # apply transformations (e.g. escapes) to section names
    mkSectionName ? (name: libStr.escape [ "[" "]" ] name),
    # format a setting line from key and value
    mkKeyValue    ? mkKeyValueDefault {} "=",
    # allow lists as values for duplicate keys
    listsAsDuplicateKeys ? false
  }: { globalSection, sections }:
    ( if globalSection == {}
      then ""
      else (toKeyValue { inherit mkKeyValue listsAsDuplicateKeys; } globalSection)
           + "\n")
    + (toINI { inherit mkSectionName mkKeyValue listsAsDuplicateKeys; } sections);

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
          if isAttrs value && !lib.isDerivation value then
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
  toYAML = toJSON;

  withRecursion =
    {
      /* If this option is not null, the given value will stop evaluating at a certain depth */
      depthLimit
      /* If this option is true, an error will be thrown, if a certain given depth is exceeded */
    , throwOnDepthLimit ? true
    }:
      assert builtins.isInt depthLimit;
      let
        specialAttrs = [
          "__functor"
          "__functionArgs"
          "__toString"
          "__pretty"
        ];
        stepIntoAttr = evalNext: name:
          if builtins.elem name specialAttrs
            then id
            else evalNext;
        transform = depth:
          if depthLimit != null && depth > depthLimit then
            if throwOnDepthLimit
              then throw "Exceeded maximum eval-depth limit of ${toString depthLimit} while trying to evaluate with `generators.withRecursion'!"
              else const "<unevaluated>"
          else id;
        mapAny = with builtins; depth: v:
          let
            evalNext = x: mapAny (depth + 1) (transform (depth + 1) x);
          in
            if isAttrs v then mapAttrs (stepIntoAttr evalNext) v
            else if isList v then map evalNext v
            else transform (depth + 1) v;
      in
        mapAny 0;

  /* Pretty print a value, akin to `builtins.trace`.
   * Should probably be a builtin as well.
   * The pretty-printed string should be suitable for rendering default values
   * in the NixOS manual. In particular, it should be as close to a valid Nix expression
   * as possible.
   */
  toPretty = {
    /* If this option is true, attrsets like { __pretty = fn; val = …; }
       will use fn to convert val to a pretty printed representation.
       (This means fn is type Val -> String.) */
    allowPrettyValues ? false,
    /* If this option is true, the output is indented with newlines for attribute sets and lists */
    multiline ? true,
    /* Initial indentation level */
    indent ? ""
  }:
    let
    go = indent: v: with builtins;
    let     isPath   = v: typeOf v == "path";
            introSpace = if multiline then "\n${indent}  " else " ";
            outroSpace = if multiline then "\n${indent}" else " ";
    in if   isInt      v then toString v
    # toString loses precision on floats, so we use toJSON instead. This isn't perfect
    # as the resulting string may not parse back as a float (e.g. 42, 1e-06), but for
    # pretty-printing purposes this is acceptable.
    else if isFloat    v then builtins.toJSON v
    else if isString   v then
      let
        lines = filter (v: ! isList v) (builtins.split "\n" v);
        escapeSingleline = libStr.escape [ "\\" "\"" "\${" ];
        escapeMultiline = libStr.replaceStrings [ "\${" "''" ] [ "''\${" "'''" ];
        singlelineResult = "\"" + concatStringsSep "\\n" (map escapeSingleline lines) + "\"";
        multilineResult = let
          escapedLines = map escapeMultiline lines;
          # The last line gets a special treatment: if it's empty, '' is on its own line at the "outer"
          # indentation level. Otherwise, '' is appended to the last line.
          lastLine = lib.last escapedLines;
        in "''" + introSpace + concatStringsSep introSpace (lib.init escapedLines)
                + (if lastLine == "" then outroSpace else introSpace + lastLine) + "''";
      in
        if multiline && length lines > 1 then multilineResult else singlelineResult
    else if true  ==   v then "true"
    else if false ==   v then "false"
    else if null  ==   v then "null"
    else if isPath     v then toString v
    else if isList     v then
      if v == [] then "[ ]"
      else "[" + introSpace
        + libStr.concatMapStringsSep introSpace (go (indent + "  ")) v
        + outroSpace + "]"
    else if isFunction v then
      let fna = lib.functionArgs v;
          showFnas = concatStringsSep ", " (libAttr.mapAttrsToList
                       (name: hasDefVal: if hasDefVal then name + "?" else name)
                       fna);
      in if fna == {}    then "<function>"
                         else "<function, args: {${showFnas}}>"
    else if isAttrs    v then
      # apply pretty values if allowed
      if allowPrettyValues && v ? __pretty && v ? val
         then v.__pretty v.val
      else if v == {} then "{ }"
      else if v ? type && v.type == "derivation" then
        "<derivation ${v.name or "???"}>"
      else "{" + introSpace
          + libStr.concatStringsSep introSpace (libAttr.mapAttrsToList
              (name: value:
                "${libStr.escapeNixIdentifier name} = ${
                  builtins.addErrorContext "while evaluating an attribute `${name}`"
                    (go (indent + "  ") value)
                };") v)
        + outroSpace + "}"
    else abort "generators.toPretty: should never happen (v = ${v})";
  in go indent;

  # PLIST handling
  toPlist = {}: v: let
    isFloat = builtins.isFloat or (x: false);
    isPath = x: builtins.typeOf x == "path";
    expr = ind: x:  with builtins;
      if x == null  then "" else
      if isBool x   then bool ind x else
      if isInt x    then int ind x else
      if isString x then str ind x else
      if isList x   then list ind x else
      if isAttrs x  then attrs ind x else
      if isPath x   then str ind (toString x) else
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
      (name: value: lib.optionals (attrFilter name value) [
      (key "\t${ind}" name)
      (expr "\t${ind}" value)
    ]) x));

  in ''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
${expr "" v}
</plist>'';

  /* Translate a simple Nix expression to Dhall notation.
   * Note that integers are translated to Integer and never
   * the Natural type.
  */
  toDhall = { }@args: v:
    with builtins;
    let concatItems = lib.strings.concatStringsSep ", ";
    in if isAttrs v then
      "{ ${
        concatItems (lib.attrsets.mapAttrsToList
          (key: value: "${key} = ${toDhall args value}") v)
      } }"
    else if isList v then
      "[ ${concatItems (map (toDhall args) v)} ]"
    else if isInt v then
      "${if v < 0 then "" else "+"}${toString v}"
    else if isBool v then
      (if v then "True" else "False")
    else if isFunction v then
      abort "generators.toDhall: cannot convert a function to Dhall"
    else if v == null then
      abort "generators.toDhall: cannot convert a null to Dhall"
    else
      builtins.toJSON v;

  /*
   Translate a simple Nix expression to Lua representation with occasional
   Lua-inlines that can be construted by mkLuaInline function.

   Configuration:
     * multiline - by default is true which results in indented block-like view.
     * indent - initial indent.
     * asBindings - by default generate single value, but with this use attrset to set global vars.

   Attention:
     Regardless of multiline parameter there is no trailing newline.

   Example:
     generators.toLua {}
       {
         cmd = [ "typescript-language-server" "--stdio" ];
         settings.workspace.library = mkLuaInline ''vim.api.nvim_get_runtime_file("", true)'';
       }
     ->
      {
        ["cmd"] = {
          "typescript-language-server",
          "--stdio"
        },
        ["settings"] = {
          ["workspace"] = {
            ["library"] = (vim.api.nvim_get_runtime_file("", true))
          }
        }
      }

   Type:
     toLua :: AttrSet -> Any -> String
  */
  toLua = {
    /* If this option is true, the output is indented with newlines for attribute sets and lists */
    multiline ? true,
    /* Initial indentation level */
    indent ? "",
    /* Interpret as variable bindings */
    asBindings ? false,
  }@args: v:
    with builtins;
    let
      innerIndent = "${indent}  ";
      introSpace = if multiline then "\n${innerIndent}" else " ";
      outroSpace = if multiline then "\n${indent}" else " ";
      innerArgs = args // {
        indent = if asBindings then indent else innerIndent;
        asBindings = false;
      };
      concatItems = concatStringsSep ",${introSpace}";
      isLuaInline = { _type ? null, ... }: _type == "lua-inline";

      generatedBindings =
          assert lib.assertMsg (badVarNames == []) "Bad Lua var names: ${toPretty {} badVarNames}";
          libStr.concatStrings (
            lib.attrsets.mapAttrsToList (key: value: "${indent}${key} = ${toLua innerArgs value}\n") v
            );

      # https://en.wikibooks.org/wiki/Lua_Programming/variable#Variable_names
      matchVarName = match "[[:alpha:]_][[:alnum:]_]*(\\.[[:alpha:]_][[:alnum:]_]*)*";
      badVarNames = filter (name: matchVarName name == null) (attrNames v);
    in
    if asBindings then
      generatedBindings
    else if v == null then
      "nil"
    else if isInt v || isFloat v || isString v || isBool v then
      builtins.toJSON v
    else if isList v then
      (if v == [ ] then "{}" else
      "{${introSpace}${concatItems (map (value: "${toLua innerArgs value}") v)}${outroSpace}}")
    else if isAttrs v then
      (
        if isLuaInline v then
          "(${v.expr})"
        else if v == { } then
          "{}"
        else
          "{${introSpace}${concatItems (
            lib.attrsets.mapAttrsToList (key: value: "[${builtins.toJSON key}] = ${toLua innerArgs value}") v
            )}${outroSpace}}"
      )
    else
      abort "generators.toLua: type ${typeOf v} is unsupported";

  /*
   Mark string as Lua expression to be inlined when processed by toLua.

   Type:
     mkLuaInline :: String -> AttrSet
  */
  mkLuaInline = expr: { _type = "lua-inline"; inherit expr; };
}
