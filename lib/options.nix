# Nixpkgs/NixOS option handling.

let lib = import ./default.nix; in

with import ./trivial.nix;
with import ./lists.nix;
with import ./misc.nix;
with import ./attrsets.nix;
with import ./strings.nix;

rec {

  isOption = lib.isType "option";
  mkOption =
    { default ? null # Default value used when no definition is given in the configuration.
    , defaultText ? null # Textual representation of the default, for in the manual.
    , example ? null # Example value used in the manual.
    , description ? null # String describing the option.
    , type ? null # Option type, providing type-checking and value merging.
    , apply ? null # Function that converts the option value to something else.
    , internal ? null # Whether the option is for NixOS developers only.
    , visible ? null # Whether the option shows up in the manual.
    , options ? null # Obsolete, used by types.optionSet.
    } @ attrs:
    attrs // { _type = "option"; };

  mkEnableOption = name: mkOption {
    default = false;
    example = true;
    description = "Whether to enable ${name}.";
    type = lib.types.bool;
  };

  mergeDefaultOption = loc: defs:
    let list = getValues defs; in
    if length list == 1 then head list
    else if all isFunction list then x: mergeDefaultOption loc (map (f: f x) list)
    else if all isList list then concatLists list
    else if all isAttrs list then fold lib.mergeAttrs {} list
    else if all isBool list then fold lib.or false list
    else if all isString list then lib.concatStrings list
    else if all isInt list && all (x: x == head list) list then head list
    else throw "Cannot merge definitions of `${showOption loc}' given in ${showFiles (getFiles defs)}.";

  /* Obsolete, will remove soon.  Specify an option type or apply
     function instead.  */
  mergeTypedOption = typeName: predicate: merge: loc: list:
    let list' = map (x: x.value) list; in
    if all predicate list then merge list'
    else throw "Expected a ${typeName}.";

  mergeEnableOption = mergeTypedOption "boolean"
    (x: true == x || false == x) (fold lib.or false);

  mergeListOption = mergeTypedOption "list" isList concatLists;

  mergeStringOption = mergeTypedOption "string" isString lib.concatStrings;

  mergeOneOption = loc: defs:
    if defs == [] then abort "This case should never happen."
    else if length defs != 1 then
      throw "The unique option `${showOption loc}' is defined multiple times, in ${showFiles (getFiles defs)}."
    else (head defs).value;

  getValues = map (x: x.value);
  getFiles = map (x: x.file);


  # Generate documentation template from the list of option declaration like
  # the set generated with filterOptionSets.
  optionAttrSetToDocList = optionAttrSetToDocList' [];

  optionAttrSetToDocList' = prefix: options:
    fold (opt: rest:
      let
        docOption = rec {
          name = showOption opt.loc;
          description = opt.description or (throw "Option `${name}' has no description.");
          declarations = filter (x: x != unknownModule) opt.declarations;
          internal = opt.internal or false;
          visible = opt.visible or true;
        }
        // optionalAttrs (opt ? example) { example = scrubOptionValue opt.example; }
        // optionalAttrs (opt ? default) { default = scrubOptionValue opt.default; }
        // optionalAttrs (opt ? defaultText) { default = opt.defaultText; };

        subOptions =
          let ss = opt.type.getSubOptions opt.loc;
          in if ss != {} then optionAttrSetToDocList' opt.loc ss else [];
      in
        # FIXME: expensive, O(n^2)
        [ docOption ] ++ subOptions ++ rest) [] (collect isOption options);


  /* This function recursively removes all derivation attributes from
     `x' except for the `name' attribute.  This is to make the
     generation of `options.xml' much more efficient: the XML
     representation of derivations is very large (on the order of
     megabytes) and is not actually used by the manual generator. */
  scrubOptionValue = x:
    if isDerivation x then
      { type = "derivation"; drvPath = x.name; outPath = x.name; name = x.name; }
    else if isList x then map scrubOptionValue x
    else if isAttrs x then mapAttrs (n: v: scrubOptionValue v) (removeAttrs x ["_args"])
    else x;


  /* For use in the ‘example’ option attribute.  It causes the given
     text to be included verbatim in documentation.  This is necessary
     for example values that are not simple values, e.g.,
     functions. */
  literalExample = text: { _type = "literalExample"; inherit text; };


  /* Helper functions. */
  showOption = concatStringsSep ".";
  showFiles = files: concatStringsSep " and " (map (f: "`${f}'") files);
  unknownModule = "<unknown-file>";

}
