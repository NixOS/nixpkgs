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

     Remark: the builtins version of `splitVersion` -- which is
     considered first -- has a behaviour which is different from
     `(lib.splitString ".")`. For example, it also recognizes `-` and
     transitions between numbers and other strings as delimiters.
     This behaviour is hence inconsistent between versions of nix and
     should not be relied upon.

     Example (discouraged):
       splitVersion "1-2a+3"
       => [ "1" "2" "a+" "3" ]
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

    Difference with `versionAtLeast` and `versionOlder`:
    - `versionAtLeast` and `versionOlder` implement order relations on
      version numbers, which are total assuming the only separator
      which is used is `.`.

    - `isGe`, `isLe`, `isLt`, and `isEq` are not order relations, they
    are not antisymmetric (e.g. both `isLe "1.1" "1.1.2"` and `isLe
    "1.1.2" "1.1"` are true).
    `(isLe x) y` reads «`y` is a version which is lesser or equal to `x`».
    Contrarily to `versionAtLeast`, it uses the first argument to
    determine the length to truncate so that `isLe "1.1" "1.1.2"` is
    true while `versionAtLeast "1.1" "1.1.2"` is false.

    The main motivation is to be able to combine and read them nicely
    with high order function such as:
    - `filter`, e.g. the result of
      ```
      filter (versionAtLeast "1.0")
             [ "1.3.1" "1.0.0" "1.0" "0.9.0" "1.0.2" ]
      ```
      is `[ "1.0" "0.9.0"]`.
      In comparison
      ```
      filter (isLe "1.0")
             [ "1.3.1" "1.0.0" "1.0" "0.9.0" "1.0.2" ]`
      ```
      returns `[ "1.0.0" "1.0" "0.9.0" "1.0.2" ]`, which can be read
      naturally in English as «we keep versions that are lesser or
      equal to "1.0"» and the outcome matches the expectations that
      "1.0.0" and "1.0.2" belong to the family of "1.0" versions.
        If you wanted to filter more precisely you should give the
      patch version of the first argument of `isLe` instead (as in
      `isLe "1.0.0"`, and if you wanted to exclude all "1.0", then you
      should use `isLt "1.0"`.
    - `switch` as in:
      pkgs/development/coq-modules/mathcomp/default.nix#L21-L22

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
