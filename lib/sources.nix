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

}
