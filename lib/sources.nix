# Functions for copying sources to the Nix store.
{ lib }:

# Tested in lib/tests/sources.sh
let
  inherit (builtins)
    hasContext
    match
    readDir
    split
    storeDir
    tryEval
    typeOf
    ;
  inherit (lib)
    attrByPath
    boolToString
    concatMapStrings
    filter
    getAttr
    head
    isString
    mapAttrs
    pathExists
    readFile
    tail
    ;
  inherit (lib.strings)
    sanitizeDerivationName
    ;
  inherit (lib.filesystem)
    commonPath
    memoizePathFunction
    pathHasPrefix
    pathIntersects
    absolutePathComponentsBetween
    ;

  # Returns the type of a path: regular (for file), symlink, or directory
  pathType = p: getAttr (baseNameOf p) (readDir (dirOf p));

  # Returns true if the path exists and is a directory, false otherwise
  pathIsDirectory = p: if pathExists p then (pathType p) == "directory" else false;

  # Returns true if the path exists and is a regular file, false otherwise
  pathIsRegularFile = p: if pathExists p then (pathType p) == "regular" else false;

  # Bring in a path as a source, filtering out all Subversion and CVS
  # directories, as well as backup files (*~).
  cleanSourceFilter = name: type: let baseName = baseNameOf (toString name); in ! (
    # Filter out version control software files/directories
    (baseName == ".git" || type == "directory" && (baseName == ".svn" || baseName == "CVS" || baseName == ".hg")) ||
    # Filter out editor backup / swap files.
    lib.hasSuffix "~" baseName ||
    match "^\\.sw[a-z]$" baseName != null ||
    match "^\\..*\\.sw[a-z]$" baseName != null ||

    # Filter out generates files.
    lib.hasSuffix ".o" baseName ||
    lib.hasSuffix ".so" baseName ||
    # Filter out nix-build result symlinks
    (type == "symlink" && lib.hasPrefix "result" baseName)
  );

  # Filters a source tree removing version control files and directories using cleanSourceWith
  #
  # Example:
  #          cleanSource ./.
  cleanSource = src: cleanSourceWith { filter = cleanSourceFilter; inherit src; };

  # Like `builtins.filterSource`, except it will compose with itself,
  # allowing you to chain multiple calls together without any
  # intermediate copies being put in the nix store.
  #
  #     lib.cleanSourceWith {
  #       filter = f;
  #       src = lib.cleanSourceWith {
  #         filter = g;
  #         src = ./.;
  #       };
  #     }
  #     # Succeeds!
  #
  #     builtins.filterSource f (builtins.filterSource g ./.)
  #     # Fails!
  #
  # Parameters:
  #
  #   src:      A path or cleanSourceWith result to filter and/or rename.
  #
  #   filter:   A function (path -> type -> bool)
  #             Optional with default value: constant true (include everything)
  #             The function will be combined with the && operator such
  #             that src.filter is called lazily.
  #             The entire store path is filtered, including the files that are
  #             accessible via relative path from the subpath focused on by
  #             `focusAt` or `union`.
  #             For implementing a filter, see
  #             https://nixos.org/nix/manual/#builtin-filterSource
  #
  #   name:     Optional name to use as part of the store path.
  #             This defaults to `src.name` or otherwise `"source"`.
  #
  cleanSourceWith = { filter ? _path: _type: true, src, name ? null }:
    let
      orig = toSourceAttributes src;
    in fromSourceAttributes {
      inherit (orig) origSrc;
      filter = path: type: filter path type && orig.filter path type;
      name = if name != null then name else orig.name;
      subpath = orig.subpath;
    };
  _filter = fn: src: cleanSourceWith { filter = fn; inherit src; };

  /*
    Produce a source that contains all the files in `base` and `extras` and
    points at the location of `base`. The returned source will be a reference
    to a subpath of a store path when it is necessary to accomodate for the
    relative locations of `extras`.

    When used in the `stdenv` `src` parameter, the whole source will be copied
    and the build script will `cd` into the path that corresponds to `base`.

    The result will match the first argument with respect to the name and
    original location of the subpath (see `sources.focusAt`).

    Type:
      extend : SourceLike -> [SourceLike] -> Source
  */
  extend =
    # Source-like object that serves as the starting point. The path `"${extend base extras}"` points to the same file as `"${base}"`
    baseRaw:
    # List of sources that will also be included in the store path.
    extrasRaw:
    let
      baseAttrs = toSourceAttributes baseRaw;
      extrasAttrs = map toSourceAttributes extrasRaw;
      root = lib.foldl' (a: b: commonPath a b.origSrc) baseAttrs.origSrc extrasAttrs;
      sourcesIncludingPath =
        memoizePathFunction
          (path: type:
            if path == root
            then [ baseAttrs ] ++ extrasAttrs
            else filter
                  (attr: pathHasPrefix path attr.origSrc # path leads up to origSrc
                    || (pathHasPrefix attr.origSrc path && attr.filter path type))
                  (sourcesIncludingPath (dirOf path))
          )
          (path: throw "sources.extend: path does not exist: ${toString path}")
          root;
    in
      fromSourceAttributes {
        origSrc = root;
        filter = path: type: sourcesIncludingPath path != [];
        name = baseAttrs.name;
        subpath = absolutePathComponentsBetween root baseAttrs.origSrc ++ baseAttrs.subpath;
      };

  /*
    Almost the identity of sources.extend when it comes to the filter function;
    `extend` will always include the nodes that lead up to `path`.

    Type:
      empty :: Path -> Source
  */
  empty = path: cleanSourceWith { src = path; filter = _: _: false; };

  /*
    Produce a new source identical to `source` except its string interpolation
    (or `outPath`) resolves to a subpath that corresponds to `path`.

    When used in the `stdenv` `src` parameter, the whole of `source` will be
    copied and the build script will `cd` into the path that corresponds to `path`.

    Type:
      focusAt :: Path -> Source -> Source

    Example:
      # suppose we have files ./foo.json and ./bar/default.json
      src = sources.filter (path: type: type == "directory" || hasSuffix ".json" path) ./.
      "${src}/bar/default.json"
      => "/nix/store/pjn...-source/bar/default.json"
      #  ^ exists

      "${sources.focusAt ./bar src}/../foo.json"
      => "/nix/store/pjn...-source/bar/../foo.json"
      #  ^ exists; notice the store hash is the same

      # contrast with cutAt
      "${sources.cutAt ./bar src}/../foo.json"
      => "/nix/store/ls9...-source/../foo.json"
      #  ^ does not exist (resolves to /nix/store/foo.json)
  */
  focusAt = path: srcRaw:
    assert typeOf path == "path";
    let
      orig = toSourceAttributes srcRaw;
      valid =
        if ! pathHasPrefix orig.origSrc path
        then throw "sources.focusAt: new path is must be a subpath (or self) of the original source directory. But ${toString path} is not a subpath (or self) of ${toString orig.origSrc}"
        else if ! pathExists path
        then
          # We could provide a function that allows this, but it seems to be a
          # bad idea unless we encounter a _good_ use case.
          throw "sources.focusAt: new path ${toString path} does not exist on the filesystem and would point to a file that doesn't exist in the store. This is usually a mistake."
        else if ! orig.filter path (pathType path)
        then
          throw "sources.focusAt: new path ${toString path} is not actually included in the source. Potential causes include an incorrect path, incorrect filter function or a forgotten sources.extend call."
        else x: x;
    in
      valid (fromSourceAttributes (orig // {
        subpath = absolutePathComponentsBetween orig.origSrc path;
       }));

  /*
    Returns the original path that is copied and returned by `"${src}"`.
    This may be a subpath of a store path, for example when `src` was created
    with `focusAt` or `extend`.

    Type: sourceLike -> Path

    Example:

      getOriginalFocusPath
        (extend
          (cleanSource ./src)
          [ ./README.md ]
        )
      == ./src
   */
  getOriginalFocusPath = srcRaw:
    let
      srcAttrs = toSourceAttributes srcRaw;
    in srcAttrs.origSrc + "${concatMapStrings (x: "/${x}") srcAttrs.subpath}";

  /*
    Produces a source that starts at `path` and only contains nodes that are in `src`.

    Type:
      cutAt :: Path -> SourceLike -> Source

    Example:
      # suppose we have files ./foo.json and ./bar/default.json
      src = sources.filter (path: type: type == "directory" || hasSuffix ".json" path) ./.
      "${src}/bar/default.json"
      => "/nix/store/pjn...-source/bar/default.json"
      #  ^ exists

      "${sources.cutAt ./bar src}/default.json"
      => "/nix/store/ls9...-source/default.json"
      #  ^ exists, hash is not sensitive to foo.json

      # contrast with focusAt
      "${sources.focusAt ./bar src}/../foo.json"
      => "/nix/store/pjn...-source/bar/../foo.json"
      #  ^ exists, hash is sensitive to both file hashes
  */
  cutAt =
    # The path that will form the new root of the source
    path:
    # A sourcelike that determines which nodes will be included, starting at `path`
    srcRaw:
    assert typeOf path == "path";
    let
      orig = toSourceAttributes srcRaw;
      valid =
        if ! pathHasPrefix orig.origSrc path
        then throw "sources.cutAt: new source root must be a subpath (or self) of the original source directory. But ${toString path} is not a subpath (or self) of ${toString orig.origSrc}"
        else if ! pathExists path
        then
          throw "sources.cutAt: new source root ${toString path} does not exist."
        else if ! orig.filter path (pathType path)
        then
          throw "sources.cutAt: new path ${toString path} is not actually included in the source. Potential causes include an incorrect path, incorrect filter function or a forgotten sources.extend call."
        else x: x;
    in
      valid (
        fromSourceAttributes (orig // {
          origSrc = path;
          subpath = [];
        })
      );

  /*
    Change source such that the root is at the `parent` directory, but include
    nothing except source and the path leading up to it.

    Type:
      sources.reparent :: Path -> SourceLike -> Source

  */
  reparent = path: source: extend (empty path) [source];

  /*
    Add logging to a source, for troubleshooting the filtering behavior.
    Type:
      sources.trace :: sourceLike -> Source
  */
  trace =
    # Source to debug. The returned source will behave like this source, but also log its filter invocations.
    src:
    let
      attrs = toSourceAttributes src;
    in
      fromSourceAttributes (
        attrs // {
          filter = path: type:
            let
              r = attrs.filter path type;
            in
              builtins.trace "${attrs.name}.filter ${path} = ${boolToString r}" r;
        }
      );

  /*
    Change the name of a source; the part after the hash in the store path.

    NOTE: `lib.sources` defaults to `source`. It is tempting to name it after the
    last path component, but this was a bad default that led to unreproducable
    store paths when the same directory contents were read from a different
    location.

    Type: sources.setName :: String -> SourceLike -> Source

    Example:
      src = with sources; setName "fizzbuzz"
              (filter (path: type: !lib.hasSuffix ".nix" path) ./.);
      "${src}"
      => "/nix/store/cafri8rrc2bc1yvrsbmg5w6ci8rbqvzs-fizzbuzz""${src}"

      src2 = sources.setName "easypeasy" ./.;
      "${src2}"
      => "/nix/store/crvhqahzla2nxxyilzigwki5bkf7nfpc-easypeasy"
    */
  setName =
    # A string that will be the new name. It will be passed to `lib.sanitizeDerivationName`
    name:
    # A source-like value
    src:
    cleanSourceWith { name = sanitizeDerivationName name; inherit src; };

  # Filter sources by a list of regular expressions.
  #
  # E.g. `src = sourceByRegex ./my-subproject [".*\.py$" "^database.sql$"]`
  sourceByRegex = src: regexes:
    let
      isFiltered = src ? _isLibCleanSourceWith;
      origSrc = if isFiltered then src.origSrc else src;
    in lib.cleanSourceWith {
      filter = (path: type:
        let relPath = lib.removePrefix (toString origSrc + "/") (toString path);
        in lib.any (re: match re relPath != null) regexes);
      inherit src;
    };

  /*
    Get all files ending with the specified suffices from the given
    source directory or its descendants, omitting files that do not match
    any suffix. The result of the example below will include files like
    `./dir/module.c` and `./dir/subdir/doc.xml` if present.

    Type: sourceLike -> [String] -> Source

    Example:
      sourceFilesBySuffices ./. [ ".xml" ".c" ]
  */
  sourceFilesBySuffices =
    # Path or source containing the files to be returned
    src:
    # A list of file suffix strings
    exts:
    let filter = name: type:
      let base = baseNameOf (toString name);
      in type == "directory" || lib.any (ext: lib.hasSuffix ext base) exts;
    in cleanSourceWith { inherit filter src; };

  pathIsGitRepo = path: (tryEval (commitIdFromGitRepo path)).success;

  # Get the commit id of a git repo
  # Example: commitIdFromGitRepo <nixpkgs/.git>
  commitIdFromGitRepo =
    let readCommitFromFile = file: path:
        let fileName       = toString path + "/" + file;
            packedRefsName = toString path + "/packed-refs";
            absolutePath   = base: path:
              if lib.hasPrefix "/" path
              then path
              else toString (/. + "${base}/${path}");
        in if pathIsRegularFile path
           # Resolve git worktrees. See gitrepository-layout(5)
           then
             let m   = match "^gitdir: (.*)$" (lib.fileContents path);
             in if m == null
                then throw ("File contains no gitdir reference: " + path)
                else
                  let gitDir      = absolutePath (dirOf path) (lib.head m);
                      commonDir'' = if pathIsRegularFile "${gitDir}/commondir"
                                    then lib.fileContents "${gitDir}/commondir"
                                    else gitDir;
                      commonDir'  = lib.removeSuffix "/" commonDir'';
                      commonDir   = absolutePath gitDir commonDir';
                      refFile     = lib.removePrefix "${commonDir}/" "${gitDir}/${file}";
                  in readCommitFromFile refFile commonDir

           else if pathIsRegularFile fileName
           # Sometimes git stores the commitId directly in the file but
           # sometimes it stores something like: «ref: refs/heads/branch-name»
           then
             let fileContent = lib.fileContents fileName;
                 matchRef    = match "^ref: (.*)$" fileContent;
             in if  matchRef == null
                then fileContent
                else readCommitFromFile (lib.head matchRef) path

           else if pathIsRegularFile packedRefsName
           # Sometimes, the file isn't there at all and has been packed away in the
           # packed-refs file, so we have to grep through it:
           then
             let fileContent = readFile packedRefsName;
                 matchRef = match "([a-z0-9]+) ${file}";
                 isRef = s: isString s && (matchRef s) != null;
                 # there is a bug in libstdc++ leading to stackoverflow for long strings:
                 # https://github.com/NixOS/nix/issues/2147#issuecomment-659868795
                 refs = filter isRef (split "\n" fileContent);
             in if refs == []
                then throw ("Could not find " + file + " in " + packedRefsName)
                else lib.head (matchRef (lib.head refs))

           else throw ("Not a .git directory: " + path);
    in readCommitFromFile "HEAD";

  pathHasContext = builtins.hasContext or (lib.hasPrefix storeDir);

  canCleanSource = src: src ? _isLibCleanSourceWith || !(pathHasContext (toString src));

  # -------------------------------------------------------------------------- #
  # Internal functions
  #

  # (private) toSourceAttributes : sourceLike -> SourceAttrs
  #
  # Convert any source-like object into a simple, singular representation.
  # We don't expose this representation in order to avoid having a fifth path-
  # like class of objects in the wild.
  # (Existing ones being: paths, strings, sources and x//{outPath})
  # So instead of exposing internals, we build a library of combinator functions.
  toSourceAttributes = src:
    if src ? _isLibCleanSourceWith
    then {
      inherit (src) origSrc filter name subpath;
    }
    else if typeOf src == "path" then
      if builtins.pathExists src
      then {
        origSrc = src;
        filter = _: _: true;
        name = "source";
        subpath = [];
      }
      else throw ''
        Path does not exist while attempting to construct a source.
        path: ${toString src}''
    else if typeOf src == "string" then
      if pathHasContext src then
        throw ''
          Path may require a build while attempting to construct a source.
          Using a build output like this is usually a bad idea because it blocks
          the evaluation process for the duration of the build. It's often better
          to filter built "sources" in a derivation than in an expression.
          path string: ${src}''
      else
        toSourceAttributes (/. + src)
    else if src ? outPath && typeOf src.outPath == "path" then
      # Sometimes, path-like attrsets are constructed to augment a path with
      # a bit of metadata.
      toSourceAttributes src.outPath
    else
      throw "A value of type ${typeOf src} can not be automatically converted to a source.";

  # (private) fromSourceAttributes : SourceAttrs -> Source
  #
  # Inverse of toSourceAttributes for Source objects.
  fromSourceAttributes = { origSrc, filter, name, subpath }:
    let
      root = builtins.path { inherit filter name; path = origSrc; };
    in {
      _isLibCleanSourceWith = true;
      inherit origSrc filter name subpath root;
      outPath = root + "${concatMapStrings (x: "/${x}") subpath}";
    };

