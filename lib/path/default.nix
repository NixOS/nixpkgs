# Functions for working with paths, see ./path.md
{ lib }:
let

  inherit (builtins)
    isString
    isPath
    split
    match
    ;

  inherit (lib.lists)
    length
    head
    last
    genList
    elemAt
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

in /* No rec! Add dependencies on this file at the top. */ {

  /* Append a subpath string to a path.

    Like `path + ("/" + string)` but safer, because it errors instead of returning potentially surprising results.
    More specifically, it checks that the first argument is a [path value type](https://nixos.org/manual/nix/stable/language/values.html#type-path"),
    and that the second argument is a valid subpath string (see `lib.path.subpath.isValid`).

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

  /* Whether a value is a valid subpath string.

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
