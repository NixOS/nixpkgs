/**
  String manipulation functions.
*/
{ lib }:
let

  inherit (builtins) length;

  inherit (lib.trivial) warnIf;

  asciiTable = import ./ascii-table.nix;

in

rec {

  inherit (builtins)
    compareVersions
    elem
    elemAt
    filter
    fromJSON
    genList
    head
    isInt
    isList
    isAttrs
    isPath
    isString
    match
    parseDrvName
    readFile
    replaceStrings
    split
    storeDir
    stringLength
    substring
    tail
    toJSON
    typeOf
    unsafeDiscardStringContext
    ;

  /**
    Concatenates a list of strings with a separator between each element.

    # Inputs

    `sep`
    : Separator to add between elements

    `list`
    : List of strings that will be joined

    # Type

    ```
    join :: string -> [ string ] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.join` usage example

    ```nix
    join ", " ["foo" "bar"]
    => "foo, bar"
    ```

    :::
  */
  join = builtins.concatStringsSep;

  /**
    Concatenate a list of strings.

    # Type

    ```
    concatStrings :: [string] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.concatStrings` usage example

    ```nix
    concatStrings ["foo" "bar"]
    => "foobar"
    ```

    :::
  */
  concatStrings = builtins.concatStringsSep "";

  /**
    Map a function over a list and concatenate the resulting strings.

    # Inputs

    `f`
    : 1\. Function argument

    `list`
    : 2\. Function argument

    # Type

    ```
    concatMapStrings :: (a -> string) -> [a] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.concatMapStrings` usage example

    ```nix
    concatMapStrings (x: "a" + x) ["foo" "bar"]
    => "afooabar"
    ```

    :::
  */
  concatMapStrings = f: list: concatStrings (map f list);

  /**
    Like `concatMapStrings` except that the function `f` also gets the
    position as a parameter.

    # Inputs

    `f`
    : 1\. Function argument

    `list`
    : 2\. Function argument

    # Type

    ```
    concatImapStrings :: (int -> a -> string) -> [a] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.concatImapStrings` usage example

    ```nix
    concatImapStrings (pos: x: "${toString pos}-${x}") ["foo" "bar"]
    => "1-foo2-bar"
    ```

    :::
  */
  concatImapStrings = f: list: concatStrings (lib.imap1 f list);

  /**
    Place an element between each element of a list

    # Inputs

    `separator`
    : Separator to add between elements

    `list`
    : Input list

    # Type

    ```
    intersperse :: a -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.strings.intersperse` usage example

    ```nix
    intersperse "/" ["usr" "local" "bin"]
    => ["usr" "/" "local" "/" "bin"].
    ```

    :::
  */
  intersperse =
    separator: list:
    if list == [ ] || length list == 1 then
      list
    else
      tail (
        lib.concatMap (x: [
          separator
          x
        ]) list
      );

  /**
    Concatenate a list of strings with a separator between each element

    # Inputs

    `sep`
    : Separator to add between elements

    `list`
    : List of input strings

    # Type

    ```
    concatStringsSep :: string -> [string] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.concatStringsSep` usage example

    ```nix
    concatStringsSep "/" ["usr" "local" "bin"]
    => "usr/local/bin"
    ```

    :::
  */
  concatStringsSep = builtins.concatStringsSep;

  /**
    Maps a function over a list of strings and then concatenates the
    result with the specified separator interspersed between
    elements.

    # Inputs

    `sep`
    : Separator to add between elements

    `f`
    : Function to map over the list

    `list`
    : List of input strings

    # Type

    ```
    concatMapStringsSep :: string -> (a -> string) -> [a] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.concatMapStringsSep` usage example

    ```nix
    concatMapStringsSep "-" (x: toUpper x)  ["foo" "bar" "baz"]
    => "FOO-BAR-BAZ"
    ```

    :::
  */
  concatMapStringsSep =
    sep: f: list:
    concatStringsSep sep (map f list);

  /**
    Same as `concatMapStringsSep`, but the mapping function
    additionally receives the position of its argument.

    # Inputs

    `sep`
    : Separator to add between elements

    `f`
    : Function that receives elements and their positions

    `list`
    : List of input strings

    # Type

    ```
    concatIMapStringsSep :: string -> (int -> a -> string) -> [a] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.concatImapStringsSep` usage example

    ```nix
    concatImapStringsSep "-" (pos: x: toString (x / pos)) [ 6 6 6 ]
    => "6-3-2"
    ```

    :::
  */
  concatImapStringsSep =
    sep: f: list:
    concatStringsSep sep (lib.imap1 f list);

  /**
    Like [`concatMapStringsSep`](#function-library-lib.strings.concatMapStringsSep)
    but takes an attribute set instead of a list.

    # Inputs

    `sep`
    : Separator to add between item strings

    `f`
    : Function that takes each key and value and return a string

    `attrs`
    : Attribute set to map from

    # Type

    ```
    concatMapAttrsStringSep :: String -> (String -> Any -> String) -> AttrSet -> String
    ```

    # Examples

    :::{.example}
    ## `lib.strings.concatMapAttrsStringSep` usage example

    ```nix
    concatMapAttrsStringSep "\n" (name: value: "${name}: foo-${value}") { a = "0.1.0"; b = "0.2.0"; }
    => "a: foo-0.1.0\nb: foo-0.2.0"
    ```

    :::
  */
  concatMapAttrsStringSep =
    sep: f: attrs:
    concatStringsSep sep (lib.attrValues (lib.mapAttrs f attrs));

  /**
    Concatenate a list of strings, adding a newline at the end of each one.
    Defined as `concatMapStrings (s: s + "\n")`.

    # Inputs

    `list`
    : List of strings. Any element that is not a string will be implicitly converted to a string.

    # Type

    ```
    concatLines :: [string] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.concatLines` usage example

    ```nix
    concatLines [ "foo" "bar" ]
    => "foo\nbar\n"
    ```

    :::
  */
  concatLines = concatMapStrings (s: s + "\n");

  /**
    Given string `s`, replace every occurrence of the string `from` with the string `to`.

    # Inputs

    `from`
    : The string to be replaced

    `to`
    : The string to replace with

    `s`
    : The original string where replacements will be made

    # Type

    ```
    replaceString :: string -> string -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.replaceString` usage example

    ```nix
    replaceString "world" "Nix" "Hello, world!"
    => "Hello, Nix!"
    replaceString "." "_" "v1.2.3"
    => "v1_2_3"
    ```

    :::
  */
  replaceString = from: to: replaceStrings [ from ] [ to ];

  /**
    Repeat a string `n` times,
    and concatenate the parts into a new string.

    # Inputs

    `n`
    : 1\. Function argument

    `s`
    : 2\. Function argument

    # Type

    ```
    replicate :: int -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.replicate` usage example

    ```nix
    replicate 3 "v"
    => "vvv"
    replicate 5 "hello"
    => "hellohellohellohellohello"
    ```

    :::
  */
  replicate = n: s: concatStrings (lib.lists.replicate n s);

  /**
    Remove leading and trailing whitespace from a string `s`.

    Whitespace is defined as any of the following characters:
      " ", "\t" "\r" "\n"

    # Inputs

    `s`
    : The string to trim

    # Type

    ```
    trim :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.trim` usage example

    ```nix
    trim "   hello, world!   "
    => "hello, world!"
    ```

    :::
  */
  trim = trimWith {
    start = true;
    end = true;
  };

  /**
    Remove leading and/or trailing whitespace from a string `s`.

    To remove both leading and trailing whitespace, you can also use [`trim`](#function-library-lib.strings.trim)

    Whitespace is defined as any of the following characters:
      " ", "\t" "\r" "\n"

    # Inputs

    `config` (Attribute set)
    : `start`
      : Whether to trim leading whitespace (`false` by default)

    : `end`
      : Whether to trim trailing whitespace (`false` by default)

    `s`
    : The string to trim

    # Type

    ```
    trimWith :: { start :: Bool; end :: Bool } -> String -> String
    ```

    # Examples
    :::{.example}
    ## `lib.strings.trimWith` usage example

    ```nix
    trimWith { start = true; } "   hello, world!   "}
    => "hello, world!   "

    trimWith { end = true; } "   hello, world!   "}
    => "   hello, world!"
    ```
    :::
  */
  trimWith =
    {
      start ? false,
      end ? false,
    }:
    let
      # Define our own whitespace character class instead of using
      # `[:space:]`, which is not well-defined.
      chars = " \t\r\n";

      # To match up until trailing whitespace, we need to capture a
      # group that ends with a non-whitespace character.
      regex =
        if start && end then
          "[${chars}]*(.*[^${chars}])[${chars}]*"
        else if start then
          "[${chars}]*(.*)"
        else if end then
          "(.*[^${chars}])[${chars}]*"
        else
          "(.*)";
    in
    s:
    let
      # If the string was empty or entirely whitespace,
      # then the regex may not match and `res` will be `null`.
      res = match regex s;
    in
    optionalString (res != null) (head res);

  /**
    Construct a Unix-style, colon-separated search path consisting of
    the given `subDir` appended to each of the given paths.

    # Inputs

    `subDir`
    : Directory name to append

    `paths`
    : List of base paths

    # Type

    ```
    makeSearchPath :: string -> [string] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.makeSearchPath` usage example

    ```nix
    makeSearchPath "bin" ["/root" "/usr" "/usr/local"]
    => "/root/bin:/usr/bin:/usr/local/bin"
    makeSearchPath "bin" [""]
    => "/bin"
    ```

    :::
  */
  makeSearchPath =
    subDir: paths: concatStringsSep ":" (map (path: path + "/" + subDir) (filter (x: x != null) paths));

  /**
    Construct a Unix-style search path by appending the given
    `subDir` to the specified `output` of each of the packages.

    If no output by the given name is found, fallback to `.out` and then to
    the default.

    # Inputs

    `output`
    : Package output to use

    `subDir`
    : Directory name to append

    `pkgs`
    : List of packages

    # Type

    ```
    makeSearchPathOutput :: string -> string -> [package] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.makeSearchPathOutput` usage example

    ```nix
    makeSearchPathOutput "dev" "bin" [ pkgs.openssl pkgs.zlib ]
    => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev/bin:/nix/store/wwh7mhwh269sfjkm6k5665b5kgp7jrk2-zlib-1.2.8/bin"
    ```

    :::
  */
  makeSearchPathOutput =
    output: subDir: pkgs:
    makeSearchPath subDir (map (lib.getOutput output) pkgs);

  /**
    Construct a library search path (such as RPATH) containing the
    libraries for a set of packages

    # Inputs

    `packages`
    : List of packages

    # Type

    ```
    makeLibraryPath :: [package] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.makeLibraryPath` usage example

    ```nix
    makeLibraryPath [ "/usr" "/usr/local" ]
    => "/usr/lib:/usr/local/lib"
    pkgs = import <nixpkgs> { }
    makeLibraryPath [ pkgs.openssl pkgs.zlib ]
    => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r/lib:/nix/store/wwh7mhwh269sfjkm6k5665b5kgp7jrk2-zlib-1.2.8/lib"
    ```

    :::
  */
  makeLibraryPath = makeSearchPathOutput "lib" "lib";

  /**
    Construct an include search path (such as C_INCLUDE_PATH) containing the
    header files for a set of packages or paths.

    # Inputs

    `packages`
    : List of packages

    # Type

    ```
    makeIncludePath :: [package] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.makeIncludePath` usage example

    ```nix
    makeIncludePath [ "/usr" "/usr/local" ]
    => "/usr/include:/usr/local/include"
    pkgs = import <nixpkgs> { }
    makeIncludePath [ pkgs.openssl pkgs.zlib ]
    => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev/include:/nix/store/wwh7mhwh269sfjkm6k5665b5kgp7jrk2-zlib-1.2.8-dev/include"
    ```

    :::
  */
  makeIncludePath = makeSearchPathOutput "dev" "include";

  /**
    Construct a binary search path (such as $PATH) containing the
    binaries for a set of packages.

    # Inputs

    `packages`
    : List of packages

    # Type

    ```
    makeBinPath :: [package] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.makeBinPath` usage example

    ```nix
    makeBinPath ["/root" "/usr" "/usr/local"]
    => "/root/bin:/usr/bin:/usr/local/bin"
    ```

    :::
  */
  makeBinPath = makeSearchPathOutput "bin" "bin";

  /**
    Normalize path, removing extraneous /s

    # Inputs

    `s`
    : 1\. Function argument

    # Type

    ```
    normalizePath :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.normalizePath` usage example

    ```nix
    normalizePath "/a//b///c/"
    => "/a/b/c/"
    ```

    :::
  */
  normalizePath =
    s:
    warnIf (isPath s)
      ''
        lib.strings.normalizePath: The argument (${toString s}) is a path value, but only strings are supported.
            Path values are always normalised in Nix, so there's no need to call this function on them.
            This function also copies the path to the Nix store and returns the store path, the same as "''${path}" will, which may not be what you want.
            This behavior is deprecated and will throw an error in the future.''
      (
        builtins.foldl' (x: y: if y == "/" && hasSuffix "/" x then x else x + y) "" (stringToCharacters s)
      );

  /**
    Depending on the boolean `cond`, return either the given string
    or the empty string. Useful to concatenate against a bigger string.

    # Inputs

    `cond`
    : Condition

    `string`
    : String to return if condition is true

    # Type

    ```
    optionalString :: bool -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.optionalString` usage example

    ```nix
    optionalString true "some-string"
    => "some-string"
    optionalString false "some-string"
    => ""
    ```

    :::
  */
  optionalString = cond: string: if cond then string else "";

  /**
    Determine whether a string has given prefix.

    # Inputs

    `pref`
    : Prefix to check for

    `str`
    : Input string

    # Type

    ```
    hasPrefix :: string -> string -> bool
    ```

    # Examples
    :::{.example}
    ## `lib.strings.hasPrefix` usage example

    ```nix
    hasPrefix "foo" "foobar"
    => true
    hasPrefix "foo" "barfoo"
    => false
    ```

    :::
  */
  hasPrefix =
    pref: str:
    # Before 23.05, paths would be copied to the store before converting them
    # to strings and comparing. This was surprising and confusing.
    warnIf (isPath pref)
      ''
        lib.strings.hasPrefix: The first argument (${toString pref}) is a path value, but only strings are supported.
            There is almost certainly a bug in the calling code, since this function always returns `false` in such a case.
            This function also copies the path to the Nix store, which may not be what you want.
            This behavior is deprecated and will throw an error in the future.
            You might want to use `lib.path.hasPrefix` instead, which correctly supports paths.''
      (substring 0 (stringLength pref) str == pref);

  /**
    Determine whether a string has given suffix.

    # Inputs

    `suffix`
    : Suffix to check for

    `content`
    : Input string

    # Type

    ```
    hasSuffix :: string -> string -> bool
    ```

    # Examples
    :::{.example}
    ## `lib.strings.hasSuffix` usage example

    ```nix
    hasSuffix "foo" "foobar"
    => false
    hasSuffix "foo" "barfoo"
    => true
    ```

    :::
  */
  hasSuffix =
    suffix: content:
    let
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
    # Before 23.05, paths would be copied to the store before converting them
    # to strings and comparing. This was surprising and confusing.
    warnIf (isPath suffix)
      ''
        lib.strings.hasSuffix: The first argument (${toString suffix}) is a path value, but only strings are supported.
            There is almost certainly a bug in the calling code, since this function always returns `false` in such a case.
            This function also copies the path to the Nix store, which may not be what you want.
            This behavior is deprecated and will throw an error in the future.''
      (lenContent >= lenSuffix && substring (lenContent - lenSuffix) lenContent content == suffix);

  /**
    Determine whether a string contains the given infix

    # Inputs

    `infix`
    : 1\. Function argument

    `content`
    : 2\. Function argument

    # Type

    ```
    hasInfix :: string -> string -> bool
    ```

    # Examples
    :::{.example}
    ## `lib.strings.hasInfix` usage example

    ```nix
    hasInfix "bc" "abcd"
    => true
    hasInfix "ab" "abcd"
    => true
    hasInfix "cd" "abcd"
    => true
    hasInfix "foo" "abcd"
    => false
    ```

    :::
  */
  hasInfix =
    infix: content:
    # Before 23.05, paths would be copied to the store before converting them
    # to strings and comparing. This was surprising and confusing.
    warnIf (isPath infix)
      ''
        lib.strings.hasInfix: The first argument (${toString infix}) is a path value, but only strings are supported.
            There is almost certainly a bug in the calling code, since this function always returns `false` in such a case.
            This function also copies the path to the Nix store, which may not be what you want.
            This behavior is deprecated and will throw an error in the future.''
      (builtins.match ".*${escapeRegex infix}.*" "${content}" != null);

  /**
    Convert a string `s` to a list of characters (i.e. singleton strings).
    This allows you to, e.g., map a function over each character.  However,
    note that this will likely be horribly inefficient; Nix is not a
    general purpose programming language. Complex string manipulations
    should, if appropriate, be done in a derivation.
    Also note that Nix treats strings as a list of bytes and thus doesn't
    handle unicode.

    # Inputs

    `s`
    : 1\. Function argument

    # Type

    ```
    stringToCharacters :: string -> [string]
    ```

    # Examples
    :::{.example}
    ## `lib.strings.stringToCharacters` usage example

    ```nix
    stringToCharacters ""
    => [ ]
    stringToCharacters "abc"
    => [ "a" "b" "c" ]
    stringToCharacters "🦄"
    => [ "�" "�" "�" "�" ]
    ```

    :::
  */
  stringToCharacters = s: genList (p: substring p 1 s) (stringLength s);

  /**
    Manipulate a string character by character and replace them by
    strings before concatenating the results.

    # Inputs

    `f`
    : Function to map over each individual character

    `s`
    : Input string

    # Type

    ```
    stringAsChars :: (string -> string) -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.stringAsChars` usage example

    ```nix
    stringAsChars (x: if x == "a" then "i" else x) "nax"
    => "nix"
    ```

    :::
  */
  stringAsChars =
    # Function to map over each individual character
    f:
    # Input string
    s:
    concatStrings (map f (stringToCharacters s));

  /**
    Convert char to ascii value, must be in printable range

    # Inputs

    `c`
    : 1\. Function argument

    # Type

    ```
    charToInt :: string -> int
    ```

    # Examples
    :::{.example}
    ## `lib.strings.charToInt` usage example

    ```nix
    charToInt "A"
    => 65
    charToInt "("
    => 40
    ```

    :::
  */
  charToInt = c: builtins.getAttr c asciiTable;

  /**
    Escape occurrence of the elements of `list` in `string` by
    prefixing it with a backslash.

    # Inputs

    `list`
    : 1\. Function argument

    `string`
    : 2\. Function argument

    # Type

    ```
    escape :: [string] -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.escape` usage example

    ```nix
    escape ["(" ")"] "(foo)"
    => "\\(foo\\)"
    ```

    :::
  */
  escape = list: replaceStrings list (map (c: "\\${c}") list);

  /**
    Escape occurrence of the element of `list` in `string` by
    converting to its ASCII value and prefixing it with \\x.
    Only works for printable ascii characters.

    # Inputs

    `list`
    : 1\. Function argument

    `string`
    : 2\. Function argument

    # Type

    ```
    escapeC = [string] -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.escapeC` usage example

    ```nix
    escapeC [" "] "foo bar"
    => "foo\\x20bar"
    ```

    :::
  */
  escapeC =
    list:
    replaceStrings list (
      map (c: "\\x${fixedWidthString 2 "0" (toLower (lib.toHexString (charToInt c)))}") list
    );

  /**
    Escape the `string` so it can be safely placed inside a URL
    query.

    # Inputs

    `string`
    : 1\. Function argument

    # Type

    ```
    escapeURL :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.escapeURL` usage example

    ```nix
    escapeURL "foo/bar baz"
    => "foo%2Fbar%20baz"
    ```

    :::
  */
  escapeURL =
    let
      unreserved = [
        "A"
        "B"
        "C"
        "D"
        "E"
        "F"
        "G"
        "H"
        "I"
        "J"
        "K"
        "L"
        "M"
        "N"
        "O"
        "P"
        "Q"
        "R"
        "S"
        "T"
        "U"
        "V"
        "W"
        "X"
        "Y"
        "Z"
        "a"
        "b"
        "c"
        "d"
        "e"
        "f"
        "g"
        "h"
        "i"
        "j"
        "k"
        "l"
        "m"
        "n"
        "o"
        "p"
        "q"
        "r"
        "s"
        "t"
        "u"
        "v"
        "w"
        "x"
        "y"
        "z"
        "0"
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "-"
        "_"
        "."
        "~"
      ];
      toEscape = removeAttrs asciiTable unreserved;
    in
    replaceStrings (builtins.attrNames toEscape) (
      lib.mapAttrsToList (_: c: "%${fixedWidthString 2 "0" (lib.toHexString c)}") toEscape
    );

  /**
    Quote `string` to be used safely within the Bourne shell if it has any
    special characters.

    # Inputs

    `string`
    : 1\. Function argument

    # Type

    ```
    escapeShellArg :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.escapeShellArg` usage example

    ```nix
    escapeShellArg "esc'ape\nme"
    => "'esc'\\''ape\nme'"
    ```

    :::
  */
  escapeShellArg =
    arg:
    let
      string = toString arg;
    in
    if match "[[:alnum:],._+:@%/-]+" string == null then
      "'${replaceString "'" "'\\''" string}'"
    else
      string;

  /**
    Quote all arguments that have special characters to be safely passed to the
    Bourne shell.

    # Inputs

    `args`
    : 1\. Function argument

    # Type

    ```
    escapeShellArgs :: [string] -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.escapeShellArgs` usage example

    ```nix
    escapeShellArgs ["one" "two three" "four'five"]
    => "one 'two three' 'four'\\''five'"
    ```

    :::
  */
  escapeShellArgs = concatMapStringsSep " " escapeShellArg;

  /**
    Test whether the given `name` is a valid POSIX shell variable name.

    # Inputs

    `name`
    : 1\. Function argument

    # Type

    ```
    string -> bool
    ```

    # Examples
    :::{.example}
    ## `lib.strings.isValidPosixName` usage example

    ```nix
    isValidPosixName "foo_bar000"
    => true
    isValidPosixName "0-bad.jpg"
    => false
    ```

    :::
  */
  isValidPosixName = name: match "[a-zA-Z_][a-zA-Z0-9_]*" name != null;

  /**
    Translate a Nix value into a shell variable declaration, with proper escaping.

    The value can be a string (mapped to a regular variable), a list of strings
    (mapped to a Bash-style array) or an attribute set of strings (mapped to a
    Bash-style associative array). Note that "string" includes string-coercible
    values like paths or derivations.

    Strings are translated into POSIX sh-compatible code; lists and attribute sets
    assume a shell that understands Bash syntax (e.g. Bash or ZSH).

    # Inputs

    `name`
    : 1\. Function argument

    `value`
    : 2\. Function argument

    # Type

    ```
    string -> ( string | [string] | { ${name} :: string; } ) -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.toShellVar` usage example

    ```nix
    ''
      ${toShellVar "foo" "some string"}
      [[ "$foo" == "some string" ]]
    ''
    ```

    :::
  */
  toShellVar =
    name: value:
    lib.throwIfNot (isValidPosixName name) "toShellVar: ${name} is not a valid shell variable name" (
      if isAttrs value && !isStringLike value then
        "declare -A ${name}=(${
          concatStringsSep " " (lib.mapAttrsToList (n: v: "[${escapeShellArg n}]=${escapeShellArg v}") value)
        })"
      else if isList value then
        "declare -a ${name}=(${escapeShellArgs value})"
      else
        "${name}=${escapeShellArg value}"
    );

  /**
    Translate an attribute set `vars` into corresponding shell variable declarations
    using `toShellVar`.

    # Inputs

    `vars`
    : 1\. Function argument

    # Type

    ```
    toShellVars :: {
      ${name} :: string | [ string ] | { ${key} :: string; };
    } -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.toShellVars` usage example

    ```nix
    let
      foo = "value";
      bar = foo;
    in ''
      ${toShellVars { inherit foo bar; }}
      [[ "$foo" == "$bar" ]]
    ''
    ```

    :::
  */
  toShellVars = vars: concatStringsSep "\n" (lib.mapAttrsToList toShellVar vars);

  /**
    Turn a string `s` into a Nix expression representing that string

    # Inputs

    `s`
    : 1\. Function argument

    # Type

    ```
    escapeNixString :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.escapeNixString` usage example

    ```nix
    escapeNixString "hello\${}\n"
    => "\"hello\\\${}\\n\""
    ```

    :::
  */
  escapeNixString = s: escape [ "$" ] (toJSON s);

  /**
    Turn a string `s` into an exact regular expression

    # Inputs

    `s`
    : 1\. Function argument

    # Type

    ```
    escapeRegex :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.escapeRegex` usage example

    ```nix
    escapeRegex "[^a-z]*"
    => "\\[\\^a-z]\\*"
    ```

    :::
  */
  escapeRegex = escape (stringToCharacters "\\[{()^$?*+|.");

  /**
    Quotes a string `s` if it can't be used as an identifier directly.

    # Inputs

    `s`
    : 1\. Function argument

    # Type

    ```
    escapeNixIdentifier :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.escapeNixIdentifier` usage example

    ```nix
    escapeNixIdentifier "hello"
    => "hello"
    escapeNixIdentifier "0abc"
    => "\"0abc\""
    ```

    :::
  */
  escapeNixIdentifier =
    s:
    # Regex from https://github.com/NixOS/nix/blob/d048577909e383439c2549e849c5c2f2016c997e/src/libexpr/lexer.l#L91
    if match "[a-zA-Z_][a-zA-Z0-9_'-]*" s != null then s else escapeNixString s;

  /**
    Escapes a string `s` such that it is safe to include verbatim in an XML
    document.

    # Inputs

    `s`
    : 1\. Function argument

    # Type

    ```
    escapeXML :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.escapeXML` usage example

    ```nix
    escapeXML ''"test" 'test' < & >''
    => "&quot;test&quot; &apos;test&apos; &lt; &amp; &gt;"
    ```

    :::
  */
  escapeXML =
    builtins.replaceStrings
      [ "\"" "'" "<" ">" "&" ]
      [ "&quot;" "&apos;" "&lt;" "&gt;" "&amp;" ];

  # Case conversion utilities.
  lowerChars = stringToCharacters "abcdefghijklmnopqrstuvwxyz";
  upperChars = stringToCharacters "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  /**
    Converts an ASCII string `s` to lower-case.

    # Inputs

    `s`
    : The string to convert to lower-case.

    # Type

    ```
    toLower :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.toLower` usage example

    ```nix
    toLower "HOME"
    => "home"
    ```

    :::
  */
  toLower = replaceStrings upperChars lowerChars;

  /**
    Converts an ASCII string `s` to upper-case.

    # Inputs

    `s`
    : The string to convert to upper-case.

    # Type

    ```
    toUpper :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.toUpper` usage example

    ```nix
    toUpper "home"
    => "HOME"
    ```

    :::
  */
  toUpper = replaceStrings lowerChars upperChars;

  /**
    Converts the first character of a string `s` to upper-case.

    # Inputs

    `str`
    : The string to convert to sentence case.

    # Type

    ```
    toSentenceCase :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.toSentenceCase` usage example

    ```nix
    toSentenceCase "home"
    => "Home"
    ```

    :::
  */
  toSentenceCase =
    str:
    lib.throwIfNot (isString str)
      "toSentenceCase does only accepts string values, but got ${typeOf str}"
      (
        let
          firstChar = substring 0 1 str;
          rest = substring 1 (stringLength str) str;
        in
        addContextFrom str (toUpper firstChar + toLower rest)
      );

  /**
    Converts a string to camelCase. Handles snake_case, PascalCase,
    kebab-case strings as well as strings delimited by spaces.

    # Inputs

    `string`
    : The string to convert to camelCase

    # Type

    ```
    toCamelCase :: string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.toCamelCase` usage example

    ```nix
    toCamelCase "hello-world"
    => "helloWorld"
    toCamelCase "hello_world"
    => "helloWorld"
    toCamelCase "hello world"
    => "helloWorld"
    toCamelCase "HelloWorld"
    => "helloWorld"
    ```

    :::
  */
  toCamelCase =
    str:
    lib.throwIfNot (isString str) "toCamelCase does only accepts string values, but got ${typeOf str}" (
      let
        separators = splitStringBy (
          prev: curr:
          elem curr [
            "-"
            "_"
            " "
          ]
        ) false str;

        parts = lib.flatten (
          map (splitStringBy (
            prev: curr: match "[a-z]" prev != null && match "[A-Z]" curr != null
          ) true) separators
        );

        first = if length parts > 0 then toLower (head parts) else "";
        rest = if length parts > 1 then map toSentenceCase (tail parts) else [ ];
      in
      concatStrings (map (addContextFrom str) ([ first ] ++ rest))
    );

  /**
    Appends string context from string like object `src` to `target`.

    :::{.warning}
    This is an implementation
    detail of Nix and should be used carefully.
    :::

    Strings in Nix carry an invisible `context` which is a list of strings
    representing store paths. If the string is later used in a derivation
    attribute, the derivation will properly populate the inputDrvs and
    inputSrcs.

    # Inputs

    `src`
    : The string to take the context from. If the argument is not a string,
      it will be implicitly converted to a string.

    `target`
    : The string to append the context to. If the argument is not a string,
      it will be implicitly converted to a string.

    # Type

    ```
    addContextFrom :: string -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.addContextFrom` usage example

    ```nix
    pkgs = import <nixpkgs> { };
    addContextFrom pkgs.coreutils "bar"
    => "bar"
    ```

    The context can be displayed using the `toString` function:

    ```nix
    nix-repl> builtins.getContext (lib.strings.addContextFrom pkgs.coreutils "bar")
    {
      "/nix/store/m1s1d2dk2dqqlw3j90jl3cjy2cykbdxz-coreutils-9.5.drv" = { ... };
    }
    ```

    :::
  */
  addContextFrom = src: target: substring 0 0 src + target;

  /**
    Cut a string with a separator and produces a list of strings which
    were separated by this separator.

    # Inputs

    `sep`
    : 1\. Function argument

    `s`
    : 2\. Function argument

    # Type

    ```
    splitString :: string -> string -> [string]
    ```

    # Examples
    :::{.example}
    ## `lib.strings.splitString` usage example

    ```nix
    splitString "." "foo.bar.baz"
    => [ "foo" "bar" "baz" ]
    splitString "/" "/usr/local/bin"
    => [ "" "usr" "local" "bin" ]
    ```

    :::
  */
  splitString =
    sep: s:
    let
      splits = builtins.filter builtins.isString (
        builtins.split (escapeRegex (toString sep)) (toString s)
      );
    in
    map (addContextFrom s) splits;

  /**
    Splits a string into substrings based on a predicate that examines adjacent characters.

    This function provides a flexible way to split strings by checking pairs of characters
    against a custom predicate function. Unlike simpler splitting functions, this allows
    for context-aware splitting based on character transitions and patterns.

    # Inputs

    `predicate`
    : Function that takes two arguments (previous character and current character)
      and returns true when the string should be split at the current position.
      For the first character, previous will be "" (empty string).

    `keepSplit`
    : Boolean that determines whether the splitting character should be kept as
      part of the result. If true, the character will be included at the beginning
      of the next substring; if false, it will be discarded.

    `str`
    : The input string to split.

    # Return

    A list of substrings from the original string, split according to the predicate.

    # Type

    ```
    splitStringBy :: (string -> string -> bool) -> bool -> string -> [string]
    ```

    # Examples
    :::{.example}
    ## `lib.strings.splitStringBy` usage example

    Split on periods and hyphens, discarding the separators:
    ```nix
    splitStringBy (prev: curr: builtins.elem curr [ "." "-" ]) false "foo.bar-baz"
    => [ "foo" "bar" "baz" ]
    ```

    Split on transitions from lowercase to uppercase, keeping the uppercase characters:
    ```nix
    splitStringBy (prev: curr: builtins.match "[a-z]" prev != null && builtins.match "[A-Z]" curr != null) true "fooBarBaz"
    => [ "foo" "Bar" "Baz" ]
    ```

    Handle leading separators correctly:
    ```nix
    splitStringBy (prev: curr: builtins.elem curr [ "." ]) false ".foo.bar.baz"
    => [ "" "foo" "bar" "baz" ]
    ```

    Handle trailing separators correctly:
    ```nix
    splitStringBy (prev: curr: builtins.elem curr [ "." ]) false "foo.bar.baz."
    => [ "foo" "bar" "baz" "" ]
    ```
    :::
  */
  splitStringBy =
    predicate: keepSplit: str:
    let
      len = stringLength str;

      # Helper function that processes the string character by character
      go =
        pos: currentPart: result:
        # Base case: reached end of string
        if pos == len then
          result ++ [ currentPart ]
        else
          let
            currChar = substring pos 1 str;
            prevChar = if pos > 0 then substring (pos - 1) 1 str else "";
            isSplit = predicate prevChar currChar;
          in
          if isSplit then
            # Split here - add current part to results and start a new one
            let
              newResult = result ++ [ currentPart ];
              newCurrentPart = if keepSplit then currChar else "";
            in
            go (pos + 1) newCurrentPart newResult
          else
            # Keep building current part
            go (pos + 1) (currentPart + currChar) result;
    in
    if len == 0 then [ (addContextFrom str "") ] else map (addContextFrom str) (go 0 "" [ ]);

  /**
    Returns a string without the specified prefix, if the prefix matches.

    # Inputs

    `prefix`
    : Prefix to remove if it matches

    `str`
    : Input string

    # Type

    ```
    removePrefix :: string -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.removePrefix` usage example

    ```nix
    removePrefix "foo." "foo.bar.baz"
    => "bar.baz"
    removePrefix "xxx" "foo.bar.baz"
    => "foo.bar.baz"
    ```

    :::
  */
  removePrefix =
    prefix: str:
    # Before 23.05, paths would be copied to the store before converting them
    # to strings and comparing. This was surprising and confusing.
    warnIf (isPath prefix)
      ''
        lib.strings.removePrefix: The first argument (${toString prefix}) is a path value, but only strings are supported.
            There is almost certainly a bug in the calling code, since this function never removes any prefix in such a case.
            This function also copies the path to the Nix store, which may not be what you want.
            This behavior is deprecated and will throw an error in the future.''
      (
        let
          preLen = stringLength prefix;
        in
        if substring 0 preLen str == prefix then
          # -1 will take the string until the end
          substring preLen (-1) str
        else
          str
      );

  /**
    Returns a string without the specified suffix, if the suffix matches.

    # Inputs

    `suffix`
    : Suffix to remove if it matches

    `str`
    : Input string

    # Type

    ```
    removeSuffix :: string -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.removeSuffix` usage example

    ```nix
    removeSuffix "front" "homefront"
    => "home"
    removeSuffix "xxx" "homefront"
    => "homefront"
    ```

    :::
  */
  removeSuffix =
    suffix: str:
    # Before 23.05, paths would be copied to the store before converting them
    # to strings and comparing. This was surprising and confusing.
    warnIf (isPath suffix)
      ''
        lib.strings.removeSuffix: The first argument (${toString suffix}) is a path value, but only strings are supported.
            There is almost certainly a bug in the calling code, since this function never removes any suffix in such a case.
            This function also copies the path to the Nix store, which may not be what you want.
            This behavior is deprecated and will throw an error in the future.''
      (
        let
          sufLen = stringLength suffix;
          sLen = stringLength str;
        in
        if sufLen <= sLen && suffix == substring (sLen - sufLen) sufLen str then
          substring 0 (sLen - sufLen) str
        else
          str
      );

  /**
    Returns true if string `v1` denotes a version older than `v2`.

    # Inputs

    `v1`
    : 1\. Function argument

    `v2`
    : 2\. Function argument

    # Type

    ```
    versionOlder :: String -> String -> Bool
    ```

    # Examples
    :::{.example}
    ## `lib.strings.versionOlder` usage example

    ```nix
    versionOlder "1.1" "1.2"
    => true
    versionOlder "1.1" "1.1"
    => false
    ```

    :::
  */
  versionOlder = v1: v2: compareVersions v2 v1 == 1;

  /**
    Returns true if string `v1` denotes a version equal to or newer than `v2`.

    # Inputs

    `v1`
    : 1\. Function argument

    `v2`
    : 2\. Function argument

    # Type

    ```
    versionAtLeast :: String -> String -> Bool
    ```

    # Examples
    :::{.example}
    ## `lib.strings.versionAtLeast` usage example

    ```nix
    versionAtLeast "1.1" "1.0"
    => true
    versionAtLeast "1.1" "1.1"
    => true
    versionAtLeast "1.1" "1.2"
    => false
    ```

    :::
  */
  versionAtLeast = v1: v2: !versionOlder v1 v2;

  /**
    This function takes an argument `x` that's either a derivation or a
    derivation's "name" attribute and extracts the name part from that
    argument.

    # Inputs

    `x`
    : 1\. Function argument

    # Type

    ```
    getName :: String | Derivation -> String
    ```

    # Examples
    :::{.example}
    ## `lib.strings.getName` usage example

    ```nix
    getName "youtube-dl-2016.01.01"
    => "youtube-dl"
    getName pkgs.youtube-dl
    => "youtube-dl"
    ```

    :::
  */
  getName =
    let
      parse = drv: (parseDrvName drv).name;
    in
    x: if isString x then parse x else x.pname or (parse x.name);

  /**
    This function takes an argument `x` that's either a derivation or a
    derivation's "name" attribute and extracts the version part from that
    argument.

    # Inputs

    `x`
    : 1\. Function argument

    # Type

    ```
    getVersion :: String | Derivation -> String
    ```

    # Examples
    :::{.example}
    ## `lib.strings.getVersion` usage example

    ```nix
    getVersion "youtube-dl-2016.01.01"
    => "2016.01.01"
    getVersion pkgs.youtube-dl
    => "2016.01.01"
    ```

    :::
  */
  getVersion =
    let
      parse = drv: (parseDrvName drv).version;
    in
    x: if isString x then parse x else x.version or (parse x.name);

  /**
    Extract name and version from a URL as shown in the examples.

    Separator `sep` is used to determine the end of the extension.

    # Inputs

    `url`
    : 1\. Function argument

    `sep`
    : 2\. Function argument

    # Type

    ```
    nameFromURL :: String -> String
    ```

    # Examples
    :::{.example}
    ## `lib.strings.nameFromURL` usage example

    ```nix
    nameFromURL "https://nixos.org/releases/nix/nix-1.7/nix-1.7-x86_64-linux.tar.bz2" "-"
    => "nix"
    nameFromURL "https://nixos.org/releases/nix/nix-1.7/nix-1.7-x86_64-linux.tar.bz2" "_"
    => "nix-1.7-x86"
    ```

    :::
  */
  nameFromURL =
    url: sep:
    let
      components = splitString "/" url;
      filename = lib.last components;
      name = head (splitString sep filename);
    in
    assert name != filename;
    name;

  /**
    Create a `"-D<feature>:<type>=<value>"` string that can be passed to typical
    CMake invocations.

    # Inputs

    `type`
    : The type of the feature to be set, as described in
      https://cmake.org/cmake/help/latest/command/set.html
      the possible values (case insensitive) are:
      BOOL FILEPATH PATH STRING INTERNAL LIST

    `feature`
    : The feature to be set

    `value`
    : The desired value

    # Type

    ```
    cmakeOptionType :: string -> string -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.cmakeOptionType` usage example

    ```nix
    cmakeOptionType "string" "ENGINE" "sdl2"
    => "-DENGINE:STRING=sdl2"
    ```

    :::
  */
  cmakeOptionType =
    let
      types = [
        "BOOL"
        "FILEPATH"
        "PATH"
        "STRING"
        "INTERNAL"
        "LIST"
      ];
    in
    type: feature: value:
    assert (elem (toUpper type) types);
    assert (isString feature);
    assert (isString value);
    "-D${feature}:${toUpper type}=${value}";

  /**
    Create a -D<condition>={TRUE,FALSE} string that can be passed to typical
    CMake invocations.

    # Inputs

    `condition`
    : The condition to be made true or false

    `flag`
    : The controlling flag of the condition

    # Type

    ```
    cmakeBool :: string -> bool -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.cmakeBool` usage example

    ```nix
    cmakeBool "ENABLE_STATIC_LIBS" false
    => "-DENABLESTATIC_LIBS:BOOL=FALSE"
    ```

    :::
  */
  cmakeBool =
    condition: flag:
    assert (lib.isString condition);
    assert (lib.isBool flag);
    cmakeOptionType "bool" condition (lib.toUpper (lib.boolToString flag));

  /**
    Create a -D<feature>:STRING=<value> string that can be passed to typical
    CMake invocations.
    This is the most typical usage, so it deserves a special case.

    # Inputs

    `feature`
    : The feature to be set

    `value`
    : The desired value

    # Type

    ```
    cmakeFeature :: string -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.cmakeFeature` usage example

    ```nix
    cmakeFeature "MODULES" "badblock"
    => "-DMODULES:STRING=badblock"
    ```

    :::
  */
  cmakeFeature =
    feature: value:
    assert (lib.isString feature);
    assert (lib.isString value);
    cmakeOptionType "string" feature value;

  /**
    Create a -D<feature>=<value> string that can be passed to typical Meson
    invocations.

    # Inputs

    `feature`
    : The feature to be set

    `value`
    : The desired value

    # Type

    ```
    mesonOption :: string -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.mesonOption` usage example

    ```nix
    mesonOption "engine" "opengl"
    => "-Dengine=opengl"
    ```

    :::
  */
  mesonOption =
    feature: value:
    assert (lib.isString feature);
    assert (lib.isString value);
    "-D${feature}=${value}";

  /**
    Create a -D<condition>={true,false} string that can be passed to typical
    Meson invocations.

    # Inputs

    `condition`
    : The condition to be made true or false

    `flag`
    : The controlling flag of the condition

    # Type

    ```
    mesonBool :: string -> bool -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.mesonBool` usage example

    ```nix
    mesonBool "hardened" true
    => "-Dhardened=true"
    mesonBool "static" false
    => "-Dstatic=false"
    ```

    :::
  */
  mesonBool =
    condition: flag:
    assert (lib.isString condition);
    assert (lib.isBool flag);
    mesonOption condition (lib.boolToString flag);

  /**
    Create a -D<feature>={enabled,disabled} string that can be passed to
    typical Meson invocations.

    # Inputs

    `feature`
    : The feature to be enabled or disabled

    `flag`
    : The controlling flag

    # Type

    ```
    mesonEnable :: string -> bool -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.mesonEnable` usage example

    ```nix
    mesonEnable "docs" true
    => "-Ddocs=enabled"
    mesonEnable "savage" false
    => "-Dsavage=disabled"
    ```

    :::
  */
  mesonEnable =
    feature: flag:
    assert (lib.isString feature);
    assert (lib.isBool flag);
    mesonOption feature (if flag then "enabled" else "disabled");

  /**
    Create an --{enable,disable}-<feature> string that can be passed to
    standard GNU Autoconf scripts.

    # Inputs

    `flag`
    : 1\. Function argument

    `feature`
    : 2\. Function argument

    # Type

    ```
    enableFeature :: bool -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.enableFeature` usage example

    ```nix
    enableFeature true "shared"
    => "--enable-shared"
    enableFeature false "shared"
    => "--disable-shared"
    ```

    :::
  */
  enableFeature =
    flag: feature:
    assert lib.isBool flag;
    assert lib.isString feature; # e.g. passing openssl instead of "openssl"
    "--${if flag then "enable" else "disable"}-${feature}";

  /**
    Create an --{enable-<feature>=<value>,disable-<feature>} string that can be passed to
    standard GNU Autoconf scripts.

    # Inputs

    `flag`
    : 1\. Function argument

    `feature`
    : 2\. Function argument

    `value`
    : 3\. Function argument

    # Type

    ```
    enableFeatureAs :: bool -> string -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.enableFeatureAs` usage example

    ```nix
    enableFeatureAs true "shared" "foo"
    => "--enable-shared=foo"
    enableFeatureAs false "shared" (throw "ignored")
    => "--disable-shared"
    ```

    :::
  */
  enableFeatureAs =
    flag: feature: value:
    enableFeature flag feature + optionalString flag "=${value}";

  /**
    Create an --{with,without}-<feature> string that can be passed to
    standard GNU Autoconf scripts.

    # Inputs

    `flag`
    : 1\. Function argument

    `feature`
    : 2\. Function argument

    # Type

    ```
    withFeature :: bool -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.withFeature` usage example

    ```nix
    withFeature true "shared"
    => "--with-shared"
    withFeature false "shared"
    => "--without-shared"
    ```

    :::
  */
  withFeature =
    flag: feature:
    assert isString feature; # e.g. passing openssl instead of "openssl"
    "--${if flag then "with" else "without"}-${feature}";

  /**
    Create an --{with-<feature>=<value>,without-<feature>} string that can be passed to
    standard GNU Autoconf scripts.

    # Inputs

    `flag`
    : 1\. Function argument

    `feature`
    : 2\. Function argument

    `value`
    : 3\. Function argument

    # Type

    ```
    withFeatureAs :: bool -> string -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.withFeatureAs` usage example

    ```nix
    withFeatureAs true "shared" "foo"
    => "--with-shared=foo"
    withFeatureAs false "shared" (throw "ignored")
    => "--without-shared"
    ```

    :::
  */
  withFeatureAs =
    flag: feature: value:
    withFeature flag feature + optionalString flag "=${value}";

  /**
    Create a fixed width string with additional prefix to match
    required width.

    This function will fail if the input string is longer than the
    requested length.

    # Inputs

    `width`
    : 1\. Function argument

    `filler`
    : 2\. Function argument

    `str`
    : 3\. Function argument

    # Type

    ```
    fixedWidthString :: int -> string -> string -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.fixedWidthString` usage example

    ```nix
    fixedWidthString 5 "0" (toString 15)
    => "00015"
    ```

    :::
  */
  fixedWidthString =
    width: filler: str:
    let
      strw = lib.stringLength str;
      reqWidth = width - (lib.stringLength filler);
    in
    assert lib.assertMsg (strw <= width)
      "fixedWidthString: requested string length (${toString width}) must not be shorter than actual length (${toString strw})";
    if strw == width then str else filler + fixedWidthString reqWidth filler str;

  /**
    Format a number adding leading zeroes up to fixed width.

    # Inputs

    `width`
    : 1\. Function argument

    `n`
    : 2\. Function argument

    # Type

    ```
    fixedWidthNumber :: int -> int -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.fixedWidthNumber` usage example

    ```nix
    fixedWidthNumber 5 15
    => "00015"
    ```

    :::
  */
  fixedWidthNumber = width: n: fixedWidthString width "0" (toString n);

  /**
    Convert a float to a string, but emit a warning when precision is lost
    during the conversion

    # Inputs

    `float`
    : 1\. Function argument

    # Type

    ```
    floatToString :: float -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.floatToString` usage example

    ```nix
    floatToString 0.000001
    => "0.000001"
    floatToString 0.0000001
    => trace: warning: Imprecise conversion from float to string 0.000000
       "0.000000"
    ```

    :::
  */
  floatToString =
    float:
    let
      result = toString float;
      precise = float == fromJSON result;
    in
    lib.warnIf (!precise) "Imprecise conversion from float to string ${result}" result;

  /**
    Check whether a list or other value `x` can be passed to `toString`.

    Many types of value are coercible to string this way, including `int`, `float`,
    `null`, `bool`, `list` of similarly coercible values.

    # Inputs

    `val`
    : 1\. Function argument

    # Type

    ```
    isConvertibleWithToString :: a -> bool
    ```
  */
  isConvertibleWithToString =
    let
      types = [
        "null"
        "int"
        "float"
        "bool"
      ];
    in
    x: isStringLike x || elem (typeOf x) types || (isList x && lib.all isConvertibleWithToString x);

  /**
    Check whether a value can be coerced to a string.
    The value must be a string, path, or attribute set.

    String-like values can be used without explicit conversion in
    string interpolations and in most functions that expect a string.

    # Inputs

    `x`
    : 1\. Function argument

    # Type

    ```
    isStringLike :: a -> bool
    ```
  */
  isStringLike = x: isString x || isPath x || x ? outPath || x ? __toString;

  /**
    Check whether a value `x` is a store path.

    # Inputs

    `x`
    : 1\. Function argument

    # Type

    ```
    isStorePath :: a -> bool
    ```

    # Examples
    :::{.example}
    ## `lib.strings.isStorePath` usage example

    ```nix
    isStorePath "/nix/store/d945ibfx9x185xf04b890y4f9g3cbb63-python-2.7.11/bin/python"
    => false
    isStorePath "/nix/store/d945ibfx9x185xf04b890y4f9g3cbb63-python-2.7.11"
    => true
    isStorePath pkgs.python
    => true
    isStorePath [] || isStorePath 42 || isStorePath {} || …
    => false
    ```

    :::
  */
  isStorePath =
    x:
    if isStringLike x then
      let
        str = toString x;
      in
      substring 0 1 str == "/"
      && (
        dirOf str == storeDir
        # Match content‐addressed derivations, which _currently_ do not have a
        # store directory prefix.
        # This is a workaround for https://github.com/NixOS/nix/issues/12361
        # which was needed during the experimental phase of ca-derivations and
        # should be removed once the issue has been resolved.
        || builtins.match "/[0-9a-z]{52}" str != null
      )
    else
      false;

  /**
    Parse a string as an int. Does not support parsing of integers with preceding zero due to
    ambiguity between zero-padded and octal numbers. See `toIntBase10`.

    # Inputs

    `str`
    : A string to be interpreted as an int.

    # Type

    ```
    toInt :: string -> int
    ```

    # Examples
    :::{.example}
    ## `lib.strings.toInt` usage example

    ```nix
    toInt "1337"
    => 1337

    toInt "-4"
    => -4

    toInt " 123 "
    => 123

    toInt "00024"
    => error: Ambiguity in interpretation of 00024 between octal and zero padded integer.

    toInt "3.14"
    => error: floating point JSON numbers are not supported
    ```

    :::
  */
  toInt =
    let
      matchStripInput = match "[[:space:]]*(-?[[:digit:]]+)[[:space:]]*";
      matchLeadingZero = match "0[[:digit:]]+";
    in
    str:
    let
      # RegEx: Match any leading whitespace, possibly a '-', one or more digits,
      # and finally match any trailing whitespace.
      strippedInput = matchStripInput str;

      # RegEx: Match a leading '0' then one or more digits.
      isLeadingZero = matchLeadingZero (head strippedInput) == [ ];

      # Attempt to parse input
      parsedInput = fromJSON (head strippedInput);

      generalError = "toInt: Could not convert ${escapeNixString str} to int.";

    in
    # Error on presence of non digit characters.
    if strippedInput == null then
      throw generalError
    # Error on presence of leading zero/octal ambiguity.
    else if isLeadingZero then
      throw "toInt: Ambiguity in interpretation of ${escapeNixString str} between octal and zero padded integer."
    # Error if parse function fails.
    else if !isInt parsedInput then
      throw generalError
    # Return result.
    else
      parsedInput;

  /**
    Parse a string as a base 10 int. This supports parsing of zero-padded integers.

    # Inputs

    `str`
    : A string to be interpreted as an int.

    # Type

    ```
    toIntBase10 :: string -> int
    ```

    # Examples
    :::{.example}
    ## `lib.strings.toIntBase10` usage example

    ```nix
    toIntBase10 "1337"
    => 1337

    toIntBase10 "-4"
    => -4

    toIntBase10 " 123 "
    => 123

    toIntBase10 "00024"
    => 24

    toIntBase10 "3.14"
    => error: floating point JSON numbers are not supported
    ```

    :::
  */
  toIntBase10 =
    let
      matchStripInput = match "[[:space:]]*0*(-?[[:digit:]]+)[[:space:]]*";
      matchZero = match "0+";
    in
    str:
    let
      # RegEx: Match any leading whitespace, then match any zero padding,
      # capture possibly a '-' followed by one or more digits,
      # and finally match any trailing whitespace.
      strippedInput = matchStripInput str;

      # RegEx: Match at least one '0'.
      isZero = matchZero (head strippedInput) == [ ];

      # Attempt to parse input
      parsedInput = fromJSON (head strippedInput);

      generalError = "toIntBase10: Could not convert ${escapeNixString str} to int.";

    in
    # Error on presence of non digit characters.
    if strippedInput == null then
      throw generalError
    # In the special case zero-padded zero (00000), return early.
    else if isZero then
      0
    # Error if parse function fails.
    else if !isInt parsedInput then
      throw generalError
    # Return result.
    else
      parsedInput;

  /**
    Read the contents of a file removing the trailing \n

    # Inputs

    `file`
    : 1\. Function argument

    # Type

    ```
    fileContents :: path -> string
    ```

    # Examples
    :::{.example}
    ## `lib.strings.fileContents` usage example

    ```nix
    $ echo "1.0" > ./version

    fileContents ./version
    => "1.0"
    ```

    :::
  */
  fileContents = file: removeSuffix "\n" (readFile file);

  /**
    Creates a valid derivation name from a potentially invalid one.

    # Inputs

    `string`
    : 1\. Function argument

    # Type

    ```
    sanitizeDerivationName :: String -> String
    ```

    # Examples
    :::{.example}
    ## `lib.strings.sanitizeDerivationName` usage example

    ```nix
    sanitizeDerivationName "../hello.bar # foo"
    => "-hello.bar-foo"
    sanitizeDerivationName ""
    => "unknown"
    sanitizeDerivationName pkgs.hello
    => "-nix-store-2g75chlbpxlrqn15zlby2dfh8hr9qwbk-hello-2.10"
    ```

    :::
  */
  sanitizeDerivationName =
    let
      okRegex = match "[[:alnum:]+_?=-][[:alnum:]+._?=-]*";
    in
    string:
    # First detect the common case of already valid strings, to speed those up
    if stringLength string <= 207 && okRegex string != null then
      unsafeDiscardStringContext string
    else
      lib.pipe string [
        # Get rid of string context. This is safe under the assumption that the
        # resulting string is only used as a derivation name
        unsafeDiscardStringContext
        # Strip all leading "."
        (x: elemAt (match "\\.*(.*)" x) 0)
        # Split out all invalid characters
        # https://github.com/NixOS/nix/blob/2.3.2/src/libstore/store-api.cc#L85-L112
        # https://github.com/NixOS/nix/blob/2242be83c61788b9c0736a92bb0b5c7bbfc40803/nix-rust/src/store/path.rs#L100-L125
        (split "[^[:alnum:]+._?=-]+")
        # Replace invalid character ranges with a "-"
        (concatMapStrings (s: if lib.isList s then "-" else s))
        # Limit to 211 characters (minus 4 chars for ".drv")
        (x: substring (lib.max (stringLength x - 207) 0) (-1) x)
        # If the result is empty, replace it with "unknown"
        (x: if stringLength x == 0 then "unknown" else x)
      ];

  /**
    Computes the Levenshtein distance between two strings `a` and `b`.

    Complexity O(n*m) where n and m are the lengths of the strings.
    Algorithm adjusted from https://stackoverflow.com/a/9750974/6605742

    # Inputs

    `a`
    : 1\. Function argument

    `b`
    : 2\. Function argument

    # Type

    ```
    levenshtein :: string -> string -> int
    ```

    # Examples
    :::{.example}
    ## `lib.strings.levenshtein` usage example

    ```nix
    levenshtein "foo" "foo"
    => 0
    levenshtein "book" "hook"
    => 1
    levenshtein "hello" "Heyo"
    => 3
    ```

    :::
  */
  levenshtein =
    a: b:
    let
      # Two dimensional array with dimensions (stringLength a + 1, stringLength b + 1)
      arr = lib.genList (i: lib.genList (j: dist i j) (stringLength b + 1)) (stringLength a + 1);
      d = x: y: lib.elemAt (lib.elemAt arr x) y;
      dist =
        i: j:
        let
          c = if substring (i - 1) 1 a == substring (j - 1) 1 b then 0 else 1;
        in
        if j == 0 then
          i
        else if i == 0 then
          j
        else
          lib.min (lib.min (d (i - 1) j + 1) (d i (j - 1) + 1)) (d (i - 1) (j - 1) + c);
    in
    d (stringLength a) (stringLength b);

  /**
    Returns the length of the prefix that appears in both strings `a` and `b`.

    # Inputs

    `a`
    : 1\. Function argument

    `b`
    : 2\. Function argument

    # Type

    ```
    commonPrefixLength :: string -> string -> int
    ```
  */
  commonPrefixLength =
    a: b:
    let
      m = lib.min (stringLength a) (stringLength b);
      go =
        i:
        if i >= m then
          m
        else if substring i 1 a == substring i 1 b then
          go (i + 1)
        else
          i;
    in
    go 0;

  /**
    Returns the length of the suffix common to both strings `a` and `b`.

    # Inputs

    `a`
    : 1\. Function argument

    `b`
    : 2\. Function argument

    # Type

    ```
    commonSuffixLength :: string -> string -> int
    ```
  */
  commonSuffixLength =
    a: b:
    let
      m = lib.min (stringLength a) (stringLength b);
      go =
        i:
        if i >= m then
          m
        else if substring (stringLength a - i - 1) 1 a == substring (stringLength b - i - 1) 1 b then
          go (i + 1)
        else
          i;
    in
    go 0;

  /**
    Returns whether the levenshtein distance between two strings `a` and `b` is at most some value `k`.

    Complexity is O(min(n,m)) for k <= 2 and O(n*m) otherwise

    # Inputs

    `k`
    : Distance threshold

    `a`
    : String `a`

    `b`
    : String `b`

    # Type

    ```
    levenshteinAtMost :: int -> string -> string -> bool
    ```

    # Examples
    :::{.example}
    ## `lib.strings.levenshteinAtMost` usage example

    ```nix
    levenshteinAtMost 0 "foo" "foo"
    => true
    levenshteinAtMost 1 "foo" "boa"
    => false
    levenshteinAtMost 2 "foo" "boa"
    => true
    levenshteinAtMost 2 "This is a sentence" "this is a sentense."
    => false
    levenshteinAtMost 3 "This is a sentence" "this is a sentense."
    => true
    ```

    :::
  */
  levenshteinAtMost =
    let
      infixDifferAtMost1 = x: y: stringLength x <= 1 && stringLength y <= 1;

      # This function takes two strings stripped by their common pre and suffix,
      # and returns whether they differ by at most two by Levenshtein distance.
      # Because of this stripping, if they do indeed differ by at most two edits,
      # we know that those edits were (if at all) done at the start or the end,
      # while the middle has to have stayed the same. This fact is used in the
      # implementation.
      infixDifferAtMost2 =
        x: y:
        let
          xlen = stringLength x;
          ylen = stringLength y;
          # This function is only called with |x| >= |y| and |x| - |y| <= 2, so
          # diff is one of 0, 1 or 2
          diff = xlen - ylen;

          # Infix of x and y, stripped by the left and right most character
          xinfix = substring 1 (xlen - 2) x;
          yinfix = substring 1 (ylen - 2) y;

          # x and y but a character deleted at the left or right
          xdelr = substring 0 (xlen - 1) x;
          xdell = substring 1 (xlen - 1) x;
          ydelr = substring 0 (ylen - 1) y;
          ydell = substring 1 (ylen - 1) y;
        in
        # A length difference of 2 can only be gotten with 2 delete edits,
        # which have to have happened at the start and end of x
        # Example: "abcdef" -> "bcde"
        if diff == 2 then
          xinfix == y
        # A length difference of 1 can only be gotten with a deletion on the
        # right and a replacement on the left or vice versa.
        # Example: "abcdef" -> "bcdez" or "zbcde"
        else if diff == 1 then
          xinfix == ydelr || xinfix == ydell
        # No length difference can either happen through replacements on both
        # sides, or a deletion on the left and an insertion on the right or
        # vice versa
        # Example: "abcdef" -> "zbcdez" or "bcdefz" or "zabcde"
        else
          xinfix == yinfix || xdelr == ydell || xdell == ydelr;

    in
    k:
    if k <= 0 then
      a: b: a == b
    else
      let
        f =
          a: b:
          let
            alen = stringLength a;
            blen = stringLength b;
            prelen = commonPrefixLength a b;
            suflen = commonSuffixLength a b;
            presuflen = prelen + suflen;
            ainfix = substring prelen (alen - presuflen) a;
            binfix = substring prelen (blen - presuflen) b;
          in
          # Make a be the bigger string
          if alen < blen then
            f b a
          # If a has over k more characters than b, even with k deletes on a, b can't be reached
          else if alen - blen > k then
            false
          else if k == 1 then
            infixDifferAtMost1 ainfix binfix
          else if k == 2 then
            infixDifferAtMost2 ainfix binfix
          else
            levenshtein ainfix binfix <= k;
      in
      f;
}
