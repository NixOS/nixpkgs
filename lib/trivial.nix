{ lib }:

rec {

  ## Simple (higher order) functions

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

  /* Concatenate two lists */
  concat = x: y: x ++ y;

  /* boolean “or” */
  or = x: y: x || y;

  /* boolean “and” */
  and = x: y: x && y;

  /* bitwise “and” */
  bitAnd = builtins.bitAnd
    or (import ./zip-int-bits.nix
        (a: b: if a==1 && b==1 then 1 else 0));

  /* bitwise “or” */
  bitOr = builtins.bitOr
    or (import ./zip-int-bits.nix
        (a: b: if a==1 || b==1 then 1 else 0));

  /* bitwise “xor” */
  bitXor = builtins.bitXor
    or (import ./zip-int-bits.nix
        (a: b: if a!=b then 1 else 0));

  /* bitwise “not” */
  bitNot = builtins.sub (-1);

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

  /* Flip the order of the arguments of a binary function.

     Example:
       flip concat [1] [2]
       => [ 2 1 ]
  */
  flip = f: a: b: f b a;

  /* Apply function if argument is non-null.

     Example:
       mapNullable (x: x+1) null
       => null
       mapNullable (x: x+1) 22
       => 23
  */
  mapNullable = f: a: if isNull a then a else f a;

  # Pull in some builtins not included elsewhere.
  inherit (builtins)
    pathExists readFile isBool
    isInt isFloat add sub lessThan
    seq deepSeq genericClosure;


  ## nixpks version strings

  # The current full nixpkgs version number.
  version = release + versionSuffix;

  # The current nixpkgs version number as string.
  release = lib.strings.fileContents ../.version;

  # The current nixpkgs version suffix as string.
  versionSuffix =
    let suffixFile = ../.version-suffix;
    in if pathExists suffixFile
    then lib.strings.fileContents suffixFile
    else "pre-git";

  nixpkgsVersion = builtins.trace "`lib.nixpkgsVersion` is deprecated, use `lib.version` instead!" version;

  # Whether we're being called by nix-shell.
  inNixShell = builtins.getEnv "IN_NIX_SHELL" != "";


  ## Integer operations

  # Return minimum/maximum of two numbers.
  min = x: y: if x < y then x else y;
  max = x: y: if x > y then x else y;

  /* Integer modulus

     Example:
       mod 11 10
       => 1
       mod 1 10
       => 1
  */
  mod = base: int: base - (int * (builtins.div base int));


  ## Comparisons

  /* C-style comparisons

     a < b,  compare a b => -1
     a == b, compare a b => 0
     a > b,  compare a b => 1
  */
  compare = a: b:
    if a < b
    then -1
    else if a > b
         then 1
         else 0;

  /* Split type into two subtypes by predicate `p`, take all elements
     of the first subtype to be less than all the elements of the
     second subtype, compare elements of a single subtype with `yes`
     and `no` respectively.

     Example:

       let cmp = splitByAndCompare (hasPrefix "foo") compare compare; in

       cmp "a" "z" => -1
       cmp "fooa" "fooz" => -1

       cmp "f" "a" => 1
       cmp "fooa" "a" => -1
       # while
       compare "fooa" "a" => 1
  */
  splitByAndCompare = p: yes: no: a: b:
    if p a
    then if p b then yes a b else -1
    else if p b then 1 else no a b;


  /* Reads a JSON file. */
  importJSON = path:
    builtins.fromJSON (builtins.readFile path);


  ## Warnings

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


  ## Function annotations

  /* Add metadata about expected function arguments to a function.
     The metadata should match the format given by
     builtins.functionArgs, i.e. a set from expected argument to a bool
     representing whether that argument has a default or not.
     setFunctionArgs : (a → b) → Map String Bool → (a → b)

     This function is necessary because you can't dynamically create a
     function of the { a, b ? foo, ... }: format, but some facilities
     like callPackage expect to be able to query expected arguments.
  */
  setFunctionArgs = f: args:
    { # TODO: Should we add call-time "type" checking like built in?
      __functor = self: f;
      __functionArgs = args;
    };

  /* Extract the expected function arguments from a function.
     This works both with nix-native { a, b ? foo, ... }: style
     functions and functions with args set with 'setFunctionArgs'. It
     has the same return type and semantics as builtins.functionArgs.
     setFunctionArgs : (a → b) → Map String Bool.
  */
  functionArgs = f: f.__functionArgs or (builtins.functionArgs f);

  /* Check whether something is a function or something
     annotated with function args.
  */
  isFunction = f: builtins.isFunction f ||
    (f ? __functor && isFunction (f.__functor f));
}
