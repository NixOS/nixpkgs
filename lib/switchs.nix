{ lib }:
with lib; {
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
       the first branch such as `b` is true

     Example:
       ```nix
       let alphanum = n: switch-if [
           { cond = n == 0; out = "zero"; }
           { cond = n == 1; out = "one";  }
         ] "I do not count beyond one"; in
       [ (alphanum 0) (alphanum 1) (alphanum 42) ]
       ```
      => `[ "zero" "one" "I do not count beyond one" ]`

  */
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
       they are converted to a `equal p`
       if `out` is missing then `default-out` is taken

     Example:
       ```nix
       let test = v1: v2: with versions; switch [ v1 v2 ] [
           { cases = [ (x: x * 2 < 4) 8 ]; out = "small, 8"; }
           { case  = [ 42 42 ]; }          # no `out` means `default-out`
           { case  = l: fold add 0 l > 42; out = "sum over 42"; }
           { case  = [ 0 1 ];              out = "zero, one"; }
         ] "weird"; in
       [ (test 1 8) (test 40 3) (test 0 1) (test 42 42) (test 1 0)]
       ```
      => `[ "small, 8" "sum over 42" "zero, one" "weird" "weird" ]`
  */
  switch = var: clauses: default: with preds; let
      compare = f:  if isFunction f then f else equal f;
      combine = cl: var:
        if cl?case then compare cl.case var
        else all (equal true) (zipListsWith compare cl.cases var); in
    switch-if (map (cl: { cond = combine cl var;
                          out = cl.out or default; }) clauses) default;
}
