{ lib }:

rec {
  /**
    Automatically convert an attribute set to command-line options.

    This helps protect against malformed command lines and also to reduce
    boilerplate related to command-line construction for simple use cases.

    `toGNUCommandLine` returns a list of nix strings.

    `toGNUCommandLineShell` returns an escaped shell string.

    # Inputs

    `options`

    : 1\. Function argument

    `attrs`

    : 2\. Function argument

    # Examples
    :::{.example}
    ## `lib.cli.toGNUCommandLineShell` usage example

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
  toGNUCommandLineShell = options: attrs: lib.escapeShellArgs (toGNUCommandLine options attrs);

  toGNUCommandLine =
    {
      # how to string-format the option name;
      # by default one character is a short option (`-`),
      # more than one characters a long option (`--`).
      mkOptionName ? k: if builtins.stringLength k == 1 then "-${k}" else "--${k}",

      # how to format a boolean value to a command list;
      # by default it’s a flag option
      # (only the option name if true, left out completely if false).
      mkBool ? k: v: lib.optional v (mkOptionName k),

      # how to format a list value to a command list;
      # by default the option name is repeated for each value
      # and `mkOption` is applied to the values themselves.
      mkList ? k: v: lib.concatMap (mkOption k) v,

      # how to format any remaining value to a command list;
      # on the toplevel, booleans and lists are handled by `mkBool` and `mkList`,
      # though they can still appear as values of a list.
      # By default, everything is printed verbatim and complex types
      # are forbidden (lists, attrsets, functions). `null` values are omitted.
      mkOption ?
        k: v:
        if v == null then
          [ ]
        else
          [
            (mkOptionName k)
            (lib.generators.mkValueStringDefault { } v)
          ],
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
    builtins.concatLists (lib.mapAttrsToList render options);
}
