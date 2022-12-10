# Functions for copying sources to the Nix store.
{ lib }:

let
  inherit (lib.strings)
    hasPrefix
    ;
in

{
  /*
    A map of all haskell packages defined in the given path,
    identified by having a cabal file with the same name as the
    directory itself.

    Type: Path -> Map String Path
  */
  haskellPathsInDir =
    # The directory within to search
    root:
    let # Files in the root
        root-files = builtins.attrNames (builtins.readDir root);
        # Files with their full paths
        root-files-with-paths =
          map (file:
            { name = file; value = root + "/${file}"; }
          ) root-files;
        # Subdirectories of the root with a cabal file.
        cabal-subdirs =
          builtins.filter ({ name, value }:
            builtins.pathExists (value + "/${name}.cabal")
          ) root-files-with-paths;
    in builtins.listToAttrs cabal-subdirs;
  /*
    Find the first directory containing a file matching 'pattern'
    upward from a given 'file'.
    Returns 'null' if no directories contain a file matching 'pattern'.

    Type: RegExp -> Path -> Nullable { path : Path; matches : [ MatchResults ]; }
  */
  locateDominatingFile =
    # The pattern to search for
    pattern:
    # The file to start searching upward from
    file:
    let go = path:
          let files = builtins.attrNames (builtins.readDir path);
              matches = builtins.filter (match: match != null)
                          (map (builtins.match pattern) files);
          in
            if builtins.length matches != 0
              then { inherit path matches; }
              else if path == /.
                then null
                else go (dirOf path);
        parent = dirOf file;
        isDir =
          let base = baseNameOf file;
              type = (builtins.readDir parent).${base} or null;
          in file == /. || type == "directory";
    in go (if isDir then file else parent);


  /*
    Given a directory, return a flattened list of all files within it recursively.

    Type: Path -> [ Path ]
  */
  listFilesRecursive =
    # The path to recursively list
    dir:
    lib.flatten (lib.mapAttrsToList (name: type:
    if type == "directory" then
      lib.filesystem.listFilesRecursive (dir + "/${name}")
    else
      dir + "/${name}"
  ) (builtins.readDir dir));

}
