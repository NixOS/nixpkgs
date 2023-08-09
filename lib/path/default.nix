# Functions for working with paths, see ./path.md
{ lib }:
let

  inherit (builtins)
    isString
    isPath
    split
    match
    typeOf
    ;

  inherit (lib.lists)
    length
    head
    last
    genList
    elemAt
    all
    concatMap
    foldl'
    take
    drop
    ;

  inherit (lib.strings)
    concatStringsSep
    substring
    ;

  inherit (lib.asserts)
    assertMsg
    ;

  inherit (lib.path.subpath)
    isValid
    ;

  # Return the reason why a subpath is invalid, or `null` if it's valid
  subpathInvalidReason = value:
    if ! isString value then
      "The given value is of type ${builtins.typeOf value}, but a string was expected"
    else if value == "" then
      "The given string is empty"
    else if substring 0 1 value == "/" then
      "The given string \"${value}\" starts with a `/`, representing an absolute path"
    # We don't support ".." components, see ./path.md#parent-directory
    else if match "(.*/)?\\.\\.(/.*)?" value != null then
      "The given string \"${value}\" contains a `..` component, which is not allowed in subpaths"
    else null;

  # Split and normalise a relative path string into its components.
  # Error for ".." components and doesn't include "." components
  splitRelPath = path:
    let
      # Split the string into its parts using regex for efficiency. This regex
      # matches patterns like "/", "/./", "/././", with arbitrarily many "/"s
      # together. These are the main special cases:
      # - Leading "./" gets split into a leading "." part
      # - Trailing "/." or "/" get split into a trailing "." or ""
      #   part respectively
      #
      # These are the only cases where "." and "" parts can occur
      parts = split "/+(\\./+)*" path;

      # `split` creates a list of 2 * k + 1 elements, containing the k +
      # 1 parts, interleaved with k matches where k is the number of
      # (non-overlapping) matches. This calculation here gets the number of parts
      # back from the list length
      # floor( (2 * k + 1) / 2 ) + 1 == floor( k + 1/2 ) + 1 == k + 1
      partCount = length parts / 2 + 1;

      # To assemble the final list of components we want to:
      # - Skip a potential leading ".", normalising "./foo" to "foo"
      # - Skip a potential trailing "." or "", normalising "foo/" and "foo/." to
      #   "foo". See ./path.md#trailing-slashes
      skipStart = if head parts == "." then 1 else 0;
      skipEnd = if last parts == "." || last parts == "" then 1 else 0;

      # We can now know the length of the result by removing the number of
      # skipped parts from the total number
      componentCount = partCount - skipEnd - skipStart;

    in
      # Special case of a single "." path component. Such a case leaves a
      # componentCount of -1 due to the skipStart/skipEnd not verifying that
      # they don't refer to the same character
      if path == "." then []

      # Generate the result list directly. This is more efficient than a
      # combination of `filter`, `init` and `tail`, because here we don't
      # allocate any intermediate lists
      else genList (index:
        # To get to the element we need to add the number of parts we skip and
        # multiply by two due to the interleaved layout of `parts`
        elemAt parts ((skipStart + index) * 2)
      ) componentCount;

  # Join relative path components together
  joinRelPath = components:
    # Always return relative paths with `./` as a prefix (./path.md#leading-dots-for-relative-paths)
    "./" +
    # An empty string is not a valid relative path, so we need to return a `.` when we have no components
    (if components == [] then "." else concatStringsSep "/" components);

  # Type: Path -> { root :: Path, components :: [ String ] }
  #
  # Deconstruct a path value type into:
  # - root: The filesystem root of the path, generally `/`
  # - components: All the path's components
  #
  # This is similar to `splitString "/" (toString path)` but safer
  # because it can distinguish different filesystem roots
  deconstructPath =
    let
      recurse = components: base:
        # If the parent of a path is the path itself, then it's a filesystem root
        if base == dirOf base then { root = base; inherit components; }
        else recurse ([ (baseNameOf base) ] ++ components) (dirOf base);
    in recurse [];

