/** \file strings.nix
 * String manipulation functions.
 */
{ lib }:
let

inherit (builtins) length;
/** @private */
in
rec {

  inherit (builtins) stringLength substring head tail isString replaceStrings;

  /**
  * @hideinitializer
  * @brief Concatenate a list of strings
  * @param [string] strings
  * @code
       Example:
       concatStrings ["foo" "bar"]
       => "foobar"
  * @endcode
  */
  concatStrings = builtins.concatStringsSep "";

  /**
  * @hideinitializer
  * @brief Map a function over a list and concatenate the resulting strings.
  * @param func f
  * @param [] list
  * @code
      Example:
        concatMapStrings (x: "a" + x) ["foo" "bar"]
        => "afooabar"
  * @endcode
  */
  concatMapStrings = f: list: concatStrings (map f list);

  /**
  * @hideinitializer
  * @brief Like #concatMapStrings except that the f functions also gets the
  *   position as a parameter.
  * @param func f
  * @param [string] list
  * @code
      Example:
        concatImapStrings (pos: x: "${toString pos}-${x}") ["foo" "bar"]
        => "1-foo2-bar"
  * @endcode
  */
  concatImapStrings = f: list: concatStrings (lib.imap1 f list);

  /**
  * @hideinitializer
  * @brief Place an element between each element of a list
  * @param string separator
  * @param [string] list
  * @code
       Example:
         concatStringsSep "/" ["usr" "local" "bin"]
          => "usr/local/bin"
  * @endcode
  */
  intersperse = separator: list:
    if list == [] || length list == 1
    then list
    else tail (lib.concatMap (x: [separator x]) list);

  /**
  * @hideinitializer
  * @brief Concatenate a list of strings with a separator between each element
  * @param string sep
  * @param [string] list
  * @code
  *     Example:
  *     concatStringsSep "/" ["usr" "local" "bin"]
  *      => "usr/local/bin"
  * @endcode
  */
  concatStringsSep = builtins.concatStringsSep or (separator: list:
    concatStrings (intersperse separator list));

  /**
  * @hideinitializer
  * @brief First maps over the list and then concatenates it.
  * @param string sep
  * @param func f
  * @param [string] list
  * @code
      Example:
        concatMapStringsSep "-" (x: toUpper x)  ["foo" "bar" "baz"]
        => "FOO-BAR-BAZ"
  * @endcode
  */
  concatMapStringsSep = sep: f: list: concatStringsSep sep (map f list);

  /**
  * @hideinitializer
  * @brief First imaps over the list and then concatenates it.
  * @param string sep
  * @param func f
  * @param [] list
  * @code
      Example:
        concatImapStringsSep "-" (pos: x: toString (x / pos)) [ 6 6 6 ]
        => "6-3-2"
  * @endcode
  */
  concatImapStringsSep = sep: f: list: concatStringsSep sep (lib.imap1 f list);

  /**
  * @hideinitializer
  * @brief Construct a Unix-style search path consisting of each `subDir"
     directory of the given list of packages.
  * @param string subDir
  * @param [string] packages
  * @code
     Example:
       makeSearchPath "bin" ["/root" "/usr" "/usr/local"]
       => "/root/bin:/usr/bin:/usr/local/bin"
       makeSearchPath "bin" ["/"]
       => "//bin"
  * @endcode
  */
  makeSearchPath = subDir: packages:
    concatStringsSep ":" (map (path: path + "/" + subDir) packages);

  /**
  * @hideinitializer
  * @brief Construct a Unix-style search path, using given package output.
     If no output is found, fallback to `.out` and then to the default.
  * @param string output
  * @param string subDir
  * @param [string] pkgs
  * @code
      Example:
        makeSearchPathOutput "dev" "bin" [ pkgs.openssl pkgs.zlib ]
        => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev/bin:/nix/store/wwh7mhwh269sfjkm6k5665b5kgp7jrk2-zlib-1.2.8/bin"
  * @endcode
  */
  makeSearchPathOutput = output: subDir: pkgs: makeSearchPath subDir (map (lib.getOutput output) pkgs);

  /**
  * @hideinitializer
  * @brief Construct a library search path (such as RPATH) containing the
     libraries for a set of packages
  * @param [string] pkgs
  * @code
      Example:
        makeLibraryPath [ "/usr" "/usr/local" ]
        => "/usr/lib:/usr/local/lib"
        pkgs = import <nixpkgs> { }
        makeLibraryPath [ pkgs.openssl pkgs.zlib ]
        => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r/lib:/nix/store/wwh7mhwh269sfjkm6k5665b5kgp7jrk2-zlib-1.2.8/lib"
  * @endcode
  */
  makeLibraryPath = makeSearchPathOutput "lib" "lib";

  /**
  * @hideinitializer
  * @brief Construct a binary search path (such as $PATH) containing the
     binaries for a set of packages.
  * @param string _sep
  * @param string _s
  * @code
      Example:
        makeBinPath ["/root" "/usr" "/usr/local"]
        => "/root/bin:/usr/bin:/usr/local/bin"
  * @endcode
  */
  makeBinPath = makeSearchPathOutput "bin" "bin";

  /**
  * @hideinitializer
  * @brief Construct a binary search path (such as $PATH) containing the
     binaries for a set of packages.
  * @todo FIXME(zimbatm): this should be moved in perl-specific code
  * @param string _sep
  * @param string _s
  * @code
      Example:
        pkgs = import <nixpkgs> { }
        makePerlPath [ pkgs.perlPackages.NetSMTP ]
        => "/nix/store/n0m1fk9c960d8wlrs62sncnadygqqc6y-perl-Net-SMTP-1.25/lib/perl5/site_perl"
  * @endcode
  */
  makePerlPath = makeSearchPathOutput "lib" "lib/perl5/site_perl";

  /**
  * @hideinitializer
  * @brief Return `string` if true, else ""
  * @details Depending on the boolean `cond', return either the given string
  *   or the empty string. Useful to concatenate against a bigger string.
  * @param bool cond
  * @param string string
  * @code
    Example:
      optionalString true "some-string"
      => "some-string"
      optionalString false "some-string"
      => ""
  * @endcode
  */
  optionalString = cond: string: if cond then string else "";

  /**
  * @hideinitializer
  * @brief Determine whether a string has given prefix.
  * @param string pref
  * @param string str
  * @code
    Example:
      hasPrefix "foo" "foobar"
      => true
      hasPrefix "foo" "barfoo"
      => false
  * @endcode
  */
  hasPrefix = pref: str:
    substring 0 (stringLength pref) str == pref;


  /**
  * @hideinitializer
  * @brief Determine whether a string has given suffix.
  * @param string suffix
  * @param string content
  * @code
      Example:
        concatMapStrings (x: "a" + x) ["foo" "bar"]
        => "afooabar"
  * @endcode
  */
  hasSuffix = suffix: content:
    let
      lenContent = stringLength content;
    /** @cond EXCLUDE_THIS */
      lenSuffix = stringLength suffix;
    in lenContent >= lenSuffix &&
       substring (lenContent - lenSuffix) lenContent content == suffix;
    /** @endcond */

  /**
  * @hideinitializer
  * @brief Convert a string to a list of characters (i.e. singleton strings).
  * @details This allows you to, e.g., map a function over each character.  However,
     note that this will likely be horribly inefficient; Nix is not a
     general purpose programming language. Complex string manipulations
     should, if appropriate, be done in a derivation.
     Also note that Nix treats strings as a list of bytes and thus doesn't
     handle unicode.
  * @param string s
  * @code
    Example:
      stringToCharacters ""
      => [ ]
      stringToCharacters "abc"
      => [ "a" "b" "c" ]
      stringToCharacters "💩"
      => [ "�" "�" "�" "�" ]
  * @endcode
  */
  stringToCharacters = s:
    map (p: substring p 1 s) (lib.range 0 (stringLength s - 1));

  /**
  * @hideinitializer
  * @brief Manipulate a string character by character and replace them by
     strings before concatenating the results.
  * @param func f
  * @param string s
  * @code
     Example:
       stringAsChars (x: if x == "a" then "i" else x) "nax"
       => "nix"
  * @endcode
  */
  stringAsChars = f: s:
    concatStrings (
      map f (stringToCharacters s)
    );

  /**
  * @hideinitializer
  * @brief Escape occurrence of the elements of ‘list’ in ‘string’ by
     prefixing it with a backslash.
  * @param [string] list
  * @param string s
  * @code
     Example:
       escape ["(" ")"] "(foo)"
       => "\\(foo\\)"
  * @endcode
  */
  escape = list: replaceChars list (map (c: "\\${c}") list);

  /**
  * @hideinitializer
  * @brief Quote string to be used safely within the Bourne shell.
  * @param string s
  * @code
     Example:
       escapeShellArg "esc'ape\nme"
       => "'esc'\\''ape\nme'"
  * @endcode
  */
  escapeShellArg = arg: "'${replaceStrings ["'"] ["'\\''"] (toString arg)}'";

  /**
  * @hideinitializer
  * @brief Quote all arguments to be safely passed to the Bourne shell.
  * @param [string] list
  * @code
     Example:
       escapeShellArgs ["one" "two three" "four'five"]
       => "'one' 'two three' 'four'\\''five'"
  * @endcode
  */
  escapeShellArgs = concatMapStringsSep " " escapeShellArg;

  /**
  * @hideinitializer
  * @brief Turn a string into a Nix expression representing that string
  * @param string s
  * @code
     Example:
       escapeNixString "hello\${}\n"
       => "\"hello\\\${}\\n\""
  * @endcode
  */
  escapeNixString = s: escape ["$"] (builtins.toJSON s);

  /**
  * @hideinitializer
  * @warning Obsolete - use replaceStrings instead.
  */
  replaceChars = builtins.replaceStrings or (
    del: new: s:
    let
      substList = lib.zipLists del new;
      subst = c:
        let found = lib.findFirst (sub: sub.fst == c) null substList; in
        if found == null then
          c
        else
          found.snd;
    in
      stringAsChars subst s);

  # Case conversion utilities.
  /**
  * @hideinitializer
  * @brief Convert char list to lowercase
  * @param [char] list
  */
  lowerChars = stringToCharacters "abcdefghijklmnopqrstuvwxyz";
  /**
  * @hideinitializer
  * @brief Convert char list to uppercase
  * @param [char] list
  */
  upperChars = stringToCharacters "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  /**
  * @hideinitializer
  * @brief Converts an ASCII string to lower-case.
  * @param string s
  * @code
     Example:
       toLower "HOME"
       => "home"
  * @endcode
  */
  toLower = replaceChars upperChars lowerChars;

  /**
  * @hideinitializer
  * @brief Converts an ASCII string to upper-case.
  * @param string s
  * @code
     Example:
       toUpper "home"
       => "HOME"
  * @endcode
  */
  toUpper = replaceChars lowerChars upperChars;

  /**
  * @hideinitializer
  * @brief Appends string context from another string.  This is an implementation
     detail of Nix.
  * @detail Strings in Nix carry an invisible `context' which is a list of strings
     representing store paths.  If the string is later used in a derivation
     attribute, the derivation will properly populate the inputDrvs and
     inputSrcs.
  * @param ctx a
  * @param string b
  * @code
     Example:
       pkgs = import <nixpkgs> { };
       addContextFrom pkgs.coreutils "bar"
       => "bar"
  * @endcode
  */
  addContextFrom = a: b: substring 0 0 a + b;

  /**
  * @hideinitializer
  * @brief Cut a string with a separator and produces a list of strings which
     were separated by this separator.
  * @warning This function is not performant and should never be used.
  * @param string _sep
  * @param string _s
  * @code
      Example:
        splitString "." "foo.bar.baz"
        => [ "foo" "bar" "baz" ]
        splitString "/" "/usr/local/bin"
        => [ "" "usr" "local" "bin" ]
  * @endcode
  */
  splitString = _sep: _s:
    let
      sep = addContextFrom _s _sep;
    /** @cond EXCLUDE_THIS */
      s = addContextFrom _sep _s;
      sepLen = stringLength sep;
      sLen = stringLength s;
      lastSearch = sLen - sepLen;
      startWithSep = startAt:
        substring startAt sepLen s == sep;
      recurse = index: startAt:
        let cutUntil = i: [(substring startAt (i - startAt) s)]; in
        if index <= lastSearch then
          if startWithSep index then
            let restartAt = index + sepLen; in
            cutUntil index ++ recurse restartAt restartAt
          else
            recurse (index + 1) startAt
        else
          cutUntil sLen;
    in
      recurse 0 0;
    /** @endcond */

  /**
  * @hideinitializer
  * @brief Return the suffix of the second argument if the first argument matches
     its prefix.
  * @param string prefix
  * @param string str
  * @code
     Example:
       removePrefix "foo." "foo.bar.baz"
       => "bar.baz"
       removePrefix "xxx" "foo.bar.baz"
       => "foo.bar.baz"
  * @endcode
  */
  removePrefix = pre: s:
    let
      preLen = stringLength pre;
      /** @cond EXCLUDE_THIS */
      sLen = stringLength s;
    in
      if hasPrefix pre s then
        substring preLen (sLen - preLen) s
      else
        s;
      /** @endcond */

  /**
  * @hideinitializer
  * @brief Return the prefix of the second argument if the first argument matches
     its suffix.
  * @param string suffix
  * @param string str
  * @code
     Example:
       removeSuffix "front" "homefront"
       => "home"
       removeSuffix "xxx" "homefront"
       => "homefront"
  * @endcode
  */
  removeSuffix = suf: s:
    let
      sufLen = stringLength suf;
    /** @cond EXCLUDE_THIS*/
      sLen = stringLength s;
    in
      if sufLen <= sLen && suf == substring (sLen - sufLen) sufLen s then
        substring 0 (sLen - sufLen) s
      else
        s;
    /* @endcond */

  /**
  * @hideinitializer
  * @brief Return true iff string v1 denotes a version older than v2.
  * @param string v1
  * @param string v2
  * @code
     Example:
       versionOlder "1.1" "1.2"
       => true
       versionOlder "1.1" "1.1"
       => false
  * @endcode
  */
  versionOlder = v1: v2: builtins.compareVersions v2 v1 == 1;

  /**
  * @hideinitializer
  * @brief Return true iff string v1 denotes a version equal to or newer than v2.
  * @param string v1
  * @param string v2
  * @code
     Example:
       versionAtLeast "1.1" "1.0"
       => true
       versionAtLeast "1.1" "1.1"
       => true
       versionAtLeast "1.1" "1.2"
       => false
  * @endcode
  */
  versionAtLeast = v1: v2: !versionOlder v1 v2;

  /**
  * @hideinitializer
  * @brief Return version from derivation name
  * @details This function takes an argument that's either a derivation or a
     derivation's "name" attribute and extracts the version part from that
     argument.
  * @param string name
  * @code
    Example:
       getVersion "youtube-dl-2016.01.01"
       => "2016.01.01"
       getVersion pkgs.youtube-dl
       => "2016.01.01"
  * @endcode
  */
  getVersion = x:
   let
     parse = drv: (builtins.parseDrvName drv).version;
    /** @cond EXCLUDE_THIS */
   in if isString x
      then parse x
      else x.version or (parse x.name);
    /** @endcond */

  /**
  * @hideinitializer
  * @brief Extract name with version from URL. Ask for separator which is
     supposed to start extension.
  * @param string url
  * @param string sep
  * @code
     Example:
       nameFromURL "https://nixos.org/releases/nix/nix-1.7/nix-1.7-x86_64-linux.tar.bz2" "-"
       => "nix"
       nameFromURL "https://nixos.org/releases/nix/nix-1.7/nix-1.7-x86_64-linux.tar.bz2" "_"
       => "nix-1.7-x86"
  * @endcode
  */
  nameFromURL = url: sep:
    let
      components = splitString "/" url;
      /** @cond EXCLUDE_THIS */
      filename = lib.last components;
      name = builtins.head (splitString sep filename);
    in assert name !=  filename; name;
      /** @endcond */

  /**
  * @hideinitializer
  * @brief Create an --{enable,disable}-<feat> string that can be passed to
     standard GNU Autoconf scripts.
  * @param bool enable
  * @param string feature
  * @code
     Example:
       enableFeature true "shared"
       => "--enable-shared"
       enableFeature false "shared"
       => "--disable-shared"
  * @endcode
  */
  enableFeature = enable: feat: "--${if enable then "enable" else "disable"}-${feat}";

  /**
  * @hideinitializer
  * @brief Create a fixed width string with additional prefix to match
     required width.
  * @param int width
  * @param string filler
  * @param string str
  * @code
     Example:
       fixedWidthString 5 "0" (toString 15)
       => "00015"
  * @endcode
  */
  fixedWidthString = width: filler: str:
    let
      strw = lib.stringLength str;
    /** @cond EXCLUDE_THIS */
      reqWidth = width - (lib.stringLength filler);
    in
      assert strw <= width;
      if strw == width then str else filler + fixedWidthString reqWidth filler str;
    /** @endcond */

  /**
  * @hideinitializer
  * @brief Format a number adding leading zeroes up to fixed width.
  * @param int width
  * @param int num
  * @code
     Example:
       fixedWidthNumber 5 15
       => "00015"
  * @endcode
  */
  fixedWidthNumber = width: n: fixedWidthString width "0" (toString n);

  /**
  * @hideinitializer
  * @brief Check whether a value is a store path.
  * @param string path
  * @code
     Example:
       isStorePath "/nix/store/d945ibfx9x185xf04b890y4f9g3cbb63-python-2.7.11/bin/python"
       => false
       isStorePath "/nix/store/d945ibfx9x185xf04b890y4f9g3cbb63-python-2.7.11/"
       => true
       isStorePath pkgs.python
       => true
       isStorePath [] || isStorePath 42 || isStorePath {} || …
       => false
  * @endcode
  */
  isStorePath = x:
       builtins.isString x
    && builtins.substring 0 1 (toString x) == "/"
    && dirOf (builtins.toPath x) == builtins.storeDir;

  /**
  * @hideinitializer
  * @brief Convert string to int
  * @remark (internal) Obviously, it is a bit hacky to use fromJSON that way.
  * @param string str
  * @code
     Example:
       toInt "1337"
       => 1337
       toInt "-4"
       => -4
       toInt "3.14"
       => error: floating point JSON numbers are not supported
  * @endcode
  */
  toInt = str:
    let
      may_be_int = builtins.fromJSON str;
    /** @cond EXCLUDE_THIS */
    in
      if builtins.isInt may_be_int
      then may_be_int
      else throw "Could not convert ${str} to int.";
    /** @endcond */


  /**
  * @hideinitializer
  * @brief Read a list of paths from `file', relative to the `rootPath'. Lines
     beginning with `#' are treated as comments and ignored. Whitespace
     is significant.
  * @param string rootpath
  * @param string file
  * @code
     Example:
       readPathsFromFile /prefix
         ./pkgs/development/libraries/qt-5/5.4/qtbase/series
       => [ "/prefix/dlopen-resolv.patch" "/prefix/tzdir.patch"
            "/prefix/dlopen-libXcursor.patch" "/prefix/dlopen-openssl.patch"
            "/prefix/dlopen-dbus.patch" "/prefix/xdg-config-dirs.patch"
            "/prefix/nix-profiles-library-paths.patch"
            "/prefix/compose-search-path.patch" ]
  * @endcode
  */
  readPathsFromFile = rootPath: file:
    let
      root = toString rootPath;
    /** @cond EXCLUDE_THIS */
      lines = lib.splitString "\n" (builtins.readFile file);
      removeComments = lib.filter (line: line != "" && !(lib.hasPrefix "#" line));
      relativePaths = removeComments lines;
      absolutePaths = builtins.map (path: builtins.toPath (root + "/" + path)) relativePaths;
    in
      absolutePaths;
    /** @endcond */

  /**
  * @hideinitializer
  * @brief Read the contents of a file removing the trailing '\\n'
  * @param string file
  * @code
     Example:
       $ echo "1.0" > ./version

       fileContents ./version
       => "1.0"
  * @endcode
  */
  fileContents = file: removeSuffix "\n" (builtins.readFile file);
}
