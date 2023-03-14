/* String manipulation functions. */
{ lib }:
let

  inherit (builtins) length;

  inherit (lib.trivial) warnIf;

in

rec {

  inherit (builtins)
    compareVersions
    elem
    elemAt
    filter
    fromJSON
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

  /* Concatenate a list of strings.

    Type: concatStrings :: [string] -> string

     Example:
       concatStrings ["foo" "bar"]
       => "foobar"
  */
  concatStrings = builtins.concatStringsSep "";

  /* Map a function over a list and concatenate the resulting strings.

    Type: concatMapStrings :: (a -> string) -> [a] -> string

     Example:
       concatMapStrings (x: "a" + x) ["foo" "bar"]
       => "afooabar"
  */
  concatMapStrings = f: list: concatStrings (map f list);

  /* Like `concatMapStrings` except that the f functions also gets the
     position as a parameter.

     Type: concatImapStrings :: (int -> a -> string) -> [a] -> string

     Example:
       concatImapStrings (pos: x: "${toString pos}-${x}") ["foo" "bar"]
       => "1-foo2-bar"
  */
  concatImapStrings = f: list: concatStrings (lib.imap1 f list);

  /* Place an element between each element of a list

     Type: intersperse :: a -> [a] -> [a]

     Example:
       intersperse "/" ["usr" "local" "bin"]
       => ["usr" "/" "local" "/" "bin"].
  */
  intersperse =
    # Separator to add between elements
    separator:
    # Input list
    list:
    if list == [] || length list == 1
    then list
    else tail (lib.concatMap (x: [separator x]) list);

  /* Concatenate a list of strings with a separator between each element

     Type: concatStringsSep :: string -> [string] -> string

     Example:
        concatStringsSep "/" ["usr" "local" "bin"]
        => "usr/local/bin"
  */
  concatStringsSep = builtins.concatStringsSep or (separator: list:
    lib.foldl' (x: y: x + y) "" (intersperse separator list));

  /* Maps a function over a list of strings and then concatenates the
     result with the specified separator interspersed between
     elements.

     Type: concatMapStringsSep :: string -> (a -> string) -> [a] -> string

     Example:
        concatMapStringsSep "-" (x: toUpper x)  ["foo" "bar" "baz"]
        => "FOO-BAR-BAZ"
  */
  concatMapStringsSep =
    # Separator to add between elements
    sep:
    # Function to map over the list
    f:
    # List of input strings
    list: concatStringsSep sep (map f list);

  /* Same as `concatMapStringsSep`, but the mapping function
     additionally receives the position of its argument.

     Type: concatIMapStringsSep :: string -> (int -> a -> string) -> [a] -> string

     Example:
       concatImapStringsSep "-" (pos: x: toString (x / pos)) [ 6 6 6 ]
       => "6-3-2"
  */
  concatImapStringsSep =
    # Separator to add between elements
    sep:
    # Function that receives elements and their positions
    f:
    # List of input strings
    list: concatStringsSep sep (lib.imap1 f list);

  /* Concatenate a list of strings, adding a newline at the end of each one.
     Defined as `concatMapStrings (s: s + "\n")`.

     Type: concatLines :: [string] -> string

     Example:
       concatLines [ "foo" "bar" ]
       => "foo\nbar\n"
  */
  concatLines = concatMapStrings (s: s + "\n");

  /* Construct a Unix-style, colon-separated search path consisting of
     the given `subDir` appended to each of the given paths.

     Type: makeSearchPath :: string -> [string] -> string

     Example:
       makeSearchPath "bin" ["/root" "/usr" "/usr/local"]
       => "/root/bin:/usr/bin:/usr/local/bin"
       makeSearchPath "bin" [""]
       => "/bin"
  */
  makeSearchPath =
    # Directory name to append
    subDir:
    # List of base paths
    paths:
    concatStringsSep ":" (map (path: path + "/" + subDir) (filter (x: x != null) paths));

  /* Construct a Unix-style search path by appending the given
     `subDir` to the specified `output` of each of the packages. If no
     output by the given name is found, fallback to `.out` and then to
     the default.

     Type: string -> string -> [package] -> string

     Example:
       makeSearchPathOutput "dev" "bin" [ pkgs.openssl pkgs.zlib ]
       => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev/bin:/nix/store/wwh7mhwh269sfjkm6k5665b5kgp7jrk2-zlib-1.2.8/bin"
  */
  makeSearchPathOutput =
    # Package output to use
    output:
    # Directory name to append
    subDir:
    # List of packages
    pkgs: makeSearchPath subDir (map (lib.getOutput output) pkgs);

  /* Construct a library search path (such as RPATH) containing the
     libraries for a set of packages

     Example:
       makeLibraryPath [ "/usr" "/usr/local" ]
       => "/usr/lib:/usr/local/lib"
       pkgs = import <nixpkgs> { }
       makeLibraryPath [ pkgs.openssl pkgs.zlib ]
       => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r/lib:/nix/store/wwh7mhwh269sfjkm6k5665b5kgp7jrk2-zlib-1.2.8/lib"
  */
  makeLibraryPath = makeSearchPathOutput "lib" "lib";

  /* Construct a binary search path (such as $PATH) containing the
     binaries for a set of packages.

     Example:
       makeBinPath ["/root" "/usr" "/usr/local"]
       => "/root/bin:/usr/bin:/usr/local/bin"
  */
  makeBinPath = makeSearchPathOutput "bin" "bin";

  /* Normalize path, removing extraneous /s

     Type: normalizePath :: string -> string

     Example:
       normalizePath "/a//b///c/"
       => "/a/b/c/"
  */
  normalizePath = s: (builtins.foldl' (x: y: if y == "/" && hasSuffix "/" x then x else x+y) "" (stringToCharacters s));

  /* Depending on the boolean `cond', return either the given string
     or the empty string. Useful to concatenate against a bigger string.

     Type: optionalString :: bool -> string -> string

     Example:
       optionalString true "some-string"
       => "some-string"
       optionalString false "some-string"
       => ""
  */
  optionalString =
    # Condition
    cond:
    # String to return if condition is true
    string: if cond then string else "";

  /* Determine whether a string has given prefix.

     Type: hasPrefix :: string -> string -> bool

     Example:
       hasPrefix "foo" "foobar"
       => true
       hasPrefix "foo" "barfoo"
       => false
  */
  hasPrefix =
    # Prefix to check for
    pref:
    # Input string
    str:
    # Before 23.05, paths would be copied to the store before converting them
    # to strings and comparing. This was surprising and confusing.
    warnIf
      (isPath pref)
      ''
        lib.strings.hasPrefix: The first argument (${toString pref}) is a path value, but only strings are supported.
            There is almost certainly a bug in the calling code, since this function always returns `false` in such a case.
            This function also copies the path to the Nix store, which may not be what you want.
            This behavior is deprecated and will throw an error in the future.''
      (substring 0 (stringLength pref) str == pref);

  /* Determine whether a string has given suffix.

     Type: hasSuffix :: string -> string -> bool

     Example:
       hasSuffix "foo" "foobar"
       => false
       hasSuffix "foo" "barfoo"
       => true
  */
  hasSuffix =
    # Suffix to check for
    suffix:
    # Input string
    content:
    let
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
    # Before 23.05, paths would be copied to the store before converting them
    # to strings and comparing. This was surprising and confusing.
    warnIf
      (isPath suffix)
      ''
        lib.strings.hasSuffix: The first argument (${toString suffix}) is a path value, but only strings are supported.
            There is almost certainly a bug in the calling code, since this function always returns `false` in such a case.
            This function also copies the path to the Nix store, which may not be what you want.
            This behavior is deprecated and will throw an error in the future.''
      (
        lenContent >= lenSuffix
        && substring (lenContent - lenSuffix) lenContent content == suffix
      );

  /* Determine whether a string contains the given infix

    Type: hasInfix :: string -> string -> bool

    Example:
      hasInfix "bc" "abcd"
      => true
      hasInfix "ab" "abcd"
      => true
      hasInfix "cd" "abcd"
      => true
      hasInfix "foo" "abcd"
      => false
  */
  hasInfix = infix: content:
    # Before 23.05, paths would be copied to the store before converting them
    # to strings and comparing. This was surprising and confusing.
    warnIf
      (isPath infix)
      ''
        lib.strings.hasInfix: The first argument (${toString infix}) is a path value, but only strings are supported.
            There is almost certainly a bug in the calling code, since this function always returns `false` in such a case.
            This function also copies the path to the Nix store, which may not be what you want.
            This behavior is deprecated and will throw an error in the future.''
      (builtins.match ".*${escapeRegex infix}.*" "${content}" != null);

  /* Convert a string to a list of characters (i.e. singleton strings).
     This allows you to, e.g., map a function over each character.  However,
     note that this will likely be horribly inefficient; Nix is not a
     general purpose programming language. Complex string manipulations
     should, if appropriate, be done in a derivation.
     Also note that Nix treats strings as a list of bytes and thus doesn't
     handle unicode.

     Type: stringToCharacters :: string -> [string]

     Example:
       stringToCharacters ""
       => [ ]
       stringToCharacters "abc"
       => [ "a" "b" "c" ]
       stringToCharacters "🦄"
       => [ "�" "�" "�" "�" ]
  */
  stringToCharacters = s:
    map (p: substring p 1 s) (lib.range 0 (stringLength s - 1));

  /* Manipulate a string character by character and replace them by
     strings before concatenating the results.

     Type: stringAsChars :: (string -> string) -> string -> string

     Example:
       stringAsChars (x: if x == "a" then "i" else x) "nax"
       => "nix"
  */
  stringAsChars =
    # Function to map over each individual character
    f:
    # Input string
    s: concatStrings (
      map f (stringToCharacters s)
    );

  /* Convert char to ascii value, must be in printable range

     Type: charToInt :: string -> int

     Example:
       charToInt "A"
       => 65
       charToInt "("
       => 40

  */
  charToInt = let
    table = import ./ascii-table.nix;
  in c: builtins.getAttr c table;

  /* Escape occurrence of the elements of `list` in `string` by
     prefixing it with a backslash.

     Type: escape :: [string] -> string -> string

     Example:
       escape ["(" ")"] "(foo)"
       => "\\(foo\\)"
  */
  escape = list: replaceStrings list (map (c: "\\${c}") list);

  /* Escape occurrence of the element of `list` in `string` by
     converting to its ASCII value and prefixing it with \\x.
     Only works for printable ascii characters.

     Type: escapeC = [string] -> string -> string

     Example:
       escapeC [" "] "foo bar"
       => "foo\\x20bar"

  */
  escapeC = list: replaceStrings list (map (c: "\\x${ toLower (lib.toHexString (charToInt c))}") list);

  /* Quote string to be used safely within the Bourne shell.

     Type: escapeShellArg :: string -> string

     Example:
       escapeShellArg "esc'ape\nme"
       => "'esc'\\''ape\nme'"
  */
  escapeShellArg = arg: "'${replaceStrings ["'"] ["'\\''"] (toString arg)}'";

  /* Quote all arguments to be safely passed to the Bourne shell.

     Type: escapeShellArgs :: [string] -> string

     Example:
       escapeShellArgs ["one" "two three" "four'five"]
       => "'one' 'two three' 'four'\\''five'"
  */
  escapeShellArgs = concatMapStringsSep " " escapeShellArg;

  /* Test whether the given name is a valid POSIX shell variable name.

     Type: string -> bool

     Example:
       isValidPosixName "foo_bar000"
       => true
       isValidPosixName "0-bad.jpg"
       => false
  */
  isValidPosixName = name: match "[a-zA-Z_][a-zA-Z0-9_]*" name != null;

  /* Translate a Nix value into a shell variable declaration, with proper escaping.

     The value can be a string (mapped to a regular variable), a list of strings
     (mapped to a Bash-style array) or an attribute set of strings (mapped to a
     Bash-style associative array). Note that "string" includes string-coercible
     values like paths or derivations.

     Strings are translated into POSIX sh-compatible code; lists and attribute sets
     assume a shell that understands Bash syntax (e.g. Bash or ZSH).

     Type: string -> (string | listOf string | attrsOf string) -> string

     Example:
       ''
         ${toShellVar "foo" "some string"}
         [[ "$foo" == "some string" ]]
       ''
  */
  toShellVar = name: value:
    lib.throwIfNot (isValidPosixName name) "toShellVar: ${name} is not a valid shell variable name" (
    if isAttrs value && ! isStringLike value then
      "declare -A ${name}=(${
        concatStringsSep " " (lib.mapAttrsToList (n: v:
          "[${escapeShellArg n}]=${escapeShellArg v}"
        ) value)
      })"
    else if isList value then
      "declare -a ${name}=(${escapeShellArgs value})"
    else
      "${name}=${escapeShellArg value}"
    );

  /* Translate an attribute set into corresponding shell variable declarations
     using `toShellVar`.

     Type: attrsOf (string | listOf string | attrsOf string) -> string

     Example:
       let
         foo = "value";
         bar = foo;
       in ''
         ${toShellVars { inherit foo bar; }}
         [[ "$foo" == "$bar" ]]
       ''
  */
  toShellVars = vars: concatStringsSep "\n" (lib.mapAttrsToList toShellVar vars);

  /* Turn a string into a Nix expression representing that string

     Type: string -> string

     Example:
       escapeNixString "hello\${}\n"
       => "\"hello\\\${}\\n\""
  */
  escapeNixString = s: escape ["$"] (toJSON s);

  /* Turn a string into an exact regular expression

     Type: string -> string

     Example:
       escapeRegex "[^a-z]*"
       => "\\[\\^a-z]\\*"
  */
  escapeRegex = escape (stringToCharacters "\\[{()^$?*+|.");

  /* Quotes a string if it can't be used as an identifier directly.

     Type: string -> string

     Example:
       escapeNixIdentifier "hello"
       => "hello"
       escapeNixIdentifier "0abc"
       => "\"0abc\""
  */
  escapeNixIdentifier = s:
    # Regex from https://github.com/NixOS/nix/blob/d048577909e383439c2549e849c5c2f2016c997e/src/libexpr/lexer.l#L91
    if match "[a-zA-Z_][a-zA-Z0-9_'-]*" s != null
    then s else escapeNixString s;

  /* Escapes a string such that it is safe to include verbatim in an XML
     document.

     Type: string -> string

     Example:
       escapeXML ''"test" 'test' < & >''
       => "&quot;test&quot; &apos;test&apos; &lt; &amp; &gt;"
  */
  escapeXML = builtins.replaceStrings
    ["\"" "'" "<" ">" "&"]
    ["&quot;" "&apos;" "&lt;" "&gt;" "&amp;"];

  # warning added 12-12-2022
  replaceChars = lib.warn "replaceChars is a deprecated alias of replaceStrings, replace usages of it with replaceStrings." builtins.replaceStrings;

  # Case conversion utilities.
  lowerChars = stringToCharacters "abcdefghijklmnopqrstuvwxyz";
  upperChars = stringToCharacters "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  /* Converts an ASCII string to lower-case.

     Type: toLower :: string -> string

     Example:
       toLower "HOME"
       => "home"
  */
  toLower = replaceStrings upperChars lowerChars;

  /* Converts an ASCII string to upper-case.

     Type: toUpper :: string -> string

     Example:
       toUpper "home"
       => "HOME"
  */
  toUpper = replaceStrings lowerChars upperChars;

  /* Appends string context from another string.  This is an implementation
     detail of Nix and should be used carefully.

     Strings in Nix carry an invisible `context` which is a list of strings
     representing store paths.  If the string is later used in a derivation
     attribute, the derivation will properly populate the inputDrvs and
     inputSrcs.

     Example:
       pkgs = import <nixpkgs> { };
       addContextFrom pkgs.coreutils "bar"
       => "bar"
  */
  addContextFrom = a: b: substring 0 0 a + b;

  /* Cut a string with a separator and produces a list of strings which
     were separated by this separator.

     Example:
       splitString "." "foo.bar.baz"
       => [ "foo" "bar" "baz" ]
       splitString "/" "/usr/local/bin"
       => [ "" "usr" "local" "bin" ]
  */
  splitString = sep: s:
    let
      splits = builtins.filter builtins.isString (builtins.split (escapeRegex (toString sep)) (toString s));
    in
      map (addContextFrom s) splits;

  /* Return a string without the specified prefix, if the prefix matches.

     Type: string -> string -> string

     Example:
       removePrefix "foo." "foo.bar.baz"
       => "bar.baz"
       removePrefix "xxx" "foo.bar.baz"
       => "foo.bar.baz"
  */
  removePrefix =
    # Prefix to remove if it matches
    prefix:
    # Input string
    str:
    let
      preLen = stringLength prefix;
      sLen = stringLength str;
    in
      if hasPrefix prefix str then
        substring preLen (sLen - preLen) str
      else
        str;

  /* Return a string without the specified suffix, if the suffix matches.

     Type: string -> string -> string

     Example:
       removeSuffix "front" "homefront"
       => "home"
       removeSuffix "xxx" "homefront"
       => "homefront"
  */
  removeSuffix =
    # Suffix to remove if it matches
    suffix:
    # Input string
    str:
    let
      sufLen = stringLength suffix;
      sLen = stringLength str;
    in
      if sufLen <= sLen && suffix == substring (sLen - sufLen) sufLen str then
        substring 0 (sLen - sufLen) str
      else
        str;

  /* Return true if string v1 denotes a version older than v2.

     Example:
       versionOlder "1.1" "1.2"
       => true
       versionOlder "1.1" "1.1"
       => false
  */
  versionOlder = v1: v2: compareVersions v2 v1 == 1;

  /* Return true if string v1 denotes a version equal to or newer than v2.

     Example:
       versionAtLeast "1.1" "1.0"
       => true
       versionAtLeast "1.1" "1.1"
       => true
       versionAtLeast "1.1" "1.2"
       => false
  */
  versionAtLeast = v1: v2: !versionOlder v1 v2;

  /* This function takes an argument that's either a derivation or a
     derivation's "name" attribute and extracts the name part from that
     argument.

     Example:
       getName "youtube-dl-2016.01.01"
       => "youtube-dl"
       getName pkgs.youtube-dl
       => "youtube-dl"
  */
  getName = x:
   let
     parse = drv: (parseDrvName drv).name;
   in if isString x
      then parse x
      else x.pname or (parse x.name);

  /* This function takes an argument that's either a derivation or a
     derivation's "name" attribute and extracts the version part from that
     argument.

     Example:
       getVersion "youtube-dl-2016.01.01"
       => "2016.01.01"
       getVersion pkgs.youtube-dl
       => "2016.01.01"
  */
  getVersion = x:
   let
     parse = drv: (parseDrvName drv).version;
   in if isString x
      then parse x
      else x.version or (parse x.name);

  /* Extract name with version from URL. Ask for separator which is
     supposed to start extension.

     Example:
       nameFromURL "https://nixos.org/releases/nix/nix-1.7/nix-1.7-x86_64-linux.tar.bz2" "-"
       => "nix"
       nameFromURL "https://nixos.org/releases/nix/nix-1.7/nix-1.7-x86_64-linux.tar.bz2" "_"
       => "nix-1.7-x86"
  */
  nameFromURL = url: sep:
    let
      components = splitString "/" url;
      filename = lib.last components;
      name = head (splitString sep filename);
    in assert name != filename; name;

  /* Create a -D<feature>=<value> string that can be passed to typical Meson
     invocations.

    Type: mesonOption :: string -> string -> string

     @param feature The feature to be set
     @param value The desired value

     Example:
       mesonOption "engine" "opengl"
       => "-Dengine=opengl"
  */
  mesonOption = feature: value:
    assert (lib.isString feature);
    assert (lib.isString value);
    "-D${feature}=${value}";

  /* Create a -D<condition>={true,false} string that can be passed to typical
     Meson invocations.

    Type: mesonBool :: string -> bool -> string

     @param condition The condition to be made true or false
     @param flag The controlling flag of the condition

     Example:
       mesonBool "hardened" true
       => "-Dhardened=true"
       mesonBool "static" false
       => "-Dstatic=false"
  */
  mesonBool = condition: flag:
    assert (lib.isString condition);
    assert (lib.isBool flag);
    mesonOption condition (lib.boolToString flag);

  /* Create a -D<feature>={enabled,disabled} string that can be passed to
     typical Meson invocations.

    Type: mesonEnable :: string -> bool -> string

     @param feature The feature to be enabled or disabled
     @param flag The controlling flag

     Example:
       mesonEnable "docs" true
       => "-Ddocs=enabled"
       mesonEnable "savage" false
       => "-Dsavage=disabled"
  */
  mesonEnable = feature: flag:
    assert (lib.isString feature);
    assert (lib.isBool flag);
    mesonOption feature (if flag then "enabled" else "disabled");

  /* Create an --{enable,disable}-<feat> string that can be passed to
     standard GNU Autoconf scripts.

     Example:
       enableFeature true "shared"
       => "--enable-shared"
       enableFeature false "shared"
       => "--disable-shared"
  */
  enableFeature = enable: feat:
    assert isString feat; # e.g. passing openssl instead of "openssl"
    "--${if enable then "enable" else "disable"}-${feat}";

  /* Create an --{enable-<feat>=<value>,disable-<feat>} string that can be passed to
     standard GNU Autoconf scripts.

     Example:
       enableFeatureAs true "shared" "foo"
       => "--enable-shared=foo"
       enableFeatureAs false "shared" (throw "ignored")
       => "--disable-shared"
  */
  enableFeatureAs = enable: feat: value: enableFeature enable feat + optionalString enable "=${value}";

  /* Create an --{with,without}-<feat> string that can be passed to
     standard GNU Autoconf scripts.

     Example:
       withFeature true "shared"
       => "--with-shared"
       withFeature false "shared"
       => "--without-shared"
  */
  withFeature = with_: feat:
    assert isString feat; # e.g. passing openssl instead of "openssl"
    "--${if with_ then "with" else "without"}-${feat}";

  /* Create an --{with-<feat>=<value>,without-<feat>} string that can be passed to
     standard GNU Autoconf scripts.

     Example:
       withFeatureAs true "shared" "foo"
       => "--with-shared=foo"
       withFeatureAs false "shared" (throw "ignored")
       => "--without-shared"
  */
  withFeatureAs = with_: feat: value: withFeature with_ feat + optionalString with_ "=${value}";

  /* Create a fixed width string with additional prefix to match
     required width.

     This function will fail if the input string is longer than the
     requested length.

     Type: fixedWidthString :: int -> string -> string -> string

     Example:
       fixedWidthString 5 "0" (toString 15)
       => "00015"
  */
  fixedWidthString = width: filler: str:
    let
      strw = lib.stringLength str;
      reqWidth = width - (lib.stringLength filler);
    in
      assert lib.assertMsg (strw <= width)
        "fixedWidthString: requested string length (${
          toString width}) must not be shorter than actual length (${
            toString strw})";
      if strw == width then str else filler + fixedWidthString reqWidth filler str;

  /* Format a number adding leading zeroes up to fixed width.

     Example:
       fixedWidthNumber 5 15
       => "00015"
  */
  fixedWidthNumber = width: n: fixedWidthString width "0" (toString n);

  /* Convert a float to a string, but emit a warning when precision is lost
     during the conversion

     Example:
       floatToString 0.000001
       => "0.000001"
       floatToString 0.0000001
       => trace: warning: Imprecise conversion from float to string 0.000000
          "0.000000"
  */
  floatToString = float: let
    result = toString float;
    precise = float == fromJSON result;
  in lib.warnIf (!precise) "Imprecise conversion from float to string ${result}"
    result;

  /* Soft-deprecated function. While the original implementation is available as
     isConvertibleWithToString, consider using isStringLike instead, if suitable. */
  isCoercibleToString = lib.warnIf (lib.isInOldestRelease 2305)
    "lib.strings.isCoercibleToString is deprecated in favor of either isStringLike or isConvertibleWithToString. Only use the latter if it needs to return true for null, numbers, booleans and list of similarly coercibles."
    isConvertibleWithToString;

  /* Check whether a list or other value can be passed to toString.

     Many types of value are coercible to string this way, including int, float,
     null, bool, list of similarly coercible values.
  */
  isConvertibleWithToString = x:
    isStringLike x ||
    elem (typeOf x) [ "null" "int" "float" "bool" ] ||
    (isList x && lib.all isConvertibleWithToString x);

  /* Check whether a value can be coerced to a string.
     The value must be a string, path, or attribute set.

     String-like values can be used without explicit conversion in
     string interpolations and in most functions that expect a string.
   */
  isStringLike = x:
    isString x ||
    isPath x ||
    x ? outPath ||
    x ? __toString;

  /* Check whether a value is a store path.

     Example:
       isStorePath "/nix/store/d945ibfx9x185xf04b890y4f9g3cbb63-python-2.7.11/bin/python"
       => false
       isStorePath "/nix/store/d945ibfx9x185xf04b890y4f9g3cbb63-python-2.7.11"
       => true
       isStorePath pkgs.python
       => true
       isStorePath [] || isStorePath 42 || isStorePath {} || …
       => false
  */
  isStorePath = x:
    if isStringLike x then
      let str = toString x; in
      substring 0 1 str == "/"
      && dirOf str == storeDir
    else
      false;

  /* Parse a string as an int. Does not support parsing of integers with preceding zero due to
  ambiguity between zero-padded and octal numbers. See toIntBase10.

     Type: string -> int

     Example:

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
  */
  toInt = str:
    let
      # RegEx: Match any leading whitespace, possibly a '-', one or more digits,
      # and finally match any trailing whitespace.
      strippedInput = match "[[:space:]]*(-?[[:digit:]]+)[[:space:]]*" str;

      # RegEx: Match a leading '0' then one or more digits.
      isLeadingZero = match "0[[:digit:]]+" (head strippedInput) == [];

      # Attempt to parse input
      parsedInput = fromJSON (head strippedInput);

      generalError = "toInt: Could not convert ${escapeNixString str} to int.";

      octalAmbigError = "toInt: Ambiguity in interpretation of ${escapeNixString str}"
      + " between octal and zero padded integer.";

    in
      # Error on presence of non digit characters.
      if strippedInput == null
      then throw generalError
      # Error on presence of leading zero/octal ambiguity.
      else if isLeadingZero
      then throw octalAmbigError
      # Error if parse function fails.
      else if !isInt parsedInput
      then throw generalError
      # Return result.
      else parsedInput;


  /* Parse a string as a base 10 int. This supports parsing of zero-padded integers.

     Type: string -> int

     Example:
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
  */
  toIntBase10 = str:
    let
      # RegEx: Match any leading whitespace, then match any zero padding,
      # capture possibly a '-' followed by one or more digits,
      # and finally match any trailing whitespace.
      strippedInput = match "[[:space:]]*0*(-?[[:digit:]]+)[[:space:]]*" str;

      # RegEx: Match at least one '0'.
      isZero = match "0+" (head strippedInput) == [];

      # Attempt to parse input
      parsedInput = fromJSON (head strippedInput);

      generalError = "toIntBase10: Could not convert ${escapeNixString str} to int.";

    in
      # Error on presence of non digit characters.
      if strippedInput == null
      then throw generalError
      # In the special case zero-padded zero (00000), return early.
      else if isZero
      then 0
      # Error if parse function fails.
      else if !isInt parsedInput
      then throw generalError
      # Return result.
      else parsedInput;

  /* Read a list of paths from `file`, relative to the `rootPath`.
     Lines beginning with `#` are treated as comments and ignored.
     Whitespace is significant.

     NOTE: This function is not performant and should be avoided.

     Example:
       readPathsFromFile /prefix
         ./pkgs/development/libraries/qt-5/5.4/qtbase/series
       => [ "/prefix/dlopen-resolv.patch" "/prefix/tzdir.patch"
            "/prefix/dlopen-libXcursor.patch" "/prefix/dlopen-openssl.patch"
            "/prefix/dlopen-dbus.patch" "/prefix/xdg-config-dirs.patch"
            "/prefix/nix-profiles-library-paths.patch"
            "/prefix/compose-search-path.patch" ]
  */
  readPathsFromFile = lib.warn "lib.readPathsFromFile is deprecated, use a list instead"
    (rootPath: file:
      let
        lines = lib.splitString "\n" (readFile file);
        removeComments = lib.filter (line: line != "" && !(lib.hasPrefix "#" line));
        relativePaths = removeComments lines;
        absolutePaths = map (path: rootPath + "/${path}") relativePaths;
      in
        absolutePaths);

  /* Read the contents of a file removing the trailing \n

     Type: fileContents :: path -> string

     Example:
       $ echo "1.0" > ./version

       fileContents ./version
       => "1.0"
  */
  fileContents = file: removeSuffix "\n" (readFile file);


  /* Creates a valid derivation name from a potentially invalid one.

     Type: sanitizeDerivationName :: String -> String

     Example:
       sanitizeDerivationName "../hello.bar # foo"
       => "-hello.bar-foo"
       sanitizeDerivationName ""
       => "unknown"
       sanitizeDerivationName pkgs.hello
       => "-nix-store-2g75chlbpxlrqn15zlby2dfh8hr9qwbk-hello-2.10"
  */
  sanitizeDerivationName =
  let okRegex = match "[[:alnum:]+_?=-][[:alnum:]+._?=-]*";
  in
  string:
  # First detect the common case of already valid strings, to speed those up
  if stringLength string <= 207 && okRegex string != null
  then unsafeDiscardStringContext string
  else lib.pipe string [
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

  /* Computes the Levenshtein distance between two strings.
     Complexity O(n*m) where n and m are the lengths of the strings.
     Algorithm adjusted from https://stackoverflow.com/a/9750974/6605742

     Type: levenshtein :: string -> string -> int

     Example:
       levenshtein "foo" "foo"
       => 0
       levenshtein "book" "hook"
       => 1
       levenshtein "hello" "Heyo"
       => 3
  */
  levenshtein = a: b: let
    # Two dimensional array with dimensions (stringLength a + 1, stringLength b + 1)
    arr = lib.genList (i:
      lib.genList (j:
        dist i j
      ) (stringLength b + 1)
    ) (stringLength a + 1);
    d = x: y: lib.elemAt (lib.elemAt arr x) y;
    dist = i: j:
      let c = if substring (i - 1) 1 a == substring (j - 1) 1 b
        then 0 else 1;
      in
      if j == 0 then i
      else if i == 0 then j
      else lib.min
        ( lib.min (d (i - 1) j + 1) (d i (j - 1) + 1))
        ( d (i - 1) (j - 1) + c );
  in d (stringLength a) (stringLength b);

  /* Returns the length of the prefix common to both strings.
  */
  commonPrefixLength = a: b:
    let
      m = lib.min (stringLength a) (stringLength b);
      go = i: if i >= m then m else if substring i 1 a == substring i 1 b then go (i + 1) else i;
    in go 0;

  /* Returns the length of the suffix common to both strings.
  */
  commonSuffixLength = a: b:
    let
      m = lib.min (stringLength a) (stringLength b);
      go = i: if i >= m then m else if substring (stringLength a - i - 1) 1 a == substring (stringLength b - i - 1) 1 b then go (i + 1) else i;
    in go 0;

  /* Returns whether the levenshtein distance between two strings is at most some value
     Complexity is O(min(n,m)) for k <= 2 and O(n*m) otherwise

     Type: levenshteinAtMost :: int -> string -> string -> bool

     Example:
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

  */
  levenshteinAtMost = let
    infixDifferAtMost1 = x: y: stringLength x <= 1 && stringLength y <= 1;

    # This function takes two strings stripped by their common pre and suffix,
    # and returns whether they differ by at most two by Levenshtein distance.
    # Because of this stripping, if they do indeed differ by at most two edits,
    # we know that those edits were (if at all) done at the start or the end,
    # while the middle has to have stayed the same. This fact is used in the
    # implementation.
    infixDifferAtMost2 = x: y:
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
        if diff == 2 then xinfix == y
        # A length difference of 1 can only be gotten with a deletion on the
        # right and a replacement on the left or vice versa.
        # Example: "abcdef" -> "bcdez" or "zbcde"
        else if diff == 1 then xinfix == ydelr || xinfix == ydell
        # No length difference can either happen through replacements on both
        # sides, or a deletion on the left and an insertion on the right or
        # vice versa
        # Example: "abcdef" -> "zbcdez" or "bcdefz" or "zabcde"
        else xinfix == yinfix || xdelr == ydell || xdell == ydelr;

    in k: if k <= 0 then a: b: a == b else
      let f = a: b:
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
        if alen < blen then f b a
        # If a has over k more characters than b, even with k deletes on a, b can't be reached
        else if alen - blen > k then false
        else if k == 1 then infixDifferAtMost1 ainfix binfix
        else if k == 2 then infixDifferAtMost2 ainfix binfix
        else levenshtein ainfix binfix <= k;
      in f;
}
