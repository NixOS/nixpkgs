{ lib }:

let
  inherit (lib.attrsets)
    mapAttrs
    ;
  inherit (lib.lists)
    head
    tail
    ;
  inherit (lib.strings)
    hasPrefix
    ;
  inherit (lib.filesystem)
    pathHasPrefix
    absolutePathComponentsBetween
    ;
in

{ # haskellPathsInDir : Path -> Map String Path
  # A map of all haskell packages defined in the given path,
  # identified by having a cabal file with the same name as the
  # directory itself.
  haskellPathsInDir = root:
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
  # locateDominatingFile :  RegExp
  #                      -> Path
  #                      -> Nullable { path : Path;
  #                                    matches : [ MatchResults ];
  #                                  }
  # Find the first directory containing a file matching 'pattern'
  # upward from a given 'file'.
  # Returns 'null' if no directories contain a file matching 'pattern'.
  locateDominatingFile = pattern: file:
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


  # listFilesRecursive: Path -> [ Path ]
  #
  # Given a directory, return a flattened list of all files within it recursively.
  listFilesRecursive = dir: lib.flatten (lib.mapAttrsToList (name: type:
    if type == "directory" then
      lib.filesystem.listFilesRecursive (dir + "/${name}")
    else
      dir + "/${name}"
  ) (builtins.readDir dir));

  # pathHasPrefix : Path -> Path -> Bool
  # pathHasPrefix ancestor somePath
  #
  # Return true iff, disregarding trailing slashes,
  #   - somePath is below ancestor
  #   - or equal to ancestor
  #
  # Equivalently, return true iff you can reach ancestor by starting at somePath
  # and traversing the `..` node zero or more times.
  pathHasPrefix = prefixPath: otherPath:
    let
      normalizedPathString = pathLike: toString (/. + pathLike);
      pre = normalizedPathString prefixPath;
      other = normalizedPathString otherPath;
    in
      if pre == "/" # root is the only path that already ends in "/"
      then true
      else
        hasPrefix (pre + "/") (other + "/");


  # commonPath : PathLike -> PathLike -> Path
  #
  # Find the common ancestory; the longest prefix path that is common between
  # the input paths.
  commonPath = a: b:
    let
      b' = /. + b;
      go = c:
        if pathHasPrefix c b'
        then c
        else go (dirOf c);
    in
      go (/. + a);

  # absolutePathComponentsBetween : PathOrString -> PathOrString -> [String]
  # absolutePathComponentsBetween ancestor descendant
  #
  # Returns the path components that form the path from ancestor to descendant.
  # Will not return ".." components, which is a feature. Throws when ancestor
  # and descendant arguments aren't in said relation to each other.
  #
  # Example:
  #
  #   absolutePathComponentsBetween /a     /a/b/c == ["b" "c"]
  #   absolutePathComponentsBetween /a/b/c /a/b/c == []
  absolutePathComponentsBetween =
    ancestor: descendant:
      let
        a' = /. + ancestor;
        go = d:
          if a' == d
          then []
          else if d == /.
          then throw "absolutePathComponentsBetween: path ${toString ancestor} is not an ancestor of ${toString descendant}"
          else go (dirOf d) ++ [(baseNameOf d)];
      in
        go (/. + descendant);

  /*
    Memoize a function that takes a path argument.

    Example:

      analyzeTree = dir:
        let g = memoizePathFunction (p: t: expensiveFunction p) (p: {}) dir;
        in presentExpensiveData g;

    Type:
      memoizePathFunction :: (Path -> Type -> a) -> (Path -> a) -> Path -> (Path -> a)
  */
  memoizePathFunction =
    # Function to memoize
    f:
    # What to return when a path does not exist, as a function of the path
    missing:
    # Filesystem location below which the returned function is defined. `/.` may be acceptable, but a path closer to the data of interest is better.
    root:
    let
      makeTree = dir: type: {
        value = f dir type;
        children =
          if type == "directory"
            then mapAttrs
                  (key: type: makeTree (dir + "/${key}") type)
                  (builtins.readDir dir)
            else {};
      };

      # This is where the memoization happens
      tree = makeTree root (lib.pathType root);

      lookup = notFound: list: subtree:
        if list == []
        then subtree.value
        else if subtree.children ? ${head list}
        then lookup notFound (tail list) subtree.children.${head list}
        else notFound;
    in
      path: lookup
        (missing path)
        (absolutePathComponentsBetween root path)
        tree;

}
