{ lib }:
with builtins; with lib; recursiveUpdate lib (rec {

  versions =
    let
      truncate = n: v: concatStringsSep "." (take n (splitVersion v));
      opTruncate = op: v0: v: let n = length (splitVersion v0); in
         op (truncate n v) (truncate n v0);
    in rec {

    /* Get string of the first n parts of a version string.

       Example:
       - truncate 2 "1.2.3-stuff"
         => "1.2"

       - truncate 4 "1.2.3-stuff"
         => "1.2.3.stuff"
    */

    inherit truncate;

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
    isEq = opTruncate pred.equal;
    range = low: high: pred.inter (versions.isGe low) (versions.isLe high);
  };

  /* Returns a list of list, splitting it using a predicate.
     This is analoguous to builtins.split sep list,
     with a predicate as a separator and a list instead of a string.

    Type: splitList :: (a -> bool) -> [a] -> [[a]]

    Example:
      splitList (x: x == "x") [ "y" "x" "z" "t" ]
      => [ [ "y" ] "x" [ "z" "t" ] ]
  */
  splitList = pred: l: # put in file lists
    let loop = (vv: v: l: if l == [] then vv ++ [v]
      else let hd = head l; tl = tail l; in
      if pred hd then loop (vv ++ [ v hd ]) [] tl else loop vv (v ++ [hd]) tl);
    in loop [] [] l;

  pred = {
    /* Predicate intersection, union, and complement */
    inter = p: q: x: p x && q x;
    union = p: q: x: p x || q x;
    compl = p:    x: ! p x;
    true  = p: true;
    false = p: false;

    /* predicate "being equal to y" */
    equal = y:    x: x == y;
  };

  /* Emulate a "switch - case" construct,
   instead of relying on `if then else if ...` */
  /* Usage:
  ```nix
  switch-if [
    if-clause-1
    ..
    if-clause-k
  ] default-out
  ```
  where a if-clause has the form `{ cond = b; out = r; }`
  the first branch such as `b` is true */

  switch-if = c: d: (findFirst (getAttr "cond") {} c).out or d;

  /* Usage:
  ```nix
  switch x [
    simple-clause-1
    ..
    simple-clause-k
  ] default-out
  ```
  where a simple-clause has the form `{ case = p; out = r; }`
  the first branch such as `p x` is true
  or
  ```nix
  switch [ x1 .. xn ] [
    complex-clause-1
    ..
    complex-clause-k
  ] default-out
  ```
  where a complex-clause is either a simple-clause
  or has the form { cases = [ p1 .. pn ]; out = r; }
  in which case the first branch such as all `pi x` are true

  if the variables p are not functions,
  they are converted to a equal p
  if out is missing the default-out is taken */

  switch = var: clauses: default: with pred; let
      compare = f:  if isFunction f then f else equal f;
      combine = cl: var:
        if cl?case then compare cl.case var
        else all (equal true) (zipListsWith compare cl.cases var); in
    switch-if (map (cl: { cond = combine cl var; inherit (cl) out; }) clauses) default;

  /* Override arguments to mkCoqDerivation for a Coq library.

     This function allows you to easily override arguments to mkCoqDerivation,
     even when they are not exposed by the Coq library directly.

     Type: overrideCoqDerivation :: AttrSet -> CoqLibraryDerivation -> CoqLibraryDerivation

     Example:

     ```nix
     coqPackages.lib.overrideCoqDerivation
       {
         defaultVersion = "9999";
         release."9999".sha256 = "1lq8x86vd3vqqh2yq6hvyagpnhfq5wmk5pg2z0xq7b7dbbbhyfkw";
       }
       coqPackages.QuickChick;
     ```

     This example overrides the `defaultVersion` and `release` arguments that
     are passed to `mkCoqDerivation` in the QuickChick derivation.

     Note that there is a difference between using `.override` on a Coq
     library vs this `overrideCoqDerivation` function. `.override` allows you
     to modify arguments to the derivation itself, for instance by passing
     different versions of dependencies:

     ```nix
     coqPackages.QuickCick.override { ssreflect = my-cool-ssreflect; }
     ```

     whereas `overrideCoqDerivation` allows you to override arguments to the
     call to `mkCoqDerivation` in the Coq library.
  */
  overrideCoqDerivation = f: drv: (drv.override (args: {
    mkCoqDerivation = drv_: (args.mkCoqDerivation drv_).override f;
  }));
})
