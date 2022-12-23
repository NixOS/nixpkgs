# Functions for working with paths, see ./path.md
{ lib }:
let

  inherit (builtins)
    isString
    match
    ;

  inherit (lib.strings)
    substring
    ;

  inherit (lib.asserts)
    assertMsg
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

in /* No rec! Add dependencies on this file at the top. */ {


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
  subpath.isValid = value:
    subpathInvalidReason value == null;

}
