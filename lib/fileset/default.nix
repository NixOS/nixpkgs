/**
  <!-- This anchor is here for backwards compatibility -->
  []{#sec-fileset}

  The [`lib.fileset`](#sec-functions-library-fileset) library allows you to work with _file sets_.
  A file set is a (mathematical) set of local files that can be added to the Nix store for use in Nix derivations.
  File sets are easy and safe to use, providing obvious and composable semantics with good error messages to prevent mistakes.

  # Overview {#sec-fileset-overview}

  Basics:
  - [Implicit coercion from paths to file sets](#sec-fileset-path-coercion)

  - [`lib.fileset.maybeMissing`](#function-library-lib.fileset.maybeMissing):

    Create a file set from a path that may be missing.

  - [`lib.fileset.trace`](#function-library-lib.fileset.trace)/[`lib.fileset.traceVal`](#function-library-lib.fileset.trace):

    Pretty-print file sets for debugging.

  - [`lib.fileset.toSource`](#function-library-lib.fileset.toSource):

    Add files in file sets to the store to use as derivation sources.

  - [`lib.fileset.toList`](#function-library-lib.fileset.toList):

    The list of files contained in a file set.

  Combinators:
  - [`lib.fileset.union`](#function-library-lib.fileset.union)/[`lib.fileset.unions`](#function-library-lib.fileset.unions):

    Create a larger file set from all the files in multiple file sets.

  - [`lib.fileset.intersection`](#function-library-lib.fileset.intersection):

    Create a smaller file set from only the files in both file sets.

  - [`lib.fileset.difference`](#function-library-lib.fileset.difference):

    Create a smaller file set containing all files that are in one file set, but not another one.

  Filtering:
  - [`lib.fileset.fileFilter`](#function-library-lib.fileset.fileFilter):

    Create a file set from all files that satisisfy a predicate in a directory.

  Utilities:
  - [`lib.fileset.fromSource`](#function-library-lib.fileset.fromSource):

    Create a file set from a `lib.sources`-based value.

  - [`lib.fileset.gitTracked`](#function-library-lib.fileset.gitTracked)/[`lib.fileset.gitTrackedWith`](#function-library-lib.fileset.gitTrackedWith):

    Create a file set from all tracked files in a local Git repository.

  If you need more file set functions,
  see [this issue](https://github.com/NixOS/nixpkgs/issues/266356) to request it.


  # Implicit coercion from paths to file sets {#sec-fileset-path-coercion}

  All functions accepting file sets as arguments can also accept [paths](https://nixos.org/manual/nix/stable/language/values.html#type-path) as arguments.
  Such path arguments are implicitly coerced to file sets containing all files under that path:
  - A path to a file turns into a file set containing that single file.
  - A path to a directory turns into a file set containing all files _recursively_ in that directory.

  If the path points to a non-existent location, an error is thrown.

  ::: {.note}
  Just like in Git, file sets cannot represent empty directories.
  Because of this, a path to a directory that contains no files (recursively) will turn into a file set containing no files.
  :::

  :::{.note}
  File set coercion does _not_ add any of the files under the coerced paths to the store.
  Only the [`toSource`](#function-library-lib.fileset.toSource) function adds files to the Nix store, and only those files contained in the `fileset` argument.
  This is in contrast to using [paths in string interpolation](https://nixos.org/manual/nix/stable/language/values.html#type-path), which does add the entire referenced path to the store.
  :::

  ## Example {#sec-fileset-path-coercion-example}

  Assume we are in a local directory with a file hierarchy like this:
  ```
  ├─ a/
  │  ├─ x (file)
  │  └─ b/
  │     └─ y (file)
  └─ c/
     └─ d/
  ```

  Here's a listing of which files get included when different path expressions get coerced to file sets:
  - `./.` as a file set contains both `a/x` and `a/b/y` (`c/` does not contain any files and is therefore omitted).
  - `./a` as a file set contains both `a/x` and `a/b/y`.
  - `./a/x` as a file set contains only `a/x`.
  - `./a/b` as a file set contains only `a/b/y`.
  - `./c` as a file set is empty, since neither `c` nor `c/d` contain any files.
*/
{ lib }:
let

  inherit (import ./internal.nix { inherit lib; })
    _coerce
    _singleton
    _coerceMany
    _toSourceFilter
    _fromSourceFilter
    _toList
    _unionMany
    _fileFilter
    _printFileset
    _intersection
    _difference
    _fromFetchGit
    _fetchGitSubmodulesMinver
    _emptyWithoutBase
    ;

  inherit (builtins)
    isBool
    isList
    isPath
    pathExists
    seq
    typeOf
    nixVersion
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
    versionOlder
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

  /**
    Create a file set from a path that may or may not exist:
    - If the path does exist, the path is [coerced to a file set](#sec-fileset-path-coercion).
    - If the path does not exist, a file set containing no files is returned.


    # Inputs

    `path`

    : 1\. Function argument

    # Type

    ```
    maybeMissing :: Path -> FileSet
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.maybeMissing` usage example

    ```nix
    # All files in the current directory, but excluding main.o if it exists
    difference ./. (maybeMissing ./main.o)
    ```

    :::
  */
  maybeMissing =
    path:
    if ! isPath path then
      if isStringLike path then
        throw ''
          lib.fileset.maybeMissing: Argument ("${toString path}") is a string-like value, but it should be a path instead.''
      else
        throw ''
          lib.fileset.maybeMissing: Argument is of type ${typeOf path}, but it should be a path instead.''
    else if ! pathExists path then
      _emptyWithoutBase
    else
      _singleton path;

  /**
    Incrementally evaluate and trace a file set in a pretty way.
    This function is only intended for debugging purposes.
    The exact tracing format is unspecified and may change.

    This function takes a final argument to return.
    In comparison, [`traceVal`](#function-library-lib.fileset.traceVal) returns
    the given file set argument.

    This variant is useful for tracing file sets in the Nix repl.


    # Inputs

    `fileset`

    : The file set to trace.

      This argument can also be a path,
      which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

    `val`

    : The value to return.

    # Type

    ```
    trace :: FileSet -> Any -> Any
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.trace` usage example

    ```nix
    trace (unions [ ./Makefile ./src ./tests/run.sh ]) null
    =>
    trace: /home/user/src/myProject
    trace: - Makefile (regular)
    trace: - src (all files in directory)
    trace: - tests
    trace:   - run.sh (regular)
    null
    ```

    :::
  */
  trace = fileset:
    let
      # "fileset" would be a better name, but that would clash with the argument name,
      # and we cannot change that because of https://github.com/nix-community/nixdoc/issues/76
      actualFileset = _coerce "lib.fileset.trace: Argument" fileset;
    in
    seq
      (_printFileset actualFileset)
      (x: x);

  /**
    Incrementally evaluate and trace a file set in a pretty way.
    This function is only intended for debugging purposes.
    The exact tracing format is unspecified and may change.

    This function returns the given file set.
    In comparison, [`trace`](#function-library-lib.fileset.trace) takes another argument to return.

    This variant is useful for tracing file sets passed as arguments to other functions.


    # Inputs

    `fileset`

    : The file set to trace and return.

      This argument can also be a path,
      which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

    # Type

    ```
    traceVal :: FileSet -> FileSet
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.traceVal` usage example

    ```nix
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
    ```

    :::
  */
  traceVal = fileset:
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

  /**
    Add the local files contained in `fileset` to the store as a single [store path](https://nixos.org/manual/nix/stable/glossary#gloss-store-path) rooted at `root`.

    The result is the store path as a string-like value, making it usable e.g. as the `src` of a derivation, or in string interpolation:
    ```nix
    stdenv.mkDerivation {
      src = lib.fileset.toSource { ... };
      # ...
    }
    ```

    The name of the store path is always `source`.

    # Inputs

    Takes an attribute set with the following attributes

    `root` (Path; _required_)

    : The local directory [path](https://nixos.org/manual/nix/stable/language/values.html#type-path) that will correspond to the root of the resulting store path.
      Paths in [strings](https://nixos.org/manual/nix/stable/language/values.html#type-string), including Nix store paths, cannot be passed as `root`.
      `root` has to be a directory.

      :::{.note}
      Changing `root` only affects the directory structure of the resulting store path, it does not change which files are added to the store.
      The only way to change which files get added to the store is by changing the `fileset` attribute.
      :::

    `fileset` (FileSet; _required_)

    : The file set whose files to import into the store.
      File sets can be created using other functions in this library.
      This argument can also be a path,
      which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

      :::{.note}
      If a directory does not recursively contain any file, it is omitted from the store path contents.
      :::

    # Type

    ```
    toSource :: {
      root :: Path,
      fileset :: FileSet,
    } -> SourceLike
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.toSource` usage example

    ```nix
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
    ```

    :::
  */
  toSource = {
    root,
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
      if root ? _isLibCleanSourceWith then
        throw ''
          lib.fileset.toSource: `root` is a `lib.sources`-based value, but it should be a path instead.
              To use a `lib.sources`-based value, convert it to a file set using `lib.fileset.fromSource` and pass it as `fileset`.
              Note that this only works for sources created from paths.''
      else if isStringLike root then
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
      seq sourceFilter
      cleanSourceWith {
        name = "source";
        src = root;
        filter = sourceFilter;
      };


  /**
    The list of file paths contained in the given file set.

    :::{.note}
    This function is strict in the entire file set.
    This is in contrast with combinators [`lib.fileset.union`](#function-library-lib.fileset.union),
    [`lib.fileset.intersection`](#function-library-lib.fileset.intersection) and [`lib.fileset.difference`](#function-library-lib.fileset.difference).

    Thus it is recommended to call `toList` on file sets created using the combinators,
    instead of doing list processing on the result of `toList`.
    :::

    The resulting list of files can be turned back into a file set using [`lib.fileset.unions`](#function-library-lib.fileset.unions).


    # Inputs

    `fileset`

    : The file set whose file paths to return. This argument can also be a path, which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

    # Type

    ```
    toList :: FileSet -> [ Path ]
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.toList` usage example

    ```nix
    toList ./.
    [ ./README.md ./Makefile ./src/main.c ./src/main.h ]

    toList (difference ./. ./src)
    [ ./README.md ./Makefile ]
    ```

    :::
  */
  toList = fileset:
    _toList (_coerce "lib.fileset.toList: Argument" fileset);

  /**
    The file set containing all files that are in either of two given file sets.
    This is the same as [`unions`](#function-library-lib.fileset.unions),
    but takes just two file sets instead of a list.
    See also [Union (set theory)](https://en.wikipedia.org/wiki/Union_(set_theory)).

    The given file sets are evaluated as lazily as possible,
    with the first argument being evaluated first if needed.


    # Inputs

    `fileset1`

    : The first file set. This argument can also be a path, which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

    `fileset2`

    : The second file set. This argument can also be a path, which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

    # Type

    ```
    union :: FileSet -> FileSet -> FileSet
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.union` usage example

    ```nix
    # Create a file set containing the file `Makefile`
    # and all files recursively in the `src` directory
    union ./Makefile ./src

    # Create a file set containing the file `Makefile`
    # and the LICENSE file from the parent directory
    union ./Makefile ../LICENSE
    ```

    :::
  */
  union =
    fileset1:
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

  /**
    The file set containing all files that are in any of the given file sets.
    This is the same as [`union`](#function-library-lib.fileset.unions),
    but takes a list of file sets instead of just two.
    See also [Union (set theory)](https://en.wikipedia.org/wiki/Union_(set_theory)).

    The given file sets are evaluated as lazily as possible,
    with earlier elements being evaluated first if needed.


    # Inputs

    `filesets`

    : A list of file sets. The elements can also be paths, which get [implicitly coerced to file sets](#sec-fileset-path-coercion).

    # Type

    ```
    unions :: [ FileSet ] -> FileSet
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.unions` usage example

    ```nix
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
    ```

    :::
  */
  unions =
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

  /**
    The file set containing all files that are in both of two given file sets.
    See also [Intersection (set theory)](https://en.wikipedia.org/wiki/Intersection_(set_theory)).

    The given file sets are evaluated as lazily as possible,
    with the first argument being evaluated first if needed.


    # Inputs

    `fileset1`

    : The first file set. This argument can also be a path, which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

    `fileset2`

    : The second file set. This argument can also be a path, which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

    # Type

    ```
    intersection :: FileSet -> FileSet -> FileSet
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.intersection` usage example

    ```nix
    # Limit the selected files to the ones in ./., so only ./src and ./Makefile
    intersection ./. (unions [ ../LICENSE ./src ./Makefile ])
    ```

    :::
  */
  intersection =
    fileset1:
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

  /**
    The file set containing all files from the first file set that are not in the second file set.
    See also [Difference (set theory)](https://en.wikipedia.org/wiki/Complement_(set_theory)#Relative_complement).

    The given file sets are evaluated as lazily as possible,
    with the first argument being evaluated first if needed.


    # Inputs

    `positive`

    : The positive file set. The result can only contain files that are also in this file set.  This argument can also be a path, which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

    `negative`

    : The negative file set. The result will never contain files that are also in this file set.  This argument can also be a path, which gets [implicitly coerced to a file set](#sec-fileset-path-coercion).

    # Type

    ```
    union :: FileSet -> FileSet -> FileSet
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.difference` usage example

    ```nix
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
    ```

    :::
  */
  difference =
    positive:
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

  /**
    Filter a file set to only contain files matching some predicate.


    # Inputs

    `predicate`

    : The predicate function to call on all files contained in given file set.
      A file is included in the resulting file set if this function returns true for it.

      This function is called with an attribute set containing these attributes:

      - `name` (String): The name of the file

      - `type` (String, one of `"regular"`, `"symlink"` or `"unknown"`): The type of the file.
        This matches result of calling [`builtins.readFileType`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-readFileType) on the file's path.

      - `hasExt` (String -> Bool): Whether the file has a certain file extension.
        `hasExt ext` is true only if `hasSuffix ".${ext}" name`.

        This also means that e.g. for a file with name `.gitignore`,
        `hasExt "gitignore"` is true.

      Other attributes may be added in the future.

    `path`

    : The path whose files to filter

    # Type

    ```
    fileFilter ::
      ({
        name :: String,
        type :: String,
        hasExt :: String -> Bool,
        ...
      } -> Bool)
      -> Path
      -> FileSet
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.fileFilter` usage example

    ```nix
    # Include all regular `default.nix` files in the current directory
    fileFilter (file: file.name == "default.nix") ./.

    # Include all non-Nix files from the current directory
    fileFilter (file: ! file.hasExt "nix") ./.

    # Include all files that start with a "." in the current directory
    fileFilter (file: hasPrefix "." file.name) ./.

    # Include all regular files (not symlinks or others) in the current directory
    fileFilter (file: file.type == "regular") ./.
    ```

    :::
  */
  fileFilter =
    predicate:
    path:
    if ! isFunction predicate then
      throw ''
        lib.fileset.fileFilter: First argument is of type ${typeOf predicate}, but it should be a function instead.''
    else if ! isPath path then
      if path._type or "" == "fileset" then
        throw ''
          lib.fileset.fileFilter: Second argument is a file set, but it should be a path instead.
              If you need to filter files in a file set, use `intersection fileset (fileFilter pred ./.)` instead.''
      else
        throw ''
          lib.fileset.fileFilter: Second argument is of type ${typeOf path}, but it should be a path instead.''
    else if ! pathExists path then
      throw ''
        lib.fileset.fileFilter: Second argument (${toString path}) is a path that does not exist.''
    else
      _fileFilter predicate path;

  /**
    Create a file set with the same files as a `lib.sources`-based value.
    This does not import any of the files into the store.

    This can be used to gradually migrate from `lib.sources`-based filtering to `lib.fileset`.

    A file set can be turned back into a source using [`toSource`](#function-library-lib.fileset.toSource).

    :::{.note}
    File sets cannot represent empty directories.
    Turning the result of this function back into a source using `toSource` will therefore not preserve empty directories.
    :::


    # Inputs

    `source`

    : 1\. Function argument

    # Type

    ```
    fromSource :: SourceLike -> FileSet
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.fromSource` usage example

    ```nix
    # There's no cleanSource-like function for file sets yet,
    # but we can just convert cleanSource to a file set and use it that way
    toSource {
      root = ./.;
      fileset = fromSource (lib.sources.cleanSource ./.);
    }

    # Keeping a previous sourceByRegex (which could be migrated to `lib.fileset.unions`),
    # but removing a subdirectory using file set functions
    difference
      (fromSource (lib.sources.sourceByRegex ./. [
        "^README\.md$"
        # This regex includes everything in ./doc
        "^doc(/.*)?$"
      ])
      ./doc/generated

    # Use cleanSource, but limit it to only include ./Makefile and files under ./src
    intersection
      (fromSource (lib.sources.cleanSource ./.))
      (unions [
        ./Makefile
        ./src
      ]);
    ```

    :::
  */
  fromSource = source:
    let
      # This function uses `._isLibCleanSourceWith`, `.origSrc` and `.filter`,
      # which are technically internal to lib.sources,
      # but we'll allow this since both libraries are in the same code base
      # and this function is a bridge between them.
      isFiltered = source ? _isLibCleanSourceWith;
      path = if isFiltered then source.origSrc else source;
    in
    # We can only support sources created from paths
    if ! isPath path then
      if isStringLike path then
        throw ''
          lib.fileset.fromSource: The source origin of the argument is a string-like value ("${toString path}"), but it should be a path instead.
              Sources created from paths in strings cannot be turned into file sets, use `lib.sources` or derivations instead.''
      else
        throw ''
          lib.fileset.fromSource: The source origin of the argument is of type ${typeOf path}, but it should be a path instead.''
    else if ! pathExists path then
      throw ''
        lib.fileset.fromSource: The source origin (${toString path}) of the argument is a path that does not exist.''
    else if isFiltered then
      _fromSourceFilter path source.filter
    else
      # If there's no filter, no need to run the expensive conversion, all subpaths will be included
      _singleton path;

  /**
    Create a file set containing all [Git-tracked files](https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository) in a repository.

    This function behaves like [`gitTrackedWith { }`](#function-library-lib.fileset.gitTrackedWith) - using the defaults.


    # Inputs

    `path`

    : The [path](https://nixos.org/manual/nix/stable/language/values#type-path) to the working directory of a local Git repository.
      This directory must contain a `.git` file or subdirectory.

    # Type

    ```
    gitTracked :: Path -> FileSet
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.gitTracked` usage example

    ```nix
    # Include all files tracked by the Git repository in the current directory
    gitTracked ./.

    # Include only files tracked by the Git repository in the parent directory
    # that are also in the current directory
    intersection ./. (gitTracked ../.)
    ```

    :::
  */
  gitTracked =
    path:
    _fromFetchGit
      "gitTracked"
      "argument"
      path
      {};

  /**
    Create a file set containing all [Git-tracked files](https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository) in a repository.
    The first argument allows configuration with an attribute set,
    while the second argument is the path to the Git working tree.

    `gitTrackedWith` does not perform any filtering when the path is a [Nix store path](https://nixos.org/manual/nix/stable/store/store-path.html#store-path) and not a repository.
    In this way, it accommodates the use case where the expression that makes the `gitTracked` call does not reside in an actual git repository anymore,
    and has presumably already been fetched in a way that excludes untracked files.
    Fetchers with such equivalent behavior include `builtins.fetchGit`, `builtins.fetchTree` (experimental), and `pkgs.fetchgit` when used without `leaveDotGit`.

    If you don't need the configuration,
    you can use [`gitTracked`](#function-library-lib.fileset.gitTracked) instead.

    This is equivalent to the result of [`unions`](#function-library-lib.fileset.unions) on all files returned by [`git ls-files`](https://git-scm.com/docs/git-ls-files)
    (which uses [`--cached`](https://git-scm.com/docs/git-ls-files#Documentation/git-ls-files.txt--c) by default).

    :::{.warning}
    Currently this function is based on [`builtins.fetchGit`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-fetchGit)
    As such, this function causes all Git-tracked files to be unnecessarily added to the Nix store,
    without being re-usable by [`toSource`](#function-library-lib.fileset.toSource).

    This may change in the future.
    :::


    # Inputs

    `options` (attribute set)
    : `recurseSubmodules` (optional, default: `false`)
      : Whether to recurse into [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to also include their tracked files.
        If `true`, this is equivalent to passing the [--recurse-submodules](https://git-scm.com/docs/git-ls-files#Documentation/git-ls-files.txt---recurse-submodules) flag to `git ls-files`.

      `path`
      : The [path](https://nixos.org/manual/nix/stable/language/values#type-path) to the working directory of a local Git repository.
        This directory must contain a `.git` file or subdirectory.

    # Type

    ```
    gitTrackedWith :: { recurseSubmodules :: Bool ? false } -> Path -> FileSet
    ```

    # Examples
    :::{.example}
    ## `lib.fileset.gitTrackedWith` usage example

    ```nix
    # Include all files tracked by the Git repository in the current directory
    # and any submodules under it
    gitTracked { recurseSubmodules = true; } ./.
    ```

    :::
  */
  gitTrackedWith =
    {
      recurseSubmodules ? false,
    }:
    path:
    if ! isBool recurseSubmodules then
      throw "lib.fileset.gitTrackedWith: Expected the attribute `recurseSubmodules` of the first argument to be a boolean, but it's a ${typeOf recurseSubmodules} instead."
    else if recurseSubmodules && versionOlder nixVersion _fetchGitSubmodulesMinver then
      throw "lib.fileset.gitTrackedWith: Setting the attribute `recurseSubmodules` to `true` is only supported for Nix version ${_fetchGitSubmodulesMinver} and after, but Nix version ${nixVersion} is used."
    else
      _fromFetchGit
        "gitTrackedWith"
        "second argument"
        path
        # This is the only `fetchGit` parameter that makes sense in this context.
        # We can't just pass `submodules = recurseSubmodules` here because
        # this would fail for Nix versions that don't support `submodules`.
        (lib.optionalAttrs recurseSubmodules {
          submodules = true;
        });
}
