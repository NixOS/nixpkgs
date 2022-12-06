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

  inherit (lib.path)
    commonAncestry
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

  inherit (lib.attrsets)
    mapAttrsToList
    ;

  pretty = toPretty { multiline = false; };

  validRelativeString = value: errorPrefix:
    if value == "" then
      throw "${errorPrefix}: The string is empty"
    else if substring 0 1 value == "/" then
      throw "${errorPrefix}: The string is an absolute path because it starts with `/`"
    else true;

  # Splits and normalises a relative path string into its components
  # Errors for ".." components, doesn't include "." components
  splitRelative = path: errorPrefix:
    #assert assertMsg (isString path) "${errorPrefix}: Not a relative path string";
    #assert validRelativeString path "${errorPrefix}: Not a valid relative path string";
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



  joinRelative = components:
    # An empty string is not a valid relative path, so we need to return a `.` when we have no components
    if components == [] then "."
    else concatStringsSep "/" components;

  isRoot = path: path == dirOf path;

  deconstructPath = path:
    let
      go = components: path:
        if isRoot path then { root = path; inherit components; }
        else go ([ (baseNameOf path) ] ++ components) (dirOf path);
    in go [] path;


in /* No rec! Add dependencies on this file just above */ {

  append = basePath: subpath:
    assert assertMsg (isPath basePath) "lib.path.append: First argument ${pretty basePath} is not a path value";
    assert assertMsg (isString subpath) "lib.path.append: Second argument ${pretty subpath} is not a string";
    assert validRelativeString subpath "lib.path.append: Second argument ${subpath} is not a valid relative path string";
    let components = splitRelative subpath "lib.path.append: Second argument ${subpath} can't be normalised";
    in basePath + ("/" + joinRelative components);


  relative.join = paths:
    let
      allComponents = concatLists (imap0 (i: subpath:
        assert assertMsg (isString subpath) "lib.path.relative.join: Element ${toString subpath} at index ${toString i} is not a string";
        assert validRelativeString subpath "lib.path.relative.join: Element ${toString subpath} at index ${toString i} is not a valid relative path string";
        splitRelative subpath "lib.path.relative.join: Element ${toString subpath} at index ${toString i} can't be normalised"
      ) paths);
    in joinRelative allComponents;

  relative.normalise = path:
    assert assertMsg (isString path) "lib.path.relative.normalise: Argument ${toString path} is not a string";
    assert validRelativeString path "lib.path.relative.normalise: Argument ${toString path} is not a valid relative path string";
    let components = splitRelative path "lib.path.relative.normalise: Argument ${toString path} can't be normalised";
    in joinRelative components;

  commonAncestry = paths:
    let
      deconstructed = lib.attrValues (lib.mapAttrs (name: value:
        assert assertMsg (isPath value) "lib.path.commonAncestry: Attribute ${name} = ${pretty value} is not a path data type";
        deconstructPath value // { inherit name value; }
      ) paths);
      pathHead = head deconstructed;
      pathTail = tail deconstructed;

      go = level:
        if lib.all (x: length x.components > level) deconstructed
          && lib.all (x: elemAt x.components level == elemAt pathHead.components level) pathTail
        then go (level + 1)
        else level;

      root =
        # Fast happy path in case all roots are the same
        if lib.all (x: x.root == pathHead.root) pathTail then pathHead.root
        # Slow sad path when that's not the case and we need to throw an error
        else lib.foldl' (result: el:
          if pathHead.root == el.root then result
          else throw "lib.path.commonAncestry: Path ${pathHead.name} = ${toString pathHead.value} (root ${toString pathHead.root}) has a different filesystem root than path ${toString el.name} = ${toString el.value} (root ${toString el.root})"
        ) null pathTail;

      level =
        # Ensure that we have a common root before trying to find a common ancestor
        # If we didn't do this one could evaluate `relativePaths` without an error even when there's no common root
        builtins.seq root
        (go 0);

      prefix = joinRelative (lib.sublist 0 level pathHead.components);
      suffices = lib.listToAttrs (map (x: { name = x.name; value = joinRelative (lib.sublist level (lib.length x.components - level) x.components); }) deconstructed);
    in
    assert assertMsg (lib.isAttrs paths) "lib.path.commonAncestry: Expecting an attribute set as an argument but got: ${pretty paths}";
    assert assertMsg (length deconstructed > 0) "lib.path.commonAncestry: No paths passed";
    {
      commonPrefix = root + ("/" + prefix);
      relativePaths = suffices;
    };

  relativeTo = basePath: subpath:
    assert assertMsg (isPath basePath) "lib.path.relativeTo: First argument ${pretty basePath} is not a path value";
    assert assertMsg (isPath subpath) "lib.path.relativeTo: First argument ${pretty subpath} is not a path value";
    let common = commonAncestry { inherit basePath subpath; }; in
    assert assertMsg (common.commonPrefix == basePath && common.relativePaths.basePath == ".")
      "lib.path.relativeTo: First arguments ${toString basePath} needs to be an ancestor of or equal to the second argument ${toString subpath}";
    common.relativePaths.subpath;

}
