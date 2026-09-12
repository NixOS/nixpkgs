{ lib }:

let
  inherit (lib)
    attrNames
    concatLists
    concatMap
    escapeShellArgs
    isBool
    isList
    join
    mapAttrsToList
    oldestSupportedReleaseIsAtLeast
    optional
    stringLength
    throwIf
    warnIf
    ;
  inherit (lib.generators) mkValueStringDefault;
  mkValueString = mkValueStringDefault { };
in
rec {
  /**
    Automatically convert an attribute set to command-line options.

    This helps protect against malformed command lines and also to reduce
    boilerplate related to command-line construction for simple use cases.

    `toGNUCommandLineShell` returns an escaped shell string.

    # Inputs

    `options`

    : How to format the arguments, see `toGNUCommandLine`

    `attrs`

    : The attributes to transform into arguments.

    # Examples

    :::{.example}
    ## `lib.cli.toGNUCommandLineShell` usage example

    ```nix
    cli.toGNUCommandLineShell {} {
      data = builtins.toJSON { id = 0; };
      X = "PUT";
      retry = 3;
      retry-delay = null;
      url = [ "https://example.com/foo" "https://example.com/bar" ];
      silent = false;
      verbose = true;
    }
    => "'-X' 'PUT' '--data' '{\"id\":0}' '--retry' '3' '--url' 'https://example.com/foo' '--url' 'https://example.com/bar' '--verbose'";
    ```

    :::
  */
  toGNUCommandLineShell =
    warnIf (oldestSupportedReleaseIsAtLeast 2511)
      "lib.cli.toGNUCommandLineShell is deprecated, please use lib.cli.toCommandLineShell or lib.cli.toCommandLineShellGNU instead."
      (options: attrs: escapeShellArgs (toGNUCommandLine options attrs));

  /**
    Automatically convert an attribute set to a list of command-line options.

    `toGNUCommandLine` returns a list of string arguments.

    # Inputs

    `options`

    : How to format the arguments, see below.

    `attrs`

    : The attributes to transform into arguments.

    ## Options

    `mkOptionName`

    : How to string-format the option name;
    By default one character is a short option (`-`), more than one characters a long option (`--`).

    `mkBool`

    : How to format a boolean value to a command list;
    By default it’s a flag option (only the option name if true, left out completely if false).

    `mkList`

    : How to format a list value to a command list;
    By default the option name is repeated for each value and `mkOption` is applied to the values themselves.

    `mkOption`

    : How to format any remaining value to a command list;
    On the toplevel, booleans and lists are handled by `mkBool` and `mkList`, though they can still appear as values of a list.
    By default, everything is printed verbatim and complex types are forbidden (lists, attrsets, functions). `null` values are omitted.

    `optionValueSeparator`

    : How to separate an option from its flag;
    By default, there is no separator, so option `-c` and value `5` would become `["-c" "5"]`.
    This is useful if the command requires equals, for example, `-c=5`.

    # Examples

    :::{.example}
    ## `lib.cli.toGNUCommandLine` usage example

    ```nix
    cli.toGNUCommandLine {} {
      data = builtins.toJSON { id = 0; };
      X = "PUT";
      retry = 3;
      retry-delay = null;
      url = [ "https://example.com/foo" "https://example.com/bar" ];
      silent = false;
      verbose = true;
    }
    => [
      "-X" "PUT"
      "--data" "{\"id\":0}"
      "--retry" "3"
      "--url" "https://example.com/foo"
      "--url" "https://example.com/bar"
      "--verbose"
    ]
    ```

    :::
  */
  toGNUCommandLine =
    warnIf (oldestSupportedReleaseIsAtLeast 2511)
      "lib.cli.toGNUCommandLine is deprecated, please use lib.cli.toCommandLine or lib.cli.toCommandLineShellGNU instead."
      (
        {
          mkOptionName ? k: if stringLength k == 1 then "-${k}" else "--${k}",

          mkBool ? k: v: optional v (mkOptionName k),

          mkList ? k: concatMap (mkOption k),

          mkOption ?
            k: v:
            if v == null then
              [ ]
            else if optionValueSeparator == null then
              [
                (mkOptionName k)
                (mkValueString v)
              ]
            else
              [ "${mkOptionName k}${optionValueSeparator}${mkValueString v}" ],

          optionValueSeparator ? null,
        }:
        let
          render =
            k: v:
            if isBool v then
              mkBool k v
            else if isList v then
              mkList k v
            else
              mkOption k v;
        in
        options: concatLists (mapAttrsToList render options)
      );

  /**
    Converts the given attributes into a single shell-escaped command-line
    string.
    Similar to `toCommandLineGNU`, but returns a single escaped string instead
    of a list of arguments.
    For further reference see:
    [`lib.cli.toCommandLineGNU`](#function-library-lib.cli.toCommandLineGNU)
  */
  toCommandLineShellGNU = options: attrs: escapeShellArgs (toCommandLineGNU options attrs);

  /**
    Converts an attribute set into a list of GNU-style command-line arguments.

    `toCommandLineGNU` returns a list of string arguments.

    # Type

    ```
    toCommandLineGNU ::
      {
        isLong :: String -> Bool,
        explicitBool :: Bool,
        formatArg :: Any -> String,
        listRepr :: String -> "repeat" | "join" | "spread",
        formatList :: [Any] -> String,
        splitList :: String -> [Any] -> [[Any]],
      } -> [String]
    ```

    # Inputs

    `options`

    : Options, see below.

    `attrs`

    : The attributes to transform into arguments.

    ## Options

    `isLong`

    : A function that determines whether an option is long or short.

    `explicitBool`

    : Whether or not boolean option arguments should be formatted explicitly.

    `formatArg`

    : A function that turns the option argument into a string.

    `listRepr`:

    : A function that takes the option name and returns the list representation:
      - `"repeat"`:
        Repeats the option with different values, e.g.:
        `--option=foo --option=bar --option=baz`.
      - `"join"`:
        Joins option arguments via `formatList`, e.g.: `--option=foo,bar,baz`.
      - `"spread"`:
        Outputs the option once and spreads the arguments after it, e.g.:
        `--option foo bar baz`.
        The behavior of this representation can be customized via the
        `splitList` function. `sep` is treated as if it were `null`.

      Defaults to `_: "repeat"`.
      For further reference see `listRepr` in:
      [`lib.cli.toCommandLine`](#function-library-lib.cli.toCommandLine)

    `formatList`

    : Called on lists when `listRepr` is `"join"`. This function turns a list of
      option arguments into a string.

    `splitList`

    : A function that takes the option name and returns the `splitList` function
      to use.
      For further reference see `splitList` in:
      [`lib.cli.toCommandLine`](#function-library-lib.cli.toCommandLine)

    # Examples

    :::{.example}
    ## `lib.cli.toCommandLineGNU` usage example

    ```nix
    lib.cli.toCommandLineGNU {} {
      v = true;
      verbose = [true true false null];
      i = ".bak";
      testsuite = ["unit" "integration"];
      e = ["s/a/b/" "s/b/c/"];
      n = false;
      data = builtins.toJSON {id = 0;};
    }
    => [
      "--data={\"id\":0}"
      "-es/a/b/"
      "-es/b/c/"
      "-i.bak"
      "--testsuite=unit"
      "--testsuite=integration"
      "-v"
      "--verbose"
      "--verbose"
    ]
    ```

    :::
  */
  toCommandLineGNU =
    {
      isLong ? optionName: stringLength optionName > 1,
      explicitBool ? false,
      formatArg ? mkValueString,
      listRepr ? _: "repeat",
      formatList ? list: join "," (map formatArg list),
      splitList ? _: list: [ list ],
    }:
    let
      optionFormat = optionName: {
        option = if isLong optionName then "--${optionName}" else "-${optionName}";
        sep = if isLong optionName then "=" else "";
        formatArg =
          value: if listRepr optionName == "join" && isList value then formatList value else formatArg value;
        listRepr = listRepr optionName;
        splitList = splitList optionName;
        inherit explicitBool;
      };
    in
    toCommandLine optionFormat;

  /**
    Converts the given attributes into a single shell-escaped command-line
    string.
    Similar to `toCommandLine`, but returns a single escaped string instead of
    a list of arguments.
    For further reference see:
    [`lib.cli.toCommandLine`](#function-library-lib.cli.toCommandLine)
  */
  toCommandLineShell = optionFormat: attrs: escapeShellArgs (toCommandLine optionFormat attrs);

  /**
    Converts an attribute set into a list of command-line arguments.

    This is the most general command-line conversion function in `lib.cli`. It
    is parameterized by an `optionFormat` function, which defines how each
    option name and its value are rendered.

    # Type

    ```
    toCommandLine ::
      (
        String ->
          {
            option :: String,
            sep :: String | Null,
            explicitBool :: Bool,
            formatArg :: Any -> String,
            listRepr :: "repeat" | "join" | "spread",
            splitList :: [Any] -> [[Any]],
          }
      ) -> AttrSet -> [String]
    ```

    # Inputs

    `optionFormat`

    : A function that takes the option name and returns an option spec, where
      the option spec is an attribute set describing how the option should be
      rendered.

      The returned attribute set must contain:

      - `option`:
        The option string, e.g. `"-v"` or `"--verbose"`.

      - `sep`:
        How to separate the option from its argument. If `null`, the option and
        its argument are returned as two separate list elements. If a string
        (e.g. `"="`), the option and argument are concatenated.

      - `explicitBool`:
        Controls how boolean values are handled:
        - `false`:
          `true` emits only the option string (e.g. `"-v"` or `"--verbose"`),
          `false` emits nothing.
        - `true`:
          Both `true` and `false` are rendered as explicit arguments via
          `formatArg`, e.g. `--debug=true` or `--escape=false`.

      - `formatArg` (optional):
        Converts the option argument to a string.
        Defaults to `lib.generators.mkValueStringDefault { }`.

      - `listRepr` (optional):
        Specifies which representation should be used for lists:
        - `"repeat"`:
          Repeats the option with different values, e.g.:
          `--option=foo --option=bar --option=baz`.
        - `"join"`:
          Passes the list of arguments into `formatArg`, e.g.:
          `--option=foo,bar,baz`.
        - `"spread"`:
          Outputs the option once and spreads the arguments after it, e.g.:
          `--option foo bar baz`.
          The behavior of this representation can be customized via the
          `splitList` function. `sep` is treated as if it were `null`.

        Defaults to `"repeat"`.

      - `splitList` (optional):
        The function that will be used when `listRepr` is `"spread"`.
        Defaults to `list: [list]`.

    `attrs`

    : An attribute set mapping option names to values.

      Value types:
      - `Null`: Omitted entirely.
      - `Bool`: Handled according to `explicitBool`.
      - `List`: Handled according to `listRepr`.
      - Anything else is rendered as a single option argument via `formatArg`.

      Empty attribute names are rejected.

    # Examples

    :::{.example}
    ## `lib.cli.toCommandLine` basic usage example

    ```nix
    let
      optionFormat = optionName: {
        option = "-${optionName}";
        sep = "=";
        explicitBool = true;
      };
    in
    lib.cli.toCommandLine optionFormat {
      v = true;
      verbose = [
        true
        true
        false
        null
      ];
      i = ".bak";
      testsuite = [
        "unit"
        "integration"
      ];
      e = [
        "s/a/b/"
        "s/b/c/"
      ];
      n = false;
      data = builtins.toJSON { id = 0; };
    }
    => [
      "-data={\"id\":0}"
      "-e=s/a/b/"
      "-e=s/b/c/"
      "-i=.bak"
      "-n=false"
      "-testsuite=unit"
      "-testsuite=integration"
      "-v=true"
      "-verbose=true"
      "-verbose=true"
      "-verbose=false"
    ]
    ```
    :::

    :::{.example}
    ## `lib.cli.toCommandLine` usage with a more complex option format

    ```nix
    let
      optionFormat =
        optionName:
        let
          isLong = lib.stringLength optionName > 1;
        in
        rec {
          option = if isLong then "--${optionName}" else "-${optionName}";
          sep = if isLong then "=" else null;
          explicitBool = true;
          formatArg =
            let
              f = value: if lib.isString value then value else lib.toJSON value;
            in
            value: if listRepr == "join" && lib.isList value then lib.join "," (map f value) else f value;
          listRepr = if optionName == "tags" then "join" else "repeat";
        };
    in
    lib.cli.toCommandLine optionFormat {
      v = true;
      verbose = [
        true
        true
        false
        null
      ];
      n = false;
      output = "result.txt";
      testsuite = [
        "unit"
        "integration"
      ];
      data = {
        id = 0;
        name = "test";
      };
      tags = [
        "foo"
        "bar"
      ];
    }
    => [
      "--data={\"id\":0,\"name\":\"test\"}"
      "-n"
      "false"
      "--output=result.txt"
      "--tags=foo,bar"
      "--testsuite=unit"
      "--testsuite=integration"
      "-v"
      "true"
      "--verbose=true"
      "--verbose=true"
      "--verbose=false"
    ]
    ```
    :::

    # See also

    - `lib.cli.toCommandLineShell`
    - `lib.cli.toCommandLineGNU`
    - `lib.cli.toCommandLineShellGNU`
  */
  toCommandLine =
    optionFormat:
    let
      handlePair =
        spec: name: value:
        throwIf (name == "") "lib.cli.toCommandLine only accepts non-empty option names." (
          concatMap (renderOption spec) (prepareValue spec value)
        );

      prepareValue =
        spec: value:
        if !isList value then
          [ value ]
        else
          let
            reprs = {
              repeat = value;
              join = [ value ];
              spread = spec.splitList value;
            };
          in
          reprs.${spec.listRepr}
            or (throw "lib.cli.toCommandline requires that listRepr is one of: ${join ", " (attrNames reprs)}");

      renderOption =
        spec: value:
        if value == null || (!spec.explicitBool && value == false) then
          [ ]
        else if !spec.explicitBool && value == true then
          [ spec.option ]
        else if isList value && spec.listRepr == "spread" then
          [ spec.option ] ++ (map spec.formatArg value)
        else
          let
            arg = spec.formatArg value;
          in
          if spec.sep != null then
            [ "${spec.option}${spec.sep}${arg}" ]
          else
            [
              spec.option
              arg
            ];

      toSpec =
        optionName:
        (
          {
            option,
            sep,
            explicitBool,
            formatArg ? mkValueString,
            listRepr ? "repeat",
            splitList ? list: [ list ],
          }@spec:
          {
            inherit formatArg listRepr splitList;
          }
          // spec
        )
          (optionFormat optionName);
    in
    attrs: concatLists (mapAttrsToList (name: handlePair (toSpec name) name) attrs);
}
