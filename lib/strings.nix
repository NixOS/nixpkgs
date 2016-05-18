/* String manipulation functions. */

let lib = import ./default.nix;

inherit (builtins) length;

in

rec {

  inherit (builtins) stringLength substring head tail isString replaceStrings;

  /* Concatenate a list of strings.

     Example:
       concatStrings ["foo" "bar"]
       => "foobar"
  */
  concatStrings =
    if builtins ? concatStringsSep then
      builtins.concatStringsSep ""
    else
      lib.foldl' (x: y: x + y) "";

  /* Map a function over a list and concatenate the resulting strings.

     Example:
       concatMapStrings (x: "a" + x) ["foo" "bar"]
       => "afooabar"
  */
  concatMapStrings = f: list: concatStrings (map f list);

  /* Like `concatMapStrings' except that the f functions also gets the
     position as a parameter.

     Example:
       concatImapStrings (pos: x: "${toString pos}-${x}") ["foo" "bar"]
       => "1-foo2-bar"
  */
  concatImapStrings = f: list: concatStrings (lib.imap f list);

  /* Place an element between each element of a list

     Example:
       intersperse "/" ["usr" "local" "bin"]
       => ["usr" "/" "local" "/" "bin"].
  */
  intersperse = separator: list:
    if list == [] || length list == 1
    then list
    else tail (lib.concatMap (x: [separator x]) list);

  /* Concatenate a list of strings with a separator between each element

     Example:
        concatStringsSep "/" ["usr" "local" "bin"]
        => "usr/local/bin"
  */
  concatStringsSep = builtins.concatStringsSep or (separator: list:
    concatStrings (intersperse separator list));

  /* First maps over the list and then concatenates it.

     Example:
        concatMapStringsSep "-" (x: toUpper x)  ["foo" "bar" "baz"]
        => "FOO-BAR-BAZ"
  */
  concatMapStringsSep = sep: f: list: concatStringsSep sep (map f list);

  /* First imaps over the list and then concatenates it.

     Example:

       concatImapStringsSep "-" (pos: x: toString (x / pos)) [ 6 6 6 ]
       => "6-3-2"
  */
  concatImapStringsSep = sep: f: list: concatStringsSep sep (lib.imap f list);

  /* Construct a Unix-style search path consisting of each `subDir"
     directory of the given list of packages.

     Example:
       makeSearchPath "bin" ["/root" "/usr" "/usr/local"]
       => "/root/bin:/usr/bin:/usr/local/bin"
       makeSearchPath "bin" ["/"]
       => "//bin"
  */
  makeSearchPath = subDir: packages:
    concatStringsSep ":" (map (path: path + "/" + subDir) packages);

  /* Construct a Unix-style search path, using given package output.
     If no output is found, fallback to `.out` and then to the default.

     Example:
       makeSearchPathOutput "dev" "bin" [ pkgs.openssl pkgs.zlib ]
       => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev/bin:/nix/store/wwh7mhwh269sfjkm6k5665b5kgp7jrk2-zlib-1.2.8/bin"
  */
  makeSearchPathOutput = output: subDir: pkgs: makeSearchPath subDir (map (lib.getOutput output) pkgs);

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


  /* Construct a perl search path (such as $PERL5LIB)

     FIXME(zimbatm): this should be moved in perl-specific code

     Example:
       pkgs = import <nixpkgs> { }
       makePerlPath [ pkgs.perlPackages.NetSMTP ]
       => "/nix/store/n0m1fk9c960d8wlrs62sncnadygqqc6y-perl-Net-SMTP-1.25/lib/perl5/site_perl"
  */
  makePerlPath = makeSearchPathOutput "lib" "lib/perl5/site_perl";

  /* Dependening on the boolean `cond', return either the given string
     or the empty string. Useful to contatenate against a bigger string.

     Example:
       optionalString true "some-string"
       => "some-string"
       optionalString false "some-string"
       => ""
  */
  optionalString = cond: string: if cond then string else "";

  /* Determine whether a string has given prefix.

     Example:
       hasPrefix "foo" "foobar"
       => true
       hasPrefix "foo" "barfoo"
       => false
  */
  hasPrefix = pref: str:
    substring 0 (stringLength pref) str == pref;

  /* Determine whether a string has given suffix.

     Example:
       hasSuffix "foo" "foobar"
       => false
       hasSuffix "foo" "barfoo"
       => true
  */
  hasSuffix = suff: str:
    let
      lenStr = stringLength str;
      lenSuff = stringLength suff;
    in lenStr >= lenSuff &&
       substring (lenStr - lenSuff) lenStr str == suff;

  /* Convert a string to a list of characters (i.e. singleton strings).
     This allows you to, e.g., map a function over each character.  However,
     note that this will likely be horribly inefficient; Nix is not a
     general purpose programming language. Complex string manipulations
     should, if appropriate, be done in a derivation.
     Also note that Nix treats strings as a list of bytes and thus doesn't
     handle unicode.

     Example:
       stringToCharacters ""
       => [ ]
       stringToCharacters "abc"
       => [ "a" "b" "c" ]
       stringToCharacters "💩"
       => [ "�" "�" "�" "�" ]
  */
  stringToCharacters = s:
    map (p: substring p 1 s) (lib.range 0 (stringLength s - 1));

  /* Manipulate a string character by character and replace them by
     strings before concatenating the results.

     Example:
       stringAsChars (x: if x == "a" then "i" else x) "nax"
       => "nix"
  */
  stringAsChars = f: s:
    concatStrings (
      map f (stringToCharacters s)
    );

  /* Escape occurrence of the elements of ‘list’ in ‘string’ by
     prefixing it with a backslash.

     Example:
       escape ["(" ")"] "(foo)"
       => "\\(foo\\)"
  */
  escape = list: replaceChars list (map (c: "\\${c}") list);

  /* Escape all characters that have special meaning in the Bourne shell.

     Example:
       escapeShellArg "so([<>])me"
       => "so\\(\\[\\<\\>\\]\\)me"
  */
  escapeShellArg = lib.escape (stringToCharacters "\\ ';$`()|<>\t*[]");

  /* Obsolete - use replaceStrings instead. */
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
  lowerChars = stringToCharacters "abcdefghijklmnopqrstuvwxyz";
  upperChars = stringToCharacters "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  /* Converts an ASCII string to lower-case.

     Example:
       toLower "HOME"
       => "home"
  */
  toLower = replaceChars upperChars lowerChars;

  /* Converts an ASCII string to upper-case.

     Example:
       toLower "home"
       => "HOME"
  */
  toUpper = replaceChars lowerChars upperChars;

  /* Appends string context from another string.  This is an implementation
     detail of Nix.

     Strings in Nix carry an invisible `context' which is a list of strings
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

     NOTE: this function is not performant and should never be used.

     Example:
       splitString "." "foo.bar.baz"
       => [ "foo" "bar" "baz" ]
       splitString "/" "/usr/local/bin"
       => [ "" "usr" "local" "bin" ]
  */
  splitString = _sep: _s:
    let
      sep = addContextFrom _s _sep;
      s = addContextFrom _sep _s;
      sepLen = stringLength sep;
      sLen = stringLength s;
      lastSearch = sLen - sepLen;
      startWithSep = startAt:
        substring startAt sepLen s == sep;

      recurse = index: startAt:
        let cutUntil = i: [(substring startAt (i - startAt) s)]; in
        if index < lastSearch then
          if startWithSep index then
            let restartAt = index + sepLen; in
            cutUntil index ++ recurse restartAt restartAt
          else
            recurse (index + 1) startAt
        else
          cutUntil sLen;
    in
      recurse 0 0;

  /* Return the suffix of the second argument if the first argument matches
     its prefix.

     Example:
       removePrefix "foo." "foo.bar.baz"
       => "bar.baz"
       removePrefix "xxx" "foo.bar.baz"
       => "foo.bar.baz"
  */
  removePrefix = pre: s:
    let
      preLen = stringLength pre;
      sLen = stringLength s;
    in
      if hasPrefix pre s then
        substring preLen (sLen - preLen) s
      else
        s;

  /* Return the prefix of the second argument if the first argument matches
     its suffix.

     Example:
       removeSuffix "front" "homefront"
       => "home"
       removeSuffix "xxx" "homefront"
       => "homefront"
  */
  removeSuffix = suf: s:
    let
      sufLen = stringLength suf;
      sLen = stringLength s;
    in
      if sufLen <= sLen && suf == substring (sLen - sufLen) sufLen s then
        substring 0 (sLen - sufLen) s
      else
        s;

  /* Return true iff string v1 denotes a version older than v2.

     Example:
       versionOlder "1.1" "1.2"
       => true
       versionOlder "1.1" "1.1"
       => false
  */
  versionOlder = v1: v2: builtins.compareVersions v2 v1 == 1;

  /* Return true iff string v1 denotes a version equal to or newer than v2.

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
     derivation's "name" attribute and extracts the version part from that
     argument.

     Example:
       getVersion "youtube-dl-2016.01.01"
       => "2016.01.01"
       getVersion pkgs.youtube-dl
       => "2016.01.01"
  */
  getVersion = x: (builtins.parseDrvName (x.name or x)).version;

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
      name = builtins.head (splitString sep filename);
    in assert name !=  filename; name;

  /* Create an --{enable,disable}-<feat> string that can be passed to
     standard GNU Autoconf scripts.

     Example:
       enableFeature true "shared"
       => "--enable-shared"
       enableFeature false "shared"
       => "--disable-shared"
  */
  enableFeature = enable: feat: "--${if enable then "enable" else "disable"}-${feat}";

  /* Create a fixed width string with additional prefix to match
     required width.

     Example:
       fixedWidthString 5 "0" (toString 15)
       => "00015"
  */
  fixedWidthString = width: filler: str:
    let
      strw = lib.stringLength str;
      reqWidth = width - (lib.stringLength filler);
    in
      assert strw <= width;
      if strw == width then str else filler + fixedWidthString reqWidth filler str;

  /* Format a number adding leading zeroes up to fixed width.

     Example:
       fixedWidthNumber 5 15
       => "00015"
  */
  fixedWidthNumber = width: n: fixedWidthString width "0" (toString n);

  /* Check whether a value is a store path.

     Example:
       isStorePath "/nix/store/d945ibfx9x185xf04b890y4f9g3cbb63-python-2.7.11/bin/python"
       => false
       isStorePath "/nix/store/d945ibfx9x185xf04b890y4f9g3cbb63-python-2.7.11/"
       => true
       isStorePath pkgs.python
       => true
  */
  isStorePath = x: builtins.substring 0 1 (toString x) == "/" && dirOf (builtins.toPath x) == builtins.storeDir;

  /* Convert string to int
     Obviously, it is a bit hacky to use fromJSON that way.

     Example:
       toInt "1337"
       => 1337
       toInt "-4"
       => -4
       toInt "3.14"
       => error: floating point JSON numbers are not supported
  */
  toInt = str:
    let may_be_int = builtins.fromJSON str; in
    if builtins.isInt may_be_int
    then may_be_int
    else throw "Could not convert ${str} to int.";

  /* Read a list of paths from `file', relative to the `rootPath'. Lines
     beginning with `#' are treated as comments and ignored. Whitespace
     is significant.

     NOTE: this function is not performant and should be avoided

     Example:
       readPathsFromFile /prefix
         ./pkgs/development/libraries/qt-5/5.4/qtbase/series
       => [ "/prefix/dlopen-resolv.patch" "/prefix/tzdir.patch"
            "/prefix/dlopen-libXcursor.patch" "/prefix/dlopen-openssl.patch"
            "/prefix/dlopen-dbus.patch" "/prefix/xdg-config-dirs.patch"
            "/prefix/nix-profiles-library-paths.patch"
            "/prefix/compose-search-path.patch" ]
  */
  readPathsFromFile = rootPath: file:
    let
      root = toString rootPath;
      lines =
        builtins.map (lib.removeSuffix "\n")
        (lib.splitString "\n" (builtins.readFile file));
      removeComments = lib.filter (line: !(lib.hasPrefix "#" line));
      relativePaths = removeComments lines;
      absolutePaths = builtins.map (path: builtins.toPath (root + "/" + path)) relativePaths;
    in
      absolutePaths;
}
