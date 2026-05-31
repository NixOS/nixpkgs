{
  nixos,
  # list representing a nixos option path (e.g. ['console' 'enable']), or a
  # prefix of such a path (e.g. ['console']), or a string representing the same
  # (e.g. 'console.enable')
  path,
  # whether to recurse down the config attrset and show each set value instead
  recursive,
}:

let
  inherit (nixos.pkgs) lib;

  path' = if lib.isString path then (if path == "" then [ ] else readOption path) else path;

  # helper that maps `f` on subslices starting when `predStart x` and
  # ending when `predEnd x` (no support for nested occurrences)
  flatMapSlices =
    predStart: predEnd: f: list:
    let
      empty = {
        result = [ ];
        active = [ ];
      };
      op =
        { result, active }:
        x:
        if predStart x && predEnd x then
          {
            result = result ++ active ++ f [ x ];
            active = [ ];
          }
        else if predStart x then
          {
            result = result ++ active;
            active = [ x ];
          }
        else if predEnd x then
          {
            result = result ++ f (active ++ [ x ]);
            active = [ ];
          }
        else
          {
            inherit result;
            active = active ++ [ x ];
          };
    in
    (x: x.result ++ x.active) (lib.foldl op empty list);

  # tries to invert showOption, taking a written-out option name and splitting
  # it into its parts
  readOption =
    str:
    let
      unescape = list: lib.replaceStrings (map (c: "\\${c}") list) list;
      unescapeNixString = lib.flip lib.pipe [
        (lib.concatStringsSep ".")
        (unescape [ "$" ])
        builtins.fromJSON
      ];
    in
    flatMapSlices (lib.hasPrefix "\"") (lib.hasSuffix "\"") (x: [ (unescapeNixString x) ]) (
      lib.splitString "." str
    );

  # like 'mapAttrsRecursiveCond' but handling errors in the attrset tree as leaf
  # nodes (which means `f` is expected to handle shallow errors)
  safeMapAttrsRecursiveCond =
    cond: f: set:
    let
      recurse =
        path:
        lib.mapAttrs (
          name: value:
          let
            e = builtins.tryEval value;
            path' = path ++ [ name ];
          in
          if e.success && lib.isAttrs value && cond value then recurse path' value else f path' value
        );
    in
    recurse [ ] set;

  # traverse the option tree along `path` from `root`, returning the option or
  # attrset at the given location
  optionByPath =
    path: root:
    let
      into =
        opt: part:
        if lib.isOption opt && opt.type.descriptionClass == "composite" then
          opt.type.getSubOptions [ ]
        else if lib.isOption opt then
          throw "Trying to access '${part}' inside ${opt.type.name} option while traversing option path '${lib.showOption path}'"
        else if lib.isAttrs opt && lib.hasAttr part opt then
          opt.${part}
        else
          throw "Found neither an attrset nor supported option type near '${part}' while traversing option path '${lib.showOption path}'";
    in
    lib.foldl into root path;

  toPretty = lib.generators.toPretty { multiline = true; };
  safeToPretty =
    x:
    let
      e = builtins.tryEval (toPretty x);
    in
    if e.success then e.value else "[1;31m«error»[m";

  indent = str: lib.concatStringsSep "\n" (map (x: "  " + x) (lib.splitString "\n" str));

  optionAttrNames = attrs: lib.filter (x: x != "_module") (lib.attrNames attrs);

  ## full, non-recursive mode: print an option from `options`
  renderAttrs =
    attrs: "This attribute set contains:\n${lib.concatStringsSep "\n" (optionAttrNames attrs)}";

  renderOption =
    option: value:
    let
      entry =
        cond: heading: value:
        lib.optional cond "${heading}:\n${indent value}";
    in
    lib.concatStringsSep "\n\n" (
      lib.concatLists [
        (entry true "Value" (toPretty value))
        (entry (option ? default) "Default" (toPretty option.default))
        (entry (option ? type) "Type" (option.type.description))
        (entry (option ? description) "Description" (lib.removeSuffix "\n" option.description))
        (entry (option ? example) "Example" (toPretty option.example))
        (entry (option ? declarations) "Declared by" (lib.concatStringsSep "\n" option.declarations))
        (entry (option ? files) "Defined by" (lib.concatStringsSep "\n" option.files))
      ]
    );

  renderFull =
    entry: configEntry:
    if lib.isOption entry then
      renderOption entry configEntry
    else if lib.isAttrs entry then
      renderAttrs entry
    else
      throw "Found neither an attrset nor option at option path '${lib.showOption path'}'";

  ## recursive mode: print paths and values from `config`
  renderRecursive =
    config:
    let
      renderShort = n: v: "${lib.showOption (path' ++ n)} = ${safeToPretty v};";
      mapAttrsRecursive' = safeMapAttrsRecursiveCond (x: !lib.isDerivation x);
    in
    if lib.isAttrs config then
      lib.concatStringsSep "\n" (lib.collect lib.isString (mapAttrsRecursive' renderShort config))
    else
      renderShort [ ] config;

in
if !lib.hasAttrByPath path' nixos.config then
  throw "Couldn't resolve config path '${lib.showOption path'}'"
else
  let
    optionEntry = optionByPath path' nixos.options;
    configEntry = lib.attrByPath path' null nixos.config;
  in
  if recursive then renderRecursive configEntry else renderFull optionEntry configEntry
