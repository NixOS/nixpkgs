{ lib, ... }:
{
  /**
    Converts a RON (Rusty Object Notation) string to Nix values.

    This function parses RON format strings and converts them to equivalent Nix data structures.
    It supports various RON types including primitives, collections, optionals, enums, structs, and tuples.

    Special RON types are represented as attribute sets with a `_type` field:
    - Optional values: `{ _type = "ron-optional"; value = ...; }`
    - Characters: `{ _type = "ron-char"; value = "c"; }`
    - Enums: `{ _type = "ron-enum"; variant = "..."; values = [...]; }`
    - Maps: `{ _type = "ron-map"; attrs = [{ key = ...; value = ...; }, ...]; }`
    - Named structs: `{ _type = "ron-named-struct"; name = "..."; value = { ... }; }`
    - Tuples: `{ _type = "ron-tuple"; values = [...]; }`
    - Raw values: `{ _type = "ron-raw"; value = "..."; }`

    The parser generates `ron-raw` values to preserve precision for
    floating-point numbers and as a fallback for unrecognized syntax.
    This makes the parser more robust by not failing on partially
    unsupported input. The `value` field will contain the original unparsed string.

    # Example

    ```nix
    lib.ron.fromRON "[1, 2, 3]"
    => [ 1 2 3 ]

    lib.ron.fromRON "Some(42)"
    => { _type = "ron-optional"; value = 42; }

    lib.ron.fromRON "(x: 1, y: 2)"
    => { x = 1; y = 2; }
    ```

    # Type

    ```
    fromRON :: String -> Any
    ```

    # Arguments

    str
    : The RON format string to parse
  */
  fromRON =
    let
      fromRON' =
        str:
        let
          trimmed = lib.trim str;

          firstChar = builtins.substring 0 1 trimmed;
          lastChar = builtins.substring (builtins.stringLength trimmed - 1) 1 trimmed;

          splitItems =
            str:
            let
              content = lib.pipe str [
                lib.trim
                (builtins.substring 1 (builtins.stringLength str - 2))
                lib.trim
              ];

              split =
                acc: current: depth: rest:
                if rest == "" then
                  if current != "" then acc ++ [ (lib.trim current) ] else acc
                else
                  let
                    char = builtins.substring 0 1 rest;
                    remaining = builtins.substring 1 (-1) rest;
                  in
                  if char == "(" || char == "[" || char == "{" then
                    split acc (current + char) (depth + 1) remaining
                  else if char == ")" || char == "]" || char == "}" then
                    split acc (current + char) (depth - 1) remaining
                  else if char == "," && depth == 0 then
                    split (acc ++ [ (lib.trim current) ]) "" depth remaining
                  else
                    split acc (current + char) depth remaining;
            in
            split [ ] "" 0 content;

          findFirstColon =
            str:
            let
              helper =
                pos: depth:
                if pos >= builtins.stringLength str then
                  null
                else
                  let
                    char = builtins.substring pos 1 str;
                  in
                  if char == "(" || char == "[" || char == "{" then
                    helper (pos + 1) (depth + 1)
                  else if char == ")" || char == "]" || char == "}" then
                    helper (pos + 1) (depth - 1)
                  else if char == ":" && depth == 0 then
                    pos
                  else
                    helper (pos + 1) depth;
            in
            helper 0 0;

          isStruct =
            str:
            let
              content = lib.pipe str [
                lib.trim
                (builtins.substring 1 (builtins.stringLength str - 2))
                lib.trim
              ];
              colonPos = findFirstColon content;

              beforeColon = builtins.substring 0 colonPos content;
              depth = lib.foldl (
                acc: char:
                if char == "(" || char == "[" || char == "{" then
                  acc + 1
                else if char == ")" || char == "]" || char == "}" then
                  acc - 1
                else
                  acc
              ) 0 (lib.stringToCharacters beforeColon);
            in
            colonPos != null && depth == 0;
        in
        if firstChar == "[" && lastChar == "]" then
          map fromRON' (splitItems trimmed)
        else if firstChar == "{" && lastChar == "}" then
          {
            _type = "ron-map";
            attrs = map (
              item:
              let
                colonPos = findFirstColon item;
                key = lib.trim (builtins.substring 0 colonPos item);
                value = lib.trim (builtins.substring (colonPos + 1) (-1) item);
              in
              {
                key = fromRON' key;
                value = fromRON' value;
              }
            ) (splitItems trimmed);
          }
        else if trimmed == "None" then
          {
            _type = "ron-optional";
            value = null;
          }
        else if builtins.match "Some\\(.*\\)" trimmed != null then
          let
            value = builtins.head (builtins.match "Some\\((.*)\\)" trimmed);
          in
          {
            _type = "ron-optional";
            value = fromRON' value;
          }
        else if trimmed == "true" then
          true
        else if trimmed == "false" then
          false
        else if firstChar == "(" && lastChar == ")" then
          if isStruct trimmed then
            builtins.listToAttrs (
              map (
                item:
                let
                  colonPos = findFirstColon item;
                  name = lib.trim (builtins.substring 0 colonPos item);
                  value = lib.trim (builtins.substring (colonPos + 1) (-1) item);
                in
                {
                  inherit name;
                  value = fromRON' value;
                }
              ) (splitItems trimmed)
            )
          else
            {
              _type = "ron-tuple";
              values = map fromRON' (splitItems trimmed);
            }
        else if builtins.match "[A-Za-z_][A-Za-z0-9_]*\\(.*\\)" trimmed != null then
          let
            matches = builtins.match "([A-Za-z_][A-Za-z0-9_]*)(\\(.*\\))" trimmed;
            name = lib.trim (builtins.head matches);
            value = lib.trim (lib.last matches);
          in
          if isStruct value then
            {
              _type = "ron-named-struct";
              inherit name;
              value = fromRON' value;
            }
          else
            {
              _type = "ron-enum";
              variant = name;
              values = map fromRON' (splitItems value);
            }
        else if builtins.match "-?[0-9]+[.][0-9]+" trimmed != null then
          let
            decimals = lib.pipe trimmed [
              (lib.splitString ".")
              lib.last
              builtins.stringLength
            ];
          in
          if decimals > 5 then
            {
              _type = "ron-raw";
              value = trimmed;
            }
          else
            builtins.fromJSON trimmed
        else if builtins.match "-?[0-9]+" trimmed != null then
          lib.toInt trimmed
        else if builtins.match "'.'" trimmed != null then
          {
            _type = "ron-char";
            value = builtins.substring 1 1 trimmed;
          }
        else if builtins.match ''".*"'' trimmed != null then
          builtins.fromJSON trimmed
        else
          {
            _type = "ron-raw";
            value = trimmed;
          };
    in
    fromRON';

  /**
    Imports and parses a RON file, returning the parsed Nix value.

    This is a convenience function that combines reading a file from the filesystem
    and parsing it as RON format.

    # Example

    ```nix
    # Assuming config.ron contains: (debug: true, port: 8080)
    lib.ron.importRON ./config.ron
    => { debug = true; port = 8080; }
    ```

    # Type

    ```
    importRON :: Path -> Any
    ```

    # Arguments

    path
    : Path to the RON file to import
  */
  importRON =
    path:
    lib.pipe path [
      builtins.readFile
      lib.ron.fromRON
    ];

  /**
    Creates a RON character value.

    Characters in RON are single-character strings enclosed in single quotes.
    This function creates the appropriate Nix representation.

    # Example

    ```nix
    lib.ron.mkChar "a"
    => { _type = "ron-char"; value = "a"; }
    ```

    # Type

    ```
    mkChar :: String -> RonChar
    ```

    # Arguments

    value
    : A single character string
  */
  mkChar = value: {
    _type = "ron-char";
    inherit value;
  };

  /**
    Creates a RON enum value.

    Enums in RON represent variants with optional associated data.
    They can be simple variants (just a name) or variants with tuple data.

    # Example

    ```nix
    # Simple enum variant
    lib.ron.mkEnum { variant = "Red"; }
    => { _type = "ron-enum"; variant = "Red"; }

    # Enum variant with data
    lib.ron.mkEnum { variant = "Point"; values = [ 10 20 ]; }
    => { _type = "ron-enum"; variant = "Point"; values = [ 10 20 ]; }

    # Enum variant with empty data
    lib.ron.mkEnum { variant = "Empty"; values = []; }
    => { _type = "ron-enum"; variant = "Empty"; values = []; }
    ```

    # Type

    ```
    mkEnum :: { variant :: String, values :: [Any] } -> RonEnum
    ```

    # Arguments

    variant
    : The enum variant name

    values
    : Optional list of values associated with the variant. If `null`, no `values` field is included.
  */
  mkEnum =
    {
      values ? null,
      variant,
    }:
    {
      _type = "ron-enum";
      inherit variant;
    }
    // lib.optionalAttrs (values != null) { inherit values; };

  /**
    Creates a RON map value.

    Maps in RON are collections of key-value pairs enclosed in curly braces.
    Unlike Nix attribute sets, RON maps can have non-string keys.

    # Example

    ```nix
    lib.ron.mkMap [
      { key = 1; value = "one"; }
      { key = 2; value = "two"; }
    ]
    => { _type = "ron-map"; attrs = [ { key = 1; value = "one"; } { key = 2; value = "two"; } ]; }
    ```

    # Type

    ```
    mkMap :: [{ key :: Any, value :: Any }] -> RonMap
    ```

    # Arguments

    attrs
    : List of key-value pairs, where each pair is an attribute set with `key` and `value` fields
  */
  mkMap = attrs: {
    _type = "ron-map";
    inherit attrs;
  };

  /**
    Creates a RON named struct value.

    Named structs in RON are like regular structs but with a type name prefix.
    They represent structured data with named fields.

    # Example

    ```nix
    lib.ron.mkNamedStruct {
      name = "Point";
      value = { x = 10; y = 20; };
    }
    => { _type = "ron-named-struct"; name = "Point"; value = { x = 10; y = 20; }; }
    ```

    # Type

    ```
    mkNamedStruct :: { name :: String, value :: AttrSet } -> RonNamedStruct
    ```

    # Arguments

    name
    : The struct type name

    value
    : Attribute set containing the struct fields
  */
  mkNamedStruct =
    { name, value }:
    {
      _type = "ron-named-struct";
      inherit name value;
    };

  /**
    Creates a RON optional value.

    Optional values in RON can be either `None` (represented as `null` in the value field)
    or `Some(value)` (represented with the actual value).

    # Example

    ```nix
    # None value
    lib.ron.mkOptional null
    => { _type = "ron-optional"; value = null; }

    # Some value
    lib.ron.mkOptional 42
    => { _type = "ron-optional"; value = 42; }
    ```

    # Type

    ```
    mkOptional :: Any -> RonOptional
    ```

    # Arguments

    value
    : The optional value, or `null` to represent `None`
  */
  mkOptional = value: {
    _type = "ron-optional";
    inherit value;
  };

  /**
    Creates a RON raw value for use with `toRON`.

    This function is used to wrap a string that should be treated as a raw,
    pre-formatted piece of RON syntax when calling `toRON`.

    It is useful for injecting complex values, or for RON features that are not
    natively supported by the `toRON` builder. The provided string will be
    injected directly into the output.

    # Example

    ```nix
    lib.ron.toRON { } {
      config = lib.ron.mkRaw "MyEnum::Variant(1)";
    }
    => ''(
        config: MyEnum::Variant(1),
    )''
    ```

    # Type

    ```
    mkRaw :: String -> RonRaw
    ```

    # Arguments

    value
    : The raw RON string to inject into the `toRON` output.
  */
  mkRaw = value: {
    _type = "ron-raw";
    inherit value;
  };

  /**
    Creates a RON tuple value.

    Tuples in RON are ordered collections of values enclosed in parentheses.
    Unlike lists, tuples can contain values of different types.

    # Example

    ```nix
    lib.ron.mkTuple [ 1 "hello" true ]
    => { _type = "ron-tuple"; values = [ 1 "hello" true ]; }
    ```

    # Type

    ```
    mkTuple :: [Any] -> RonTuple
    ```

    # Arguments

    values
    : List of values to include in the tuple
  */
  mkTuple = values: {
    _type = "ron-tuple";
    inherit values;
  };

  /**
    Converts Nix values to RON (Rusty Object Notation) format string.

    This function serializes Nix data structures to RON format strings.
    It handles various Nix types and special RON types created by the `mk*` functions.

    The output is formatted with proper indentation for readability.
    Special RON types (those with `_type` field) are converted to their appropriate RON syntax.

    # Example

    ```nix
    lib.ron.toRON { } [ 1 2 3 ]
    => "[
        1,
        2,
        3,
    ]"

    lib.ron.toRON { } { x = 1; y = 2; }
    => "(
        x: 1,
        y: 2,
    )"
    ```

    # Type

    ```
    toRON :: { indent :: String } -> Any -> String
    ```

    # Arguments

    options
    : Options attribute set containing:
      - `indent`: Indentation string to use (defaults to empty string, which uses 4 spaces per level)

    value
    : The Nix value to convert to RON format
  */
  toRON =
    let
      toRON' =
        {
          indent ? "",
        }@options:
        value:
        let
          type = builtins.typeOf value;
          nextIndent = indent + "    ";

          nextOptions = options // {
            indent = nextIndent;
          };
        in
        {
          bool = lib.boolToString value;

          float =
            let
              trimFloatString =
                float:
                let
                  string = lib.strings.floatToString float;
                in
                if lib.hasInfix "." string then
                  builtins.head (builtins.match "([0-9]+[.][0-9]*[1-9]|[0-9]+[.]0)0*" string)
                else
                  string;
            in
            trimFloatString value;

          int = toString value;
          lambda = throw "Functions are not supported in RON";

          list =
            let
              count = builtins.length value;
            in
            if count == 0 then
              "[]"
            else
              "[\n${
                lib.concatImapStringsSep "\n" (
                  index: element:
                  "${nextIndent}${toRON' nextOptions element}${lib.optionalString (index != count) ","}"
                ) value
              },\n${indent}]";

          null = throw "If you want to represent a null value in RON, you can use the `optional` type.";

          path = lib.pipe value [
            toString
            lib.strings.escapeNixString
          ];

          set =
            if value ? _type then
              if value._type == "ron-raw" then
                assert lib.assertMsg (value ? value) "raw type must have a value.";
                assert lib.assertMsg (builtins.isString value.value) "raw type value must be a string.";

                value.value
              else if value._type == "ron-optional" then
                assert lib.assertMsg (value ? value) "optional type must have a value.";

                if value.value == null then "None" else "Some(${toRON' options value.value})"
              else if value._type == "ron-char" then
                assert lib.assertMsg (value ? value) "char type must have a value.";
                assert lib.assertMsg (builtins.isString value.value) "char type value must be a string.";
                assert lib.assertMsg (
                  builtins.stringLength value.value == 1
                ) "char type value must be a single character string.";

                "'${value.value}'"
              else if value._type == "ron-enum" then
                assert lib.assertMsg (value ? variant) "enum type must have a variant.";
                assert lib.assertMsg (builtins.isString value.variant) "enum type variant must be a string value.";

                if value ? values then
                  assert lib.assertMsg (builtins.isList value.values) "enum type must have a list of values.";

                  let
                    count = builtins.length value.values;
                  in
                  if count == 0 then
                    "${value.variant}()"
                  else
                    "${value.variant}(\n${
                      lib.concatImapStringsSep "\n" (
                        index: element:
                        "${nextIndent}${toRON' nextOptions element}${lib.optionalString (index != count) ","}"
                      ) value.values
                    },\n${indent})"
                else
                  value.variant
              else if value._type == "ron-map" then
                assert lib.assertMsg (value ? attrs) "map type must have a value.";
                assert lib.assertMsg (builtins.isList value.attrs) "map type value must be a list.";
                assert lib.assertMsg (builtins.all builtins.isAttrs value.attrs)
                  "map type value must be a list of attribute sets.";

                let
                  count = builtins.length value.attrs;
                in
                if count == 0 then
                  "{}"
                else
                  "{\n${
                    lib.concatImapStringsSep "\n" (
                      index: entry:
                      assert lib.assertMsg (
                        let
                          keys = builtins.attrNames entry;
                        in
                        keys == [
                          "key"
                          "value"
                        ]
                      ) "map type entry must have only 'key' and 'value' attributes.";

                      "${nextIndent}${toRON' nextOptions entry.key}: ${toRON' nextOptions entry.value}${
                        lib.optionalString (index != count) ","
                      }"
                    ) value.attrs
                  },\n${indent}}"
              else if value._type == "ron-tuple" then
                assert lib.assertMsg (value ? values) "tuple type must have a value.";
                assert lib.assertMsg (builtins.isList value.values) "tuple type value must be a list.";

                let
                  count = builtins.length value.values;
                in
                if count == 0 then
                  "()"
                else
                  "(\n${
                    lib.concatImapStringsSep "\n" (
                      index: element:
                      "${nextIndent}${toRON' nextOptions element}${lib.optionalString (index != count) ","}"
                    ) value.values
                  },\n${indent})"
              else if value._type == "ron-named-struct" then
                assert lib.assertMsg (value ? name) "named-struct type must have a name.";
                assert lib.assertMsg (builtins.isString value.name) "named-struct type name must be a string.";
                assert lib.assertMsg (value ? value) "named-struct type must have a value.";
                assert lib.assertMsg (builtins.isAttrs value.value)
                  "named-struct type value must be a attribute set.";

                let
                  keys = builtins.attrNames value.value;
                  count = builtins.length keys;
                in
                if count == 0 then
                  "${value.name}()"
                else
                  "${value.name}(\n${
                    lib.concatImapStringsSep "\n" (
                      index: key:
                      "${nextIndent}${key}: ${toRON' nextOptions value.value.${key}}${
                        lib.optionalString (index != count) ","
                      }"
                    ) keys
                  },\n${indent})"
              else
                throw "set type ${toString value._type} is not supported."
            else
              let
                keys = builtins.attrNames value;
                count = builtins.length keys;
              in
              if count == 0 then
                "()"
              else
                "(\n${
                  lib.concatImapStringsSep "\n" (
                    index: key:
                    "${nextIndent}${key}: ${toRON' nextOptions value.${key}}${lib.optionalString (index != count) ","}"
                  ) keys
                },\n${indent})";

          string = lib.strings.escapeNixString value;
        }
        .${type} or (throw "${type} is not supported.");
    in
    toRON';
}
