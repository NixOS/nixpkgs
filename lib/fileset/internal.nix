{ lib ? import ../. }:
let

  inherit (builtins)
    isAttrs
    isPath
    isString
    pathExists
    readDir
    typeOf
    split
    ;

  inherit (lib.attrsets)
    attrValues
    mapAttrs
    zipAttrsWith
    ;

  inherit (lib.filesystem)
    pathType
    ;

  inherit (lib.lists)
    all
    commonPrefix
    drop
    elemAt
    filter
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
  _currentVersion = 1;

  # Migrations between versions. The 0th element converts from v0 to v1, and so on
  migrations = [
    # Convert v0 into v1: Add the _internalBase{Root,Components} attributes
    (
      filesetV0:
      let
        parts = splitRoot filesetV0._internalBase;
      in
      filesetV0 // {
        _internalVersion = 1;
        _internalBaseRoot = parts.root;
        _internalBaseComponents = components parts.subpath;
      }
    )
  ];

  # Create a fileset, see ./README.md#fileset
  # Type: path -> filesetTree -> fileset
  _create = base: tree:
    let
      # Decompose the base into its components
      # See ../path/README.md for why we're not just using `toString`
      parts = splitRoot base;
    in
    {
      _type = "fileset";

      _internalVersion = _currentVersion;
      _internalBase = base;
      _internalBaseRoot = parts.root;
      _internalBaseComponents = components parts.subpath;
      _internalTree = tree;

      # Double __ to make it be evaluated and ordered first
      __noEval = throw ''
        lib.fileset: Directly evaluating a file set is not supported. Use `lib.fileset.toSource` to turn it into a usable source instead.'';
    };

  # Coerce a value to a fileset, erroring when the value cannot be coerced.
  # The string gives the context for error messages.
  # Type: String -> (fileset | Path) -> fileset
  _coerce = context: value:
    if value._type or "" == "fileset" then
      if value._internalVersion > _currentVersion then
        throw ''
          ${context} is a file set created from a future version of the file set library with a different internal representation:
              - Internal version of the file set: ${toString value._internalVersion}
              - Internal version of the library: ${toString _currentVersion}
              Make sure to update your Nixpkgs to have a newer version of `lib.fileset`.''
      else if value._internalVersion < _currentVersion then
        let
          # Get all the migration functions necessary to convert from the old to the current version
          migrationsToApply = sublist value._internalVersion (_currentVersion - value._internalVersion) migrations;
        in
        foldl' (value: migration: migration value) value migrationsToApply
      else
        value
    else if ! isPath value then
      if isStringLike value then
        throw ''
          ${context} "${toString value}" is a string-like value, but it should be a path instead.
              Paths represented as strings are not supported by `lib.fileset`, use `lib.sources` or derivations instead.''
      else
        throw ''
          ${context} is of type ${typeOf value}, but it should be a path instead.''
    else if ! pathExists value then
      throw ''
        ${context} ${toString value} does not exist.''
    else
      _singleton value;

  # Coerce many values to filesets, erroring when any value cannot be coerced,
  # or if the filesystem root of the values doesn't match.
  # Type: String -> [ { context :: String, value :: fileset | Path } ] -> [ fileset ]
  _coerceMany = functionContext: list:
    let
      filesets = map ({ context, value }:
        _coerce "${functionContext}: ${context}" value
      ) list;

      firstBaseRoot = (head filesets)._internalBaseRoot;

      # Finds the first element with a filesystem root different than the first element, if any
      differentIndex = findFirstIndex (fileset:
        firstBaseRoot != fileset._internalBaseRoot
      ) null filesets;
    in
    if differentIndex != null then
      throw ''
        ${functionContext}: Filesystem roots are not the same:
            ${(head list).context}: root "${toString firstBaseRoot}"
            ${(elemAt list differentIndex).context}: root "${toString (elemAt filesets differentIndex)._internalBaseRoot}"
            Different roots are not supported.''
    else
      filesets;

  # Create a file set from a path.
  # Type: Path -> fileset
  _singleton = path:
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
      #     # Other directory entries
      #     <name> = null;
      #   }
      # See ./README.md#single-files
      _create (dirOf path)
        (_nestTree
          (dirOf path)
          [ (baseNameOf path) ]
          type
        );

  /*
    Nest a filesetTree under some extra components, while filling out all the other directory entries that aren't included with null

    _nestTree ./. [ "foo" "bar" ] tree == {
      foo = {
        bar = tree;
        <other-entries> = null;
      }
      <other-entries> = null;
    }

    Type: Path -> [ String ] -> filesetTree -> filesetTree
  */
  _nestTree = targetBase: extraComponents: tree:
    let
      recurse = index: focusPath:
        if index == length extraComponents then
          tree
        else
          mapAttrs (_: _: null) (readDir focusPath)
          // {
            ${elemAt extraComponents index} = recurse (index + 1) (append focusPath (elemAt extraComponents index));
          };
    in
    recurse 0 targetBase;

  # Expand "directory" filesetTree representation to the equivalent { <name> = filesetTree; }
  # Type: Path -> filesetTree -> { <name> = filesetTree; }
  _directoryEntries = path: value:
    if isAttrs value then
      value
    else
      readDir path;

  /*
    Simplify a filesetTree recursively:
    - Replace all directories that have no files with `null`
      This removes directories that would be empty
    - Replace all directories with all files with `"directory"`
      This speeds up the source filter function

    Note that this function is strict, it evaluates the entire tree

    Type: Path -> filesetTree -> filesetTree
  */
  _simplifyTree = path: tree:
    if tree == "directory" || isAttrs tree then
      let
        entries = _directoryEntries path tree;
        simpleSubtrees = mapAttrs (name: _simplifyTree (path + "/${name}")) entries;
        subtreeValues = attrValues simpleSubtrees;
      in
      # This triggers either when all files in a directory are filtered out
      # Or when the directory doesn't contain any files at all
      if all isNull subtreeValues then
        null
      # Triggers when we have the same as a `readDir path`, so we can turn it back into an equivalent "directory".
      else if all isString subtreeValues then
        "directory"
      else
        simpleSubtrees
    else
      tree;

  # Turn a fileset into a source filter function suitable for `builtins.path`
  # Only directories recursively containing at least one files are recursed into
  # Type: Path -> fileset -> (String -> String -> Bool)
  _toSourceFilter = fileset:
    let
      # Simplify the tree, necessary to make sure all empty directories are null
      # which has the effect that they aren't included in the result
      tree = _simplifyTree fileset._internalBase fileset._internalTree;

      # The base path as a string with a single trailing slash
      baseString =
        if fileset._internalBaseComponents == [] then
          # Need to handle the filesystem root specially
          "/"
        else
          "/" + concatStringsSep "/" fileset._internalBaseComponents + "/";

      baseLength = stringLength baseString;

      # Check whether a list of path components under the base path exists in the tree.
      # This function is called often, so it should be fast.
      # Type: [ String ] -> Bool
      inTree = components:
        let
          recurse = index: localTree:
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
        in recurse 0 tree;

      # Filter suited when there's no files
      empty = _: _: false;

      # Filter suited when there's some files
      # This can't be used for when there's no files, because the base directory is always included
      nonEmpty =
        path: _:
        let
          # Add a slash to the path string, turning "/foo" to "/foo/",
          # making sure to not have any false prefix matches below.
          # Note that this would produce "//" for "/",
          # but builtins.path doesn't call the filter function on the `path` argument itself,
          # meaning this function can never receive "/" as an argument
          pathSlash = path + "/";
        in
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
          inTree (split "/" (substring baseLength (-1) path));
    in
    # Special case because the code below assumes that the _internalBase is always included in the result
    # which shouldn't be done when we have no files at all in the base
    # This also forces the tree before returning the filter, leads to earlier error messages
    if tree == null then
      empty
    else
      nonEmpty;

  # Computes the union of a list of filesets.
  # The filesets must already be coerced and validated to be in the same filesystem root
  # Type: [ Fileset ] -> Fileset
  _unionMany = filesets:
    let
      first = head filesets;

      # To be able to union filesetTree's together, they need to have the same base path.
      # Base paths can be unioned by taking their common prefix,
      # e.g. such that `union /foo/bar /foo/baz` has the base path `/foo`

      # A list of path components common to all base paths.
      # Note that commonPrefix can only be fully evaluated,
      # so this cannot cause a stack overflow due to a build-up of unevaluated thunks.
      commonBaseComponents = foldl'
        (components: el: commonPrefix components el._internalBaseComponents)
        first._internalBaseComponents
        # We could also not do the `tail` here to avoid a list allocation,
        # but then we'd have to pay for a potentially expensive
        # but unnecessary `commonPrefix` call
        (tail filesets);

      # The common base path assembled from a filesystem root and the common components
      commonBase = append first._internalBaseRoot (join commonBaseComponents);

      # The number of path components common to all base paths
      commonBaseComponentsCount = length commonBaseComponents;

      # A list of filesetTree's that all have the same base path
      # This is achieved by nesting the trees into the components they have over the common base path
      # E.g. `union /foo/bar /foo/baz` has the base path /foo
      # So the tree under `/foo/bar` gets nested under `{ bar = ...; ... }`,
      # while the tree under `/foo/baz` gets nested under `{ baz = ...; ... }`
      # Therefore allowing combined operations over them.
      trees = map (fileset:
        _nestTree
          commonBase
          (drop commonBaseComponentsCount fileset._internalBaseComponents)
          fileset._internalTree
        ) filesets;

      # Folds all trees together into a single one using _unionTree
      # We do not use a fold here because it would cause a thunk build-up
      # which could cause a stack overflow for a large number of trees
      resultTree = _unionTrees trees;
    in
    _create commonBase resultTree;

  # The union of multiple filesetTree's with the same base path.
  # Later elements are only evaluated if necessary.
  # Type: [ filesetTree ] -> filesetTree
  _unionTrees = trees:
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
}