in /* No rec! Add dependencies on this file at the top. */ {

  /* Append a subpath string to a path.

    Like `path + ("/" + string)` but safer, because it errors instead of returning potentially surprising results.
    More specifically, it checks that the first argument is a [path value type](https://nixos.org/manual/nix/stable/language/values.html#type-path"),
    and that the second argument is a valid subpath string (see `lib.path.subpath.isValid`).

    Laws:

    - Not influenced by subpath normalisation

        append p s == append p (subpath.normalise s)

    Type:
      append :: Path -> String -> Path

    Example:
      append /foo "bar/baz"
      => /foo/bar/baz

      # subpaths don't need to be normalised
      append /foo "./bar//baz/./"
      => /foo/bar/baz

      # can append to root directory
      append /. "foo/bar"
      => /foo/bar

      # first argument needs to be a path value type
      append "/foo" "bar"
      => <error>

      # second argument needs to be a valid subpath string
      append /foo /bar
      => <error>
      append /foo ""
      => <error>
      append /foo "/bar"
      => <error>
      append /foo "../bar"
      => <error>
  */
  append =
    # The absolute path to append to
    path:
    # The subpath string to append
    subpath:
    assert assertMsg (isPath path) ''
      lib.path.append: The first argument is of type ${builtins.typeOf path}, but a path was expected'';
    assert assertMsg (isValid subpath) ''
      lib.path.append: Second argument is not a valid subpath string:
          ${subpathInvalidReason subpath}'';
    path + ("/" + subpath);

  /*
  Whether the first path is a component-wise prefix of the second path.

  Laws:

  - `hasPrefix p q` is only true if `q == append p s` for some subpath `s`.

  - `hasPrefix` is a [non-strict partial order](https://en.wikipedia.org/wiki/Partially_ordered_set#Non-strict_partial_order) over the set of all path values

  Type:
    hasPrefix :: Path -> Path -> Bool

  Example:
    hasPrefix /foo /foo/bar
    => true
    hasPrefix /foo /foo
    => true
    hasPrefix /foo/bar /foo
    => false
    hasPrefix /. /foo
    => true
  */
  hasPrefix =
    path1:
    assert assertMsg
      (isPath path1)
      "lib.path.hasPrefix: First argument is of type ${typeOf path1}, but a path was expected";
    let
      path1Deconstructed = deconstructPath path1;
    in
      path2:
      assert assertMsg
        (isPath path2)
        "lib.path.hasPrefix: Second argument is of type ${typeOf path2}, but a path was expected";
      let
        path2Deconstructed = deconstructPath path2;
      in
        assert assertMsg
        (path1Deconstructed.root == path2Deconstructed.root) ''
          lib.path.hasPrefix: Filesystem roots must be the same for both paths, but paths with different roots were given:
              first argument: "${toString path1}" with root "${toString path1Deconstructed.root}"
              second argument: "${toString path2}" with root "${toString path2Deconstructed.root}"'';
        take (length path1Deconstructed.components) path2Deconstructed.components == path1Deconstructed.components;

  /*
  Remove the first path as a component-wise prefix from the second path.
  The result is a normalised subpath string, see `lib.path.subpath.normalise`.

  Laws:

  - Inverts `append` for normalised subpaths:

        removePrefix p (append p s) == subpath.normalise s

  Type:
    removePrefix :: Path -> Path -> String

  Example:
    removePrefix /foo /foo/bar/baz
    => "./bar/baz"
    removePrefix /foo /foo
    => "./."
    removePrefix /foo/bar /foo
    => <error>
    removePrefix /. /foo
    => "./foo"
  */
  removePrefix =
    path1:
    assert assertMsg
      (isPath path1)
      "lib.path.removePrefix: First argument is of type ${typeOf path1}, but a path was expected.";
    let
      path1Deconstructed = deconstructPath path1;
      path1Length = length path1Deconstructed.components;
    in
      path2:
      assert assertMsg
        (isPath path2)
        "lib.path.removePrefix: Second argument is of type ${typeOf path2}, but a path was expected.";
      let
        path2Deconstructed = deconstructPath path2;
        success = take path1Length path2Deconstructed.components == path1Deconstructed.components;
        components =
          if success then
            drop path1Length path2Deconstructed.components
          else
            throw ''
              lib.path.removePrefix: The first path argument "${toString path1}" is not a component-wise prefix of the second path argument "${toString path2}".'';
      in
        assert assertMsg
        (path1Deconstructed.root == path2Deconstructed.root) ''
          lib.path.removePrefix: Filesystem roots must be the same for both paths, but paths with different roots were given:
              first argument: "${toString path1}" with root "${toString path1Deconstructed.root}"
              second argument: "${toString path2}" with root "${toString path2Deconstructed.root}"'';
        joinRelPath components;

  /*
  Split the filesystem root from a [path](https://nixos.org/manual/nix/stable/language/values.html#type-path).
  The result is an attribute set with these attributes:
  - `root`: The filesystem root of the path, meaning that this directory has no parent directory.
  - `subpath`: The [normalised subpath string](#function-library-lib.path.subpath.normalise) that when [appended](#function-library-lib.path.append) to `root` returns the original path.

  Laws:
  - [Appending](#function-library-lib.path.append) the `root` and `subpath` gives the original path:

        p ==
          append
            (splitRoot p).root
            (splitRoot p).subpath

  - Trying to get the parent directory of `root` using [`readDir`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-readDir) returns `root` itself:

        dirOf (splitRoot p).root == (splitRoot p).root

  Type:
    splitRoot :: Path -> { root :: Path, subpath :: String }

  Example:
    splitRoot /foo/bar
    => { root = /.; subpath = "./foo/bar"; }

    splitRoot /.
    => { root = /.; subpath = "./."; }

    # Nix neutralises `..` path components for all path values automatically
    splitRoot /foo/../bar
    => { root = /.; subpath = "./bar"; }

    splitRoot "/foo/bar"
    => <error>
  */
  splitRoot = path:
    assert assertMsg
      (isPath path)
      "lib.path.splitRoot: Argument is of type ${typeOf path}, but a path was expected";
    let
      deconstructed = deconstructPath path;
    in {
      root = deconstructed.root;
      subpath = joinRelPath deconstructed.components;
    };

  /* Whether a value is a valid subpath string.

  A subpath string points to a specific file or directory within an absolute base directory.
  It is a stricter form of a relative path that excludes `..` components, since those could escape the base directory.

  - The value is a string

  - The string is not empty

  - The string doesn't start with a `/`

  - The string doesn't contain any `..` path components

  Type:
    subpath.isValid :: String -> Bool

  Example:
    # Not a string
    subpath.isValid null
    => false

    # Empty string
    subpath.isValid ""
    => false

    # Absolute path
    subpath.isValid "/foo"
    => false

    # Contains a `..` path component
    subpath.isValid "../foo"
    => false

    # Valid subpath
    subpath.isValid "foo/bar"
    => true

    # Doesn't need to be normalised
    subpath.isValid "./foo//bar/"
    => true
  */
  subpath.isValid =
    # The value to check
    value:
    subpathInvalidReason value == null;


  /* Join subpath strings together using `/`, returning a normalised subpath string.

    Like `concatStringsSep "/"` but safer, specifically:

    - All elements must be valid subpath strings, see `lib.path.subpath.isValid`

    - The result gets normalised, see `lib.path.subpath.normalise`

    - The edge case of an empty list gets properly handled by returning the neutral subpath `"./."`

    Laws:

    - Associativity:

          subpath.join [ x (subpath.join [ y z ]) ] == subpath.join [ (subpath.join [ x y ]) z ]

    - Identity - `"./."` is the neutral element for normalised paths:

          subpath.join [ ] == "./."
          subpath.join [ (subpath.normalise p) "./." ] == subpath.normalise p
          subpath.join [ "./." (subpath.normalise p) ] == subpath.normalise p

    - Normalisation - the result is normalised according to `lib.path.subpath.normalise`:

          subpath.join ps == subpath.normalise (subpath.join ps)

    - For non-empty lists, the implementation is equivalent to normalising the result of `concatStringsSep "/"`.
      Note that the above laws can be derived from this one.

          ps != [] -> subpath.join ps == subpath.normalise (concatStringsSep "/" ps)

    Type:
      subpath.join :: [ String ] -> String

    Example:
      subpath.join [ "foo" "bar/baz" ]
      => "./foo/bar/baz"

      # normalise the result
      subpath.join [ "./foo" "." "bar//./baz/" ]
      => "./foo/bar/baz"

      # passing an empty list results in the current directory
      subpath.join [ ]
      => "./."

      # elements must be valid subpath strings
      subpath.join [ /foo ]
      => <error>
      subpath.join [ "" ]
      => <error>
      subpath.join [ "/foo" ]
      => <error>
      subpath.join [ "../foo" ]
      => <error>
  */
  subpath.join =
    # The list of subpaths to join together
    subpaths:
    # Fast in case all paths are valid
    if all isValid subpaths
    then joinRelPath (concatMap splitRelPath subpaths)
    else
      # Otherwise we take our time to gather more info for a better error message
      # Strictly go through each path, throwing on the first invalid one
      # Tracks the list index in the fold accumulator
      foldl' (i: path:
        if isValid path
        then i + 1
        else throw ''
          lib.path.subpath.join: Element at index ${toString i} is not a valid subpath string:
              ${subpathInvalidReason path}''
      ) 0 subpaths;

  /*
  Split [a subpath](#function-library-lib.path.subpath.isValid) into its path component strings.
  Throw an error if the subpath isn't valid.
  Note that the returned path components are also valid subpath strings, though they are intentionally not [normalised](#function-library-lib.path.subpath.normalise).

  Laws:

  - Splitting a subpath into components and [joining](#function-library-lib.path.subpath.join) the components gives the same subpath but [normalised](#function-library-lib.path.subpath.normalise):

        subpath.join (subpath.components s) == subpath.normalise s

  Type:
    subpath.components :: String -> [ String ]

  Example:
    subpath.components "."
    => [ ]

    subpath.components "./foo//bar/./baz/"
    => [ "foo" "bar" "baz" ]

    subpath.components "/foo"
    => <error>
  */
  subpath.components =
    subpath:
    assert assertMsg (isValid subpath) ''
      lib.path.subpath.components: Argument is not a valid subpath string:
          ${subpathInvalidReason subpath}'';
    splitRelPath subpath;

  /* Normalise a subpath. Throw an error if the subpath isn't valid, see
  `lib.path.subpath.isValid`

  - Limit repeating `/` to a single one

  - Remove redundant `.` components

  - Remove trailing `/` and `/.`

  - Add leading `./`

  Laws:

  - Idempotency - normalising multiple times gives the same result:

        subpath.normalise (subpath.normalise p) == subpath.normalise p

  - Uniqueness - there's only a single normalisation for the paths that lead to the same file system node:

        subpath.normalise p != subpath.normalise q -> $(realpath ${p}) != $(realpath ${q})

  - Don't change the result when appended to a Nix path value:

        base + ("/" + p) == base + ("/" + subpath.normalise p)

  - Don't change the path according to `realpath`:

        $(realpath ${p}) == $(realpath ${subpath.normalise p})

  - Only error on invalid subpaths:

        builtins.tryEval (subpath.normalise p)).success == subpath.isValid p

  Type:
    subpath.normalise :: String -> String

  Example:
    # limit repeating `/` to a single one
    subpath.normalise "foo//bar"
    => "./foo/bar"

    # remove redundant `.` components
    subpath.normalise "foo/./bar"
    => "./foo/bar"

    # add leading `./`
    subpath.normalise "foo/bar"
    => "./foo/bar"

    # remove trailing `/`
    subpath.normalise "foo/bar/"
    => "./foo/bar"

    # remove trailing `/.`
    subpath.normalise "foo/bar/."
    => "./foo/bar"

    # Return the current directory as `./.`
    subpath.normalise "."
    => "./."

    # error on `..` path components
    subpath.normalise "foo/../bar"
    => <error>

    # error on empty string
    subpath.normalise ""
    => <error>

    # error on absolute path
    subpath.normalise "/foo"
    => <error>
  */
  subpath.normalise =
    # The subpath string to normalise
    subpath:
    assert assertMsg (isValid subpath) ''
      lib.path.subpath.normalise: Argument is not a valid subpath string:
          ${subpathInvalidReason subpath}'';
    joinRelPath (splitRelPath subpath);

}
