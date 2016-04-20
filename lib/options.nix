# Nixpkgs/NixOS option handling.

let lib = import ./default.nix; in

with import ./trivial.nix;
with import ./lists.nix;
with import ./attrsets.nix;
with import ./strings.nix;

rec {

  isOption = lib.isType "option";
  mkOption =
    { default ? null # Default value used when no definition is given in the configuration.
    , defaultText ? null # Textual representation of the default, for in the manual.
    , example ? null # Example value used in the manual.
    , description ? null # String describing the option.
    , packages ? [] # Related packages to be specified with `literalPackages*' functions
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
      check = x: true;
      merge = loc: defs: false;
    };
    apply = x: throw "Option value is not readable because the option is not declared.";
  } // attrs);

  mergeDefaultOption = loc: defs:
    let list = getValues defs; in
    if length list == 1 then head list
    else if all isFunction list then x: mergeDefaultOption loc (map (f: f x) list)
    else if all isList list then concatLists list
    else if all isAttrs list then foldl' lib.mergeAttrs {} list
    else if all isBool list then foldl' lib.or false list
    else if all isString list then lib.concatStrings list
    else if all isInt list && all (x: x == head list) list then head list
    else throw "Cannot merge definitions of `${showOption loc}' given in ${showFiles (getFiles defs)}.";

  mergeOneOption = loc: defs:
    if defs == [] then abort "This case should never happen."
    else if length defs != 1 then
      throw "The unique option `${showOption loc}' is defined multiple times, in ${showFiles (getFiles defs)}."
    else (head defs).value;

  /* "Merge" option definitions by checking that they all have the same value. */
  mergeEqualOption = loc: defs:
    if defs == [] then abort "This case should never happen."
    else foldl' (val: def:
      if def.value != val then
        throw "The option `${showOption loc}' has conflicting definitions, in ${showFiles (getFiles defs)}."
      else
        val) (head defs).value defs;

  getValues = map (x: x.value);
  getFiles = map (x: x.file);

  # Generate DocBook documentation for a list of packages
  packageListToDocString = packages:
    let
      describePkg = n: p:
          "<listitem>"
        + "<para><option>${n}</option> (${p.name}): ${p.meta.description or "???"}.</para>"
        # Lots of `longDescription's break DocBook, so we just wrap them into <programlisting>
        + optionalString (p.meta ? longDescription) "\n<programlisting>${p.meta.longDescription}</programlisting>"
        + "</listitem>";
    in "<itemizedlist>${concatStringsSep "\n" (map ({name, value}: describePkg name value) packages)}</itemizedlist>";

  # Generate documentation template from the list of option declaration like
  # the set generated with filterOptionSets.
  optionAttrSetToDocList = optionAttrSetToDocList' [];

  optionAttrSetToDocList' = prefix: options:
    concatMap (opt:
      let
        docOption = rec {
          name = showOption opt.loc;
          description = (opt.description or (throw "Option `${name}' has no description."))
                      + optionalString (opt ? packages && opt.packages != []) "\n\n${packageListToDocString opt.packages}";
          declarations = filter (x: x != unknownModule) opt.declarations;
          internal = opt.internal or false;
          visible = opt.visible or true;
          readOnly = opt.readOnly or false;
          type = opt.type.name or null;
        }
        // (optionalAttrs (opt ? example)     { example = scrubOptionValue opt.example; })
        // (optionalAttrs (opt ? default)     { default = scrubOptionValue opt.default; })
        // (optionalAttrs (opt ? defaultText) { default = opt.defaultText; });

        subOptions =
          let ss = opt.type.getSubOptions opt.loc;
          in if ss != {} then optionAttrSetToDocList' opt.loc ss else [];
      in
        [ docOption ] ++ subOptions) (collect isOption options);


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

  /* For use in the ‘packages’ option attribute. */
  literalPackage' = pkgs: n: p: nameValuePair "${optionalString (n != "") (n + ".")}${p}" (getAttrFromPath (splitString "." p) pkgs);

  literalPackages' = pkgs: n: l: map (literalPackage' pkgs n) l;

  literalPackage = pkgs: n: literalPackage' { inherit pkgs; } "" n;

  literalPackages = pkgs: l: literalPackages' { inherit pkgs; } "" l;

  /* Helper functions. */
  showOption = concatStringsSep ".";
  showFiles = files: concatStringsSep " and " (map (f: "`${f}'") files);
  unknownModule = "<unknown-file>";

}
