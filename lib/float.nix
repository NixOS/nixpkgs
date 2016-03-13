let

  # Split string by "."'s.
  split = (import ./strings.nix).splitString ".";
  # String to Int
  stoi = builtins.fromJSON;
  # Int to String
  itos = builtins.toString;
  # Substring.
  substr = builtins.substring;

  # Fold over array, where first element is initial value.
  fold = f: a: builtins.foldl' f (builtins.head a) (builtins.tail a);

  # Sum over array.
  sum = fold (x: y: x + y);

  # repeat value v, t times.
  repeat = v: t: builtins.genList (x: v) t;

  # index of array
  ind = builtins.elemAt;

  # absolute value
  abs = num: if num < 0 then -num else num;

  # length of string or list
  len = v:
    if builtins.typeOf v == "string" then
      builtins.stringLength v
    else
      builtins.length v;
  
  # 10^exp
  tenPow = exp: fold builtins.mul (repeat 10 (abs exp));
  
  # Make a string out of num zeroes.
  zeros = num:
    sum (repeat "0" (abs num));
  
  # 56234 -> 10000; 100 -> 100; 230 -> 100;
  tens = num:
    stoi ("1" + zeros (len (itos num) - 1));

in {

  float = rec {

    # Truncation value. So far it only applies to division.
    truncate = 10;

    # From int to float.
    fromInt = num:
      simplify {
        num = num;
        exp = 0;
      };

    # From float to int.
    toInt = {num, exp}:
      if exp < 0
      then num / (tenPow exp)
      else num * (tenPow exp);

    # Float to string.
    toString = {num, exp}:
      let
        str = itos num;
        index = (len str) + exp;
        int =
          if index < 1
          then "0"
          else substr 0 index str;
        dec =
          if index < 1
          then (zeros index) + str
          else substr index (-1) str;
      in
        if exp < 0
          then int + "." + dec
          else int;

    # String to float.
    fromString = str:
      let
        arr = split str;
        num = sum arr;
        exp =
          if len arr == 2
          then -(len (ind arr 1))
          else 0;
      in simplify {
        num = (stoi num);
        exp = exp;
      };

    # a + b
    add = x: y:
      let
        diff = y.exp - x.exp;
        a =
          if diff < 0 then
            {
              num = (x.num) * (tenPow diff);
              exp = x.exp + diff;
            }
          else x;
        b = if diff > 0
              then (y.num) * (tenPow diff)
              else y.num;
      in
        simplify {
          num = a.num + b;
          exp = a.exp;
        };

    # -a
    neg = { num, exp }: { num = -num; exp = exp; };

    # a - b = a + (-b)
    sub = a: b: add a (neg b);

    # a * b
    mul = a: b:
      simplify {
        num = a.num * b.num;
        exp = a.exp + b.exp;
      };

    # 1 / a
    inv = { num, exp }: {
      num = (tens num) * (tenPow truncate) / num;
      exp = -truncate;
    };

    # a / b = a * (1 / b)
    div = a: b: mul a (inv b);

    # Simplifies floats by dividing by the necessary number of 10s.
    simplify = float@{num, exp}:
      if num == 0 then
        {
          num = 0;
          exp = 0;
        }
      else if num == num / 10 * 10 then
        simplify {
          num = num / 10;
          exp = exp + 1;
        }
      else float;
  };

}
