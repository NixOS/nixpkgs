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
    ;
  inherit (lib)
    attrByPath
    boolToString
    concatMapStrings
    filter
    getAttr
    isString
    mapAttrs
    pathExists
    readFile
    ;
  inherit (lib.filesystem)
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
    };
  _filter = fn: src: cleanSourceWith { filter = fn; inherit src; };

  # sources.union : Source -> Source -> Source
  # sources.union a b
  #
  # Combine the sources such that if a file occurs in a or b, it occurs in the
  # sources.union a b.
  #
  # The root of union a b will be equal that of a.
  # The root of b in union a b must be within the original source of a
  # and will be present in union a b.
  union = left: right:
    let
      l = toSourceAttributes (enforceSubpathInvariant left);
      r = toSourceAttributes (enforceSubpathInvariant right);
      valid =
        if pathHasPrefix l.origSrc r.origSrc
        then x: x
        else
          throw "sources.union: The right-hand side must be equal to, or a subpath of the left-hand side, but the input ${toString r.origSrc} is not a subpath of ${toString l.origSrc}.";
    in valid (
      fromSourceAttributes {
        inherit (l) origSrc;
        # TODO rule out filters that exclude a parent
        filter = path: type:
          l.filter path type                # path is in l
            || pathHasPrefix path r.origSrc # path leads up to r (always include because r.filter may not support paths above r.origSrc)
            || (                            # path is in r
              pathHasPrefix r.origSrc path
                && r.filter path type
            );
        name = "source";
      } // {
        satisfiesSubpathInvariant = true;
      }
    );

  # extend : SourceLike -> [SourceLike] -> Source
  # extend base extras : Source
  #
  # Produce a source that contains all the files in `base` and `extras` and
  # points at the location of `base`.
  extend = base: lib.foldl union base;

  # Identity of sources.union when it comes to the filter function
  empty = path: cleanSourceWith { src = path; filter = _: _: false; };

  # sources.reparent: Path -> Source -> Source
  # sources.reparent parent source
  #
  # Change source such that the root is at the parent directory, but include
  # nothing except source and the path leading up to it.
  reparent = path: source: union (empty path) source;

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
      ) // {
        satisfiesSubpathInvariant = src ? satisfiesSubpathInvariant && src.satisfiesSubpathInvariant;
      };

  setName = name: src: cleanSourceWith { inherit name src; };

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
    let
      isFiltered = src ? _isLibCleanSourceWith;
    in
    {
      # The original path
      origSrc = if isFiltered then src.origSrc else src;
      filter = if isFiltered then src.filter else _: _: true;
      name = if isFiltered then src.name else "source";
    };

  # (private) fromSourceAttributes : SourceAttrs -> Source
  #
  # Inverse of toSourceAttributes for Source objects.
  fromSourceAttributes = { origSrc, filter, name }:
    {
      _isLibCleanSourceWith = true;
      inherit origSrc filter name;
      outPath = builtins.path { inherit filter name; path = origSrc; };
    };

  # (private) enforceSubpathInvariant : Source -> Source
  #
  # Enforces
  #
  #   forall source, a, b.
  #   pathHasPrefix source.origSrc a -> source.filter (a + "/${b}") x -> source.filter a x
  #
  # which means filter only returns true for paths whose ancestry up to
  # origSrc is also included.
  #
  # This reflects the behavior of filterSource, which is sensible, composes
  # and provides good performance thanks to early cutoff.
  #
  # This invariant is useful in a function like sources.union, which sometimes
  # queries subpaths of excluded paths.
  #
  enforceSubpathInvariant = src:
    # Avoid memoization if the source claims to satisfy. Helps with chains of
    # nested sources.union calls.
    if src ? satisfiesSubpathInvariant && src.satisfiesSubpathInvariant
    then src
    else memoizeSource src;

  # (private) memoizeSource : Source -> Source
  #
  # Does the work of enforcing the subpath invariant, while avoiding recomputation.
  #
  # See enforceSubpathInvariant
  memoizeSource = src:
    let
      attrs = toSourceAttributes src;
    in
      if src?memoized && src.memoized
      then src
      else
        fromSourceAttributes (attrs // {
          filter = memoizeSourceFilter attrs.origSrc attrs.filter;
        }) // {
          memoized = true;
          satisfiesSubpathInvariant = true;
        };

  # See memoizeSource
  memoizeSourceFilter = origSrc: fn:
    let
      makeTree = dir:
        mapAttrs (key: type:
          let
            path' = dir + "/${key}";
          in
            if fn path' type
            then
              if type == "directory"
              then makeTree path'
              else true
            else false
         ) (builtins.readDir dir);

      # This is where the memoization happens
      tree = makeTree origSrc;
    in
      path: _type:
        attrByPath (absolutePathComponentsBetween origSrc path) false tree != false;

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

    empty
    extend
    reparent
    setName
    trace
    union
    ;
  filter = _filter;
}
