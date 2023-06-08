# Add this to docs somewhere: If you pass the same arguments to the same functions, you will get the same result
{ lib }:
let
  # TODO: Add builtins.traceVerbose or so to all the operations for debugging
  # TODO: Document limitation that empty directories won't be included
  # TODO: Point out that equality comparison using `==` doesn't quite work because there's multiple representations for all files in a directory: "directory" and `readDir path`.
  # TODO: subset and superset check functions. Can easily be implemented with `difference` and `isEmpty`
  # TODO: Write down complexity of each operation, most should be O(1)!
  # TODO: Implement an operation for optionally including a file if it exists.
  # TODO: Derive property tests from https://en.wikipedia.org/wiki/Algebra_of_sets

  inherit (builtins)
    isAttrs
    isString
    isPath
    isList
    typeOf
    readDir
    match
    pathExists
    seq
    ;

  inherit (lib.trivial)
    mapNullable
    ;

  inherit (lib.lists)
    head
    tail
    foldl'
    range
    length
    elemAt
    all
    imap0
    drop
    commonPrefix
    ;

  inherit (lib.strings)
    isCoercibleToString
    ;

  inherit (lib.attrsets)
    mapAttrs
    attrNames
    attrValues
    ;

  inherit (lib.filesystem)
    pathType
    ;

  inherit (lib.sources)
    cleanSourceWith
    ;

  inherit (lib.path)
    append
    deconstruct
    construct
    hasPrefix
    removePrefix
    ;

  inherit (lib.path.components)
    fromSubpath
    ;

  # Internal file set structure:
  #
  # # A set of files
  # <fileset> = {
  #   _type = "fileset";
  #
  #   # The base path, only files under this path can be represented
  #   # Always a directory
  #   _base = <path>;
  #
  #   # A tree representation of all included files
  #   _tree = <tree>;
  # };
  #
  # # A directory entry value
  # <tree> =
  #   # A nested directory
  #   <directory>
  #
  #   # A nested file
  #   | <file>
  #
  #   # A removed file or directory
  #   # This is represented like this instead of removing the entry from the attribute set because:
  #   # - It improves laziness
  #   # - It allows keeping the attribute set as a `builtins.readDir` cache
  #   | null
  #
  # # A directory
  # <directory> =
  #   # The inclusion state for every directory entry
  #   { <name> = <tree>; }
  #
  #   # All files in a directory, recursively.
  #   # Semantically this is equivalent to `builtins.readDir path`, but lazier, because
  #   # operations that don't require the entry listing can avoid it.
  #   # This string is chosen to be compatible with `builtins.readDir` for a simpler implementation
  #   "directory";
  #
  # # A file
  # <file> =
  #   # A file with this filetype
  #   # These strings match `builtins.readDir` for a simpler implementation
  #   "regular" | "symlink" | "unknown"

  # Create a fileset structure
  # Type: Path -> <tree> -> <fileset>
  _create = base: tree: {
    _type = "fileset";
    # All attributes are internal
    _base = base;
    _tree = tree;
    # Double __ to make it be evaluated and ordered first
    __noEval = throw ''
      File sets are not intended to be directly inspected or evaluated. Instead prefer:
      - If you want to print a file set, use the `lib.fileset.trace` or `lib.fileset.pretty` function.
      - If you want to check file sets for equality, use the `lib.fileset.equals` function.
    '';
  };

  # Create a file set from a path
  # Type: Path -> <fileset>
  _singleton = path:
    let
      type = pathType path;
    in
    if type == "directory" then
      _create path type
    else
      # Always coerce to a directory
      # If we don't do this we run into problems like:
      # - What should `toSource { base = ./default.nix; fileset = difference ./default.nix ./default.nix; }` do?
      #   - Importing an empty directory wouldn't make much sense because our `base` is a file
      #   - Neither can we create a store path containing nothing at all
      #   - The only option is to throw an error that `base` should be a directory
      # - Should `fileFilter (file: file.name == "default.nix") ./default.nix` run the predicate on the ./default.nix file?
      #   - If no, should the result include or exclude ./default.nix? In any case, it would be confusing and inconsistent
      #   - If yes, it needs to consider ./. to have influence the filesystem result, because file names are part of the parent directory, so filter would change the necessary base
      _create (dirOf path)
        (_nestTree
          (dirOf path)
          [ (baseNameOf path) ]
          type
        );

  # Turn a builtins.filterSource-based source filter on a root path into a file set containing only files included by the filter
  # Type: Path -> (String -> String -> Bool) -> <fileset>
  _fromSource = root: filter:
    let
      recurse = focusPath: type:
        # FIXME: Generally we shouldn't use toString on paths, though it might be correct
        # here since we're trying to mimic the impure behavior of `builtins.filterPath`
        if ! filter (toString focusPath) type then
          null
        else if type == "directory" then
          mapAttrs
            (name: recurse (append focusPath name))
            (readDir focusPath)
        else
          type;


      rootPathType = pathType root;
      tree =
        if rootPathType == "directory" then
          recurse root rootPathType
        else
          rootPathType;
    in
    _create root tree;

  # Coerce a value to a fileset
  # Type: String -> String -> Any -> <fileset>
  _coerce = function: context: value:
    if value._type or "" == "fileset" then
      value
    else if ! isPath value then
      if value._isLibCleanSourceWith or false then
        throw ''
          lib.fileset.${function}: Expected ${context} to be a path, but it's a value produced by `lib.sources` instead.
              Such a value is only supported when converted to a file set using `lib.fileset.fromSource`.''
      else if isCoercibleToString value then
        throw ''
          lib.fileset.${function}: Expected ${context} to be a path, but it's a string-coercible value instead, possibly a Nix store path.
              Such a value is not supported, `lib.fileset` only supports local file filtering.''
      else
        throw "lib.fileset.${function}: Expected ${context} to be a path, but got a ${typeOf value}."
    else if ! pathExists value then
      throw "lib.fileset.${function}: Expected ${context} \"${toString value}\" to be a path that exists, but it doesn't."
    else
      _singleton value;

  # Nest a tree under some further components
  # Type: Path -> [ String ] -> <tree> -> <tree>
  _nestTree = targetBase: extraComponents: tree:
    let
      recurse = index: focusPath:
        if index == length extraComponents then
          tree
        else
          let
            focusedName = elemAt extraComponents index;
          in
          mapAttrs
            (name: _:
              if name == focusedName then
                recurse (index + 1) (append focusPath name)
              else
                null
            )
            (readDir focusPath);
    in
    recurse 0 targetBase;

  # Expand "directory" to { <name> = <tree>; }
  # Type: Path -> <directory> -> { <name> = <tree>; }
  _directoryEntries = path: value:
    if isAttrs value then
      value
    else
      readDir path;

  # The following tables are a bit complicated, but they nicely explain the
  # corresponding implementations, here's the legend:
  #
  # lhs\rhs: The values for the left hand side and right hand side arguments
  # null: null, an excluded file/directory
  # attrs: satisfies `isAttrs value`, an explicitly listed directory containing nested trees
  # dir: "directory", a recursively included directory
  # str: "regular", "symlink" or "unknown", a filetype string
  # rec: A result computed by recursing
  # -: Can't occur because one argument is a directory while the other is a file
  # <number>: Indicates that the result is computed by the branch with that number

  # The union of two <tree>'s
  # Type: <tree> -> <tree> -> <tree>
  #
  # lhs\rhs |   null  |   attrs |   dir |   str |
  # ------- | ------- | ------- | ----- | ----- |
  # null    | 2 null  | 2 attrs | 2 dir | 2 str |
  # attrs   | 3 attrs | 1 rec   | 2 dir |   -   |
  # dir     | 3 dir   | 3 dir   | 2 dir |   -   |
  # str     | 3 str   |   -     |   -   | 2 str |
  _unionTree = lhs: rhs:
    # Branch 1
    if isAttrs lhs && isAttrs rhs then
      mapAttrs (name: _unionTree lhs.${name}) rhs
    # Branch 2
    else if lhs == null || isString rhs then
      rhs
    # Branch 3
    else
      lhs;

  # The intersection of two <tree>'s
  # Type: <tree> -> <tree> -> <tree>
  #
  # lhs\rhs |   null  |   attrs |   dir   |   str  |
  # ------- | ------- | ------- | ------- | ------ |
  # null    | 2 null  | 2 null  | 2 null  | 2 null |
  # attrs   | 3 null  | 1 rec   | 2 attrs |   -    |
  # dir     | 3 null  | 3 attrs | 2 dir   |   -    |
  # str     | 3 null  |   -     |   -     | 2 str  |
  _intersectTree = lhs: rhs:
    # Branch 1
    if isAttrs lhs && isAttrs rhs then
      mapAttrs (name: _intersectTree lhs.${name}) rhs
    # Branch 2
    else if lhs == null || isString rhs then
      lhs
    # Branch 3
    else
      rhs;

  # The difference between two <tree>'s
  # Type: Path -> <tree> -> <tree> -> <tree>
  #
  # lhs\rhs |   null  |   attrs |   dir  |   str  |
  # ------- | ------- | ------- | ------ | ------ |
  # null    | 1 null  | 1 null  | 1 null | 1 null |
  # attrs   | 2 attrs | 3 rec   | 1 null |   -    |
  # dir     | 2 dir   | 3 rec   | 1 null |   -    |
  # str     | 2 str   |   -     |   -    | 1 null |
  _differenceTree = path: lhs: rhs:
    # Branch 1
    if isString rhs || lhs == null then
      null
    # Branch 2
    else if rhs == null then
      lhs
    # Branch 3
    else
      mapAttrs (name: lhsValue:
        _differenceTree (append path name) lhsValue rhs.${name}
      ) (_directoryEntries path lhs);

  # Whether two <tree>'s are equal
  # Type: Path -> <tree> -> <tree> -> <tree>
  #
  # | lhs\rhs |   null  |   attrs |   dir  |   str   |
  # | ------- | ------- | ------- | ------ | ------- |
  # | null    | 1 true  | 1 rec   | 1 rec  | 1 false |
  # | attrs   | 2 rec   | 3 rec   | 3 rec  |   -     |
  # | dir     | 2 rec   | 3 rec   | 4 true |   -     |
  # | str     | 2 false |   -     |   -    | 4 true  |
  _equalsTree = path: lhs: rhs:
    # Branch 1
    if lhs == null then
      _isEmptyTree path rhs
    # Branch 2
    else if rhs == null then
      _isEmptyTree path lhs
    # Branch 3
    else if isAttrs lhs || isAttrs rhs then
      let
        lhs' = _directoryEntries path lhs;
        rhs' = _directoryEntries path rhs;
      in
      all (name:
        _equalsTree (append path name) lhs'.${name} rhs'.${name}
      ) (attrNames lhs')
    # Branch 4
    else
      true;

  # Whether a tree is empty, containing no files
  # Type: Path -> <tree> -> Bool
  _isEmptyTree = path: tree:
    if isAttrs tree || tree == "directory" then
      let
        entries = _directoryEntries path tree;
      in
      all (name: _isEmptyTree (append path name) entries.${name}) (attrNames entries)
    else
      tree == null;

  # Simplifies a tree, optionally expanding all "directory"'s into complete listings
  # Type: Bool -> Path -> <tree> -> <tree>
  _simplifyTree = expand: base: tree:
    let
      recurse = focusPath: tree:
        if tree == "directory" && expand || isAttrs tree then
          let
            expanded = _directoryEntries focusPath tree;
            transformedSubtrees = mapAttrs (name: recurse (append focusPath name)) expanded;
            values = attrValues transformedSubtrees;
          in
          if all (value: value == "emptyDir") values then
            "emptyDir"
          else if all (value: isNull value || value == "emptyDir") values then
            null
          else if !expand && all (value: isString value || value == "emptyDir") values then
            "directory"
          else
            mapAttrs (name: value: if value == "emptyDir" then null else value) transformedSubtrees
        else
          tree;
      result = recurse base tree;
    in
    if result == "emptyDir" then
      null
    else
      result;

  _prettyTreeSuffix = tree:
    if isAttrs tree then
      ""
    else if tree == "directory" then
      " (recursive directory)"
    else
      " (${tree})";

  # Pretty-print all files included in the file set.
  # Type: (b -> String -> b) -> b -> Path -> FileSet -> b
  _prettyFoldl' = f: start: base: tree:
    let
      traceTreeAttrs = start: indent: tree:
        # Nix should really be evaluating foldl''s second argument before starting the iteration
        # See the same problem in Haskell:
        # - https://stackoverflow.com/a/14282642
        # - https://gitlab.haskell.org/ghc/ghc/-/issues/12173
        # - https://well-typed.com/blog/90/#a-postscript-which-foldl
        # - https://old.reddit.com/r/haskell/comments/21wvk7/foldl_is_broken/
        seq start
          (foldl' (prev: name:
            let
              subtree = tree.${name};

              intermediate =
                f prev "${indent}- ${name}${_prettyTreeSuffix subtree}";
            in
            if subtree == null then
              # Don't print anything at all if this subtree is empty
              prev
            else if isAttrs subtree then
              # A directory with explicit entries
              # Do print this node, but also recurse
              traceTreeAttrs intermediate "${indent}  " subtree
            else
              # Either a file, or a recursively included directory
              # Do print this node but no further recursion needed
              intermediate
          ) start (attrNames tree));

      intermediate =
        if tree == null then
          f start "${toString base} (empty)"
        else
          f start "${toString base}${_prettyTreeSuffix tree}";
    in
    if isAttrs tree then
      traceTreeAttrs intermediate "" tree
    else
      intermediate;

  # Coerce and normalise the bases of multiple file set values passed to user-facing functions
  # Type: String -> [ { context :: String, value :: Any } ] -> { commonBase :: Path, trees :: [ <tree> ] }
  _normaliseBase = function: list:
    let
      processed = map ({ context, value }:
        let
          fileset = _coerce function context value;
        in {
          inherit fileset context;
          baseParts = deconstruct fileset._base;
        }
      ) list;

      first = head processed;

      commonComponents = foldl' (components: el:
        if first.baseParts.root != el.baseParts.root then
          throw "lib.fileset.${function}: Expected file sets to have the same filesystem root, but ${first.context} has root \"${toString first.baseParts.root}\" while ${el.context} has root \"${toString el.baseParts.root}\"."
        else
          commonPrefix components el.baseParts.components
      ) first.baseParts.components (tail processed);

      commonBase = construct {
        root = first.baseParts.root;
        components = commonComponents;
      };

      commonComponentsLength = length commonComponents;

      trees = map (value:
        _nestTree
          commonBase
          (drop commonComponentsLength value.baseParts.components)
          value.fileset._tree
      ) processed;
    in
    {
      inherit commonBase trees;
    };

