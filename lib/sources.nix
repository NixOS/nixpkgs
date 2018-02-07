# Functions for copying sources to the Nix store.
{ lib }:

rec {

  # Returns the type of a path: regular (for file), symlink, or directory
  pathType = p: with builtins; getAttr (baseNameOf p) (readDir (dirOf p));

  # Returns true if the path exists and is a directory, false otherwise
  pathIsDirectory = p: if builtins.pathExists p then (pathType p) == "directory" else false;

  # Bring in a path as a source, filtering out all Subversion and CVS
  # directories, as well as backup files (*~).
  cleanSourceFilter = name: type: let baseName = baseNameOf (toString name); in ! (
    # Filter out Subversion and CVS directories.
    (type == "directory" && (baseName == ".git" || baseName == ".svn" || baseName == "CVS" || baseName == ".hg")) ||
    # Filter out editor backup / swap files.
    lib.hasSuffix "~" baseName ||
    builtins.match "^\\.sw[a-z]$" baseName != null ||
    builtins.match "^\\..*\\.sw[a-z]$" baseName != null ||

    # Filter out generates files.
    lib.hasSuffix ".o" baseName ||
    lib.hasSuffix ".so" baseName ||
    # Filter out nix-build result symlinks
    (type == "symlink" && lib.hasPrefix "result" baseName)
  );

  cleanSource = src: cleanSourceWith { filter = cleanSourceFilter; inherit src; };

  # Like `builtins.filterSource`, except it will compose with itself,
  # allowing you to chain multiple calls together without any
  # intermediate copies being put in the nix store.
  #
  #     lib.cleanSourceWith f (lib.cleanSourceWith g ./.)     # Succeeds!
  #     builtins.filterSource f (builtins.filterSource g ./.) # Fails!
  cleanSourceWith = { filter, src }:
    composablePath { inherit filter; path = src; };

  # | Like 'builtins.path', except composable, with underlying filters
  # composed without adding paths to the store multiple times.
  #
  # The 'recursive' argument is not implemented because useful use of
  # filters implies recursive = true.
  #
  # Uses filterSource where allowed by the arguments for backwards
  # compatibility.
  composablePath =
    { path
    , filter ? null
    , name ? null
    , sha256 ? null
    }@args:
      let path' = if path._isLibComposablePath or false
                    then path
                    else {};
          hasName = args ? name || path' ? name;
          hasFilter = args ? filter || path' ? filter;
          filter =
            if path' ? filter
              then if args ? filter
                     then name: type: args.filter name type &&
                                        path'.filter name type
                   else path'.filter
            else args.filter;
          name = args.name or path'.name;
          needsPathBuiltin = hasName || args ? sha256;
          origPath = path'.path or path;
          inherit (lib) optionalAttrs;
          optionalArgs =
            (optionalAttrs hasName { inherit name; }) //
            (optionalAttrs hasFilter { inherit filter; }) //
            (optionalAttrs (args ? sha256) { inherit sha256; });
      in
        { _isLibComposablePath = true;
          path = origPath;
          outPath =
            if needsPathBuiltin
              then if builtins ? path
                     then builtins.path
                            ({ path = origPath; } // optionalArgs)
                   else throw "You must be using at least nix 2.0 to use composablePath with a name or sha256"
            else if hasFilter
                   then builtins.filterSource filter origPath
                 else throw "You must pass at least one of filter, name, or sha256 to composablePath";
        } // (removeAttrs optionalArgs [ "sha256" ]);

  # Filter sources by a list of regular expressions.
  #
  # E.g. `src = sourceByRegex ./my-subproject [".*\.py$" "^database.sql$"]`
  sourceByRegex = src: regexes: cleanSourceWith {
    filter = (path: type:
      let relPath = lib.removePrefix (toString src + "/") (toString path);
      in lib.any (re: builtins.match re relPath != null) regexes);
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


  # Get the commit id of a git repo
  # Example: commitIdFromGitRepo <nixpkgs/.git>
  commitIdFromGitRepo =
    let readCommitFromFile = path: file:
      with builtins;
        let fileName       = toString path + "/" + file;
            packedRefsName = toString path + "/packed-refs";
        in if lib.pathExists fileName
           then
             let fileContent = lib.fileContents fileName;
                 # Sometimes git stores the commitId directly in the file but
                 # sometimes it stores something like: «ref: refs/heads/branch-name»
                 matchRef    = match "^ref: (.*)$" fileContent;
             in if   isNull matchRef
                then fileContent
                else readCommitFromFile path (lib.head matchRef)
           # Sometimes, the file isn't there at all and has been packed away in the
           # packed-refs file, so we have to grep through it:
           else if lib.pathExists packedRefsName
           then
             let fileContent = readFile packedRefsName;
                 matchRef    = match (".*\n([^\n ]*) " + file + "\n.*") fileContent;
             in if   isNull matchRef
                then throw ("Could not find " + file + " in " + packedRefsName)
                else lib.head matchRef
           else throw ("Not a .git directory: " + path);
    in lib.flip readCommitFromFile "HEAD";

  pathHasContext = builtins.hasContext or (lib.hasPrefix builtins.storeDir);

  canCleanSource = src: src ? _isLibComposablePath || !(pathHasContext (toString src));
}
