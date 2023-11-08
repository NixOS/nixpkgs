{ lib }:
let

  inherit (import ./internal.nix { inherit lib; })
    _coerce
    _coerceMany
    _toSourceFilter
    _unionMany
    _fileFilter
    _printFileset
    _intersection
    _difference
    ;

  inherit (builtins)
    isList
    isPath
    pathExists
    seq
    typeOf
    ;

  inherit (lib.lists)
    elemAt
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
    isFunction
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
          lib.fileset.toSource: `root` (${toString root}) is a string-like value, but it should be a path instead.
              Paths in strings are not supported by `lib.fileset`, use `lib.sources` or derivations instead.''
      else
        throw ''
          lib.fileset.toSource: `root` is of type ${typeOf root}, but it should be a path instead.''
    # Currently all Nix paths have the same filesystem root, but this could change in the future.
    # See also ../path/README.md
    else if ! fileset._internalIsEmptyWithoutBase && rootFilesystemRoot != filesetFilesystemRoot then
      throw ''
        lib.fileset.toSource: Filesystem roots are not the same for `fileset` and `root` (${toString root}):
            `root`: Filesystem root is "${toString rootFilesystemRoot}"
            `fileset`: Filesystem root is "${toString filesetFilesystemRoot}"
            Different filesystem roots are not supported.''
    else if ! pathExists root then
      throw ''
        lib.fileset.toSource: `root` (${toString root}) is a path that does not exist.''
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
          context = "First argument";
          value = fileset1;
        }
        {
          context = "Second argument";
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
      throw ''
        lib.fileset.unions: Argument is of type ${typeOf filesets}, but it should be a list instead.''
    else
      pipe filesets [
        # Annotate the elements with context, used by _coerceMany for better errors
        (imap0 (i: el: {
          context = "Element ${toString i}";
          value = el;
        }))
        (_coerceMany "lib.fileset.unions")
        _unionMany
      ];

  /*
    Filter a file set to only contain files matching some predicate.

    Type:
      fileFilter ::
        ({
          name :: String,
          type :: String,
          ...
        } -> Bool)
        -> FileSet
        -> FileSet

    Example:
      # Include all regular `default.nix` files in the current directory
      fileFilter (file: file.name == "default.nix") ./.

      # Include all non-Nix files from the current directory
      fileFilter (file: ! hasSuffix ".nix" file.name) ./.

      # Include all files that start with a "." in the current directory
      fileFilter (file: hasPrefix "." file.name) ./.

      # Include all regular files (not symlinks or others) in the current directory
      fileFilter (file: file.type == "regular")
  */
  fileFilter =
    /*
      The predicate function to call on all files contained in given file set.
      A file is included in the resulting file set if this function returns true for it.

      This function is called with an attribute set containing these attributes:

      - `name` (String): The name of the file

      - `type` (String, one of `"regular"`, `"symlink"` or `"unknown"`): The type of the file.
        This matches result of calling [`builtins.readFileType`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-readFileType) on the file's path.

      Other attributes may be added in the future.
    */
    predicate:
    # The file set to filter based on the predicate function
    fileset:
    if ! isFunction predicate then
      throw ''
        lib.fileset.fileFilter: First argument is of type ${typeOf predicate}, but it should be a function.''
    else
      _fileFilter predicate
        (_coerce "lib.fileset.fileFilter: Second argument" fileset);

  /*
    The file set containing all files that are in both of two given file sets.
    See also [Intersection (set theory)](https://en.wikipedia.org/wiki/Intersection_(set_theory)).

    The given file sets are evaluated as lazily as possible,
    with the first argument being evaluated first if needed.

    Type:
      intersection :: FileSet -> FileSet -> FileSet

    Example:
      # Limit the selected files to the ones in ./., so only ./src and ./Makefile
      intersection ./. (unions [ ../LICENSE ./src ./Makefile ])
  */
  intersection =
    # The first file set.
    # This argument can also be a path,
    # which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).
    fileset1:
    # The second file set.
    # This argument can also be a path,
    # which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).
    fileset2:
    let
      filesets = _coerceMany "lib.fileset.intersection" [
        {
          context = "First argument";
          value = fileset1;
        }
        {
          context = "Second argument";
          value = fileset2;
        }
      ];
    in
    _intersection
      (elemAt filesets 0)
      (elemAt filesets 1);

  /*
    The file set containing all files from the first file set that are not in the second file set.
    See also [Difference (set theory)](https://en.wikipedia.org/wiki/Complement_(set_theory)#Relative_complement).

    The given file sets are evaluated as lazily as possible,
    with the first argument being evaluated first if needed.

    Type:
      union :: FileSet -> FileSet -> FileSet

    Example:
      # Create a file set containing all files from the current directory,
      # except ones under ./tests
      difference ./. ./tests

      let
        # A set of Nix-related files
        nixFiles = unions [ ./default.nix ./nix ./tests/default.nix ];
      in
      # Create a file set containing all files under ./tests, except ones in `nixFiles`,
      # meaning only without ./tests/default.nix
      difference ./tests nixFiles
  */
  difference =
    # The positive file set.
    # The result can only contain files that are also in this file set.
    #
    # This argument can also be a path,
    # which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).
    positive:
    # The negative file set.
    # The result will never contain files that are also in this file set.
    #
    # This argument can also be a path,
    # which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).
    negative:
    let
      filesets = _coerceMany "lib.fileset.difference" [
        {
          context = "First argument (positive set)";
          value = positive;
        }
        {
          context = "Second argument (negative set)";
          value = negative;
        }
      ];
    in
    _difference
      (elemAt filesets 0)
      (elemAt filesets 1);

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
      actualFileset = _coerce "lib.fileset.trace: Argument" fileset;
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
      actualFileset = _coerce "lib.fileset.traceVal: Argument" fileset;
    in
    seq
      (_printFileset actualFileset)
      # We could also return the original fileset argument here,
      # but that would then duplicate work for consumers of the fileset, because then they have to coerce it again
      actualFileset;
}
