/**
  Functions that generate widespread file
  formats from nix data structures.

  They all follow a similar interface:

  ```nix
  generator { config-attrs } data
  ```

  `config-attrs` are “holes” in the generators
  with sensible default implementations that
  can be overwritten. The default implementations
  are mostly generators themselves, called with
  their respective default values; they can be reused.

  Tests can be found in ./tests/misc.nix

  Further Documentation can be found [here](#sec-generators).
*/
{ lib }:

let
  inherit (lib)
    addErrorContext
    assertMsg
    attrNames
    concatLists
    concatMapStringsSep
    concatStrings
    concatStringsSep
    const
    elem
    escape
    filter
    flatten
    foldl
    functionArgs # Note: not the builtin; considers `__functor` in attrsets.
    gvariant
    hasInfix
    head
    id
    init
    isAttrs
    isBool
    isDerivation
    isFloat
    isFunction # Note: not the builtin; considers `__functor` in attrsets.
    isInt
    isList
    isPath
    isString
    last
    length
    mapAttrs
    mapAttrsToList
    optionals
    recursiveUpdate
    replaceStrings
    reverseList
    splitString
    tail
    toList
    ;

  inherit (lib.strings)
    escapeNixIdentifier
    floatToString
    match
    split
    toJSON
    typeOf
    escapeXML
    ;

  ## -- HELPER FUNCTIONS & DEFAULTS --
