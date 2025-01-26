# Functions for copying sources to the Nix store.
{ lib }:

# Tested in lib/tests/sources.sh
let
  inherit (builtins)
    match
    split
    storeDir
    ;
  inherit (lib)
    boolToString
    filter
    isString
    readFile
    ;
  inherit (lib.filesystem)
    pathIsRegularFile
    ;

  /*
    A basic filter for `cleanSourceWith` that removes
    directories of version control system, backup files (*~)
    and some generated files.
  */
  cleanSourceFilter =
    name: type:
    let
      baseName = baseNameOf (toString name);
    in
    !(
      # Filter out version control software files/directories
      (
        baseName == ".git"
        || type == "directory" && (baseName == ".svn" || baseName == "CVS" || baseName == ".hg")
      )
      ||
        # Filter out editor backup / swap files.
        lib.hasSuffix "~" baseName
      || match "^\\.sw[a-z]$" baseName != null
      || match "^\\..*\\.sw[a-z]$" baseName != null
      ||

        # Filter out generates files.
        lib.hasSuffix ".o" baseName
      || lib.hasSuffix ".so" baseName
      ||
        # Filter out nix-build result symlinks
        (type == "symlink" && lib.hasPrefix "result" baseName)
      ||
        # Filter out sockets and other types of files we can't have in the store.
        (type == "unknown")
    );

  /*
    Filters a source tree removing version control files and directories using cleanSourceFilter.

    Example:
             cleanSource ./.
  */
  cleanSource =
    src:
    cleanSourceWith {
      filter = cleanSourceFilter;
      inherit src;
    };

  /*
    Like `builtins.filterSource`, except it will compose with itself,
    allowing you to chain multiple calls together without any
    intermediate copies being put in the nix store.

    Example:
        lib.cleanSourceWith {
          filter = f;
          src = lib.cleanSourceWith {
            filter = g;
            src = ./.;
          };
        }
        # Succeeds!

        builtins.filterSource f (builtins.filterSource g ./.)
        # Fails!
  */
  cleanSourceWith =
    {
      # A path or cleanSourceWith result to filter and/or rename.
      src,
      # Optional with default value: constant true (include everything)
      # The function will be combined with the && operator such
      # that src.filter is called lazily.
      # For implementing a filter, see
      # https://nixos.org/nix/manual/#builtin-filterSource
      # Type: A function (path -> type -> bool)
      filter ? _path: _type: true,
      # Optional name to use as part of the store path.
      # This defaults to `src.name` or otherwise `"source"`.
      name ? null,
    }:
    let
      orig = toSourceAttributes src;
    in
    fromSourceAttributes {
      inherit (orig) origSrc;
      filter = path: type: filter path type && orig.filter path type;
      name = if name != null then name else orig.name;
    };

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
      attrs
      // {
        filter =
          path: type:
          let
            r = attrs.filter path type;
          in
          builtins.trace "${attrs.name}.filter ${path} = ${boolToString r}" r;
      }
    )
    // {
      satisfiesSubpathInvariant = src ? satisfiesSubpathInvariant && src.satisfiesSubpathInvariant;
    };

  /*
    Filter sources by a list of regular expressions.

    Example: src = sourceByRegex ./my-subproject [".*\.py$" "^database.sql$"]
  */
  sourceByRegex =
    src: regexes:
    let
      isFiltered = src ? _isLibCleanSourceWith;
      origSrc = if isFiltered then src.origSrc else src;
    in
    lib.cleanSourceWith {
      filter = (
        path: type:
        let
          relPath = lib.removePrefix (toString origSrc + "/") (toString path);
        in
        lib.any (re: match re relPath != null) regexes
      );
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
    let
      filter =
        name: type:
        let
          base = baseNameOf (toString name);
        in
        type == "directory" || lib.any (ext: lib.hasSuffix ext base) exts;
    in
    cleanSourceWith { inherit filter src; };

  pathIsGitRepo = path: (_commitIdFromGitRepoOrError path) ? value;

  /*
    Get the commit id of a git repo.

    Example: commitIdFromGitRepo <nixpkgs/.git>
  */
  commitIdFromGitRepo =
    path:
    let
      commitIdOrError = _commitIdFromGitRepoOrError path;
    in
    commitIdOrError.value or (throw commitIdOrError.error);

  # Get the commit id of a git repo.

  # Returns `{ value = commitHash }` or `{ error = "... message ..." }`.

  # Example: commitIdFromGitRepo <nixpkgs/.git>
  # not exported, used for commitIdFromGitRepo
  _commitIdFromGitRepoOrError =
    let
      readCommitFromFile =
        file: path:
        let
          fileName = path + "/${file}";
          packedRefsName = path + "/packed-refs";
          absolutePath =
            base: path: if lib.hasPrefix "/" path then path else toString (/. + "${base}/${path}");
        in
        if
          pathIsRegularFile path
        # Resolve git worktrees. See gitrepository-layout(5)
        then
          let
            m = match "^gitdir: (.*)$" (lib.fileContents path);
          in
          if m == null then
            { error = "File contains no gitdir reference: " + path; }
          else
            let
              gitDir = absolutePath (dirOf path) (lib.head m);
              commonDir'' =
                if pathIsRegularFile "${gitDir}/commondir" then lib.fileContents "${gitDir}/commondir" else gitDir;
              commonDir' = lib.removeSuffix "/" commonDir'';
              commonDir = absolutePath gitDir commonDir';
              refFile = lib.removePrefix "${commonDir}/" "${gitDir}/${file}";
            in
            readCommitFromFile refFile commonDir

        else if
          pathIsRegularFile fileName
        # Sometimes git stores the commitId directly in the file but
        # sometimes it stores something like: «ref: refs/heads/branch-name»
        then
          let
            fileContent = lib.fileContents fileName;
            matchRef = match "^ref: (.*)$" fileContent;
          in
          if matchRef == null then { value = fileContent; } else readCommitFromFile (lib.head matchRef) path

        else if
          pathIsRegularFile packedRefsName
        # Sometimes, the file isn't there at all and has been packed away in the
        # packed-refs file, so we have to grep through it:
        then
          let
            fileContent = readFile packedRefsName;
            matchRef = match "([a-z0-9]+) ${file}";
            isRef = s: isString s && (matchRef s) != null;
            # there is a bug in libstdc++ leading to stackoverflow for long strings:
            # https://github.com/NixOS/nix/issues/2147#issuecomment-659868795
            refs = filter isRef (split "\n" fileContent);
          in
          if refs == [ ] then
            { error = "Could not find " + file + " in " + packedRefsName; }
          else
            { value = lib.head (matchRef (lib.head refs)); }

        else
          { error = "Not a .git directory: " + toString path; };
    in
    readCommitFromFile "HEAD";

  pathHasContext = builtins.hasContext or (lib.hasPrefix storeDir);

  canCleanSource = src: src ? _isLibCleanSourceWith || !(pathHasContext (toString src));

  # -------------------------------------------------------------------------- #
  # Internal functions
  #

  # toSourceAttributes : sourceLike -> SourceAttrs
  #
  # Convert any source-like object into a simple, singular representation.
  # We don't expose this representation in order to avoid having a fifth path-
  # like class of objects in the wild.
  # (Existing ones being: paths, strings, sources and x//{outPath})
  # So instead of exposing internals, we build a library of combinator functions.
  toSourceAttributes =
    src:
    let
      isFiltered = src ? _isLibCleanSourceWith;
    in
    {
      # The original path
      origSrc = if isFiltered then src.origSrc else src;
      filter = if isFiltered then src.filter else _: _: true;
      name = if isFiltered then src.name else "source";
    };

  # fromSourceAttributes : SourceAttrs -> Source
  #
  # Inverse of toSourceAttributes for Source objects.
  fromSourceAttributes =
    {
      origSrc,
      filter,
      name,
    }:
    {
      _isLibCleanSourceWith = true;
      inherit origSrc filter name;
      outPath = builtins.path {
        inherit filter name;
        path = origSrc;
      };
    };

in
{

  pathType =
    lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2305)
      "lib.sources.pathType has been moved to lib.filesystem.pathType."
      lib.filesystem.pathType;

  pathIsDirectory =
    lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2305)
      "lib.sources.pathIsDirectory has been moved to lib.filesystem.pathIsDirectory."
      lib.filesystem.pathIsDirectory;

  pathIsRegularFile =
    lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2305)
      "lib.sources.pathIsRegularFile has been moved to lib.filesystem.pathIsRegularFile."
      lib.filesystem.pathIsRegularFile;

  inherit
    pathIsGitRepo
    commitIdFromGitRepo

    cleanSource
    cleanSourceWith
    cleanSourceFilter
    pathHasContext
    canCleanSource

    sourceByRegex
    sourceFilesBySuffices

    trace
    ;
}