in {

  /*
  Import a file set into the Nix store, making it usable inside derivations.
  Return a source-like value that can be coerced to a Nix store path.

  This function takes an attribute set with these attributes as an argument:

  - `root` (required): The local path that should be the root of the result.
    `fileset` must not be influenceable by paths outside `root`, meaning `lib.fileset.getInfluenceBase fileset` must be under `root`.

    Warning: Setting `root` to `lib.fileset.getInfluenceBase fileset` directly would make the resulting Nix store path file structure dependent on how `fileset` is declared.
    This makes it non-trivial to predict where specific paths are located in the result.

  - `fileset` (required): The set of files to import into the Nix store.
    Use the other `lib.fileset` functions to define `fileset`.
    Only directories containing at least one file are included in the result, unless `extraExistingDirs` is used to ensure the existence of specific directories even without any files.

  - `extraExistingDirs` (optional, default `[]`): Additionally ensure the existence of these directory paths in the result, even they don't contain any files in `fileset`.

  Type:
    toSource :: {
      root :: Path,
      fileset :: FileSet,
      extraExistingDirs :: [ Path ] ? [ ],
    } -> SourceLike
  */
  toSource = { root, fileset, extraExistingDirs ? [ ] }:
    let
      maybeFileset = fileset;
    in
    let
      fileset = _coerce "toSource" "`fileset` attribute" maybeFileset;

      # Directories that recursively have no files in them will always be `null`
      sparseTree =
        let
          recurse = focusPath: tree:
            if tree == "directory" || isAttrs tree then
              let
                entries = _directoryEntries focusPath tree;
                sparseSubtrees = mapAttrs (name: recurse (append focusPath name)) entries;
                values = attrValues sparseSubtrees;
              in
              if all isNull values then
                null
              else if all isString values then
                "directory"
              else
                sparseSubtrees
            else
              tree;
          resultingTree = recurse fileset._base fileset._tree;
          # The fileset's _base might be below the root of the `toSource`, so we need to lift the tree up to `root`
          extraRootNesting = removePrefix root fileset._base;
        in _nestTree root extraRootNesting resultingTree;

      sparseExtendedTree =
        if ! isList extraExistingDirs then
          throw "lib.fileset.toSource: Expected the `extraExistingDirs` attribute to be a list, but it's a ${typeOf extraExistingDirs} instead."
        else
          lib.foldl' (tree: i:
            let
              dir = elemAt extraExistingDirs i;

              # We're slightly abusing the internal functions and structure to ensure that the extra directory is represented in the sparse tree.
              value = mapAttrs (name: value: null) (readDir dir);
              extraTree = _nestTree root (removePrefix root dir) value;
              result = _unionTree tree extraTree;
            in
            if ! isPath dir then
              throw "lib.fileset.toSource: Expected all elements of the `extraExistingDirs` attribute to be paths, but element at index ${toString i} is a ${typeOf dir} instead."
            else if ! pathExists dir then
              throw "lib.fileset.toSource: Expected all elements of the `extraExistingDirs` attribute to be paths that exist, but the path at index ${toString i} \"${toString dir}\" does not."
            else if pathType dir != "directory" then
              throw "lib.fileset.toSource: Expected all elements of the `extraExistingDirs` attribute to be paths pointing to directories, but the path at index ${toString i} \"${toString dir}\" points to a file instead."
            else if ! hasPrefix root dir then
              throw "lib.fileset.toSource: Expected all elements of the `extraExistingDirs` attribute to be paths under the `root` attribute \"${toString root}\", but the path at index ${toString i} \"${toString dir}\" is not."
            else
              result
          ) sparseTree (range 0 (length extraExistingDirs - 1));

      rootComponentsLength = length (deconstruct root).components;

      # This function is called often for the filter, so it should be fast
      inSet = components:
        let
          recurse = index: localTree:
            if index == length components then
              localTree != null
            else if localTree ? ${elemAt components index} then
              recurse (index + 1) localTree.${elemAt components index}
            else
              localTree == "directory";
        in recurse rootComponentsLength sparseExtendedTree;

    in
    if ! isPath root then
      if root._isLibCleanSourceWith or false then
        throw ''
          lib.fileset.toSource: Expected attribute `root` to be a path, but it's a value produced by `lib.sources` instead.
              Such a value is only supported when converted to a file set using `lib.fileset.fromSource` and passed to the `fileset` attribute, where it may also be combined using other functions from `lib.fileset`.''
      else if isCoercibleToString root then
        throw ''
          lib.fileset.toSource: Expected attribute `root` to be a path, but it's a string-like value instead, possibly a Nix store path.
              Such a value is not supported, `lib.fileset` only supports local file filtering.''
      else
        throw "lib.fileset.toSource: Expected attribute `root` to be a path, but it's a ${typeOf root} instead."
    else if ! pathExists root then
      throw "lib.fileset.toSource: Expected attribute `root` \"${toString root}\" to be a path that exists, but it doesn't."
    else if pathType root != "directory" then
      throw "lib.fileset.toSource: Expected attribute `root` \"${toString root}\" to be a path pointing to a directory, but it's pointing to a file instead."
    else if ! hasPrefix root fileset._base then
      throw "lib.fileset.toSource: Expected attribute `fileset` to not be influenceable by any paths outside `root`, but `lib.fileset.getInfluenceBase fileset` \"${toString fileset._base}\" is outside `root`."
    else
      cleanSourceWith {
        name = "source";
        src = root;
        filter = pathString: _: inSet (fromSubpath "./${pathString}");
      };

  /*
  Create a file set from a filtered local source as produced by the `lib.sources` functions.
  This does not import anything into the store.

  Type:
    fromSource :: SourceLike -> FileSet

  Example:
    fromSource (lib.sources.cleanSource ./.)
  */
  fromSource = source:
    if ! source._isLibCleanSourceWith or false || ! source ? origSrc || ! source ? filter then
      throw "lib.fileset.fromSource: Expected the argument to be a value produced from `lib.sources`, but got a ${typeOf source} instead."
    else if ! isPath source.origSrc then
      throw "lib.fileset.fromSource: Expected the argument to be source-like value of a local path."
    else
      _fromSource source.origSrc source.filter;

  /*
  Coerce a value to a file set:

  - If the value is a file set already, return it directly

  - If the value is a path pointing to a file, return a file set with that single file

  - If the value is a path pointing to a directory, return a file set with all files contained in that directory

  This function is mostly not needed because all functions in `lib.fileset` will implicitly apply it for arguments that are expected to be a file set.

  Type:
    coerce :: Any -> FileSet
  */
  coerce = value: _coerce "coerce" "argument" value;


  /*
  Create a file set containing all files contained in a path (see `coerce`), or no files if the path doesn't exist.

  This is useful when you want to include a file only if it actually exists.

  Type:
    optional :: Path -> FileSet
  */
  optional = path:
    if ! isPath path then
      throw "lib.fileset.optional: Expected argument to be a path, but got a ${typeOf path}."
    else if pathExists path then
      _singleton path
    else
      _create path null;

  /*
  Return the common ancestor directory of all file set operations used to construct this file set, meaning that nothing outside the this directory can influence the set of files included.

  Type:
    getInfluenceBase :: FileSet -> Path

  Example:
    getInfluenceBase ./Makefile
    => ./.

    getInfluenceBase ./src
    => ./src

    getInfluenceBase (fileFilter (file: false) ./.)
    => ./.

    getInfluenceBase (union ./Makefile ../default.nix)
    => ../.
  */
  getInfluenceBase = maybeFileset:
    let
      fileset = _coerce "getInfluenceBase" "argument" maybeFileset;
    in
    fileset._base;

  /*
  Incrementally evaluate and trace a file set in a pretty way.
  Functionally this is the same as splitting the result from `lib.fileset.pretty` into lines and tracing those.
  However this function can do the same thing incrementally, so it can already start printing the result as the first lines are known.

  The `expand` argument (false by default) controls whether all files should be printed individually.

  Type:
    trace :: { expand :: Bool ? false } -> FileSet -> Any -> Any

  Example:
    trace {} (unions [ ./foo.nix ./bar/baz.c ./qux ])
    =>
    trace: /home/user/src/myProject
    trace: - bar
    trace:   - baz.c (regular)
    trace: - foo.nix (regular)
    trace: - qux (recursive directory)
    null

    trace { expand = true; } (unions [ ./foo.nix ./bar/baz.c ./qux ])
    =>
    trace: /home/user/src/myProject
    trace: - bar
    trace:   - baz.c (regular)
    trace: - foo.nix (regular)
    trace: - qux
    trace:   - florp.c (regular)
    trace:   - florp.h (regular)
    null
  */
  trace = { expand ? false }: maybeFileset:
    let
      fileset = _coerce "trace" "second argument" maybeFileset;
      simpleTree = _simplifyTree expand fileset._base fileset._tree;
    in
    _prettyFoldl' (acc: el: builtins.trace el acc) (x: x)
      fileset._base
      simpleTree;

  /*
  The same as `lib.fileset.trace`, but instead of taking an argument for the value to return, the given file set is returned instead.

  Type:
    traceVal :: { expand :: Bool ? false } -> FileSet -> FileSet
  */
  traceVal = { expand ? false }: maybeFileset:
    let
      fileset = _coerce "traceVal" "second argument" maybeFileset;
      simpleTree = _simplifyTree expand fileset._base fileset._tree;
    in
    _prettyFoldl' (acc: el: builtins.trace el acc) fileset
      fileset._base
      simpleTree;

  /*
  The same as `lib.fileset.trace`, but instead of tracing each line, the result is returned as a string.

  Type:
    pretty :: { expand :: Bool ? false } -> FileSet -> String
  */
  pretty = { expand ? false }: maybeFileset:
    let
      fileset = _coerce "pretty" "second argument" maybeFileset;
      simpleTree = _simplifyTree expand fileset._base fileset._tree;
    in
    _prettyFoldl' (acc: el: "${acc}\n${el}") ""
      fileset._base
      simpleTree;

  /*
  The file set containing all files that are in either of two given file sets.
  Recursively, the first argument is evaluated first, only evaluating the second argument if necessary.

      union a b = a ⋃ b

  Type:
    union :: FileSet -> FileSet -> FileSet
  */
  union = lhs: rhs:
    let
      normalised = _normaliseBase "union" [
        {
          context = "first argument";
          value = lhs;
        }
        {
          context = "second argument";
          value = rhs;
        }
      ];
    in
    _create normalised.commonBase
      (_unionTree
        (elemAt normalised.trees 0)
        (elemAt normalised.trees 1)
      );

  /*
  The file containing all files from that are in any of the given file sets.
  Recursively, the elements are evaluated from left to right, only evaluating arguments on the right if necessary.

  Type:
    unions :: [FileSet] -> FileSet
  */
  unions = list:
    let
      annotated = imap0 (i: el: {
        context = "element ${toString i} of the argument";
        value = el;
      }) list;

      normalised = _normaliseBase "unions" annotated;

      tree = foldl' _unionTree (head normalised.trees) (tail normalised.trees);
    in
    if ! isList list then
      throw "lib.fileset.unions: Expected argument to be a list, but got a ${typeOf list}."
    else if length list == 0 then
      throw "lib.fileset.unions: Expected argument to be a list with at least one element, but it contains no elements."
    else
      _create normalised.commonBase tree;

  /*
  The file set containing all files that are in both given sets.
  Recursively, the first argument is evaluated first, only evaluating the second argument if necessary.

      intersect a b == a ⋂ b

  Type:
    intersect :: FileSet -> FileSet -> FileSet
  */
  intersect = lhs: rhs:
    let
      normalised = _normaliseBase "intersect" [
        {
          context = "first argument";
          value = lhs;
        }
        {
          context = "second argument";
          value = rhs;
        }
      ];
    in
    _create normalised.commonBase
      (_intersectTree
        (elemAt normalised.trees 0)
        (elemAt normalised.trees 1)
      );

  /*
  The file set containing all files that are in all the given sets.
  Recursively, the elements are evaluated from left to right, only evaluating arguments on the right if necessary.

  Type:
    intersects :: [FileSet] -> FileSet
  */
  intersects = list:
    let
      annotated = imap0 (i: el: {
        context = "element ${toString i} of the argument";
        value = el;
      }) list;

      normalised = _normaliseBase "intersects" annotated;

      tree = foldl' _intersectTree (head normalised.trees) (tail normalised.trees);
    in
    if ! isList list then
      throw "lib.fileset.intersects: Expected argument to be a list, but got a ${typeOf list}."
    else if length list == 0 then
      throw "lib.fileset.intersects: Expected argument to be a list with at least one element, but it contains no elements."
    else
      _create normalised.commonBase tree;

  /*
  The file set containing all files that are in the first file set but not in the second.
  Recursively, the second argument is evaluated first, only evaluating the first argument if necessary.

      difference a b == a ∖ b

  Type:
    difference :: FileSet -> FileSet -> FileSet
  */
  difference = lhs: rhs:
    let
      normalised = _normaliseBase "difference" [
        {
          context = "first argument";
          value = lhs;
        }
        {
          context = "second argument";
          value = rhs;
        }
      ];
    in
    _create normalised.commonBase
      (_differenceTree normalised.commonBase
        (elemAt normalised.trees 0)
        (elemAt normalised.trees 1)
      );

  /*
  Filter a file set to only contain files matching some predicate.

  The predicate is called with an attribute set containing these attributes:

  - `name`: The filename

  - `type`: The type of the file, either "regular", "symlink" or "unknown"

  - `ext`: The file extension or `null` if the file has none.

    More formally:
    - `ext` contains no `.`
    - `.${ext}` is a suffix of the `name`

  - Potentially other attributes in the future

  Type:
    fileFilter ::
      ({
        name :: String,
        type :: String,
        ext :: String | Null,
        ...
      } -> Bool)
      -> FileSet
      -> FileSet
  */
  fileFilter = predicate: maybeFileset:
    let
      fileset = _coerce "fileFilter" "second argument" maybeFileset;
      recurse = focusPath: tree:
        mapAttrs (name: subtree:
          if isAttrs subtree || subtree == "directory" then
            recurse (append focusPath name) subtree
          else if
            predicate {
              inherit name;
              type = subtree;
              ext = mapNullable head (match ".*\\.(.*)" name);
              # To ensure forwards compatibility with more arguments being added in the future,
              # adding an attribute which can't be deconstructed :)
              "This attribute is passed to prevent `lib.fileset.fileFilter` predicate functions from breaking when more attributes are added in the future. Please add `...` to the function to handle this and future additional arguments." = null;
            }
          then
            subtree
          else
            null
        ) (_directoryEntries focusPath tree);
    in
    _create fileset._base (recurse fileset._base fileset._tree);

  /*
  A file set containing all files that are contained in a directory whose name satisfies the given predicate.
  Only directories under the given path are checked, this is to ensure that components outside of the given path cannot influence the result.
  Consequently this function does not accept a file set as an argument.
  If you need to filter files in a file set based on components, use `intersect myFileSet (directoryFilter myPredicate myPath)` instead.

  Type:
    directoryFilter :: (String -> Bool) -> Path -> FileSet

  Example:
    # Select all files in hidden directories within ./.
    directoryFilter (hasPrefix ".") ./.

    # Select all files in directories named `build` within ./src
    directoryFilter (name: name == "build") ./src
  */
  directoryFilter = predicate: path:
    let
      recurse = focusPath:
        mapAttrs (name: type:
          if type == "directory" then
            if predicate name then
              type
            else
              recurse (append focusPath name)
          else
            null
        ) (readDir focusPath);
    in
    if path._type or null == "fileset" then
      throw ''
        lib.fileset.directoryFilter: Expected second argument to be a path, but it's a file set.
            If you need to filter files in a file set, use `intersect myFileSet (directoryFilter myPredicate myPath)` instead.''
    else if ! isPath path then
      throw "lib.fileset.directoryFilter: Expected second argument to be a path, but got a ${typeOf path}."
    else if pathType path != "directory" then
      throw "lib.fileset.directoryFilter: Expected second argument \"${toString path}\" to be a directory, but it's not."
    else
      _create path (recurse path);

  /*
  Check whether two file sets contain the same files.

  Type:
    equals :: FileSet -> FileSet -> Bool
  */
  equals = lhs: rhs:
    let
      normalised = _normaliseBase "equals" [
        {
          context = "first argument";
          value = lhs;
        }
        {
          context = "second argument";
          value = rhs;
        }
      ];
    in
    _equalsTree normalised.commonBase
      (elemAt normalised.trees 0)
      (elemAt normalised.trees 1);

  /*
  Check whether a file set contains no files.

  Type:
    isEmpty :: FileSet -> Bool
  */
  isEmpty = maybeFileset:
    let
      fileset = _coerce "isEmpty" "argument" maybeFileset;
    in
    _isEmptyTree fileset._base fileset._tree;
}
