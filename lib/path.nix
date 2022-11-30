# Functions for working with file paths
{ lib }:
let

  inherit (builtins)
    isPath
    isString
    split
    substring
    ;

  inherit (lib.asserts)
    assertMsg
    ;

  inherit (lib.lists)
    length
    head
    last
    genList
    elemAt
    concatLists
    imap1
    imap0
    tail
    ;

  inherit (lib.generators)
    toPretty
    ;

  inherit (lib.strings)
    concatStringsSep
    ;

  validRelativeString = value: errorPrefix:
    if value == "" then
      throw "${errorPrefix}: The string is empty, which is not a valid path"
    else if substring 0 1 value == "/" then
      throw "${errorPrefix}: The string starts with a `/`, representing an absolute path. Use a path value for absolute paths instead"
    else true;

  # Splits a relative path string into its components
  # Errors for ".." components, doesn't include "." components
  normaliseComponents = path: errorPrefix:
    assert assertMsg (isString path) "${errorPrefix}: Not a relative path string";
    assert validRelativeString path "${errorPrefix}: Not a valid relative path string";
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
      #   "foo"
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

      # And we can use this to generate the result list directly. Doing it this
      # way over a combination of `filter`, `init` and `tail` makes it more
      # efficient, because we don't allocate any intermediate lists
      else genList (index:
        let
          # To get to the element we need to add the number of parts we skip and
          # multiply by two due to the interleaved layout of `parts`
          value = elemAt parts ((skipStart + index) * 2);
        in

        # We don't support ".." components, see ./path-design.md
        if value == ".." then
          throw "${errorPrefix}: Path string contains contains a `..` component, which is not supported"
        # Otherwise just return the part unchanged
        else
          value
      ) componentCount;

  joinAbsolute = firstPath: relativePaths:
    let
      allComponents = concatLists (imap1 (i: el:
        normaliseComponents el "lib.path.join: Cannot normalise element ${toPretty { multiline = false; } el} at index ${toString i}"
      ) relativePaths);
    in
      if allComponents == [] then firstPath
      else firstPath + ("/" + concatStringsSep "/" allComponents);

  joinRelative = relativePaths:
    let
      allComponents = concatLists (imap0 (i: el:
        normaliseComponents el "lib.path.join: Cannot normalise element ${toPretty { multiline = false; } el} at index ${toString i}"
      ) relativePaths);
    in
      # An empty string is not a valid relative path, so we need to return a `.` when we have no components
      if allComponents == [] then "."
      else concatStringsSep "/" allComponents;


in /* No rec! Add dependencies on this file just above */ {

  join = paths:
    assert assertMsg (paths != []) "lib.path.join: No paths provided";
    let firstPath = head paths; in
    if isPath firstPath then joinAbsolute firstPath (tail paths)
    else if isString firstPath then joinRelative paths
    else throw "lib.path.join: First passed element ${toPretty { multiline = false; } firstPath} is neither an absolute path value nor a relative path string";

  normalise = path:
    if isPath path then path
    else if isString path then
      let components = normaliseComponents path "lib.path.normalise: Cannot normalise value ${toPretty { multiline = false; } path}";
      in if components == [] then "."
      else concatStringsSep "/" components
    else throw "lib.path.normalise: Passed value ${toPretty { multiline = false; } path} is neither an absolute path value nor a relative path string";

}
