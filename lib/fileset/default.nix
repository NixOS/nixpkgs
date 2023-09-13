{ lib }:
let

  inherit (import ./internal.nix { inherit lib; })
    _coerce
    _toSourceFilter
    ;

  inherit (builtins)
    isPath
    pathExists
    typeOf
    ;

  inherit (lib.path)
    hasPrefix
    splitRoot
    ;

  inherit (lib.strings)
    isStringLike
    ;

  inherit (lib.filesystem)
    pathType
    ;

  inherit (lib.sources)
    cleanSourceWith
    ;

in {

  /*
    Add the local files contained in `fileset` to the store as a single [store path](https://nixos.org/manual/nix/stable/glossary#gloss-store-path) rooted at `root`.

    The result is the store path as a string-like value, making it usable e.g. as the `src` of a derivation, or in string interpolation:
    ```nix
    stdenv.mkDerivation {
      src = lib.fileset.toSource { ... };
      # ...
    }
    ```

    The name of the store path is always `source`.

    Type:
      toSource :: {
        root :: Path,
        fileset :: FileSet,
      } -> SourceLike

    Example:
      # Import the current directory into the store but only include files under ./src
      toSource { root = ./.; fileset = ./src; }
      => "/nix/store/...-source"

      # The file set coerced from path ./bar could contain files outside the root ./foo, which is not allowed
      toSource { root = ./foo; fileset = ./bar; }
      => <error>

      # The root has to be a local filesystem path
      toSource { root = "/nix/store/...-source"; fileset = ./.; }
      => <error>
  */
  toSource = {
    /*
      (required) The local directory [path](https://nixos.org/manual/nix/stable/language/values.html#type-path) that will correspond to the root of the resulting store path.
      Paths in [strings](https://nixos.org/manual/nix/stable/language/values.html#type-string), including Nix store paths, cannot be passed as `root`.
      `root` has to be a directory.

<!-- Ignore the indentation here, this is a nixdoc rendering bug that needs to be fixed -->
:::{.note}
Changing `root` only affects the directory structure of the resulting store path, it does not change which files are added to the store.
The only way to change which files get added to the store is by changing the `fileset` attribute.
:::
    */
    root,
    /*
      (required) The file set whose files to import into the store.
      Currently the only way to construct file sets is using [implicit coercion from paths](#sec-fileset-path-coercion).
      If a directory does not recursively contain any file, it is omitted from the store path contents.
    */
    fileset,
  }:
    let
      # We cannot rename matched attribute arguments, so let's work around it with an extra `let in` statement
      # For now filesets are always paths
      filesetPath = fileset;
    in
    let
      fileset = _coerce "lib.fileset.toSource: `fileset`" filesetPath;
      rootFilesystemRoot = (splitRoot root).root;
      filesetFilesystemRoot = (splitRoot fileset._internalBase).root;
      filter = _toSourceFilter fileset;
    in
    if ! isPath root then
      if isStringLike root then
        throw ''
          lib.fileset.toSource: `root` "${toString root}" is a string-like value, but it should be a path instead.
              Paths in strings are not supported by `lib.fileset`, use `lib.sources` or derivations instead.''
      else
        throw ''
          lib.fileset.toSource: `root` is of type ${typeOf root}, but it should be a path instead.''
    # Currently all Nix paths have the same filesystem root, but this could change in the future.
    # See also ../path/README.md
    else if rootFilesystemRoot != filesetFilesystemRoot then
      throw ''
        lib.fileset.toSource: Filesystem roots are not the same for `fileset` and `root` "${toString root}":
            `root`: root "${toString rootFilesystemRoot}"
            `fileset`: root "${toString filesetFilesystemRoot}"
            Different roots are not supported.''
    else if ! pathExists root then
      throw ''
        lib.fileset.toSource: `root` ${toString root} does not exist.''
    else if pathType root != "directory" then
      throw ''
        lib.fileset.toSource: `root` ${toString root} is a file, but it should be a directory instead. Potential solutions:
            - If you want to import the file into the store _without_ a containing directory, use string interpolation or `builtins.path` instead of this function.
            - If you want to import the file into the store _with_ a containing directory, set `root` to the containing directory, such as ${toString (dirOf root)}, and set `fileset` to the file path.''
    else if ! hasPrefix root fileset._internalBase then
      throw ''
        lib.fileset.toSource: `fileset` could contain files in ${toString fileset._internalBase}, which is not under the `root` ${toString root}. Potential solutions:
            - Set `root` to ${toString fileset._internalBase} or any directory higher up. This changes the layout of the resulting store path.
            - Set `fileset` to a file set that cannot contain files outside the `root` ${toString root}. This could change the files included in the result.''
    else
      builtins.seq filter
      cleanSourceWith {
        name = "source";
        src = root;
        inherit filter;
      };
}
