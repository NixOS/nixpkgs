rec {

  /* The identity function
     For when you need a function that does “nothing”.

     Type: id :: a -> a
  */
  id = x: x;

  /* The constant function
     Ignores the second argument.
     Or: Construct a function that always returns a static value.

     Type: const :: a -> b -> a
     Example:
       let f = const 5; in f 10
       => 5
  */
  const = x: y: x;


  ## Named versions corresponding to some builtin operators.

  /* Concat two strings */
  concat = x: y: x ++ y;

  /* boolean “or” */
  or = x: y: x || y;

  /* boolean “and” */
  and = x: y: x && y;

  /* Convert a boolean to a string.
     Note that toString on a bool returns "1" and "".
  */
  boolToString = b: if b then "true" else "false";

  /* Merge two attribute sets shallowly, right side trumps left

     Example:
       mergeAttrs { a = 1; b = 2; } { b = 3; c = 4; }
       => { a = 1; b = 3; c = 4; }
  */
  mergeAttrs = x: y: x // y;

  # Flip the order of the arguments of a binary function.
  flip = f: a: b: f b a;

  # Apply function if argument is non-null
  mapNullable = f: a: if isNull a then a else f a;

  # Pull in some builtins not included elsewhere.
  inherit (builtins)
    pathExists readFile isBool isFunction
    isInt add sub lessThan
    seq deepSeq genericClosure;

  inherit (import ./strings.nix) fileContents;

  # Return the Nixpkgs version number.
  nixpkgsVersion =
    let suffixFile = ../.version-suffix; in
    fileContents ../.version
    + (if pathExists suffixFile then fileContents suffixFile else "pre-git");

  # Whether we're being called by nix-shell.
  inNixShell = builtins.getEnv "IN_NIX_SHELL" != "";

  # Return minimum/maximum of two numbers.
  min = x: y: if x < y then x else y;
  max = x: y: if x > y then x else y;

  /* Reads a JSON file. */
  importJSON = path:
    builtins.fromJSON (builtins.readFile path);

  /* See https://github.com/NixOS/nix/issues/749. Eventually we'd like these
     to expand to Nix builtins that carry metadata so that Nix can filter out
     the INFO messages without parsing the message string.

     Usage:
     {
       foo = lib.warn "foo is deprecated" oldFoo;
     }

     TODO: figure out a clever way to integrate location information from
     something like __unsafeGetAttrPos.
  */
  warn = msg: builtins.trace "WARNING: ${msg}";
  info = msg: builtins.trace "INFO: ${msg}";
}
