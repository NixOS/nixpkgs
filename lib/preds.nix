{ lib }:
with lib; {
  /* Constant predicates: true and false */
  true  = p: true;
  false = p: false;

  /* Predicate intersection, union, complement,
     difference and implication */
  inter = p: q: x: p x && q x;
  union = p: q: x: p x || q x;
  compl = p:    x: ! p x;
  diff  = p: q: preds.inter p (preds.compl q);
  impl  = p: q: x: p x -> q x;

  /* predicate "being equal to x" */
  equal = x: y: y == x;
}
