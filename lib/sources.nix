# Functions for copying sources to the Nix store.

let lib = import ./default.nix; in

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
    # Filter out backup files.
    lib.hasSuffix "~" baseName ||
    # Filter out generates files.
    lib.hasSuffix ".o" baseName ||
    lib.hasSuffix ".so" baseName ||
    # Filter out nix-build result symlinks
    (type == "symlink" && lib.hasPrefix "result" baseName)
  );

  cleanSource = builtins.filterSource cleanSourceFilter;

  # Filter sources by a list of regular expressions.
  #
  # E.g. `src = sourceByRegex ./my-subproject [".*\.py$" "^database.sql$"]`
  sourceByRegex = src: regexes: builtins.filterSource (path: type:
    let relPath = lib.removePrefix (toString src + "/") (toString path);
    in lib.any (re: builtins.match re relPath != null) regexes) src;

  # Get all files ending with the specified suffices from the given
  # directory or its descendants.  E.g. `sourceFilesBySuffices ./dir
  # [".xml" ".c"]'.
  sourceFilesBySuffices = path: exts:
    let filter = name: type:
      let base = baseNameOf (toString name);
      in type == "directory" || lib.any (ext: lib.hasSuffix ext base) exts;
    in builtins.filterSource filter path;


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
}
