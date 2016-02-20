# Nixpkgs/NixOS option handling.

let lib = import ./default.nix; in

with import ./trivial.nix;
with import ./lists.nix;
with import ./attrsets.nix;
with import ./strings.nix;
with {inherit (import ./types.nix) types; };

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
    , readOnly ? null # Whether the option can be set only once
    , options ? null # Obsolete, used by types.optionSet.
    } @ attrs:
    attrs // { _type = "option"; };

  mkEnableOption = name: mkOption {
    default = false;
    example = true;
    description = "Whether to enable ${name}.";
    type = lib.types.bool;
  };

  # This option accept anything, but it does not produce any result.  This
  # is useful for sharing a module across different module sets without
  # having to implement similar features as long as the value of the options
  # are not expected.
  mkSinkUndeclaredOptions = attrs: mkOption ({
    internal = true;
    visible = false;
    default = false;
    description = "Sink for option definitions.";
    type = mkOptionType {
      name = "sink";
      typerep = "(sink)";
      check = x: true;
      merge = config: loc: defs: false;
    };
    apply = x: throw "Option value is not readable because the option is not declared.";
  } // attrs);

  mergeDefaultOption = config: loc: defs:
    let list = getValues defs; in
    if length list == 1 then head list
    else if all isFunction list then x: mergeDefaultOption config loc (map (f: f x) list)
    else if all isList list then concatLists list
    else if all isAttrs list then foldl' lib.mergeAttrs {} list
    else if all isBool list then foldl' lib.or false list
    else if all isString list then lib.concatStrings list
    else if all isInt list && all (x: x == head list) list then head list
    else throw "Cannot merge definitions of `${showOption loc}' given in ${showFiles (getFiles defs)}.";

  mergeOneOption = config: loc: defs:
    if defs == [] then abort "This case should never happen."
    else if length defs != 1 then
      throw "The unique option `${showOption loc}' is defined multiple times, in ${showFiles (getFiles defs)}."
    else (head defs).value;

  /* "Merge" option definitions by checking that they all have the same value. */
  mergeEqualOption = config: loc: defs:
    if defs == [] then abort "This case should never happen."
    else foldl' (val: def:
      if def.value != val then
        throw "The option `${showOption loc}' has conflicting definitions, in ${showFiles (getFiles defs)}."
      else
        val) (head defs).value defs;

  getValues = map (x: x.value);
  getFiles = map (x: x.file);

  # Generate documentation template from the list of option declaration like
  # the set generated with filterOptionSets.
  optionAttrSetToDocList = optionAttrSetToDocList' [];

  optionAttrSetToDocList' = prefix: internalModuleConfig: options:
    concatMap (opt:
      let
        decls = filter (x: x != unknownModule) opt.declarations;
        docOption = rec {
          name = showOption opt.loc;
          description = opt.description or (throw "Option `${name}' has no description.");
          declarations = decls;
          internal = opt.internal or false;
          visible = opt.visible or true;
          readOnly = opt.readOnly or false;
          type = opt.type.name or null;
        }
        // (if opt ? example then { example = detectDerivation decls opt.example; } else {})
        // (if opt ? default then { default = detectDerivation decls opt.default; } else {})
        // (if opt ? defaultText then { default = opt.defaultText; } else {});

        subOptions =
          let ss = opt.type.getSubOptionsPrefixed opt.loc;
          in if ss != {} then optionAttrSetToDocList' opt.loc internalModuleConfig (ss internalModuleConfig) else [];
      in
        [ docOption ] ++ subOptions) (collect isOption options);

  # TODO: Use "extractOptionAttrSet" instead of "optionAttrSetToDocList'" to reduce the code size.
  #       It should be a drop-in-replacement. But first, examine the impact on the evaluation time.
  # optionAttrSetToDocList = extractOptionAttrSet true [];

  # Generate a machine readable specification of the list of option declarations.
  optionAttrSetToParseableSpecifications = extractOptionAttrSet false [];

  extractOptionAttrSet = toDoc: prefix: internalModuleConfig: options:
    concatMap (opt:
      let
        optionName = showOption opt.loc;

        # Check if a type contains derivations, that is check if a type nests
        # a 'package', 'packageSet' or 'nixpkgsConfig' type.
        hasDerivation = any (t: elem t opt.type.nestedTypes) ((map (x: x.typerep) (with types; [package packageSet])) ++ ["(nixpkgsConfig)"]);

        # Check if type is 'path' which can potentially contain a derivation.
        maybeHiddenDerivation = any (t: elem t opt.type.nestedTypes) (map (x: x.typerep) (with types; [path]));

        isDefaultValue = elem opt.default opt.type.defaultValues;

        /* Enforce that the example attribute is wrapped with 'literalExample'
           for every type that contains derivations. */
        example =
          if opt ? example
          then (if hasDerivation
                then (if isLiteralExample opt.example
                      then { example = detectDerivation decls opt.example; }
                      else throw "The attribute ${optionName}.example must be wrapped with 'literalExample' in ${concatStringsSep " and " decls}!")
                else { example = detectDerivation decls opt.example; })
          else {};

        /* Enforce that the 'defaultText' attribute is defined for every option
           that has a 'default' attribute that contains derivations. */
        default =
          if opt ? default
          then (if hasDerivation
                then (if isDefaultValue
                      then { default = opt.default; }
                      else (if opt ? defaultText
                            then { default = literalExample (detectDerivation decls opt.defaultText); }
                            else throw "The option ${optionName} requires a 'defaultText' attribute in ${concatStringsSep " and " decls}!"))
                else (if opt ? defaultText
                      then (if maybeHiddenDerivation
                            then (if (let eval = builtins.tryEval (findDerivation opt.default); in eval.success && !eval.value)
                                  then builtins.trace
                                       "The attribute ${optionName}.defaultText might not be necessary in ${concatStringsSep " and " decls}!"
                                       { default = literalExample (detectDerivation decls opt.defaultText); }
                                  else { default = literalExample (detectDerivation decls opt.defaultText); })
                            else builtins.trace
                                 "The attribute ${optionName}.defaultText is not used and can be removed in ${concatStringsSep " and " decls}!"
                                 { default = detectDerivation decls opt.default; })
                      else { default = detectDerivation decls opt.default; }))
          else {};

        decls = filter (x: x != unknownModule) opt.declarations;

        docOption = {
          name = optionName;
          description = opt.description or (throw "Option `${optionName}' has no description.");
          declarations = decls;
          internal = opt.internal or false;
          visible = opt.visible or true;
          readOnly = opt.readOnly or false;
        } // example // default // subOptions // typeKeys;

        typeKeys = if toDoc then { type = opt.type.name or null; } else { type = opt.type.typerep; keys = opt.loc; };

        subOptions =
          if toDoc
          then {}
          else let ss = opt.type.getSubOptions;
               in if ss != {} then { suboptions = (extractOptionAttrSet false [] internalModuleConfig (ss internalModuleConfig)); } else {};

        subOptionsDoc =
          if toDoc
          then let ss = opt.type.getSubOptionsPrefixed opt.loc;
               in if ss != {} then extractOptionAttrSet true opt.loc internalModuleConfig (ss internalModuleConfig) else []
          else [];
      in
        [ docOption ]  ++ subOptionsDoc )
          (filter (opt: (opt.visible or true) && !(opt.internal or false)) (collect isOption options));


  /* This function recursively checks for derivations within an
     an expression, and throws an error if a derivation or a
     store path is found. The function is used to ensure that no
     derivation leaks from the 'default' or 'example' attributes
     of an option.
     This makes the generation of `options.xml' much more efficient:
     the XML representation of derivations is very large (on the
     order of megabytes) and is not actually used by the manual
     generator. */
  detectDerivation = decl: x:
    if isDerivation x then
      throw "Found unexpected derivation in '${x.name}' in '${concatStringsSep " and " decl}'!"
    else if isString x && isStorePath x then
      throw "Found unexpected store path in '${x.name}' in '${concatStringsSep " and " decl}'!"
    else if isList x then map (detectDerivation decl) x
    else if isAttrs x then mapAttrs (n: v: (detectDerivation decl) v) (removeAttrs x ["_args"])
    else x;

  /* Same as detectDerivation, but returns a boolean instead of
     throwing an exception. */
  findDerivation = x:
    if (isString x && isStorePath x) || isDerivation x then true
    else if isList x then any findDerivation x
    else if isAttrs x then any findDerivation (mapAttrsToList (_: v: v) (removeAttrs x ["_args"]))
    else false;



  /* For use in the ‘example’ option attribute.  It causes the given
     text to be included verbatim in documentation.  This is necessary
     for example values that are not simple values, e.g.,
     functions. */
  # TODO: A more general name would probably be "literalNix".
  literalExample = text: { _type = "literalExample"; inherit text; };

  isLiteralExample = x: isAttrs x && hasAttr "_type" x && x._type == "literalExample";


  /* Helper functions. */
  showOption = concatStringsSep ".";
  showFiles = files: concatStringsSep " and " (map (f: "`${f}'") files);
  unknownModule = "<unknown-file>";

}
