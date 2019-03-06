# Functions for copying sources to the Nix store.
{ lib }:

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
    filter
    getAttr
    isString
    pathExists
    readFile
    ;
in
rec {

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
      isFiltered = src ? _isLibCleanSourceWith;
      origSrc = if isFiltered then src.origSrc else src;
      filter' = if isFiltered then name: type: filter name type && src.filter name type else filter;
      name' = if name != null then name else if isFiltered then src.name else "source";
    in {
      inherit origSrc;
      filter = filter';
      outPath = builtins.path { filter = filter'; path = origSrc; name = name'; };
      _isLibCleanSourceWith = true;
      name = name';
    };

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

  # Get all files ending with the specified suffices from the given
  # directory or its descendants.  E.g. `sourceFilesBySuffices ./dir
  # [".xml" ".c"]'.
  sourceFilesBySuffices = path: exts:
    let filter = name: type:
      let base = baseNameOf (toString name);
      in type == "directory" || lib.any (ext: lib.hasSuffix ext base) exts;
    in cleanSourceWith { inherit filter; src = path; };

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
                  let gitDir     = absolutePath (dirOf path) (lib.head m);
                      commonDir' = if pathIsRegularFile "${gitDir}/commondir"
                                   then lib.fileContents "${gitDir}/commondir"
                                   else gitDir;
                      commonDir  = absolutePath gitDir commonDir';
                      refFile    = lib.removePrefix "${commonDir}/" "${gitDir}/${file}";
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

  # Splits a filesystem path into its components.
  splitPath = path: lib.splitString "/" (toString path);

  # Turns a list of path components into a tree, e.g.
  #
  #     ["a" "b" "c1"]
  #     ["a" "b" "c2"]
  #     ["a" "b" "c3"]
  #     ["a" "x"     ]
  #
  # becomes:
  #
  #     { a = { b = { c1 = null; c2 = null; c3 = null }; x = null; }; }
  pathComponentsToTree = paths: with lib;
    foldl (tree: path: recursiveUpdate tree (setAttrByPath path null)) {} paths;

  # Returns true if and only if any prefix of the given `path` leads to a leaf
  # (`null`) in the given `tree` (nested attrset).
  # That is: "If we go down the tree by the given path, do we hit a leaf?"
  #
  # Example: For the tree `tree`
  #
  #     a
  #       b-leaf
  #       c-leaf
  #       d
  #         e-leaf
  #     f-leaf
  #
  # represented as attrset
  #
  #     { a = { b = null; c = null; d = { e = null; }; }; f = null; }
  #
  # we have (string quotes omitted for readability):
  #
  #     isPrefixOfLeafPath [a]       tree == false
  #     isPrefixOfLeafPath [x]       tree == false
  #     isPrefixOfLeafPath [a b]     tree == true
  #     isPrefixOfLeafPath [a b c]   tree == true
  #     isPrefixOfLeafPath [a b c x] tree == true
  #     isPrefixOfLeafPath [a d]     tree == false
  isPrefixOfLeafPath = path: tree:
    if tree == null
      then true
      else
        if path == []
          then false
          else
            let
              component = builtins.head path;
              restPath = builtins.tail path;
            in
              if !(builtins.hasAttr component tree)
                then false
                else
                  let
                    subtree = builtins.getAttr component tree;
                  in
                    isPrefixOfLeafPath restPath subtree;



  # See `explicitSource` for an example of this this filter.
  #
  # You can use this filter standalone (with `builtins.filterSource`
  # or better, `builtins.path` with explicitly given `name`) when
  # you want to combine it with other filters.
  explicitSourceFilter =
    {
      # List of dirs under which all recursively contained files are taken in
      # (unless a file is filtered by other arguments).
      # Dirs that match explicitly are immediately taken in.
      includeDirs ? [],
      # Explicit list of files that should be taken in.
      includeFiles ? [],
      # Exclude dotfiles/dirs by default (unless they are matched explicitly)?
      excludeHidden ? true,
      # If any of the path components given here appears anywhere in the path,
      # (e.g. X in `.../X/...`), the path is excluded (unless matched explicitly).
      # Example: `pathComponentExcludes = [ "gen" "build" ]`.
      pathComponentExcludes ? [],

      # Debugging

      # Enable this to enable a `builtins.trace` output that prints which files
      # were matched as source inputs.
      # Output looks like:
      #     trace: myproject: include regular   /home/user/myproject/Setup.hs
      #     trace: myproject: skip    regular   /home/user/myproject/myproject.nix
      #     trace: myproject: skip    directory /home/user/myproject/dist
      #     trace: myproject: include directory /home/user/myproject/images
      #     trace: myproject: include regular   /home/user/myproject/images/image.svg
      #     trace: myproject: include directory /home/user/myproject/src
      #     trace: myproject: include directory /home/user/myproject/src/MyDir
      #     trace: myproject: include regular   /home/user/myproject/src/MyDir/File1.hs
      #     trace: myproject: include regular   /home/user/myproject/src/MyDir/File2.hs
      debugTraceEnable ? false,
      # Set this to prefix the trace output with some arbitrary string.
      # Useful if you enable `debugTraceEnable` in multiple places and want
      # to distinguish them.
      debugTracePrefix ? "",

      # For debugging
      name,
    }: with lib;
      let
        # Pre-processing done once, across all files passed in.

        # Turns a list into a "set" (map where all values are null).
        keySet = list: genAttrs list (name: null);

        # For fast non-O(n) lookup, we turn `includeDirs` and `includeFiles` into
        # string-keyed attrsets first.
        includeDirsSet = keySet (map toString includeDirs);
        srcFilesSet = keySet (map toString includeFiles);

        # We also turn `includeDirs` into a directory-prefix-tree so that we can
        # check whether a given path is under one of the `includeDirs` in sub-O(n).
        includeDirsTree = pathComponentsToTree (map splitPath includeDirs);
      in
        # The actual filter function with per-file processing
        fullPath: type:
          let
            fileName = baseNameOf (toString fullPath);

            components = splitPath fullPath;

            isExplicitSrcFile = hasAttr fullPath srcFilesSet;
            isExplicitSrcDir = type == "directory" && hasAttr fullPath includeDirsSet;
            # The below is equivalent to
            #   any (srcDir: hasPrefix (toString srcDir + "/") fullPath) includeDirs;
            # but faster than O(n) where n is the number of `includeDirs` entries.
            isUnderSomeSrcDir = isPrefixOfLeafPath components includeDirsTree;

            isHidden = excludeHidden && hasPrefix "." fileName;

            hasExcludedComponentInPath = any (c: elem c pathComponentExcludes) components;

            isSourceInput =
              isExplicitSrcFile ||
              isExplicitSrcDir ||
              (isUnderSomeSrcDir && !isHidden && !hasExcludedComponentInPath);

            tracing =
              let
                prefix = if debugTracePrefix == "" then "" else debugTracePrefix + ": ";
                action = if isSourceInput then "include" else "skip   ";
                # Pad type (e.g. "regular", "symlink") to be as wide as
                # the widest ("directory") for aligned output.
                width = max (stringLength "directory") (stringLength type);
                formattedType = substring 0 width (type + "         ");
              in
              debug.traceIf
                debugTraceEnable
                "${prefix}${action} ${formattedType} ${fullPath}";
          in
            tracing isSourceInput;

  # A general-purpose, explicit source code importer suitable for most
  # packaging needs.
  #
  # See `explicitSourceFilter` for an explanation of the filter arguments.
  #
  # Example usage:
  #
  #    src = lib.explicitSource ./. {
  #      name = "mypackage";
  #      includeDirs = [
  #        ./src
  #        ./app
  #        ./images
  #      ];
  #      includeFiles = [
  #        ./mypackage.cabal
  #        ./Setup.hs
  #      ];
  #      pathComponentExcludes = [ "build" "gen" ];
  #    };
  #
  # Note that `includeDirs = [ ./. ]` is also permitted.
  #
  # But consider that in most cases you will not want to include files
  # that are not relevant for the build, such as `.nix` files, so that
  # input hashes do not change unnecessarily.
  #
  # If you want to combine it with other filters, use `explicitSourceFilter`
  # directly instead.
  explicitSource = topPath: filterArgs@{
    # Recommended, to be identifiable in downloads and `nix-store -qR`.
    # "-src" will be automatically appended.
    name ? "filtered",
    # Other `explicitSourceFilter` arguments.
    ...
  }:
    cleanSourceWith {
      # The `-src` suffix makes it easy to distinguish source store paths
      # from built output store paths in the nix store.
      #
      # Requiring an explicit name prevents the basename of the directory
      # making it into the store path when `./.` is used, thus preventing
      # impure builds in situations where ./. is a directory with random
      # names, as is common e.g. when cloning source repositories under
      # multiple names; see https://github.com/NixOS/nix/issues/1305
      # and https://github.com/NixOS/nixpkgs/pull/67996.
      name = name + "-src";
      src = topPath;
      filter = explicitSourceFilter filterArgs;
    };

}
