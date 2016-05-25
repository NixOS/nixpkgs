# Functions for copying sources to the Nix store.

let lib = import ./default.nix; in

rec {


  # Bring in a path as a source, filtering out all Subversion and CVS
  # directories, as well as backup files (*~).
  cleanSource =
    let filter = name: type: let baseName = baseNameOf (toString name); in ! (
      # Filter out Subversion and CVS directories.
      (type == "directory" && (baseName == ".git" || baseName == ".svn" || baseName == "CVS" || baseName == ".hg")) ||
      # Filter out backup files.
      lib.hasSuffix "~" baseName ||
      # Filter out generates files.
      lib.hasSuffix ".o" baseName ||
      lib.hasSuffix ".so" baseName
    );
    in src: builtins.filterSource filter src;


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
             let fileContent = readFile fileName;
                 # Sometimes git stores the commitId directly in the file but
                 # sometimes it stores something like: «ref: refs/heads/branch-name»
                 matchRef    = match "^ref: (.*)\n$" fileContent;
             in if   isNull matchRef
                then lib.removeSuffix "\n" fileContent
                else readCommitFromFile path (lib.head matchRef)
           # Sometimes, the file isn't there at all and has been packed away in the
           # packed-refs file, so we have to grep through it:
           else if lib.pathExists packedRefsName
           then
             let packedRefs  = lib.splitString "\n" (readFile packedRefsName);
                 matchRule   = match ("^(.*) " + file + "$");
                 matchedRefs = lib.flatten (lib.filter (m: ! (isNull m)) (map matchRule packedRefs));
             in lib.head matchedRefs
           else throw ("Not a .git directory: " + path);
    in lib.flip readCommitFromFile "HEAD";
}
