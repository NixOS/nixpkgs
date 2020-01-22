{ lib }:

rec {
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
    { mkKey ?
        k: if builtins.stringLength k == 1
           then "-${k}"
           else "--${k}"

    , mkOption ?
        k: v: if v == null
              then []
              else [ (mkKey k) (builtins.toString v) ]

    , mkBool ? k: v: lib.optional v (mkKey k)

    , mkList ? k: v: lib.concatMap (mkOption k) v
    }:
    options:
      let
        render = k: v:
          if      builtins.isBool v then mkBool k v
          else if builtins.isList v then mkList k v
          else mkOption k v;

      in
        builtins.concatLists (lib.mapAttrsToList render options);
}
