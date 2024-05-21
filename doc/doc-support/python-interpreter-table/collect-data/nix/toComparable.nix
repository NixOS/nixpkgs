/* Convert a "<name> <version>" string to a comparable list.

The purpose of this function is to allow for
natural sorting of strings representing versioned names,
where the version are numbers separated by dots.

Examples:

- `toComparable "CPython"` returns `[ "CPython" 0 ]`
- `toComparable "CPython 3"` returns `[ "CPython" 3 ]`
- `toComparable "CPython 3.0"` returns `[ "CPython" 3 0 ]`
- `toComparable "CPython 3.9"` returns `[ "CPython" 3 9 ]`
- `toComparable "CPython 3.10"` returns `[ "CPython" 3 10 ]`
*/
{ lib }:
str:
let
  inherit (lib.lists) head length map tail;
  inherit (lib.strings) splitString toInt;
  inherit (lib.versions) splitVersion;

  versionToIntList = versionSuffix:
    (stringListToIntList (splitVersion (head (tail versionSuffix))));

  stringListToIntList = map (x: toInt x);

  # The head corresponds with the name and
  # the tail corresponds with the version.
  lst = splitString " " str;
in
  if length lst == 1 then lst ++ [0]
  else [(head lst)] ++ versionToIntList lst
