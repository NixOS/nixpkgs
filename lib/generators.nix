/* Functions that generate widespread file
 * formats from nix data structures.
 *
 * They all follow a similar interface:
 * generator { config-attrs } data
 *
 * Tests can be found in ./tests.nix
 * Documentation in the manual, #sec-generators
 */
with import ./trivial.nix;
let
  libStr = import ./strings.nix;
  libAttr = import ./attrsets.nix;

  flipMapAttrs = flip libAttr.mapAttrs;
in

rec {

  /* Generate a line of key k and value v, separated by
   * character sep. If sep appears in k, it is escaped.
   * Helper for synaxes with different separators.
   *
   * mkKeyValueDefault ":" "f:oo" "bar"
   * > "f\:oo:bar"
   */
  mkKeyValueDefault = sep: k: v:
    "${libStr.escape [sep] k}${sep}${toString v}";


  /* Generate a key-value-style config file from an attrset.
   *
   * mkKeyValue is the same as in toINI.
   */
  toKeyValue = {
    mkKeyValue ? mkKeyValueDefault "="
  }: attrs:
    let mkLine = k: v: mkKeyValue k v + "\n";
    in libStr.concatStrings (libAttr.mapAttrsToList mkLine attrs);


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
    mkKeyValue    ? mkKeyValueDefault "="
  }: attrsOfAttrs:
    let
        # map function to string for each key val
        mapAttrsToStringsSep = sep: mapFn: attrs:
          libStr.concatStringsSep sep
            (libAttr.mapAttrsToList mapFn attrs);
        mkSection = sectName: sectValues: ''
          [${mkSectionName sectName}]
        '' + toKeyValue { inherit mkKeyValue; } sectValues;
    in
      # map input to ini sections
      mapAttrsToStringsSep "\n" mkSection attrsOfAttrs;


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
  toPretty = {
    /* If this option is true, attrsets like { __pretty = fn; val = …; }
       will use fn to convert val to a pretty printed representation.
       (This means fn is type Val -> String.) */
    allowPrettyValues ? false
  }@args: v: with builtins;
    if      isInt      v then toString v
    else if isBool     v then (if v == true then "true" else "false")
    else if isString   v then "\"" + v + "\""
    else if null ==    v then "null"
    else if isFunction v then
      let fna = functionArgs v;
          showFnas = concatStringsSep "," (libAttr.mapAttrsToList
                       (name: hasDefVal: if hasDefVal then "(${name})" else name)
                       fna);
      in if fna == {}    then "<λ>"
                         else "<λ:{${showFnas}}>"
    else if isList     v then "[ "
        + libStr.concatMapStringsSep " " (toPretty args) v
      + " ]"
    else if isAttrs    v then
      # apply pretty values if allowed
      if attrNames v == [ "__pretty" "val" ] && allowPrettyValues
         then v.__pretty v.val
      # TODO: there is probably a better representation?
      else if v ? type && v.type == "derivation" then "<δ>"
      else "{ "
          + libStr.concatStringsSep " " (libAttr.mapAttrsToList
              (name: value:
                "${toPretty args name} = ${toPretty args value};") v)
        + " }"
    else "toPretty: should never happen (v = ${v})";

}
