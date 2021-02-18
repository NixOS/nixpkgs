/* Version string functions. */
{ lib }:

with lib;
let
  truncate = n: v: concatStringsSep "." (take n (splitVersion v));
  opTruncate = op: v0: v: let n = length (splitVersion v0); in
     op (truncate n v) (truncate n v0);
in rec {

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

  /* Get string of the first n parts of a version string.

    Example:
    - truncate 2 "1.2.3-stuff"
      => "1.2"
    - truncate 4 "1.2.3-stuff"
      => "1.2.3.stuff"
  */

  inherit truncate;

  /* Get string of the first two parts (major and minor)
     of a version string.

     Example:
       majorMinor "1.2.3"
       => "1.2"
  */
  majorMinor = truncate 2;

  /* Get string of the first three parts (major, minor and patch)
     of a version string.

    Example:
      majorMinorPatch "1.2.3-stuff"
      => "1.2.3"
  */
  majorMinorPatch = truncate 3;

  /* Version comparison predicates,
    - isGe v0 v <-> v is greater or equal than v0   [*]
    - isLe v0 v <-> v is lesser  or equal than v0   [*]
    - isGt v0 v <-> v is strictly greater than v0   [*]
    - isLt v0 v <-> v is strictly lesser  than v0   [*]
    - isEq v0 v <-> v is equal to v0                [*]
    - range low high v <-> v is between low and high [**]

  [*]  truncating v to the same number of digits as v0
  [**] truncating v to low for the lower bound and high for the upper bound

    Examples:
    - isGe "8.10" "8.10.1"
      => true
    - isLe "8.10" "8.10.1"
      => true
    - isGt "8.10" "8.10.1"
      => false
    - isGt "8.10.0" "8.10.1"
      => true
    - isEq "8.10" "8.10.1"
      => true
    - range "8.10" "8.11" "8.11.1"
      => true
    - range "8.10" "8.11+" "8.11.0"
      => false
    - range "8.10" "8.11+" "8.11+beta1"
      => false
  */
  isGe = opTruncate versionAtLeast;
  isGt = opTruncate (flip versionOlder);
  isLe = opTruncate (flip versionAtLeast);
  isLt = opTruncate versionOlder;
  isEq = opTruncate preds.equal;
  range = low: high: preds.inter (versions.isGe low) (versions.isLe high);

}
