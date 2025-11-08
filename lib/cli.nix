{ lib }:

{
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
    lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2511)
      "lib.cli.toGNUCommandLineShell is deprecated, please use lib.cli.toCommandLineShell or lib.cli.toCommandLineShellGNU instead."
      (options: attrs: lib.escapeShellArgs (lib.cli.toGNUCommandLine options attrs));

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
    By default, there is no separator, so option `-c` and value `5` would become ["-c" "5"].
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
    lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2511)
      "lib.cli.toGNUCommandLine is deprecated, please use lib.cli.toCommandLine or lib.cli.toCommandLineShellGNU instead."
      (
        {
          mkOptionName ? k: if builtins.stringLength k == 1 then "-${k}" else "--${k}",

          mkBool ? k: v: lib.optional v (mkOptionName k),

          mkList ? k: v: lib.concatMap (mkOption k) v,

          mkOption ?
            k: v:
            if v == null then
              [ ]
            else if optionValueSeparator == null then
              [
                (mkOptionName k)
                (lib.generators.mkValueStringDefault { } v)
              ]
            else
              [ "${mkOptionName k}${optionValueSeparator}${lib.generators.mkValueStringDefault { } v}" ],

          optionValueSeparator ? null,
        }:
        options:
        let
          render =
            k: v:
            if builtins.isBool v then
              mkBool k v
            else if builtins.isList v then
              mkList k v
            else
              mkOption k v;

        in
        builtins.concatLists (lib.mapAttrsToList render options)
      );

  /**
    Converts the given attributes into a single shell-escaped command-line string.
    Similar to `toCommandLineGNU`, but returns a single escaped string instead of an array of arguments.
    For further reference see: [`lib.cli.toCommandLineGNU`](#function-library-lib.cli.toCommandLineGNU)
  */
  toCommandLineShellGNU =
    options: attrs: lib.escapeShellArgs (lib.cli.toCommandLineGNU options attrs);

  /**
    Converts an attribute set into a list of GNU-style command line options.

    `toCommandLineGNU` returns a list of string arguments.

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
      isLong ? optionName: builtins.stringLength optionName > 1,
      explicitBool ? false,
      formatArg ? lib.generators.mkValueStringDefault { },
    }:
    let
      optionFormat = optionName: {
        option = if isLong optionName then "--${optionName}" else "-${optionName}";
        sep = if isLong optionName then "=" else "";
        inherit explicitBool formatArg;
      };
    in
    lib.cli.toCommandLine optionFormat;

  /**
    Converts the given attributes into a single shell-escaped command-line string.
    Similar to `toCommandLine`, but returns a single escaped string instead of an array of arguments.
    For further reference see: [`lib.cli.toCommandLine`](#function-library-lib.cli.toCommandLine)
  */
  toCommandLineShell =
    optionFormat: attrs: lib.escapeShellArgs (lib.cli.toCommandLine optionFormat attrs);

  /**
    Converts an attribute set into a list of command line options.

    `toCommandLine` returns a list of string arguments.

    # Inputs

    `optionFormat`

    : The option format that describes how options and their arguments should be formatted.

    `attrs`

    : The attributes to transform into arguments.

    # Examples
    :::{.example}
    ## `lib.cli.toCommandLine` usage example

    ```nix
    let
      optionFormat = optionName: {
        option = "-${optionName}";
        sep = "=";
        explicitBool = true;
      };
    in lib.cli.toCommandLine optionFormat {
      v = true;
      verbose = [true true false null];
      i = ".bak";
      testsuite = ["unit" "integration"];
      e = ["s/a/b/" "s/b/c/"];
      n = false;
      data = builtins.toJSON {id = 0;};
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
  */
  toCommandLine =
    optionFormat: attrs:
    let
      handlePair =
        k: v:
        if k == "" then
          lib.throw "lib.cli.toCommandLine only accepts non-empty option names."
        else if builtins.isList v then
          builtins.concatMap (handleOption k) v
        else
          handleOption k v;

      handleOption = k: renderOption (optionFormat k) k;

      renderOption =
        {
          option,
          sep,
          explicitBool,
          formatArg ? lib.generators.mkValueStringDefault { },
        }:
        k: v:
        if v == null || (!explicitBool && v == false) then
          [ ]
        else if !explicitBool && v == true then
          [ option ]
        else
          let
            arg = formatArg v;
          in
          if sep != null then
            [ "${option}${sep}${arg}" ]
          else
            [
              option
              arg
            ];
    in
    builtins.concatLists (lib.mapAttrsToList handlePair attrs);
}
