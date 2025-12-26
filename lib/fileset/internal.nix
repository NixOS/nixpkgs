{
  lib ? import ../.,
}:
let

  inherit (builtins)
    isAttrs
    isPath
    isString
    nixVersion
    pathExists
    readDir
    split
    trace
    typeOf
    fetchGit
    ;

  inherit (lib.attrsets)
    attrNames
    attrValues
    mapAttrs
    mapAttrsToList
    optionalAttrs
    zipAttrsWith
    ;

  inherit (lib.filesystem)
    pathType
    ;

  inherit (lib.lists)
    all
    commonPrefix
    concatLists
    elemAt
    filter
    findFirst
    findFirstIndex
    foldl'
    head
    length
    sublist
    tail
    ;

  inherit (lib.path)
    append
    splitRoot
    hasStorePathPrefix
    splitStorePath
    ;

  inherit (lib.path.subpath)
    components
    join
    ;

  inherit (lib.strings)
    isStringLike
    concatStringsSep
    substring
    stringLength
    hasSuffix
    versionAtLeast
    ;

  inherit (lib.trivial)
    inPureEvalMode
    ;
in
# Rare case of justified usage of rec:
# - This file is internal, so the return value doesn't matter, no need to make things overridable
# - The functions depend on each other
# - We want to expose all of these functions for easy testing
rec {

  # If you change the internal representation, make sure to:
  # - Increment this version
  # - Add an additional migration function below
  # - Update the description of the internal representation in ./README.md
  _currentVersion = 3;

  # Migrations between versions. The 0th element converts from v0 to v1, and so on
  migrations = [
    # Convert v0 into v1: Add the _internalBase{Root,Components} attributes
    (
      filesetV0:
      let
        parts = splitRoot filesetV0._internalBase;
      in
      filesetV0
      // {
        _internalVersion = 1;
        _internalBaseRoot = parts.root;
        _internalBaseComponents = components parts.subpath;
      }
    )

    # Convert v1 into v2: filesetTree's can now also omit attributes to signal paths not being included
    (
      filesetV1:
      # This change is backwards compatible (but not forwards compatible, so we still need a new version)
      filesetV1
      // {
        _internalVersion = 2;
      }
    )

    # Convert v2 into v3: filesetTree's now have a representation for an empty file set without a base path
    (
      filesetV2:
      filesetV2
      // {
        # All v1 file sets are not the new empty file set
        _internalIsEmptyWithoutBase = false;
        _internalVersion = 3;
      }
    )
  ];

  _noEvalMessage = ''
    lib.fileset: Directly evaluating a file set is not supported.
      To turn it into a usable source, use `lib.fileset.toSource`.
      To pretty-print the contents, use `lib.fileset.trace` or `lib.fileset.traceVal`.'';

  # The empty file set without a base path
  _emptyWithoutBase = {
    _type = "fileset";

    _internalVersion = _currentVersion;

    # The one and only!
    _internalIsEmptyWithoutBase = true;

    # Due to alphabetical ordering, this is evaluated last,
    # which makes the nix repl output nicer than if it would be ordered first.
    # It also allows evaluating it strictly up to this error, which could be useful
    _noEval = throw _noEvalMessage;
  };

  # Create a fileset, see ./README.md#fileset
  # Type: path -> filesetTree -> fileset
  _create =
    base: tree:
    let
      # Decompose the base into its components
      # See ../path/README.md for why we're not just using `toString`
      parts = splitRoot base;
    in
    {
      _type = "fileset";

      _internalVersion = _currentVersion;

      _internalIsEmptyWithoutBase = false;
      _internalBase = base;
      _internalBaseRoot = parts.root;
      _internalBaseComponents = components parts.subpath;
      _internalTree = tree;

      # Due to alphabetical ordering, this is evaluated last,
      # which makes the nix repl output nicer than if it would be ordered first.
      # It also allows evaluating it strictly up to this error, which could be useful
      _noEval = throw _noEvalMessage;
    };

  # Coerce a value to a fileset. Return a set containing the attribute `success`
  # indicating whether coercing succeeded, and either `value` when `success ==
  # true`, or an error `message` when `success == false`. The string gives the
  # context for error messages.
  #
  # Type: String -> (fileset | Path) -> { success :: Bool, value :: fileset } ] -> { success :: Bool, message :: String }
  _coerceResult =
    let
      ok = value: {
        success = true;
        inherit value;
      };
      error = message: {
        success = false;
        inherit message;
      };
    in
    context: value:
    if value._type or "" == "fileset" then
      if value._internalVersion > _currentVersion then
        error ''
          ${context} is a file set created from a future version of the file set library with a different internal representation:
              - Internal version of the file set: ${toString value._internalVersion}
              - Internal version of the library: ${toString _currentVersion}
              Make sure to update your Nixpkgs to have a newer version of `lib.fileset`.''
      else if value._internalVersion < _currentVersion then
        let
          # Get all the migration functions necessary to convert from the old to the current version
          migrationsToApply = sublist value._internalVersion (
            _currentVersion - value._internalVersion
          ) migrations;
        in
        ok (foldl' (value: migration: migration value) value migrationsToApply)
      else
        ok value
    else if !isPath value then
      if value ? _isLibCleanSourceWith then
        error ''
          ${context} is a `lib.sources`-based value, but it should be a file set or a path instead.
              To convert a `lib.sources`-based value to a file set you can use `lib.fileset.fromSource`.
              Note that this only works for sources created from paths.''
      else if isStringLike value then
        error ''
          ${context} ("${toString value}") is a string-like value, but it should be a file set or a path instead.
              Paths represented as strings are not supported by `lib.fileset`, use `lib.sources` or derivations instead.''
      else
        error ''${context} is of type ${typeOf value}, but it should be a file set or a path instead.''
    else if !pathExists value then
      error ''
        ${context} (${toString value}) is a path that does not exist.
            To create a file set from a path that may not exist, use `lib.fileset.maybeMissing`.''
    else
      ok (_singleton value);

  # Coerce a value to a fileset, erroring when the value cannot be coerced.
  # The string gives the context for error messages.
  # Type: String -> (fileset | Path) -> fileset
  _coerce =
    context: value:
    let
      result = _coerceResult context value;
    in
    if result.success then result.value else throw result.message;

  # Coerce many values to filesets, erroring when any value cannot be coerced,
  # or if the filesystem root of the values doesn't match.
  # Type: String -> [ { context :: String, value :: fileset | Path } ] -> [ fileset ]
  _coerceMany =
    functionContext: list:
    let
      filesets = map ({ context, value }: _coerce "${functionContext}: ${context}" value) list;

      # Find the first value with a base, there may be none!
      firstWithBase = findFirst (fileset: !fileset._internalIsEmptyWithoutBase) null filesets;
      # This value is only accessed if first != null
      firstBaseRoot = firstWithBase._internalBaseRoot;

      # Finds the first element with a filesystem root different than the first element, if any
      differentIndex = findFirstIndex (
        fileset:
        # The empty value without a base doesn't have a base path
        !fileset._internalIsEmptyWithoutBase && firstBaseRoot != fileset._internalBaseRoot
      ) null filesets;
    in
    # Only evaluates `differentIndex` if there are any elements with a base
    if firstWithBase != null && differentIndex != null then
      throw ''
        ${functionContext}: Filesystem roots are not the same:
            ${(head list).context}: Filesystem root is "${toString firstBaseRoot}"
            ${(elemAt list differentIndex).context}: Filesystem root is "${toString (elemAt filesets differentIndex)._internalBaseRoot}"
            Different filesystem roots are not supported.''
    else
      filesets;

  # Create a file set from a path.
  # Type: Path -> fileset
  _singleton =
    path:
    let
      type = pathType path;
    in
    if type == "directory" then
      _create path type
    else
      # This turns a file path ./default.nix into a fileset with
      # - _internalBase: ./.
      # - _internalTree: {
      #     "default.nix" = <type>;
      #   }
      # See ./README.md#single-files
      _create (dirOf path) {
        ${baseNameOf path} = type;
      };

  # Expand a directory representation to an equivalent one in attribute set form.
  # All directory entries are included in the result.
  # Type: Path -> filesetTree -> { <name> = filesetTree; }
  _directoryEntries =
    path: value:
    if value == "directory" then
      readDir path
    else
      # Set all entries not present to null
      mapAttrs (name: value: null) (readDir path) // value;

  /**
    A normalisation of a filesetTree suitable filtering with `builtins.path`:
    - Replace all directories that have no files with `null`.
      This removes directories that would be empty
    - Replace all directories with all files with `"directory"`.
      This speeds up the source filter function

    Note that this function is strict, it evaluates the entire tree

    # Inputs

    `path`

    : 1\. Function argument

    `tree`

    : 2\. Function argument

    # Type

    ```
    Path -> filesetTree -> filesetTree
    ```
  */
  _normaliseTreeFilter =
    path: tree:
    if tree == "directory" || isAttrs tree then
      let
        entries = _directoryEntries path tree;
        normalisedSubtrees = mapAttrs (name: _normaliseTreeFilter (path + "/${name}")) entries;
        subtreeValues = attrValues normalisedSubtrees;
      in
      # This triggers either when all files in a directory are filtered out
      # Or when the directory doesn't contain any files at all
      if all isNull subtreeValues then
        null
      # Triggers when we have the same as a `readDir path`, so we can turn it back into an equivalent "directory".
      else if all isString subtreeValues then
        "directory"
      else
        normalisedSubtrees
    else
      tree;

  /**
    A minimal normalisation of a filesetTree, intended for pretty-printing:
    - If all children of a path are recursively included or empty directories, the path itself is also recursively included
    - If all children of a path are fully excluded or empty directories, the path itself is an empty directory
    - Other empty directories are represented with the special "emptyDir" string
      While these could be replaced with `null`, that would take another mapAttrs

    Note that this function is partially lazy.

    # Inputs

    `path`

    : 1\. Function argument

    `tree`

    : 2\. Function argument

    # Type

    ```
    Path -> filesetTree -> filesetTree (with "emptyDir"'s)
    ```
  */
  _normaliseTreeMinimal =
    path: tree:
    if tree == "directory" || isAttrs tree then
      let
        entries = _directoryEntries path tree;
        normalisedSubtrees = mapAttrs (name: _normaliseTreeMinimal (path + "/${name}")) entries;
        subtreeValues = attrValues normalisedSubtrees;
      in
      # If there are no entries, or all entries are empty directories, return "emptyDir".
      # After this branch we know that there's at least one file
      if all (value: value == "emptyDir") subtreeValues then
        "emptyDir"

      # If all subtrees are fully included or empty directories
      # (both of which are coincidentally represented as strings), return "directory".
      # This takes advantage of the fact that empty directories can be represented as included directories.
      # Note that the tree == "directory" check allows avoiding recursion
      else if tree == "directory" || all (value: isString value) subtreeValues then
        "directory"

      # If all subtrees are fully excluded or empty directories, return null.
      # This takes advantage of the fact that empty directories can be represented as excluded directories
      else if all (value: isNull value || value == "emptyDir") subtreeValues then
        null

      # Mix of included and excluded entries
      else
        normalisedSubtrees
    else
      tree;

  # Trace a filesetTree in a pretty way when the resulting value is evaluated.
  # This can handle both normal filesetTree's, and ones returned from _normaliseTreeMinimal
  # Type: Path -> filesetTree (with "emptyDir"'s) -> Null
  _printMinimalTree =
    base: tree:
    let
      treeSuffix =
        tree:
        if isAttrs tree then
          ""
        else if tree == "directory" then
          " (all files in directory)"
        else
          # This does "leak" the file type strings of the internal representation,
          # but this is the main reason these file type strings even are in the representation!
          # TODO: Consider removing that information from the internal representation for performance.
          # The file types can still be printed by querying them only during tracing
          " (${tree})";

      # Only for attribute set trees
      traceTreeAttrs =
        prevLine: indent: tree:
        foldl' (
          prevLine: name:
          let
            subtree = tree.${name};

            # Evaluating this prints the line for this subtree
            thisLine = trace "${indent}- ${name}${treeSuffix subtree}" prevLine;
          in
          if subtree == null || subtree == "emptyDir" then
            # Don't print anything at all if this subtree is empty
            prevLine
          else if isAttrs subtree then
            # A directory with explicit entries
            # Do print this node, but also recurse
            traceTreeAttrs thisLine "${indent}  " subtree
          else
            # Either a file, or a recursively included directory
            # Do print this node but no further recursion needed
            thisLine
        ) prevLine (attrNames tree);

      # Evaluating this will print the first line
      firstLine =
        if tree == null || tree == "emptyDir" then
          trace "(empty)" null
        else
          trace "${toString base}${treeSuffix tree}" null;
    in
    if isAttrs tree then traceTreeAttrs firstLine "" tree else firstLine;

  # Pretty-print a file set in a pretty way when the resulting value is evaluated
  # Type: fileset -> Null
  _printFileset =
    fileset:
    if fileset._internalIsEmptyWithoutBase then
      trace "(empty)" null
    else
      _printMinimalTree fileset._internalBase (
        _normaliseTreeMinimal fileset._internalBase fileset._internalTree
      );

  # Turn a fileset into a source filter function suitable for `builtins.path`
  # Only directories recursively containing at least one files are recursed into
  # Type: fileset -> (String -> String -> Bool)
  _toSourceFilter =
    fileset:
    let
      # Simplify the tree, necessary to make sure all empty directories are null
      # which has the effect that they aren't included in the result
      tree = _normaliseTreeFilter fileset._internalBase fileset._internalTree;

      # The base path as a string with a single trailing slash
      baseString =
        if fileset._internalBaseComponents == [ ] then
          # Need to handle the filesystem root specially
          "/"
        else
          "/" + concatStringsSep "/" fileset._internalBaseComponents + "/";

      baseLength = stringLength baseString;

      # Check whether a list of path components under the base path exists in the tree.
      # This function is called often, so it should be fast.
      # Type: [ String ] -> Bool
      inTree =
        components:
        let
          recurse =
            index: localTree:
            if isAttrs localTree then
              # We have an attribute set, meaning this is a directory with at least one file
              if index >= length components then
                # The path may have no more components though, meaning the filter is running on the directory itself,
                # so we always include it, again because there's at least one file in it.
                true
              else
                # If we do have more components, the filter runs on some entry inside this directory, so we need to recurse
                # We do +2 because builtins.split is an interleaved list of the inbetweens and the matches
                recurse (index + 2) localTree.${elemAt components index}
            else
              # If it's not an attribute set it can only be either null (in which case it's not included)
              # or a string ("directory" or "regular", etc.) in which case it's included
              localTree != null;
        in
        recurse 0 tree;

      # Filter suited when there's no files
      empty = _: _: false;

      # Filter suited when there's some files
      # This can't be used for when there's no files, because the base directory is always included
      nonEmpty =
        path: type:
        let
          # Add a slash to the path string, turning "/foo" to "/foo/",
          # making sure to not have any false prefix matches below.
          # Note that this would produce "//" for "/",
          # but builtins.path doesn't call the filter function on the `path` argument itself,
          # meaning this function can never receive "/" as an argument
          pathSlash = path + "/";
        in
        (
          # Same as `hasPrefix pathSlash baseString`, but more efficient.
          # With base /foo/bar we need to include /foo:
          # hasPrefix "/foo/" "/foo/bar/"
          if substring 0 (stringLength pathSlash) baseString == pathSlash then
            true
          # Same as `! hasPrefix baseString pathSlash`, but more efficient.
          # With base /foo/bar we need to exclude /baz
          # ! hasPrefix "/baz/" "/foo/bar/"
          else if substring 0 baseLength pathSlash != baseString then
            false
          else
            # Same as `removePrefix baseString path`, but more efficient.
            # From the above code we know that hasPrefix baseString pathSlash holds, so this is safe.
            # We don't use pathSlash here because we only needed the trailing slash for the prefix matching.
            # With base /foo and path /foo/bar/baz this gives
            # inTree (split "/" (removePrefix "/foo/" "/foo/bar/baz"))
            # == inTree (split "/" "bar/baz")
            # == inTree [ "bar" "baz" ]
            inTree (split "/" (substring baseLength (-1) path))
        )
        # This is a way have an additional check in case the above is true without any significant performance cost
        && (
          # This relies on the fact that Nix only distinguishes path types "directory", "regular", "symlink" and "unknown",
          # so everything except "unknown" is allowed, seems reasonable to rely on that
          type != "unknown"
          || throw ''
            lib.fileset.toSource: `fileset` contains a file that cannot be added to the store: ${path}
                This file is neither a regular file nor a symlink, the only file types supported by the Nix store.
                Therefore the file set cannot be added to the Nix store as is. Make sure to not include that file to avoid this error.''
        );
    in
    # Special case because the code below assumes that the _internalBase is always included in the result
    # which shouldn't be done when we have no files at all in the base
    # This also forces the tree before returning the filter, leads to earlier error messages
    if fileset._internalIsEmptyWithoutBase || tree == null then empty else nonEmpty;

  # Turn a builtins.filterSource-based source filter on a root path into a file set
  # containing only files included by the filter.
  # The filter is lazily called as necessary to determine whether paths are included
  # Type: Path -> (String -> String -> Bool) -> fileset
  _fromSourceFilter =
    root: sourceFilter:
    let
      # During the recursion we need to track both:
      # - The path value such that we can safely call `readDir` on it
      # - The path string value such that we can correctly call the `filter` with it
      #
      # While we could just recurse with the path value,
      # this would then require converting it to a path string for every path,
      # which is a fairly expensive operation

      # Create a file set from a directory entry
      fromDirEntry =
        path: pathString: type:
        # The filter needs to run on the path as a string
        if !sourceFilter pathString type then
          null
        else if type == "directory" then
          fromDir path pathString
        else
          type;

      # Create a file set from a directory
      fromDir =
        path: pathString:
        mapAttrs
          # This looks a bit funny, but we need both the path-based and the path string-based values
          (name: fromDirEntry (path + "/${name}") (pathString + "/${name}"))
          # We need to readDir on the path value, because reading on a path string
          # would be unspecified if there are multiple filesystem roots
          (readDir path);

      rootPathType = pathType root;

      # We need to convert the path to a string to imitate what builtins.path calls the filter function with.
      # We don't want to rely on `toString` for this though because it's not very well defined, see ../path/README.md
      # So instead we use `lib.path.splitRoot` to safely deconstruct the path into its filesystem root and subpath
      # We don't need the filesystem root though, builtins.path doesn't expose that in any way to the filter.
      # So we only need the components, which we then turn into a string as one would expect.
      rootString = "/" + concatStringsSep "/" (components (splitRoot root).subpath);
    in
    if rootPathType == "directory" then
      # We imitate builtins.path not calling the filter on the root path
      _create root (fromDir root rootString)
    else
      # Direct files are always included by builtins.path without calling the filter
      # But we need to lift up the base path to its parent to satisfy the base path invariant
      _create (dirOf root) {
        ${baseNameOf root} = rootPathType;
      };

  # Turns a file set into the list of file paths it includes.
  # Type: fileset -> [ Path ]
  _toList =
    fileset:
    let
      recurse =
        path: tree:
        if isAttrs tree then
          concatLists (mapAttrsToList (name: value: recurse (path + "/${name}") value) tree)
        else if tree == "directory" then
          recurse path (readDir path)
        else if tree == null then
          [ ]
        else
          [ path ];
    in
    if fileset._internalIsEmptyWithoutBase then
      [ ]
    else
      recurse fileset._internalBase fileset._internalTree;

  # Transforms the filesetTree of a file set to a shorter base path, e.g.
  # _shortenTreeBase [ "foo" ] (_create /foo/bar null)
  # => { bar = null; }
  _shortenTreeBase =
    targetBaseComponents: fileset:
    let
      recurse =
        index:
        # If we haven't reached the required depth yet
        if index < length fileset._internalBaseComponents then
          # Create an attribute set and recurse as the value, this can be lazily evaluated this way
          { ${elemAt fileset._internalBaseComponents index} = recurse (index + 1); }
        else
          # Otherwise we reached the appropriate depth, here's the original tree
          fileset._internalTree;
    in
    recurse (length targetBaseComponents);

  # Transforms the filesetTree of a file set to a longer base path, e.g.
  # _lengthenTreeBase [ "foo" "bar" ] (_create /foo { bar.baz = "regular"; })
  # => { baz = "regular"; }
  _lengthenTreeBase =
    targetBaseComponents: fileset:
    let
      recurse =
        index: tree:
        # If the filesetTree is an attribute set and we haven't reached the required depth yet
        if isAttrs tree && index < length targetBaseComponents then
          # Recurse with the tree under the right component (which might not exist)
          recurse (index + 1) (tree.${elemAt targetBaseComponents index} or null)
        else
          # For all values here we can just return the tree itself:
          # tree == null -> the result is also null, everything is excluded
          # tree == "directory" -> the result is also "directory",
          #   because the base path is always a directory and everything is included
          # isAttrs tree -> the result is `tree`
          #   because we don't need to recurse any more since `index == length longestBaseComponents`
          tree;
    in
    recurse (length fileset._internalBaseComponents) fileset._internalTree;

  # Computes the union of a list of filesets.
  # The filesets must already be coerced and validated to be in the same filesystem root
  # Type: [ Fileset ] -> Fileset
  _unionMany =
    filesets:
    let
      # All filesets that have a base, aka not the ones that are the empty value without a base
      filesetsWithBase = filter (fileset: !fileset._internalIsEmptyWithoutBase) filesets;

      # The first fileset that has a base.
      # This value is only accessed if there are at all.
      firstWithBase = head filesetsWithBase;

      # To be able to union filesetTree's together, they need to have the same base path.
      # Base paths can be unioned by taking their common prefix,
      # e.g. such that `union /foo/bar /foo/baz` has the base path `/foo`

      # A list of path components common to all base paths.
      # Note that commonPrefix can only be fully evaluated,
      # so this cannot cause a stack overflow due to a build-up of unevaluated thunks.
      commonBaseComponents =
        foldl' (components: el: commonPrefix components el._internalBaseComponents)
          firstWithBase._internalBaseComponents
          # We could also not do the `tail` here to avoid a list allocation,
          # but then we'd have to pay for a potentially expensive
          # but unnecessary `commonPrefix` call
          (tail filesetsWithBase);

      # The common base path assembled from a filesystem root and the common components
      commonBase = append firstWithBase._internalBaseRoot (join commonBaseComponents);

      # A list of filesetTree's that all have the same base path
      # This is achieved by nesting the trees into the components they have over the common base path
      # E.g. `union /foo/bar /foo/baz` has the base path /foo
      # So the tree under `/foo/bar` gets nested under `{ bar = ...; ... }`,
      # while the tree under `/foo/baz` gets nested under `{ baz = ...; ... }`
      # Therefore allowing combined operations over them.
      trees = map (_shortenTreeBase commonBaseComponents) filesetsWithBase;

      # Folds all trees together into a single one using _unionTree
      # We do not use a fold here because it would cause a thunk build-up
      # which could cause a stack overflow for a large number of trees
      resultTree = _unionTrees trees;
    in
    # If there's no values with a base, we have no files
    if filesetsWithBase == [ ] then _emptyWithoutBase else _create commonBase resultTree;

  # The union of multiple filesetTree's with the same base path.
  # Later elements are only evaluated if necessary.
  # Type: [ filesetTree ] -> filesetTree
  _unionTrees =
    trees:
    let
      stringIndex = findFirstIndex isString null trees;
      withoutNull = filter (tree: tree != null) trees;
    in
    if stringIndex != null then
      # If there's a string, it's always a fully included tree (dir or file),
      # no need to look at other elements
      elemAt trees stringIndex
    else if withoutNull == [ ] then
      # If all trees are null, then the resulting tree is also null
      null
    else
      # The non-null elements have to be attribute sets representing partial trees
      # We need to recurse into those
      zipAttrsWith (name: _unionTrees) withoutNull;

  # Computes the intersection of a list of filesets.
  # The filesets must already be coerced and validated to be in the same filesystem root
  # Type: Fileset -> Fileset -> Fileset
  _intersection =
    fileset1: fileset2:
    let
      # The common base components prefix, e.g.
      # (/foo/bar, /foo/bar/baz) -> /foo/bar
      # (/foo/bar, /foo/baz) -> /foo
      commonBaseComponentsLength =
        # TODO: Have a `lib.lists.commonPrefixLength` function such that we don't need the list allocation from commonPrefix here
        length (commonPrefix fileset1._internalBaseComponents fileset2._internalBaseComponents);

      # To be able to intersect filesetTree's together, they need to have the same base path.
      # Base paths can be intersected by taking the longest one (if any)

      # The fileset with the longest base, if any, e.g.
      # (/foo/bar, /foo/bar/baz) -> /foo/bar/baz
      # (/foo/bar, /foo/baz) -> null
      longestBaseFileset =
        if commonBaseComponentsLength == length fileset1._internalBaseComponents then
          # The common prefix is the same as the first path, so the second path is equal or longer
          fileset2
        else if commonBaseComponentsLength == length fileset2._internalBaseComponents then
          # The common prefix is the same as the second path, so the first path is longer
          fileset1
        else
          # The common prefix is neither the first nor the second path
          # This means there's no overlap between the two sets
          null;

      # Whether the result should be the empty value without a base
      resultIsEmptyWithoutBase =
        # If either fileset is the empty fileset without a base, the intersection is too
        fileset1._internalIsEmptyWithoutBase
        || fileset2._internalIsEmptyWithoutBase
        # If there is no overlap between the base paths
        || longestBaseFileset == null;

      # Lengthen each fileset's tree to the longest base prefix
      tree1 = _lengthenTreeBase longestBaseFileset._internalBaseComponents fileset1;
      tree2 = _lengthenTreeBase longestBaseFileset._internalBaseComponents fileset2;

      # With two filesetTree's with the same base, we can compute their intersection
      resultTree = _intersectTree tree1 tree2;
    in
    if resultIsEmptyWithoutBase then
      _emptyWithoutBase
    else
      _create longestBaseFileset._internalBase resultTree;

  # The intersection of two filesetTree's with the same base path
  # The second element is only evaluated as much as necessary.
  # Type: filesetTree -> filesetTree -> filesetTree
  _intersectTree =
    lhs: rhs:
    if isAttrs lhs && isAttrs rhs then
      # Both sides are attribute sets, we can recurse for the attributes existing on both sides
      mapAttrs (name: _intersectTree lhs.${name}) (builtins.intersectAttrs lhs rhs)
    else if lhs == null || isString rhs then
      # If the lhs is null, the result should also be null
      # And if the rhs is the identity element
      # (a string, aka it includes everything), then it's also the lhs
      lhs
    else
      # In all other cases it's the rhs
      rhs;

  # Compute the set difference between two file sets.
  # The filesets must already be coerced and validated to be in the same filesystem root.
  # Type: Fileset -> Fileset -> Fileset
  _difference =
    positive: negative:
    let
      # The common base components prefix, e.g.
      # (/foo/bar, /foo/bar/baz) -> /foo/bar
      # (/foo/bar, /foo/baz) -> /foo
      commonBaseComponentsLength =
        # TODO: Have a `lib.lists.commonPrefixLength` function such that we don't need the list allocation from commonPrefix here
        length (commonPrefix positive._internalBaseComponents negative._internalBaseComponents);

      # We need filesetTree's with the same base to be able to compute the difference between them
      # This here is the filesetTree from the negative file set, but for a base path that matches the positive file set.
      # Examples:
      # For `difference /foo /foo/bar`, `negativeTreeWithPositiveBase = { bar = "directory"; }`
      #   because under the base path of `/foo`, only `bar` from the negative file set is included
      # For `difference /foo/bar /foo`, `negativeTreeWithPositiveBase = "directory"`
      #   because under the base path of `/foo/bar`, everything from the negative file set is included
      # For `difference /foo /bar`, `negativeTreeWithPositiveBase = null`
      #   because under the base path of `/foo`, nothing from the negative file set is included
      negativeTreeWithPositiveBase =
        if commonBaseComponentsLength == length positive._internalBaseComponents then
          # The common prefix is the same as the positive base path, so the second path is equal or longer.
          # We need to _shorten_ the negative filesetTree to the same base path as the positive one
          # E.g. for `difference /foo /foo/bar` the common prefix is /foo, equal to the positive file set's base
          # So we need to shorten the base of the tree for the negative argument from /foo/bar to just /foo
          _shortenTreeBase positive._internalBaseComponents negative
        else if commonBaseComponentsLength == length negative._internalBaseComponents then
          # The common prefix is the same as the negative base path, so the first path is longer.
          # We need to lengthen the negative filesetTree to the same base path as the positive one.
          # E.g. for `difference /foo/bar /foo` the common prefix is /foo, equal to the negative file set's base
          # So we need to lengthen the base of the tree for the negative argument from /foo to /foo/bar
          _lengthenTreeBase positive._internalBaseComponents negative
        else
          # The common prefix is neither the first nor the second path.
          # This means there's no overlap between the two file sets,
          # and nothing from the negative argument should get removed from the positive one
          # E.g for `difference /foo /bar`, we remove nothing to get the same as `/foo`
          null;

      resultingTree =
        _differenceTree positive._internalBase positive._internalTree
          negativeTreeWithPositiveBase;
    in
    # If the first file set is empty, we can never have any files in the result
    if positive._internalIsEmptyWithoutBase then
      _emptyWithoutBase
    # If the second file set is empty, nothing gets removed, so the result is just the first file set
    else if negative._internalIsEmptyWithoutBase then
      positive
    else
      # We use the positive file set base for the result,
      # because only files from the positive side may be included,
      # which is what base path is for
      _create positive._internalBase resultingTree;

  # Computes the set difference of two filesetTree's
  # Type: Path -> filesetTree -> filesetTree
  _differenceTree =
    path: lhs: rhs:
    # If the lhs doesn't have any files, or the right hand side includes all files
    if lhs == null || isString rhs then
      # The result will always be empty
      null
    # If the right hand side has no files
    else if rhs == null then
      # The result is always the left hand side, because nothing gets removed
      lhs
    else
      # Otherwise we always have two attribute sets to recurse into
      mapAttrs (name: lhsValue: _differenceTree (path + "/${name}") lhsValue (rhs.${name} or null)) (
        _directoryEntries path lhs
      );

  # Filters all files in a path based on a predicate
  # Type: ({ name, type, ... } -> Bool) -> Path -> FileSet
  _fileFilter =
    predicate: root:
    let
      # Check the predicate for a single file
      # Type: String -> String -> filesetTree
      fromFile =
        name: type:
        if
          predicate {
            inherit name type;
            hasExt = ext: hasSuffix ".${ext}" name;

            # To ensure forwards compatibility with more arguments being added in the future,
            # adding an attribute which can't be deconstructed :)
            "lib.fileset.fileFilter: The predicate function passed as the first argument must be able to handle extra attributes for future compatibility. If you're using `{ name, file, hasExt }:`, use `{ name, file, hasExt, ... }:` instead." =
              null;
          }
        then
          type
        else
          null;

      # Check the predicate for all files in a directory
      # Type: Path -> filesetTree
      fromDir =
        path:
        mapAttrs (
          name: type: if type == "directory" then fromDir (path + "/${name}") else fromFile name type
        ) (readDir path);

      rootType = pathType root;
    in
    if rootType == "directory" then
      _create root (fromDir root)
    else
      # Single files are turned into a directory containing that file or nothing.
      _create (dirOf root) {
        ${baseNameOf root} = fromFile (baseNameOf root) rootType;
      };

  # Mirrors the contents of a Nix store path relative to a local path as a file set.
  # Some notes:
  # - The store path is read at evaluation time.
  # - The store path must not include files that don't exist in the respective local path.
  #
  # Type: Path -> String -> FileSet
  _mirrorStorePath =
    localPath: storePath:
    let
      recurse =
        focusedStorePath:
        mapAttrs (
          name: type: if type == "directory" then recurse (focusedStorePath + "/${name}") else type
        ) (builtins.readDir focusedStorePath);
    in
    _create localPath (recurse storePath);

  # Create a file set from the files included in the result of a fetchGit call
  # Type: String -> String -> Path -> Attrs -> FileSet
  _fromFetchGit =
    function: argument: path: extraFetchGitAttrs:
    let
      # The code path for when isStorePath is true
      tryStorePath =
        if pathExists (path + "/.git") then
          # If there is a `.git` directory in the path,
          # it means that the path was imported unfiltered into the Nix store.
          # This function should throw in such a case, because
          # - `fetchGit` doesn't generally work with `.git` directories in store paths
          # - Importing the entire path could include Git-tracked files
          throw ''
            lib.fileset.${function}: The ${argument} (${toString path}) is a store path within a working tree of a Git repository.
                This indicates that a source directory was imported into the store using a method such as `import "''${./.}"` or `path:.`.
                This function currently does not support such a use case, since it currently relies on `builtins.fetchGit`.
                You could make this work by using a fetcher such as `fetchGit` instead of copying the whole repository.
                If you can't avoid copying the repo to the store, see https://github.com/NixOS/nix/issues/9292.''
        else
          # Otherwise we're going to assume that the path was a Git directory originally,
          # but it was fetched using a method that already removed files not tracked by Git,
          # such as `builtins.fetchGit`, `pkgs.fetchgit` or others.
          # So we can just import the path in its entirety.
          _singleton path;

      # The code path for when isStorePath is false
      tryFetchGit =
        let
          # This imports the files unnecessarily, which currently can't be avoided
          # because `builtins.fetchGit` is the only function exposing which files are tracked by Git.
          # With the [lazy trees PR](https://github.com/NixOS/nix/pull/6530),
          # the unnecessarily import could be avoided.
          # However a simpler alternative still would be [a builtins.gitLsFiles](https://github.com/NixOS/nix/issues/2944).
          fetchResult = fetchGit (
            {
              url = path;
              shallow = true;
            }
            // extraFetchGitAttrs
          );
        in
        # We can identify local working directories by checking for .git,
        # see https://git-scm.com/docs/gitrepository-layout#_description.
        # Note that `builtins.fetchGit` _does_ work for bare repositories (where there's no `.git`),
        # even though `git ls-files` wouldn't return any files in that case.
        if !pathExists (path + "/.git") then
          throw "lib.fileset.${function}: Expected the ${argument} (${toString path}) to point to a local working tree of a Git repository, but it's not."
        else
          _mirrorStorePath path fetchResult.outPath;

    in
    if !isPath path then
      throw "lib.fileset.${function}: Expected the ${argument} to be a path, but it's a ${typeOf path} instead."
    else if pathType path != "directory" then
      throw "lib.fileset.${function}: Expected the ${argument} (${toString path}) to be a directory, but it's a file instead."
    else if hasStorePathPrefix path then
      tryStorePath
    else
      tryFetchGit;

}
