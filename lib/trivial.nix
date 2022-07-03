{ lib }:

rec {

  ## Simple (higher order) functions

  /* The identity function
     For when you need a function that does “nothing”.

     Type: id :: a -> a
  */
  id =
    # The value to return
    x: x;

  /* The constant function

     Ignores the second argument. If called with only one argument,
     constructs a function that always returns a static value.

     Type: const :: a -> b -> a
     Example:
       let f = const 5; in f 10
       => 5
  */
  const =
    # Value to return
    x:
    # Value to ignore
    y: x;

  /* Pipes a value through a list of functions, left to right.

     Type: pipe :: a -> [<functions>] -> <return type of last function>
     Example:
       pipe 2 [
         (x: x + 2)  # 2 + 2 = 4
         (x: x * 2)  # 4 * 2 = 8
       ]
       => 8

       # ideal to do text transformations
       pipe [ "a/b" "a/c" ] [

         # create the cp command
         (map (file: ''cp "${src}/${file}" $out\n''))

         # concatenate all commands into one string
         lib.concatStrings

         # make that string into a nix derivation
         (pkgs.runCommand "copy-to-out" {})

       ]
       => <drv which copies all files to $out>

     The output type of each function has to be the input type
     of the next function, and the last function returns the
     final value.
  */
  pipe = val: functions:
    let reverseApply = x: f: f x;
    in builtins.foldl' reverseApply val functions;

  # note please don’t add a function like `compose = flip pipe`.
  # This would confuse users, because the order of the functions
  # in the list is not clear. With pipe, it’s obvious that it
  # goes first-to-last. With `compose`, not so much.

  ## Named versions corresponding to some builtin operators.

  /* Concatenate two lists

     Type: concat :: [a] -> [a] -> [a]

     Example:
       concat [ 1 2 ] [ 3 4 ]
       => [ 1 2 3 4 ]
  */
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

     This function uses the strings "true" and "false" to represent
     boolean values. Calling `toString` on a bool instead returns "1"
     and "" (sic!).

     Type: boolToString :: bool -> string
  */
  boolToString = b: if b then "true" else "false";

  /* Merge two attribute sets shallowly, right side trumps left

     mergeAttrs :: attrs -> attrs -> attrs

     Example:
       mergeAttrs { a = 1; b = 2; } { b = 3; c = 4; }
       => { a = 1; b = 3; c = 4; }
  */
  mergeAttrs =
    # Left attribute set
    x:
    # Right attribute set (higher precedence for equal keys)
    y: x // y;

  /* Flip the order of the arguments of a binary function.

     Type: flip :: (a -> b -> c) -> (b -> a -> c)

     Example:
       flip concat [1] [2]
       => [ 2 1 ]
  */
  flip = f: a: b: f b a;

  /* Apply function if the supplied argument is non-null.

     Example:
       mapNullable (x: x+1) null
       => null
       mapNullable (x: x+1) 22
       => 23
  */
  mapNullable =
    # Function to call
    f:
    # Argument to check for null before passing it to `f`
    a: if a == null then a else f a;

  # Pull in some builtins not included elsewhere.
  inherit (builtins)
    pathExists readFile isBool
    isInt isFloat add sub lessThan
    seq deepSeq genericClosure;


  ## nixpkgs version strings

  /* Returns the current full nixpkgs version number. */
  version = release + versionSuffix;

  /* Returns the current nixpkgs release number as string. */
  release = lib.strings.fileContents ../.version;

  /* The latest release that is supported, at the time of release branch-off,
     if applicable.

     Ideally, out-of-tree modules should be able to evaluate cleanly with all
     supported Nixpkgs versions (master, release and old release until EOL).
     So if possible, deprecation warnings should take effect only when all
     out-of-tree expressions/libs/modules can upgrade to the new way without
     losing support for supported Nixpkgs versions.

     This release number allows deprecation warnings to be implemented such that
     they take effect as soon as the oldest release reaches end of life. */
  oldestSupportedRelease =
    # Update on master only. Do not backport.
    2111;

  /* Whether a feature is supported in all supported releases (at the time of
     release branch-off, if applicable). See `oldestSupportedRelease`. */
  isInOldestRelease =
    /* Release number of feature introduction as an integer, e.g. 2111 for 21.11.
       Set it to the upcoming release, matching the nixpkgs/.version file.
    */
    release:
      release <= lib.trivial.oldestSupportedRelease;

  /* Returns the current nixpkgs release code name.

     On each release the first letter is bumped and a new animal is chosen
     starting with that new letter.
  */
  codeName = "Raccoon";

  /* Returns the current nixpkgs version suffix as string. */
  versionSuffix =
    let suffixFile = ../.version-suffix;
    in if pathExists suffixFile
    then lib.strings.fileContents suffixFile
    else "pre-git";

  /* Attempts to return the the current revision of nixpkgs and
     returns the supplied default value otherwise.

     Type: revisionWithDefault :: string -> string
  */
  revisionWithDefault =
    # Default value to return if revision can not be determined
    default:
    let
      revisionFile = "${toString ./..}/.git-revision";
      gitRepo      = "${toString ./..}/.git";
    in if lib.pathIsGitRepo gitRepo
       then lib.commitIdFromGitRepo gitRepo
       else if lib.pathExists revisionFile then lib.fileContents revisionFile
       else default;

  nixpkgsVersion = builtins.trace "`lib.nixpkgsVersion` is deprecated, use `lib.version` instead!" version;

  /* Determine whether the function is being called from inside a Nix
     shell.

     Type: inNixShell :: bool
  */
  inNixShell = builtins.getEnv "IN_NIX_SHELL" != "";

  /* Determine whether the function is being called from inside pure-eval mode
     by seeing whether `builtins` contains `currentSystem`. If not, we must be in
     pure-eval mode.

     Type: inPureEvalMode :: bool
  */
  inPureEvalMode = ! builtins ? currentSystem;

  ## Integer operations

  /* Return minimum of two numbers. */
  min = x: y: if x < y then x else y;

  /* Return maximum of two numbers. */
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

     Type: (a -> bool) -> (a -> a -> int) -> (a -> a -> int) -> (a -> a -> int)

     Example:
       let cmp = splitByAndCompare (hasPrefix "foo") compare compare; in

       cmp "a" "z" => -1
       cmp "fooa" "fooz" => -1

       cmp "f" "a" => 1
       cmp "fooa" "a" => -1
       # while
       compare "fooa" "a" => 1
  */
  splitByAndCompare =
    # Predicate
    p:
    # Comparison function if predicate holds for both values
    yes:
    # Comparison function if predicate holds for neither value
    no:
    # First value to compare
    a:
    # Second value to compare
    b:
    if p a
    then if p b then yes a b else -1
    else if p b then 1 else no a b;


  /* Reads a JSON file.

     Type :: path -> any
  */
  importJSON = path:
    builtins.fromJSON (builtins.readFile path);

  /* Reads a TOML file.

     Type :: path -> any
  */
  importTOML = path:
    builtins.fromTOML (builtins.readFile path);

  ## Warnings

  # See https://github.com/NixOS/nix/issues/749. Eventually we'd like these
  # to expand to Nix builtins that carry metadata so that Nix can filter out
  # the INFO messages without parsing the message string.
  #
  # Usage:
  # {
  #   foo = lib.warn "foo is deprecated" oldFoo;
  #   bar = lib.warnIf (bar == "") "Empty bar is deprecated" bar;
  # }
  #
  # TODO: figure out a clever way to integrate location information from
  # something like __unsafeGetAttrPos.

  /*
    Print a warning before returning the second argument. This function behaves
    like `builtins.trace`, but requires a string message and formats it as a
    warning, including the `warning: ` prefix.

    To get a call stack trace and abort evaluation, set the environment variable
    `NIX_ABORT_ON_WARN=true` and set the Nix options `--option pure-eval false --show-trace`

    Type: string -> a -> a
  */
  warn =
    if lib.elem (builtins.getEnv "NIX_ABORT_ON_WARN") ["1" "true" "yes"]
    then msg: builtins.trace "[1;31mwarning: ${msg}[0m" (abort "NIX_ABORT_ON_WARN=true; warnings are treated as unrecoverable errors.")
    else msg: builtins.trace "[1;31mwarning: ${msg}[0m";

  /*
    Like warn, but only warn when the first argument is `true`.

    Type: bool -> string -> a -> a
  */
  warnIf = cond: msg: if cond then warn msg else x: x;

  /*
    Like warnIf, but negated (warn if the first argument is `false`).

    Type: bool -> string -> a -> a
  */
  warnIfNot = cond: msg: if cond then x: x else warn msg;

  /*
    Like the `assert b; e` expression, but with a custom error message and
    without the semicolon.

    If true, return the identity function, `r: r`.

    If false, throw the error message.

    Calls can be juxtaposed using function application, as `(r: r) a = a`, so
    `(r: r) (r: r) a = a`, and so forth.

    Type: bool -> string -> a -> a

    Example:

        throwIfNot (lib.isList overlays) "The overlays argument to nixpkgs must be a list."
        lib.foldr (x: throwIfNot (lib.isFunction x) "All overlays passed to nixpkgs must be functions.") (r: r) overlays
        pkgs

  */
  throwIfNot = cond: msg: if cond then x: x else throw msg;

  /*
    Like throwIfNot, but negated (throw if the first argument is `true`).

    Type: bool -> string -> a -> a
  */
  throwIf = cond: msg: if cond then throw msg else x: x;

  /* Check if the elements in a list are valid values from a enum, returning the identity function, or throwing an error message otherwise.

     Example:
       let colorVariants = ["bright" "dark" "black"]
       in checkListOfEnum "color variants" [ "standard" "light" "dark" ] colorVariants;
       =>
       error: color variants: bright, black unexpected; valid ones: standard, light, dark

     Type: String -> List ComparableVal -> List ComparableVal -> a -> a
  */
  checkListOfEnum = msg: valid: given:
    let
      unexpected = lib.subtractLists valid given;
    in
      lib.throwIfNot (unexpected == [])
        "${msg}: ${builtins.concatStringsSep ", " (builtins.map builtins.toString unexpected)} unexpected; valid ones: ${builtins.concatStringsSep ", " (builtins.map builtins.toString valid)}";

  info = msg: builtins.trace "INFO: ${msg}";

  showWarnings = warnings: res: lib.foldr (w: x: warn w x) res warnings;

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
  functionArgs = f:
    if f ? __functor
    then f.__functionArgs or (lib.functionArgs (f.__functor f))
    else builtins.functionArgs f;

  /* Check whether something is a function or something
     annotated with function args.
  */
  isFunction = f: builtins.isFunction f ||
    (f ? __functor && isFunction (f.__functor f));

  /*
    Turns any non-callable values into constant functions.
    Returns callable values as is.

    Example:

      nix-repl> lib.toFunction 1 2
      1

      nix-repl> lib.toFunction (x: x + 1) 2
      3
  */
  toFunction =
    # Any value
    v:
    if isFunction v
    then v
    else k: v;

  /* Convert the given positive integer to a string of its hexadecimal
     representation. For example:

     toHexString 0 => "0"

     toHexString 16 => "10"

     toHexString 250 => "FA"
  */
  toHexString = i:
    let
      toHexDigit = d:
        if d < 10
        then toString d
        else
          {
            "10" = "A";
            "11" = "B";
            "12" = "C";
            "13" = "D";
            "14" = "E";
            "15" = "F";
          }.${toString d};
    in
      lib.concatMapStrings toHexDigit (toBaseDigits 16 i);

  /* `toBaseDigits base i` converts the positive integer i to a list of its
     digits in the given base. For example:

     toBaseDigits 10 123 => [ 1 2 3 ]

     toBaseDigits 2 6 => [ 1 1 0 ]

     toBaseDigits 16 250 => [ 15 10 ]
  */
  toBaseDigits = base: i:
    let
      go = i:
        if i < base
        then [i]
        else
          let
            r = i - ((i / base) * base);
            q = (i - r) / base;
          in
            [r] ++ go q;
    in
      assert (base >= 2);
      assert (i >= 0);
      lib.reverseList (go i);
}