in
rec {
  /**
    Convert a value to a sensible default string representation.
    The builtin `toString` function has some strange defaults,
    suitable for bash scripts but not much else.

    # Inputs

    Options
    : Empty set, there may be configuration options in the future

    `v`
    : 2\. Function argument
  */
  mkValueStringDefault =
    { }:
    v:
    let
      err = t: v: abort ("generators.mkValueStringDefault: " + "${t} not supported: ${toPretty { } v}");
    in
    if isInt v then
      toString v
    # convert derivations to store paths
    else if isDerivation v then
      toString v
    # we default to not quoting strings
    else if isString v then
      v
    # isString returns "1", which is not a good default
    else if true == v then
      "true"
    # here it returns to "", which is even less of a good default
    else if false == v then
      "false"
    else if null == v then
      "null"
    # if you have lists you probably want to replace this
    else if isList v then
      err "lists" v
    # same as for lists, might want to replace
    else if isAttrs v then
      err "attrsets" v
    # functions can’t be printed of course
    else if isFunction v then
      err "functions" v
    # Floats currently can't be converted to precise strings,
    # condition warning on nix version once this isn't a problem anymore
    # See https://github.com/NixOS/nix/pull/3480
    else if isFloat v then
      floatToString v
    else
      err "this value is" (toString v);

  /**
    Generate a line of key `k` and value `v`, separated by
    character `sep`. If `sep` appears in `k`, it is escaped.
    Helper for syntaxes with different separators.

    `mkValueString` specifies how values should be formatted.

    ```nix
    mkKeyValueDefault {} ":" "f:oo" "bar"
    > "f\:oo:bar"
    ```

    # Inputs

    Structured function argument
    : mkValueString (optional, default: `mkValueStringDefault {}`)
      : Function to convert values to strings

    `sep`

    : 2\. Function argument

    `k`

    : 3\. Function argument

    `v`

    : 4\. Function argument
  */
  mkKeyValueDefault =
    {
      mkValueString ? mkValueStringDefault { },
    }:
    sep: k: v:
    "${escape [ sep ] k}${sep}${mkValueString v}";

  ## -- FILE FORMAT GENERATORS --

  /**
    Generate a key-value-style config file from an attrset.

    # Inputs

    Structured function argument

    : mkKeyValue (optional, default: `mkKeyValueDefault {} "="`)
      : format a setting line from key and value

    : listsAsDuplicateKeys (optional, default: `false`)
      : allow lists as values for duplicate keys

    : indent (optional, default: `""`)
      : Initial indentation level
  */
  toKeyValue =
    {
      mkKeyValue ? mkKeyValueDefault { } "=",
      listsAsDuplicateKeys ? false,
      indent ? "",
    }:
    let
      mkLine = k: v: indent + mkKeyValue k v + "\n";
      mkLines =
        if listsAsDuplicateKeys then
          k: v: map (mkLine k) (if isList v then v else [ v ])
        else
          k: v: [ (mkLine k v) ];
    in
    attrs: concatStrings (concatLists (mapAttrsToList mkLines attrs));

  /**
    Generate an INI-style config file from an
    attrset of sections to an attrset of key-value pairs.

    # Inputs

    Structured function argument

    : mkSectionName (optional, default: `(name: escape [ "[" "]" ] name)`)
      : apply transformations (e.g. escapes) to section names

    : mkKeyValue (optional, default: `{} "="`)
      : format a setting line from key and value

    : listsAsDuplicateKeys (optional, default: `false`)
      : allow lists as values for duplicate keys

    # Examples
    :::{.example}
    ## `lib.generators.toINI` usage example

    ```nix
    generators.toINI {} {
      foo = { hi = "${pkgs.hello}"; ciao = "bar"; };
      baz = { "also, integers" = 42; };
    }

    > [baz]
    > also, integers=42
    >
    > [foo]
    > ciao=bar
    > hi=/nix/store/y93qql1p5ggfnaqjjqhxcw0vqw95rlz0-hello-2.10
    ```

    The mk* configuration attributes can generically change
    the way sections and key-value strings are generated.

    For more examples see the test cases in ./tests/misc.nix.

    :::
  */
  toINI =
    {
      mkSectionName ? (name: escape [ "[" "]" ] name),
      mkKeyValue ? mkKeyValueDefault { } "=",
      listsAsDuplicateKeys ? false,
    }:
    attrsOfAttrs:
    let
      # map function to string for each key val
      mapAttrsToStringsSep =
        sep: mapFn: attrs:
        concatStringsSep sep (mapAttrsToList mapFn attrs);
      mkSection =
        sectName: sectValues:
        ''
          [${mkSectionName sectName}]
        ''
        + toKeyValue { inherit mkKeyValue listsAsDuplicateKeys; } sectValues;
    in
    # map input to ini sections
    mapAttrsToStringsSep "\n" mkSection attrsOfAttrs;

  /**
    Generate an INI-style config file from an attrset
    specifying the global section (no header), and an
    attrset of sections to an attrset of key-value pairs.

    # Inputs

    1\. Structured function argument

    : mkSectionName (optional, default: `(name: escape [ "[" "]" ] name)`)
      : apply transformations (e.g. escapes) to section names

    : mkKeyValue (optional, default: `{} "="`)
      : format a setting line from key and value

    : listsAsDuplicateKeys (optional, default: `false`)
      : allow lists as values for duplicate keys

    2\. Structured function argument

    : globalSection (required)
      : global section key-value pairs

    : sections (optional, default: `{}`)
      : attrset of sections to key-value pairs

    # Examples
    :::{.example}
    ## `lib.generators.toINIWithGlobalSection` usage example

    ```nix
    generators.toINIWithGlobalSection {} {
      globalSection = {
        someGlobalKey = "hi";
      };
      sections = {
        foo = { hi = "${pkgs.hello}"; ciao = "bar"; };
        baz = { "also, integers" = 42; };
    }

    > someGlobalKey=hi
    >
    > [baz]
    > also, integers=42
    >
    > [foo]
    > ciao=bar
    > hi=/nix/store/y93qql1p5ggfnaqjjqhxcw0vqw95rlz0-hello-2.10
    ```

    The mk* configuration attributes can generically change
    the way sections and key-value strings are generated.

    For more examples see the test cases in ./tests/misc.nix.

    :::

    If you don’t need a global section, you can also use
    `generators.toINI` directly, which only takes
    the part in `sections`.
  */
  toINIWithGlobalSection =
    {
      mkSectionName ? (name: escape [ "[" "]" ] name),
      mkKeyValue ? mkKeyValueDefault { } "=",
      listsAsDuplicateKeys ? false,
    }:
    {
      globalSection,
      sections ? { },
    }:
    (
      if globalSection == { } then
        ""
      else
        (toKeyValue { inherit mkKeyValue listsAsDuplicateKeys; } globalSection) + "\n"
    )
    + (toINI { inherit mkSectionName mkKeyValue listsAsDuplicateKeys; } sections);

  /**
    Generate a git-config file from an attrset.

    It has two major differences from the regular INI format:

    1. values are indented with tabs
    2. sections can have sub-sections

    Further: [git-config examples](https://git-scm.com/docs/git-config#EXAMPLES)

    # Examples
    :::{.example}
    ## `lib.generators.toGitINI` usage example

    ```nix
    generators.toGitINI {
      url."ssh://git@github.com/".insteadOf = "https://github.com";
      user.name = "edolstra";
    }

    > [url "ssh://git@github.com/"]
    >   insteadOf = "https://github.com"
    >
    > [user]
    >   name = "edolstra"
    ```

    :::

    # Inputs

    `attrs`

    : Key-value pairs to be converted to a git-config file.
      See the [git-config documentation](https://git-scm.com/docs/git-config#_variables) for possible values.
  */
  toGitINI =
    attrs:
    let
      mkSectionName =
        name:
        let
          containsQuote = hasInfix ''"'' name;
          sections = splitString "." name;
          section = head sections;
          subsections = tail sections;
          subsection = concatStringsSep "." subsections;
        in
        if containsQuote || subsections == [ ] then name else ''${section} "${subsection}"'';

      mkValueString =
        v:
        let
          escapedV = ''"${replaceStrings [ "\n" "	" ''"'' "\\" ] [ "\\n" "\\t" ''\"'' "\\\\" ] v}"'';
        in
        mkValueStringDefault { } (if isString v then escapedV else v);

      # generation for multiple ini values
      mkKeyValue =
        k: v:
        let
          mkKeyValue = mkKeyValueDefault { inherit mkValueString; } " = " k;
        in
        concatStringsSep "\n" (map (kv: "\t" + mkKeyValue kv) (toList v));

      # converts { a.b.c = 5; } to { "a.b".c = 5; } for toINI
      gitFlattenAttrs =
        let
          recurse =
            path: value:
            if isAttrs value && !isDerivation value then
              mapAttrsToList (name: value: recurse ([ name ] ++ path) value) value
            else if length path > 1 then
              {
                ${concatStringsSep "." (reverseList (tail path))}.${head path} = value;
              }
            else
              {
                ${head path} = value;
              };
        in
        attrs: foldl recursiveUpdate { } (flatten (recurse [ ] attrs));

      toINI_ = toINI { inherit mkKeyValue mkSectionName; };
    in
    toINI_ (gitFlattenAttrs attrs);

  /**
    `mkKeyValueDefault` wrapper that handles dconf INI quirks.
    The main differences of the format is that it requires strings to be quoted.
  */
  mkDconfKeyValue = mkKeyValueDefault { mkValueString = v: toString (gvariant.mkValue v); } "=";

  /**
    Generates INI in dconf keyfile style. See the [GNOME documentation](https://help.gnome.org/system-admin-guide/dconf-keyfiles.html)
    for details.
  */
  toDconfINI = toINI { mkKeyValue = mkDconfKeyValue; };

  /**
    Recurses through a `Value` limited to a certain depth. (`depthLimit`)

    If the depth is exceeded, an error is thrown, unless `throwOnDepthLimit` is set to `false`.

    # Inputs

    Structured function argument

    : depthLimit (required)
      : If this option is not null, the given value will stop evaluating at a certain depth

    : throwOnDepthLimit (optional, default: `true`)
      : If this option is true, an error will be thrown, if a certain given depth is exceeded

    Value
    : The value to be evaluated recursively
  */
  withRecursion =
    {
      depthLimit,
      throwOnDepthLimit ? true,
    }:
    assert isInt depthLimit;
    let
      specialAttrs = [
        "__functor"
        "__functionArgs"
        "__toString"
        "__pretty"
      ];
      stepIntoAttr = evalNext: name: if elem name specialAttrs then id else evalNext;
      transform =
        depth:
        if depthLimit != null && depth > depthLimit then
          if throwOnDepthLimit then
            throw "Exceeded maximum eval-depth limit of ${toString depthLimit} while trying to evaluate with `generators.withRecursion'!"
          else
            const "<unevaluated>"
        else
          id;
      mapAny =
        depth: v:
        let
          evalNext = x: mapAny (depth + 1) (transform (depth + 1) x);
        in
        if isAttrs v then
          mapAttrs (stepIntoAttr evalNext) v
        else if isList v then
          map evalNext v
        else
          transform (depth + 1) v;
    in
    mapAny 0;

  /**
    Pretty print a value, akin to `builtins.trace`.

    Should probably be a builtin as well.

    The pretty-printed string should be suitable for rendering default values
    in the NixOS manual. In particular, it should be as close to a valid Nix expression
    as possible.

    # Inputs

    Structured function argument
    : allowPrettyValues
      : If this option is true, attrsets like `{ __pretty = fn; val = …; }`
        will use `fn` to convert `val` to a pretty printed representation.
        (This means `fn` is type `Val -> String`.)
    : multiline
      : If this option is true, the output is indented with newlines for attribute sets and lists
    : indent
      : Initial indentation level

    Value
    : The value to be pretty printed
  */
  toPretty =
    {
      allowPrettyValues ? false,
      multiline ? true,
      indent ? "",
    }:
    let
      go =
        indent: v:
        let
          introSpace = if multiline then "\n${indent}  " else " ";
          outroSpace = if multiline then "\n${indent}" else " ";
        in
        if isInt v then
          toString v
        # toString loses precision on floats, so we use toJSON instead. This isn't perfect
        # as the resulting string may not parse back as a float (e.g. 42, 1e-06), but for
        # pretty-printing purposes this is acceptable.
        else if isFloat v then
          builtins.toJSON v
        else if isString v then
          let
            lines = filter (v: !isList v) (split "\n" v);
            escapeSingleline = escape [
              "\\"
              "\""
              "\${"
            ];
            escapeMultiline = replaceStrings [ "\${" "''" ] [ "''\${" "'''" ];
            singlelineResult = "\"" + concatStringsSep "\\n" (map escapeSingleline lines) + "\"";
            multilineResult =
              let
                escapedLines = map escapeMultiline lines;
                # The last line gets a special treatment: if it's empty, '' is on its own line at the "outer"
                # indentation level. Otherwise, '' is appended to the last line.
                lastLine = last escapedLines;
              in
              "''"
              + introSpace
              + concatStringsSep introSpace (init escapedLines)
              + (if lastLine == "" then outroSpace else introSpace + lastLine)
              + "''";
          in
          if multiline && length lines > 1 then multilineResult else singlelineResult
        else if true == v then
          "true"
        else if false == v then
          "false"
        else if null == v then
          "null"
        else if isPath v then
          toString v
        else if isList v then
          if v == [ ] then
            "[ ]"
          else
            "[" + introSpace + concatMapStringsSep introSpace (go (indent + "  ")) v + outroSpace + "]"
        else if isFunction v then
          let
            fna = functionArgs v;
            showFnas = concatStringsSep ", " (
              mapAttrsToList (name: hasDefVal: if hasDefVal then name + "?" else name) fna
            );
          in
          if fna == { } then "<function>" else "<function, args: {${showFnas}}>"
        else if isAttrs v then
          # apply pretty values if allowed
          if allowPrettyValues && v ? __pretty && v ? val then
            v.__pretty v.val
          else if v == { } then
            "{ }"
          else if v ? type && v.type == "derivation" then
            "<derivation ${v.name or "???"}>"
          else
            "{"
            + introSpace
            + concatStringsSep introSpace (
              mapAttrsToList (
                name: value:
                "${escapeNixIdentifier name} = ${
                  addErrorContext "while evaluating an attribute `${name}`" (go (indent + "  ") value)
                };"
              ) v
            )
            + outroSpace
            + "}"
        else
          abort "generators.toPretty: should never happen (v = ${v})";
    in
    go indent;

  /**
    Translate a simple Nix expression to [Plist notation](https://en.wikipedia.org/wiki/Property_list).

    # Inputs

    Structured function argument

    : escape (optional, default: `false`)
      : If this option is true, XML special characters are escaped in string values and keys

    Value
      : The value to be converted to Plist
  */
  toPlist =
    {
      escape ? false,
    }:
    v:
    let
      expr =
        ind: x:
        if x == null then
          ""
        else if isBool x then
          bool ind x
        else if isInt x then
          int ind x
        else if isString x then
          str ind x
        else if isList x then
          list ind x
        else if isAttrs x then
          attrs ind x
        else if isPath x then
          str ind (toString x)
        else if isFloat x then
          float ind x
        else
          abort "generators.toPlist: should never happen (v = ${v})";

      literal = ind: x: ind + x;

      maybeEscapeXML = if escape then escapeXML else x: x;

      bool = ind: x: literal ind (if x then "<true/>" else "<false/>");
      int = ind: x: literal ind "<integer>${toString x}</integer>";
      str = ind: x: literal ind "<string>${maybeEscapeXML x}</string>";
      key = ind: x: literal ind "<key>${maybeEscapeXML x}</key>";
      float = ind: x: literal ind "<real>${toString x}</real>";

      indent = ind: expr "\t${ind}";

      item = ind: concatMapStringsSep "\n" (indent ind);

      list =
        ind: x:
        concatStringsSep "\n" [
          (literal ind "<array>")
          (item ind x)
          (literal ind "</array>")
        ];

      attrs =
        ind: x:
        concatStringsSep "\n" [
          (literal ind "<dict>")
          (attr ind x)
          (literal ind "</dict>")
        ];

      attr =
        let
          attrFilter = name: value: name != "_module" && value != null;
        in
        ind: x:
        concatStringsSep "\n" (
          flatten (
            mapAttrsToList (
              name: value:
              optionals (attrFilter name value) [
                (key "\t${ind}" name)
                (expr "\t${ind}" value)
              ]
            ) x
          )
        );

    in
    # TODO: As discussed in #356502, deprecated functionality should be removed sometime after 25.11.
    lib.warnIf (!escape && lib.oldestSupportedReleaseIsAtLeast 2505)
      "Using `lib.generators.toPlist` without `escape = true` is deprecated"
      ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        ${expr "" v}
        </plist>'';

  /**
    Translate a simple Nix expression to Dhall notation.

    Note that integers are translated to Integer and never
    the Natural type.

    # Inputs

    Options

    : Empty set, there may be configuration options in the future

    Value

    : The value to be converted to Dhall
  */
  toDhall =
    { }@args:
    v:
    let
      concatItems = concatStringsSep ", ";
    in
    if isAttrs v then
      "{ ${concatItems (mapAttrsToList (key: value: "${key} = ${toDhall args value}") v)} }"
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
      toJSON v;

  /**
    Translate a simple Nix expression to Lua representation with occasional
    Lua-inlines that can be constructed by `mkLuaInline` function.

    Configuration:

    * `multiline` - by default is true which results in indented block-like view.
    * `indent` - initial indent.
    * `asBindings` - by default generate single value, but with this use attrset to set global vars.

    ::: {.note}
    Regardless of multiline parameter there is no trailing newline.
    :::

    # Inputs

    Structured function argument

    : multiline (optional, default: `true`)
      : If this option is true, the output is indented with newlines for attribute sets and lists
    : indent (optional, default: `""`)
      : Initial indentation level
    : asBindings (optional, default: `false`)
      : Interpret as variable bindings

    Value

    : The value to be converted to Lua

    # Type

    ```
    toLua :: AttrSet -> Any -> String
    ```

    # Examples
    :::{.example}
    ## `lib.generators.toLua` usage example

    ```nix
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
    ```

    :::
  */
  toLua =
    {
      multiline ? true,
      indent ? "",
      asBindings ? false,
    }@args:
    v:
    let
      innerIndent = "${indent}  ";
      introSpace = if multiline then "\n${innerIndent}" else " ";
      outroSpace = if multiline then "\n${indent}" else " ";
      innerArgs = args // {
        indent = if asBindings then indent else innerIndent;
        asBindings = false;
      };
      concatItems = concatStringsSep ",${introSpace}";
      isLuaInline =
        {
          _type ? null,
          ...
        }:
        _type == "lua-inline";

      generatedBindings =
        assert assertMsg (badVarNames == [ ]) "Bad Lua var names: ${toPretty { } badVarNames}";
        concatStrings (mapAttrsToList (key: value: "${indent}${key} = ${toLua innerArgs value}\n") v);

      # https://en.wikibooks.org/wiki/Lua_Programming/variable#Variable_names
      matchVarName = match "[[:alpha:]_][[:alnum:]_]*(\\.[[:alpha:]_][[:alnum:]_]*)*";
      badVarNames = filter (name: matchVarName name == null) (attrNames v);
    in
    if asBindings then
      generatedBindings
    else if v == null then
      "nil"
    else if isInt v || isFloat v || isString v || isBool v then
      toJSON v
    else if isPath v || isDerivation v then
      toJSON "${v}"
    else if isList v then
      (
        if v == [ ] then
          "{}"
        else
          "{${introSpace}${concatItems (map (value: "${toLua innerArgs value}") v)}${outroSpace}}"
      )
    else if isAttrs v then
      (
        if isLuaInline v then
          "(${v.expr})"
        else if v == { } then
          "{}"
        else
          "{${introSpace}${
            concatItems (mapAttrsToList (key: value: "[${toJSON key}] = ${toLua innerArgs value}") v)
          }${outroSpace}}"
      )
    else
      abort "generators.toLua: type ${typeOf v} is unsupported";

  /**
    Mark string as Lua expression to be inlined when processed by `toLua`.

    # Inputs

    `expr`

    : 1\. Function argument

    # Type

    ```
    mkLuaInline :: String -> AttrSet
    ```
  */
  mkLuaInline = expr: {
    _type = "lua-inline";
    inherit expr;
  };
}
// {
  /**
    Generates JSON from an arbitrary (non-function) value.
    For more information see the documentation of the builtin.

    # Inputs

    Options

    : Empty set, there may be configuration options in the future

    Value

    : The value to be converted to JSON
  */
  toJSON = { }: lib.strings.toJSON;

  /**
    YAML has been a strict superset of JSON since 1.2, so we
    use toJSON. Before it only had a few differences referring
    to implicit typing rules, so it should work with older
    parsers as well.

    # Inputs

    Options

    : Empty set, there may be configuration options in the future

    Value

    : The value to be converted to YAML
  */
  toYAML = { }: lib.strings.toJSON;
}
