{ lib }:

let
  inherit (lib.trivial)
    isFunction
    isInt
    functionArgs
    pathExists
    release
    setFunctionArgs
    toBaseDigits
    version
    versionSuffix
    warn
    ;
  inherit (lib)
    isString
    ;
in
{

  ## Simple (higher order) functions

  /**
    The identity function
    For when you need a function that does “nothing”.

    # Inputs

    `x`

    : The value to return

    # Type

    ```
    id :: a -> a
    ```
  */
  id = x: x;

  /**
    The constant function

    Ignores the second argument. If called with only one argument,
    constructs a function that always returns a static value.

    # Inputs

    `x`

    : Value to return

    `y`

    : Value to ignore

    # Type

    ```
    const :: a -> b -> a
    ```

    # Examples
    :::{.example}
    ## `lib.trivial.const` usage example

    ```nix
    let f = const 5; in f 10
    => 5
    ```

    :::
  */
  const = x: y: x;

  /**
    Pipes a value through a list of functions, left to right.

    # Inputs

    `value`

    : Value to start piping.

    `fns`

    : List of functions to apply sequentially.

    # Type

    ```
    pipe :: a -> [<functions>] -> <return type of last function>
    ```

    # Examples
    :::{.example}
    ## `lib.trivial.pipe` usage example

    ```nix
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
    ```

    :::
  */
  pipe = builtins.foldl' (x: f: f x);

  # note please don’t add a function like `compose = flip pipe`.
  # This would confuse users, because the order of the functions
  # in the list is not clear. With pipe, it’s obvious that it
  # goes first-to-last. With `compose`, not so much.

  ## Named versions corresponding to some builtin operators.

  /**
    Concatenate two lists

    # Inputs

    `x`

    : 1\. Function argument

    `y`

    : 2\. Function argument

    # Type

    ```
    concat :: [a] -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.trivial.concat` usage example

    ```nix
    concat [ 1 2 ] [ 3 4 ]
    => [ 1 2 3 4 ]
    ```

    :::
  */
  concat = x: y: x ++ y;

  /**
    boolean “or”

    # Inputs

    `x`

    : 1\. Function argument

    `y`

    : 2\. Function argument
  */
  or = x: y: x || y;

  /**
    boolean “and”

    # Inputs

    `x`

    : 1\. Function argument

    `y`

    : 2\. Function argument
  */
  and = x: y: x && y;

  /**
    boolean “exclusive or”

    # Inputs

    `x`

    : 1\. Function argument

    `y`

    : 2\. Function argument
  */
  # We explicitly invert the arguments purely as a type assertion.
  # This is invariant under XOR, so it does not affect the result.
  xor = x: y: (!x) != (!y);

  /**
    bitwise “not”
  */
  bitNot = builtins.sub (-1);

  /**
    Convert a boolean to a string.

    This function uses the strings "true" and "false" to represent
    boolean values. Calling `toString` on a bool instead returns "1"
    and "" (sic!).

    # Inputs

    `b`

    : 1\. Function argument

    # Type

    ```
    boolToString :: bool -> string
    ```
  */
  boolToString = b: if b then "true" else "false";

  /**
    Converts a boolean to a string.

    This function uses the strings "yes" and "no" to represent
    boolean values.

    # Inputs

    `b`

    : The boolean to convert

    # Type

    ```
    boolToYesNo :: bool -> string
    ```
  */
  boolToYesNo = b: if b then "yes" else "no";

  /**
    Merge two attribute sets shallowly, right side trumps left

    mergeAttrs :: attrs -> attrs -> attrs

    # Inputs

    `x`

    : Left attribute set

    `y`

    : Right attribute set (higher precedence for equal keys)

    # Examples
    :::{.example}
    ## `lib.trivial.mergeAttrs` usage example

    ```nix
    mergeAttrs { a = 1; b = 2; } { b = 3; c = 4; }
    => { a = 1; b = 3; c = 4; }
    ```

    :::
  */
  mergeAttrs = x: y: x // y;

  /**
    Flip the order of the arguments of a binary function.

    # Inputs

    `f`

    : 1\. Function argument

    `a`

    : 2\. Function argument

    `b`

    : 3\. Function argument

    # Type

    ```
    flip :: (a -> b -> c) -> (b -> a -> c)
    ```

    # Examples
    :::{.example}
    ## `lib.trivial.flip` usage example

    ```nix
    flip concat [1] [2]
    => [ 2 1 ]
    ```

    :::
  */
  flip =
    f: a: b:
    f b a;

  /**
    Returns `maybeValue` if not null, otherwise return `default`.

    # Inputs

    `default`

    : 1\. Function argument

    `maybeValue`

    : 2\. Function argument

    # Examples
    :::{.example}
    ## `lib.trivial.defaultTo` usage example

    ```nix
    defaultTo "default" null
    => "default"
    defaultTo "default" "foo"
    => "foo"
    defaultTo "default" false
    => false
    ```

    :::
  */
  defaultTo = default: maybeValue: if maybeValue != null then maybeValue else default;

  /**
    Apply function if the supplied argument is non-null.

    # Inputs

    `f`

    : Function to call

    `a`

    : Argument to check for null before passing it to `f`

    # Examples
    :::{.example}
    ## `lib.trivial.mapNullable` usage example

    ```nix
    mapNullable (x: x+1) null
    => null
    mapNullable (x: x+1) 22
    => 23
    ```

    :::
  */
  mapNullable = f: a: if a == null then a else f a;

  # Pull in some builtins not included elsewhere.
  inherit (builtins)
    pathExists
    readFile
    isBool
    isInt
    isFloat
    add
    sub
    lessThan
    seq
    deepSeq
    genericClosure
    bitAnd
    bitOr
    bitXor
    ;

  ## nixpkgs version strings

  /**
    Returns the current full nixpkgs version number.
  */
  version = release + versionSuffix;

  /**
    Returns the current nixpkgs release number as string.
  */
  release = lib.strings.fileContents ./.version;

  /**
    The latest release that is supported, at the time of release branch-off,
    if applicable.

    Ideally, out-of-tree modules should be able to evaluate cleanly with all
    supported Nixpkgs versions (master, release and old release until EOL).
    So if possible, deprecation warnings should take effect only when all
    out-of-tree expressions/libs/modules can upgrade to the new way without
    losing support for supported Nixpkgs versions.

    This release number allows deprecation warnings to be implemented such that
    they take effect as soon as the oldest release reaches end of life.
  */
  oldestSupportedRelease =
    # Update on master only. Do not backport.
    2505;

  /**
    Whether a feature is supported in all supported releases (at the time of
    release branch-off, if applicable). See `oldestSupportedRelease`.

    # Inputs

    `release`

    : Release number of feature introduction as an integer, e.g. 2111 for 21.11.
    Set it to the upcoming release, matching the nixpkgs/.version file.
  */
  isInOldestRelease =
    lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2411)
      "lib.isInOldestRelease is deprecated. Use lib.oldestSupportedReleaseIsAtLeast instead."
      lib.oldestSupportedReleaseIsAtLeast;

  /**
    Alias for `isInOldestRelease` introduced in 24.11.
    Use `isInOldestRelease` in expressions outside of Nixpkgs for greater compatibility.
  */
  oldestSupportedReleaseIsAtLeast = release: release <= lib.trivial.oldestSupportedRelease;

  /**
    Returns the current nixpkgs release code name.

    On each release the first letter is bumped and a new animal is chosen
    starting with that new letter.
  */
  codeName = "Yarara";

  /**
    Returns the current nixpkgs version suffix as string.
  */
  versionSuffix =
    let
      suffixFile = ../.version-suffix;
    in
    if pathExists suffixFile then lib.strings.fileContents suffixFile else "pre-git";

  /**
    Attempts to return the the current revision of nixpkgs and
    returns the supplied default value otherwise.

    # Inputs

    `default`

    : Default value to return if revision can not be determined

    # Type

    ```
    revisionWithDefault :: string -> string
    ```
  */
  revisionWithDefault =
    default:
    let
      revisionFile = "${toString ./..}/.git-revision";
      gitRepo = "${toString ./..}/.git";
    in
    if lib.pathIsGitRepo gitRepo then
      lib.commitIdFromGitRepo gitRepo
    else if lib.pathExists revisionFile then
      lib.fileContents revisionFile
    else
      default;

  nixpkgsVersion = warn "lib.nixpkgsVersion is a deprecated alias of lib.version." version;

  /**
    Determine whether the function is being called from inside a Nix
    shell.

    # Type

    ```
    inNixShell :: bool
    ```
  */
  inNixShell = builtins.getEnv "IN_NIX_SHELL" != "";

  /**
    Determine whether the function is being called from inside pure-eval mode
    by seeing whether `builtins` contains `currentSystem`. If not, we must be in
    pure-eval mode.

    # Type

    ```
    inPureEvalMode :: bool
    ```
  */
  inPureEvalMode = !builtins ? currentSystem;

  ## Integer operations

  /**
    Returns minimum of two numbers.

    # Inputs

    `x`

    : 1\. Function argument

    `y`

    : 2\. Function argument
  */
  min = x: y: if x < y then x else y;

  /**
    Returns maximum of two numbers.

    # Inputs

    `x`

    : 1\. Function argument

    `y`

    : 2\. Function argument
  */
  max = x: y: if x > y then x else y;

  /**
    Integer modulus

    # Inputs

    `base`

    : 1\. Function argument

    `int`

    : 2\. Function argument

    # Examples
    :::{.example}
    ## `lib.trivial.mod` usage example

    ```nix
    mod 11 10
    => 1
    mod 1 10
    => 1
    ```

    :::
  */
  mod = base: int: base - (int * (builtins.div base int));

  ## Comparisons

  /**
    C-style comparisons

    a < b,  compare a b => -1
    a == b, compare a b => 0
    a > b,  compare a b => 1

    # Inputs

    `a`

    : 1\. Function argument

    `b`

    : 2\. Function argument
  */
  compare =
    a: b:
    if a < b then
      -1
    else if a > b then
      1
    else
      0;

  /**
    Split type into two subtypes by predicate `p`, take all elements
    of the first subtype to be less than all the elements of the
    second subtype, compare elements of a single subtype with `yes`
    and `no` respectively.

    # Inputs

    `p`

    : Predicate

    `yes`

    : Comparison function if predicate holds for both values

    `no`

    : Comparison function if predicate holds for neither value

    `a`

    : First value to compare

    `b`

    : Second value to compare

    # Type

    ```
    (a -> bool) -> (a -> a -> int) -> (a -> a -> int) -> (a -> a -> int)
    ```

    # Examples
    :::{.example}
    ## `lib.trivial.splitByAndCompare` usage example

    ```nix
    let cmp = splitByAndCompare (hasPrefix "foo") compare compare; in

    cmp "a" "z" => -1
    cmp "fooa" "fooz" => -1

    cmp "f" "a" => 1
    cmp "fooa" "a" => -1
    # while
    compare "fooa" "a" => 1
    ```

    :::
  */
  splitByAndCompare =
    p: yes: no: a: b:
    if p a then
      if p b then yes a b else -1
    else if p b then
      1
    else
      no a b;

  /**
    Reads a JSON file.

    # Examples
    :::{.example}
    ## `lib.trivial.importJSON` usage example

    example.json
    ```json
    {
      "title": "Example JSON",
      "hello": {
        "world": "foo",
        "bar": {
          "foobar": true
        }
      }
    }
    ```

    ```nix
    importJSON ./example.json
    => {
      title = "Example JSON";
      hello = {
        world = "foo";
        bar = {
          foobar = true;
        };
      };
    }
    ```

    :::

    # Inputs

    `path`

    : 1\. Function argument

    # Type

    ```
    importJSON :: path -> any
    ```
  */
  importJSON = path: builtins.fromJSON (builtins.readFile path);

  /**
    Reads a TOML file.

    # Examples
    :::{.example}
    ## `lib.trivial.importTOML` usage example

    example.toml
    ```toml
    title = "TOML Example"

    [hello]
    world = "foo"

    [hello.bar]
    foobar = true
    ```

    ```nix
    importTOML ./example.toml
    => {
      title = "TOML Example";
      hello = {
        world = "foo";
        bar = {
          foobar = true;
        };
      };
    }
    ```

    :::

    # Inputs

    `path`

    : 1\. Function argument

    # Type

    ```
    importTOML :: path -> any
    ```
  */
  importTOML = path: fromTOML (builtins.readFile path);

  /**
    `warn` *`message`* *`value`*

    Print a warning before returning the second argument.

    See [`builtins.warn`](https://nix.dev/manual/nix/latest/language/builtins.html#builtins-warn) (Nix >= 2.23).
    On older versions, the Nix 2.23 behavior is emulated with [`builtins.trace`](https://nix.dev/manual/nix/latest/language/builtins.html#builtins-warn), including the [`NIX_ABORT_ON_WARN`](https://nix.dev/manual/nix/latest/command-ref/conf-file#conf-abort-on-warn) behavior, but not the `nix.conf` setting or command line option.

    # Inputs

    *`message`* (String)

    : Warning message to print before evaluating *`value`*.

    *`value`* (any value)

    : Value to return as-is.

    # Type

    ```
    String -> a -> a
    ```
  */
  warn =
    # Since Nix 2.23, https://github.com/NixOS/nix/pull/10592
    builtins.warn or (
      let
        mustAbort = lib.elem (builtins.getEnv "NIX_ABORT_ON_WARN") [
          "1"
          "true"
          "yes"
        ];
      in
      # Do not eta reduce v, so that we have the same strictness as `builtins.warn`.
      msg: v:
      # `builtins.warn` requires a string message, so we enforce that in our implementation, so that callers aren't accidentally incompatible with newer Nix versions.
      assert isString msg;
      if mustAbort then
        builtins.trace "[1;31mevaluation warning:[0m ${msg}" (
          abort "NIX_ABORT_ON_WARN=true; warnings are treated as unrecoverable errors."
        )
      else
        builtins.trace "[1;35mevaluation warning:[0m ${msg}" v
    );

  /**
    `warnIf` *`condition`* *`message`* *`value`*

    Like `warn`, but only warn when the first argument is `true`.

    # Inputs

    *`condition`* (Boolean)

    : `true` to trigger the warning before continuing with *`value`*.

    *`message`* (String)

    : Warning message to print before evaluating

    *`value`* (any value)

    : Value to return as-is.

    # Type

    ```
    Bool -> String -> a -> a
    ```
  */
  warnIf = cond: msg: if cond then warn msg else x: x;

  /**
    `warnIfNot` *`condition`* *`message`* *`value`*

    Like `warnIf`, but negated: warn if the first argument is `false`.

    # Inputs

    *`condition`*

    : `false` to trigger the warning before continuing with `val`.

    *`message`*

    : Warning message to print before evaluating *`value`*.

    *`value`*

    : Value to return as-is.

    # Type

    ```
    Boolean -> String -> a -> a
    ```
  */
  warnIfNot = cond: msg: if cond then x: x else warn msg;

  /**
    Like the `assert b; e` expression, but with a custom error message and
    without the semicolon.

    If true, return the identity function, `r: r`.

    If false, throw the error message.

    Calls can be juxtaposed using function application, as `(r: r) a = a`, so
    `(r: r) (r: r) a = a`, and so forth.

    # Inputs

    `cond`

    : 1\. Function argument

    `msg`

    : 2\. Function argument

    # Type

    ```
    bool -> string -> a -> a
    ```

    # Examples
    :::{.example}
    ## `lib.trivial.throwIfNot` usage example

    ```nix
    throwIfNot (lib.isList overlays) "The overlays argument to nixpkgs must be a list."
    lib.foldr (x: throwIfNot (lib.isFunction x) "All overlays passed to nixpkgs must be functions.") (r: r) overlays
    pkgs
    ```

    :::
  */
  throwIfNot = cond: msg: if cond then x: x else throw msg;

  /**
    Like `throwIfNot`, but negated (throw if the first argument is `true`).

    # Inputs

    `cond`

    : 1\. Function argument

    `msg`

    : 2\. Function argument

    # Type

    ```
    bool -> string -> a -> a
    ```
  */
  throwIf = cond: msg: if cond then throw msg else x: x;

  /**
    Check if the elements in a list are valid values from a enum, returning the identity function, or throwing an error message otherwise.

    # Inputs

    `msg`

    : 1\. Function argument

    `valid`

    : 2\. Function argument

    `given`

    : 3\. Function argument

    # Type

    ```
    String -> List ComparableVal -> List ComparableVal -> a -> a
    ```

    # Examples
    :::{.example}
    ## `lib.trivial.checkListOfEnum` usage example

    ```nix
    let colorVariants = ["bright" "dark" "black"]
    in checkListOfEnum "color variants" [ "standard" "light" "dark" ] colorVariants;
    =>
    error: color variants: bright, black unexpected; valid ones: standard, light, dark
    ```

    :::
  */
  checkListOfEnum =
    msg: valid: given:
    let
      unexpected = lib.subtractLists valid given;
    in
    lib.throwIfNot (unexpected == [ ])
      "${msg}: ${builtins.concatStringsSep ", " (map toString unexpected)} unexpected; valid ones: ${builtins.concatStringsSep ", " (map toString valid)}";

  info = msg: builtins.trace "INFO: ${msg}";

  showWarnings = warnings: res: lib.foldr (w: x: warn w x) res warnings;

  ## Function annotations

  /**
    Add metadata about expected function arguments to a function.
    The metadata should match the format given by
    builtins.functionArgs, i.e. a set from expected argument to a bool
    representing whether that argument has a default or not.
    setFunctionArgs : (a → b) → Map String Bool → (a → b)

    This function is necessary because you can't dynamically create a
    function of the `{ a, b ? foo, ... }:` format, but some facilities
    like `callPackage` expect to be able to query expected arguments.

    # Inputs

    `f`

    : 1\. Function argument

    `args`

    : 2\. Function argument
  */
  setFunctionArgs = f: args: {
    # TODO: Should we add call-time "type" checking like built in?
    __functor = self: f;
    __functionArgs = args;
  };

  /**
    Extract the expected function arguments from a function.
    This works both with nix-native `{ a, b ? foo, ... }:` style
    functions and functions with args set with `setFunctionArgs`. It
    has the same return type and semantics as `builtins.functionArgs`.
    setFunctionArgs : (a → b) → Map String Bool.

    # Inputs

    `f`

    : 1\. Function argument
  */
  functionArgs =
    f:
    if f ? __functor then
      f.__functionArgs or (functionArgs (f.__functor f))
    else
      builtins.functionArgs f;

  /**
    Check whether something is a function or something
    annotated with function args.

    # Inputs

    `f`

    : 1\. Function argument
  */
  isFunction = f: builtins.isFunction f || (f ? __functor && isFunction (f.__functor f));

  /**
    `mirrorFunctionArgs f g` creates a new function `g'` with the same behavior as `g` (`g' x == g x`)
    but its function arguments mirroring `f` (`lib.functionArgs g' == lib.functionArgs f`).

    # Inputs

    `f`

    : Function to provide the argument metadata

    `g`

    : Function to set the argument metadata to

    # Type

    ```
    mirrorFunctionArgs :: (a -> b) -> (a -> c) -> (a -> c)
    ```

    # Examples
    :::{.example}
    ## `lib.trivial.mirrorFunctionArgs` usage example

    ```nix
    addab = {a, b}: a + b
    addab { a = 2; b = 4; }
    => 6
    lib.functionArgs addab
    => { a = false; b = false; }
    addab1 = attrs: addab attrs + 1
    addab1 { a = 2; b = 4; }
    => 7
    lib.functionArgs addab1
    => { }
    addab1' = lib.mirrorFunctionArgs addab addab1
    addab1' { a = 2; b = 4; }
    => 7
    lib.functionArgs addab1'
    => { a = false; b = false; }
    ```

    :::
  */
  mirrorFunctionArgs =
    f:
    let
      fArgs = functionArgs f;
    in
    g: setFunctionArgs g fArgs;

  /**
    Turns any non-callable values into constant functions.
    Returns callable values as is.

    # Inputs

    `v`

    : Any value

    # Examples
    :::{.example}
    ## `lib.trivial.toFunction` usage example

    ```nix
    nix-repl> lib.toFunction 1 2
    1

    nix-repl> lib.toFunction (x: x + 1) 2
    3
    ```

    :::
  */
  toFunction = v: if isFunction v then v else k: v;

  /**
    Convert a hexadecimal string to it's integer representation.

    # Type

    ```
    fromHexString :: String -> [ String ]
    ```

    # Examples

    ```nix
    fromHexString "FF"
    => 255

    fromHexString "0x7fffffffffffffff"
    => 9223372036854775807
    ```
  */
  fromHexString =
    str:
    let
      match = builtins.match "(0x)?([0-7]?[0-9A-Fa-f]{1,15})" str;
    in
    if match != null then
      (fromTOML "v=0x${builtins.elemAt match 1}").v
    else
      # TODO: Turn this into a `throw` in 26.05.
      assert lib.warn "fromHexString: ${
        lib.generators.toPretty { } str
      } is not a valid input and will be rejected in 26.05" true;
      let
        noPrefix = lib.strings.removePrefix "0x" (lib.strings.toLower str);
      in
      (fromTOML "v=0x${noPrefix}").v;

  /**
    Convert the given positive integer to a string of its hexadecimal
    representation. For example:

    toHexString 0 => "0"

    toHexString 16 => "10"

    toHexString 250 => "FA"
  */
  toHexString =
    let
      hexDigits = {
        "10" = "A";
        "11" = "B";
        "12" = "C";
        "13" = "D";
        "14" = "E";
        "15" = "F";
      };
      toHexDigit = d: if d < 10 then toString d else hexDigits.${toString d};
    in
    i: lib.concatMapStrings toHexDigit (toBaseDigits 16 i);

  /**
    `toBaseDigits base i` converts the positive integer `i` to a list of its
    digits in the given base.

    toBaseDigits 10 123 => [ 1 2 3 ]

    toBaseDigits 2 6 => [ 1 1 0 ]

    toBaseDigits 16 250 => [ 15 10 ]

    # Inputs

    `base`

    : 1\. Function argument

    `i`

    : 2\. Function argument
  */
  toBaseDigits =
    base: i:
    let
      go =
        i:
        if i < base then
          [ i ]
        else
          let
            r = i - ((i / base) * base);
            q = (i - r) / base;
          in
          [ r ] ++ go q;
    in
    assert (isInt base);
    assert (isInt i);
    assert (base >= 2);
    assert (i >= 0);
    lib.reverseList (go i);
}
