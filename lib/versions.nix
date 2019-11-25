/* Version string functions. */
{ lib }:

rec {

  /* Break a version string into its component parts.

     Example:
       splitVersion "1.2.3"
       => ["1" "2" "3"]
  */
  splitVersion = builtins.splitVersion or (lib.splitString ".");

  /* Get the major version string from a string.

    Example:
      major "1.2.3"
      => "1"
  */
  major = v: builtins.elemAt (splitVersion v) 0;

  /* Get the minor version string from a string.

    Example:
      minor "1.2.3"
      => "2"
  */
  minor = v: builtins.elemAt (splitVersion v) 1;

  /* Get the patch version string from a string.

    Example:
      patch "1.2.3"
      => "3"
  */
  patch = v: builtins.elemAt (splitVersion v) 2;

  /* Get string of the first two parts (major and minor)
     of a version string.

     Example:
       majorMinor "1.2.3"
       => "1.2"
  */
  majorMinor = v:
    builtins.concatStringsSep "."
    (lib.take 2 (splitVersion v));

}
