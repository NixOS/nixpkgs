{ lib }:

rec {
  /* Format a boolean value to a command line list. If boolean is false,
     returns empty list. Otherwise, returns a list with option name.

     Example:
       cli.mkDefaultBool "help" true => ["--help"]
       cli.mkDefaultBool "verbose" false => []
  */
  mkDefaultBool = k: v: lib.optional v (mkDefaultOptionName k);

  /* Format a list value to a command line list. Interleaves the same option
     name for each value in the list.

     Example:
       cli.mkDefaultList "name" ["ethel" "joe"] => ["--name" "ethel" "--name" "joe"]
  */
  mkDefaultList =  k: v: lib.concatMap (mkDefaultOption k) v;

  /* Format a value to a command line list. Returns option name, followed by
     stringified representation of the value.

     Example:
       cli.mkDefaultOption "disk" "/dev/sda" => ["--disk" "/dev/sda"]
       cli.mkDefaultOption "ram" 2048 => ["--ram" "2048"]
  */
  mkDefaultOption =
    k: v: if v == null
      then []
      else [ (mkDefaultOptionName k) (lib.generators.mkValueStringDefault {} v) ];

  /* Format option name. One character names are assumed to be short options (`-`),
     other names are long options (`--`).

     Example:
       cli.mkDefaultOptionName "h" => ["-h"]
       cli.mkDefaultOptionName "help" => ["--help"]
  */
  mkDefaultOptionName =
    k: if builtins.stringLength k == 1
        then "-${k}"
        else "--${k}";

  /* Automatically convert an attribute set to command-line options.

     This helps protect against malformed command lines and also to reduce
     boilerplate related to command-line construction for simple use cases.

     `toGNUCommandLine` returns a list of nix strings.
     `toGNUCommandLineShell` returns an escaped shell string.

     Example:
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
  */
  toGNUCommandLineShell =
    options: attrs: lib.escapeShellArgs (toGNUCommandLine options attrs);

  toGNUCommandLine =
    { mkBool ? mkDefaultBool,
      mkList ? mkDefaultList,
      mkOption ? mkDefaultOption,
      mkOptionName ? mkDefaultOptionName }:
    options:
      let
        render = k: v:
          if      builtins.isBool v then mkBool k v
          else if builtins.isList v then mkList k v
          else mkOption k v;
      in
        builtins.concatLists (lib.mapAttrsToList render options);
}
