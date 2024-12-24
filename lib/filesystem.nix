/**
  Functions for querying information about the filesystem
  without copying any files to the Nix store.
*/
{ lib }:

# Tested in lib/tests/filesystem.sh
let
  inherit (builtins)
    readDir
    pathExists
    toString
    ;

  inherit (lib.attrsets)
    mapAttrs'
    filterAttrs
    ;

  inherit (lib.filesystem)
    pathType
    ;

  inherit (lib.strings)
    hasSuffix
    removeSuffix
    ;
in

{

  /**
    The type of a path. The path needs to exist and be accessible.
    The result is either "directory" for a directory, "regular" for a regular file, "symlink" for a symlink, or "unknown" for anything else.

    # Inputs

    path

    : The path to query

    # Type

    ```
    pathType :: Path -> String
    ```

    # Examples
    :::{.example}
    ## `lib.filesystem.pathType` usage example

    ```nix
    pathType /.
    => "directory"

    pathType /some/file.nix
    => "regular"
    ```

    :::
  */
  pathType =
    builtins.readFileType or
    # Nix <2.14 compatibility shim
    (path:
      if ! pathExists path
      # Fail irrecoverably to mimic the historic behavior of this function and
      # the new builtins.readFileType
      then abort "lib.filesystem.pathType: Path ${toString path} does not exist."
      # The filesystem root is the only path where `dirOf / == /` and
      # `baseNameOf /` is not valid. We can detect this and directly return
      # "directory", since we know the filesystem root can't be anything else.
      else if dirOf path == path
      then "directory"
      else (readDir (dirOf path)).${baseNameOf path}
    );

  /**
    Whether a path exists and is a directory.


    # Inputs

    `path`

    : 1\. Function argument

    # Type

    ```
    pathIsDirectory :: Path -> Bool
    ```

    # Examples
    :::{.example}
    ## `lib.filesystem.pathIsDirectory` usage example

    ```nix
    pathIsDirectory /.
    => true

    pathIsDirectory /this/does/not/exist
    => false

    pathIsDirectory /some/file.nix
    => false
    ```

    :::
  */
  pathIsDirectory = path:
    pathExists path && pathType path == "directory";

  /**
    Whether a path exists and is a regular file, meaning not a symlink or any other special file type.


    # Inputs

    `path`

    : 1\. Function argument

    # Type

    ```
    pathIsRegularFile :: Path -> Bool
    ```

    # Examples
    :::{.example}
    ## `lib.filesystem.pathIsRegularFile` usage example

    ```nix
    pathIsRegularFile /.
    => false

    pathIsRegularFile /this/does/not/exist
    => false

    pathIsRegularFile /some/file.nix
    => true
    ```

    :::
  */
  pathIsRegularFile = path:
    pathExists path && pathType path == "regular";

  /**
    A map of all haskell packages defined in the given path,
    identified by having a cabal file with the same name as the
    directory itself.


    # Inputs

    `root`

    : The directory within to search

    # Type

    ```
    Path -> Map String Path
    ```
  */
  haskellPathsInDir =
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
  /**
    Find the first directory containing a file matching 'pattern'
    upward from a given 'file'.
    Returns 'null' if no directories contain a file matching 'pattern'.


    # Inputs

    `pattern`

    : The pattern to search for

    `file`

    : The file to start searching upward from

    # Type

    ```
    RegExp -> Path -> Nullable { path : Path; matches : [ MatchResults ]; }
    ```
  */
  locateDominatingFile =
    pattern:
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


  /**
    Given a directory, return a flattened list of all files within it recursively.


    # Inputs

    `dir`

    : The path to recursively list

    # Type

    ```
    Path -> [ Path ]
    ```
  */
  listFilesRecursive =
    dir:
    lib.flatten (lib.mapAttrsToList (name: type:
    if type == "directory" then
      lib.filesystem.listFilesRecursive (dir + "/${name}")
    else
      dir + "/${name}"
  ) (builtins.readDir dir));

  /**
    Transform a directory tree containing package files suitable for
    `callPackage` into a matching nested attribute set of derivations.

    For a directory tree like this:

    ```
    my-packages
    ├── a.nix
    ├── b.nix
    ├── c
    │  ├── my-extra-feature.patch
    │  ├── package.nix
    │  └── support-definitions.nix
    └── my-namespace
       ├── d.nix
       ├── e.nix
       └── f
          └── package.nix
    ```

    `packagesFromDirectoryRecursive` will produce an attribute set like this:

    ```nix
    # packagesFromDirectoryRecursive {
    #   callPackage = pkgs.callPackage;
    #   directory = ./my-packages;
    # }
    {
      a = pkgs.callPackage ./my-packages/a.nix { };
      b = pkgs.callPackage ./my-packages/b.nix { };
      c = pkgs.callPackage ./my-packages/c/package.nix { };
      my-namespace = {
        d = pkgs.callPackage ./my-packages/my-namespace/d.nix { };
        e = pkgs.callPackage ./my-packages/my-namespace/e.nix { };
        f = pkgs.callPackage ./my-packages/my-namespace/f/package.nix { };
      };
    }
    ```

    In particular:
    - If the input directory contains a `package.nix` file, then
      `callPackage <directory>/package.nix { }` is returned.
    - Otherwise, the input directory's contents are listed and transformed into
      an attribute set.
      - If a file name has the `.nix` extension, it is turned into attribute
        where:
        - The attribute name is the file name without the `.nix` extension
        - The attribute value is `callPackage <file path> { }`
      - Other files are ignored.
      - Directories are turned into an attribute where:
        - The attribute name is the name of the directory
        - The attribute value is the result of calling
          `packagesFromDirectoryRecursive { ... }` on the directory.

        As a result, directories with no `.nix` files (including empty
        directories) will be transformed into empty attribute sets.

    # Type

    ```
    packagesFromDirectoryRecursive :: {
      callPackage :: Path -> {} -> a,
      directory :: Path,
      ...
    } -> AttrSet
    ```

    # Inputs

    `callPackage`
    : The function used to convert a Nix file's path into a leaf of the attribute set.
      It is typically the `callPackage` function, taken from either `pkgs` or a new scope corresponding to the `directory`.

    `directory`
    : The directory to read package files from.


    # Examples
    :::{.example}
    ## Basic use of `lib.packagesFromDirectoryRecursive`

    ```nix
    packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage;
      directory = ./my-packages;
    }
    => { ... }
    ```

    In this case, `callPackage` will only search `pkgs` for a file's input parameters.
    In other words, a file cannot refer to another file in the directory in its input parameters.
    :::

    ::::{.example}
    ## Create a scope for the nix files found in a directory
    ```nix
    lib.makeScope pkgs.newScope (
      self: packagesFromDirectoryRecursive {
        inherit (self) callPackage;
        directory = ./my-packages;
      }
    )
    => { ... }
    ```

    For example, take the following directory structure:
    ```
    my-packages
    ├── a.nix    → { b }: assert b ? b1; ...
    └── b
       ├── b1.nix  → { a }: ...
       └── b2.nix
    ```

    Here, `b1.nix` can specify `{ a }` as a parameter, which `callPackage` will resolve as expected.
    Likewise, `a.nix` receive an attrset corresponding to the contents of the `b` directory.

    :::{.note}
    `a.nix` cannot directly take as inputs packages defined in a child directory, such as `b1`.
    :::

    :::{.warning}
    As of now, `lib.packagesFromDirectoryRecursive` cannot create nested scopes for sub-directories.

    In particular, files under `b/` can only require (as inputs) other files under `my-packages`,
    but not to those in the same directory, nor those in a parent directory; e.g, `b2.nix` cannot directly
    require `b1`.
    :::
    ::::
  */
  packagesFromDirectoryRecursive =
    {
      callPackage,
      directory,
      ...
    }:
    let
      # Determine if a directory entry from `readDir` indicates a package or
      # directory of packages.
      directoryEntryIsPackage = basename: type:
        type == "directory" || hasSuffix ".nix" basename;

      # List directory entries that indicate packages in the given `path`.
      packageDirectoryEntries = path:
        filterAttrs directoryEntryIsPackage (readDir path);

      # Transform a directory entry (a `basename` and `type` pair) into a
      # package.
      directoryEntryToAttrPair = subdirectory: basename: type:
        let
          path = subdirectory + "/${basename}";
        in
        if type == "regular"
        then
        {
          name = removeSuffix ".nix" basename;
          value = callPackage path { };
        }
        else
        if type == "directory"
        then
        {
          name = basename;
          value = packagesFromDirectory path;
        }
        else
        throw
          ''
            lib.filesystem.packagesFromDirectoryRecursive: Unsupported file type ${type} at path ${toString subdirectory}
          '';

      # Transform a directory into a package (if there's a `package.nix`) or
      # set of packages (otherwise).
      packagesFromDirectory = path:
        let
          defaultPackagePath = path + "/package.nix";
        in
        if pathExists defaultPackagePath
        then callPackage defaultPackagePath { }
        else mapAttrs'
          (directoryEntryToAttrPair path)
          (packageDirectoryEntries path);
    in
    packagesFromDirectory directory;
}
