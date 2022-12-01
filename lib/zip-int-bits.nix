/* Helper function to implement a fallback for the bit operators
   `bitAnd`, `bitOr` and `bitXor` on older nix version.
   See ./trivial.nix
*/
f: x: y:
  let
    # (intToBits 6) -> [ 0 1 1 ]
    intToBits = x:
      if x == 0 || x == -1 then
        []
      else
        let
          headbit  = if (x / 2) * 2 != x then 1 else 0;          # x & 1
          tailbits = if x < 0 then ((x + 1) / 2) - 1 else x / 2; # x >> 1
        in
          [headbit] ++ (intToBits tailbits);

    # (bitsToInt [ 0 1 1 ] 0) -> 6
    # (bitsToInt [ 0 1 0 ] 1) -> -6
    bitsToInt = l: signum:
      if l == [] then
        (if signum == 0 then 0 else -1)
      else
        (builtins.head l) + (2 * (bitsToInt (builtins.tail l) signum));

    xsignum = if x < 0 then 1 else 0;
    ysignum = if y < 0 then 1 else 0;
    zipListsWith' = fst: snd:
      if fst==[] && snd==[] then
        []
      else if fst==[] then
        [(f xsignum             (builtins.head snd))] ++ (zipListsWith' []                  (builtins.tail snd))
      else if snd==[] then
        [(f (builtins.head fst) ysignum            )] ++ (zipListsWith' (builtins.tail fst) []                 )
      else
        [(f (builtins.head fst) (builtins.head snd))] ++ (zipListsWith' (builtins.tail fst) (builtins.tail snd));
  in
    assert (builtins.isInt x) && (builtins.isInt y);
    bitsToInt (zipListsWith' (intToBits x) (intToBits y)) (f xsignum ysignum)