in {
  inherit
    pathType
    pathIsDirectory
    pathIsRegularFile

    pathIsGitRepo
    commitIdFromGitRepo

    cleanSource
    cleanSourceWith
    cleanSourceFilter
    pathHasContext
    canCleanSource

    sourceByRegex
    sourceFilesBySuffices
    ;

  # part of the interface meant to be referenced as source.* or localized
  # let inherit.
  inherit
    # combinators
    cutAt
    empty
    extend
    focusAt
    reparent
    setName
    trace

    # getters
    getOriginalFocusPath
    ;

  /*
    Use a function to remove files, directories, etc from a source.

    By reducing the number of files that are available to a derivation, more
    evaluations will result in the same hash and therefore do not need to be
    rebuilt.

    This function is similar to `builtins.filterSource`, but more useful
    because it returns a `Source` object that can be used by the other functions
    in `lib.sources`.

    When nesting `sources.filter` calls, the inner call's predicate is respected
    by combining it with the && operator. If you want the opposite effect, the
    `sources.extend` function may be of interest.

    Type: sources.filter :: (Path -> TypeString -> Bool) -> SourceLike -> Source

    Example:
      src = lib.sources.filter (path: type: !lib.hasSuffix ".nix" path) ./.;
      "${src}"
      => "/nix/store/cdklw7jpc3ffjxhvpzwl5aaysay07z0y-source"
      src2 = lib.sources.filter (path: type: type == "directory" || lib.hasSuffix ".json" path)
      "${src2}"
      => "/nix/store/j7l6s884ngkdzzsnw8k3zxflsi6ax492-source"
  */
  filter = _filter;
}
