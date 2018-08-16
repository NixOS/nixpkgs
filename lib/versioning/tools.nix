{lib}:
with builtins;
rec {
  levenCode = n:
    let l = stringLength n; in
    if l == 0 then "0"
    else if l == 1 && n < "9" then n
    else "9" + levenCode (toString l) + n;
  mkVersioner = inject: rec {
    inherit inject;
    extract = x: if isString x then inject x else inject (lib.getVersion x);
    compare = x: y: lib.compare (extract x) (extract y);
  };
}
