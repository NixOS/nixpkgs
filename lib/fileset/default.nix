{ lib }:
let

  inherit (import ./internal.nix { inherit lib; })
    _coerce
    _coerceMany
    _toSourceFilter
    _unionMany
    _printFileset
    ;

  inherit (builtins)
    isList
    isPath
    pathExists
    seq
    typeOf
    ;

  inherit (lib.lists)
    imap0
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

  inherit (lib.trivial)
    pipe
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
      # Import the current directory into the store
      # but only include files under ./src
      toSource {
        root = ./.;
        fileset = ./src;
      }
      => "/nix/store/...-source"

      # Import the current directory into the store
      # but only include ./Makefile and all files under ./src
      toSource {
        root = ./.;
        fileset = union
          ./Makefile
          ./src;
      }
      => "/nix/store/...-source"

      # Trying to include a file outside the root will fail
      toSource {
        root = ./.;
        fileset = unions [
          ./Makefile
          ./src
          ../LICENSE
        ];
      }
      => <error>

      # The root needs to point to a directory that contains all the files
      toSource {
        root = ../.;
        fileset = unions [
          ./Makefile
          ./src
          ../LICENSE
        ];
      }
      => "/nix/store/...-source"

      # The root has to be a local filesystem path
      toSource {
        root = "/nix/store/...-source";
        fileset = ./.;
      }
      => <error>
  */
  toSource = {
    /*
      (required) The local directory [path](https://nixos.org/manual/nix/stable/language/values.html#type-path) that will correspond to the root of the resulting store path.
      Paths in [strings](https://nixos.org/manual/nix/stable/language/values.html#type-string), including Nix store paths, cannot be passed as `root`.
      `root` has to be a directory.

<!-- Ignore the indentation here, this is a nixdoc rendering bug that needs to be fixed: https://github.com/nix-community/nixdoc/issues/75 -->
:::{.note}
Changing `root` only affects the directory structure of the resulting store path, it does not change which files are added to the store.
The only way to change which files get added to the store is by changing the `fileset` attribute.
:::
    */
    root,
    /*
      (required) The file set whose files to import into the store.
      File sets can be created using other functions in this library.
      This argument can also be a path,
      which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

<!-- Ignore the indentation here, this is a nixdoc rendering bug that needs to be fixed: https://github.com/nix-community/nixdoc/issues/75 -->
:::{.note}
If a directory does not recursively contain any file, it is omitted from the store path contents.
:::

    */
    fileset,
  }:
    let
      # We cannot rename matched attribute arguments, so let's work around it with an extra `let in` statement
      filesetArg = fileset;
    in
    let
      fileset = _coerce "lib.fileset.toSource: `fileset`" filesetArg;
      rootFilesystemRoot = (splitRoot root).root;
      filesetFilesystemRoot = (splitRoot fileset._internalBase).root;
      sourceFilter = _toSourceFilter fileset;
    in
    if ! isPath root then
      if isStringLike root then
        throw ''
          lib.fileset.toSource: `root` ("${toString root}") is a string-like value, but it should be a path instead.
              Paths in strings are not supported by `lib.fileset`, use `lib.sources` or derivations instead.''
      else
        throw ''
          lib.fileset.toSource: `root` is of type ${typeOf root}, but it should be a path instead.''
    # Currently all Nix paths have the same filesystem root, but this could change in the future.
    # See also ../path/README.md
    else if ! fileset._internalIsEmptyWithoutBase && rootFilesystemRoot != filesetFilesystemRoot then
      throw ''
        lib.fileset.toSource: Filesystem roots are not the same for `fileset` and `root` ("${toString root}"):
            `root`: root "${toString rootFilesystemRoot}"
            `fileset`: root "${toString filesetFilesystemRoot}"
            Different roots are not supported.''
    else if ! pathExists root then
      throw ''
        lib.fileset.toSource: `root` (${toString root}) does not exist.''
    else if pathType root != "directory" then
      throw ''
        lib.fileset.toSource: `root` (${toString root}) is a file, but it should be a directory instead. Potential solutions:
            - If you want to import the file into the store _without_ a containing directory, use string interpolation or `builtins.path` instead of this function.
            - If you want to import the file into the store _with_ a containing directory, set `root` to the containing directory, such as ${toString (dirOf root)}, and set `fileset` to the file path.''
    else if ! fileset._internalIsEmptyWithoutBase && ! hasPrefix root fileset._internalBase then
      throw ''
        lib.fileset.toSource: `fileset` could contain files in ${toString fileset._internalBase}, which is not under the `root` (${toString root}). Potential solutions:
            - Set `root` to ${toString fileset._internalBase} or any directory higher up. This changes the layout of the resulting store path.
            - Set `fileset` to a file set that cannot contain files outside the `root` (${toString root}). This could change the files included in the result.''
    else
      builtins.seq sourceFilter
      cleanSourceWith {
        name = "source";
        src = root;
        filter = sourceFilter;
      };

  /*
    The file set containing all files that are in either of two given file sets.
    This is the same as [`unions`](#function-library-lib.fileset.unions),
    but takes just two file sets instead of a list.
    See also [Union (set theory)](https://en.wikipedia.org/wiki/Union_(set_theory)).

    The given file sets are evaluated as lazily as possible,
    with the first argument being evaluated first if needed.

    Type:
      union :: FileSet -> FileSet -> FileSet

    Example:
      # Create a file set containing the file `Makefile`
      # and all files recursively in the `src` directory
      union ./Makefile ./src

      # Create a file set containing the file `Makefile`
      # and the LICENSE file from the parent directory
      union ./Makefile ../LICENSE
  */
  union =
    # The first file set.
    # This argument can also be a path,
    # which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).
    fileset1:
    # The second file set.
    # This argument can also be a path,
    # which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).
    fileset2:
    _unionMany
      (_coerceMany "lib.fileset.union" [
        {
          context = "first argument";
          value = fileset1;
        }
        {
          context = "second argument";
          value = fileset2;
        }
      ]);

  /*
    The file set containing all files that are in any of the given file sets.
    This is the same as [`union`](#function-library-lib.fileset.unions),
    but takes a list of file sets instead of just two.
    See also [Union (set theory)](https://en.wikipedia.org/wiki/Union_(set_theory)).

    The given file sets are evaluated as lazily as possible,
    with earlier elements being evaluated first if needed.

    Type:
      unions :: [ FileSet ] -> FileSet

    Example:
      # Create a file set containing selected files
      unions [
        # Include the single file `Makefile` in the current directory
        # This errors if the file doesn't exist
        ./Makefile

        # Recursively include all files in the `src/code` directory
        # If this directory is empty this has no effect
        ./src/code

        # Include the files `run.sh` and `unit.c` from the `tests` directory
        ./tests/run.sh
        ./tests/unit.c

        # Include the `LICENSE` file from the parent directory
        ../LICENSE
      ]
  */
  unions =
    # A list of file sets.
    # The elements can also be paths,
    # which get [implicitly coerced to file sets](#sec-fileset-path-coercion).
    filesets:
    if ! isList filesets then
      throw "lib.fileset.unions: Expected argument to be a list, but got a ${typeOf filesets}."
    else
      pipe filesets [
        # Annotate the elements with context, used by _coerceMany for better errors
        (imap0 (i: el: {
          context = "element ${toString i}";
          value = el;
        }))
        (_coerceMany "lib.fileset.unions")
        _unionMany
      ];

  /*
    Incrementally evaluate and trace a file set in a pretty way.
    This function is only intended for debugging purposes.
    The exact tracing format is unspecified and may change.

    This function takes a final argument to return.
    In comparison, [`traceVal`](#function-library-lib.fileset.traceVal) returns
    the given file set argument.

    This variant is useful for tracing file sets in the Nix repl.

    Type:
      trace :: FileSet -> Any -> Any

    Example:
      trace (unions [ ./Makefile ./src ./tests/run.sh ]) null
      =>
      trace: /home/user/src/myProject
      trace: - Makefile (regular)
      trace: - src (all files in directory)
      trace: - tests
      trace:   - run.sh (regular)
      null
  */
  trace =
    /*
    The file set to trace.

    This argument can also be a path,
    which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).
    */
    fileset:
    let
      # "fileset" would be a better name, but that would clash with the argument name,
      # and we cannot change that because of https://github.com/nix-community/nixdoc/issues/76
      actualFileset = _coerce "lib.fileset.trace: argument" fileset;
    in
    seq
      (_printFileset actualFileset)
      (x: x);

  /*
    Incrementally evaluate and trace a file set in a pretty way.
    This function is only intended for debugging purposes.
    The exact tracing format is unspecified and may change.

    This function returns the given file set.
    In comparison, [`trace`](#function-library-lib.fileset.trace) takes another argument to return.

    This variant is useful for tracing file sets passed as arguments to other functions.

    Type:
      traceVal :: FileSet -> FileSet

    Example:
      toSource {
        root = ./.;
        fileset = traceVal (unions [
          ./Makefile
          ./src
          ./tests/run.sh
        ]);
      }
      =>
      trace: /home/user/src/myProject
      trace: - Makefile (regular)
      trace: - src (all files in directory)
      trace: - tests
      trace:   - run.sh (regular)
      "/nix/store/...-source"
  */
  traceVal =
    /*
    The file set to trace and return.

    This argument can also be a path,
    which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).
    */
    fileset:
    let
      # "fileset" would be a better name, but that would clash with the argument name,
      # and we cannot change that because of https://github.com/nix-community/nixdoc/issues/76
      actualFileset = _coerce "lib.fileset.traceVal: argument" fileset;
    in
    seq
      (_printFileset actualFileset)
      # We could also return the original fileset argument here,
      # but that would then duplicate work for consumers of the fileset, because then they have to coerce it again
      actualFileset;
}
