# Functions for copying sources to the Nix store.
{ lib }:

let
  inherit (builtins)
    readDir
    pathExists
    ;

  inherit (lib.strings)
    hasPrefix
    ;

  inherit (lib.filesystem)
    pathType
    ;
in

{

  /*
    The type of a path. The path needs to exist and be accessible.
    The result is either "directory" for a directory, "regular" for a regular file, "symlink" for a symlink, or "unknown" for anything else.

    Type:
      pathType :: Path -> String

    Example:
      pathType /.
      => "directory"

      pathType /some/file.nix
      => "regular"
  */
  pathType = path:
    if ! pathExists path
    # Fail irrecoverably to mimic the historic behavior of this function and
    # the new builtins.readFileType
    then abort "lib.filesystem.pathType: Path ${toString path} does not exist."
    # The filesystem root is the only path where `dirOf / == /` and
    # `baseNameOf /` is not valid. We can detect this and directly return
    # "directory", since we know the filesystem root can't be anything else.
    else if dirOf path == path
    then "directory"
    else (readDir (dirOf path)).${baseNameOf path};

  /*
    Whether a path exists and is a directory.

    Type:
      pathIsDirectory :: Path -> Bool

    Example:
      pathIsDirectory /.
      => true

      pathIsDirectory /this/does/not/exist
      => false

      pathIsDirectory /some/file.nix
      => false
  */
  pathIsDirectory = path:
    pathExists path && pathType path == "directory";

  /*
    Whether a path exists and is a regular file, meaning not a symlink or any other special file type.

    Type:
      pathIsRegularFile :: Path -> Bool

    Example:
      pathIsRegularFile /.
      => false

      pathIsRegularFile /this/does/not/exist
      => false

      pathIsRegularFile /some/file.nix
      => true
  */
  pathIsRegularFile = path:
    pathExists path && pathType path == "regular";

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
