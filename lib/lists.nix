# General list operations.

with import ./trivial.nix;

let

  inc = builtins.add 1;

  dec = n: builtins.sub n 1;

in rec {

  inherit (builtins) head tail length isList elemAt concatLists filter elem;


  # Create a list consisting of a single element.  `singleton x' is
  # sometimes more convenient with respect to indentation than `[x]'
  # when x spans multiple lines.
  singleton = x: [x];


  # "Fold" a binary function `op' between successive elements of
  # `list' with `nul' as the starting value, i.e., `fold op nul [x_1
  # x_2 ... x_n] == op x_1 (op x_2 ... (op x_n nul))'.  (This is
  # Haskell's foldr).
  fold = op: nul: list:
    let
      len = length list;
      fold' = n:
        if n == len
        then nul
        else op (elemAt list n) (fold' (inc n));
    in fold' 0;

  # Left fold: `fold op nul [x_1 x_2 ... x_n] == op (... (op (op nul
  # x_1) x_2) ... x_n)'.
  foldl = op: nul: list:
    let
      len = length list;
      foldl' = n:
        if n == minus1
        then nul
        else op (foldl' (dec n)) (elemAt list n);
    in foldl' (dec (length list));

  minus1 = dec 0;


  # map with index: `imap (i: v: "${v}-${toString i}") ["a" "b"] ==
  # ["a-1" "b-2"]'
  imap = f: list:
    let
      len = length list;
      imap' = n:
        if n == len
          then []
          else [ (f (inc n) (elemAt list n)) ] ++ imap' (inc n);
    in imap' 0;


  # Map and concatenate the result.
  concatMap = f: list: concatLists (map f list);


  # Flatten the argument into a single list; that is, nested lists are
  # spliced into the top-level lists.  E.g., `flatten [1 [2 [3] 4] 5]
  # == [1 2 3 4 5]' and `flatten 1 == [1]'.
  flatten = x:
    if isList x
    then fold (x: y: (flatten x) ++ y) [] x
    else [x];


  # Remove elements equal to 'e' from a list.  Useful for buildInputs.
  remove = e: filter (x: x != e);


  # Find the sole element in the list matching the specified
  # predicate, returns `default' if no such element exists, or
  # `multiple' if there are multiple matching elements.
  findSingle = pred: default: multiple: list:
    let found = filter pred list; len = length found;
    in if len == 0 then default
      else if len != 1 then multiple
      else head found;


  # Find the first element in the list matching the specified
  # predicate or returns `default' if no such element exists.
  findFirst = pred: default: list:
    let found = filter pred list;
    in if found == [] then default else head found;


  # Return true iff function `pred' returns true for at least element
  # of `list'.
  any = pred: fold (x: y: if pred x then true else y) false;


  # Return true iff function `pred' returns true for all elements of
  # `list'.
  all = pred: fold (x: y: if pred x then y else false) true;


  # Count how many times function `pred' returns true for the elements
  # of `list'.
  count = pred: fold (x: c: if pred x then inc c else c) 0;


  # Return a singleton list or an empty list, depending on a boolean
  # value.  Useful when building lists with optional elements
  # (e.g. `++ optional (system == "i686-linux") flashplayer').
  optional = cond: elem: if cond then [elem] else [];


  # Return a list or an empty list, dependening on a boolean value.
  optionals = cond: elems: if cond then elems else [];


  # If argument is a list, return it; else, wrap it in a singleton
  # list.  If you're using this, you should almost certainly
  # reconsider if there isn't a more "well-typed" approach.
  toList = x: if isList x then x else [x];


  # Return a list of integers from `first' up to and including `last'.
  range = first: last:
    if lessThan last first
    then []
    else [first] ++ range (add first 1) last;


  # Partition the elements of a list in two lists, `right' and
  # `wrong', depending on the evaluation of a predicate.
  partition = pred:
    fold (h: t:
      if pred h
      then { right = [h] ++ t.right; wrong = t.wrong; }
      else { right = t.right; wrong = [h] ++ t.wrong; }
    ) { right = []; wrong = []; };


  zipListsWith = f: fst: snd:
    let
      len1 = length fst;
      len2 = length snd;
      len = if lessThan len1 len2 then len1 else len2;
      zipListsWith' = n:
        if n != len then
          [ (f (elemAt fst n) (elemAt snd n)) ]
          ++ zipListsWith' (inc n)
        else [];
    in zipListsWith' 0;

  zipLists = zipListsWith (fst: snd: { inherit fst snd; });


  # Reverse the order of the elements of a list.  FIXME: O(n^2)!
  reverseList = fold (e: acc: acc ++ [ e ]) [];


  # Sort a list based on a comparator function which compares two
  # elements and returns true if the first argument is strictly below
  # the second argument.  The returned list is sorted in an increasing
  # order.  The implementation does a quick-sort.
  sort = strictLess: list:
    let
      len = length list;
      first = head list;
      pivot' = n: acc@{ left, right }: let el = elemAt list n; next = pivot' (inc n); in
        if n == len
          then acc
        else if strictLess first el
          then next { inherit left; right = [ el ] ++ right; }
        else
          next { left = [ el ] ++ left; inherit right; };
      pivot = pivot' 1 { left = []; right = []; };
    in
      if lessThan len 2 then list
      else (sort strictLess pivot.left) ++  [ first ] ++  (sort strictLess pivot.right);


  # Return the first (at most) N elements of a list.
  take = count: list:
    let
      len = length list;
      take' = n:
        if n == len || n == count
          then []
        else
          [ (elemAt list n) ] ++ take' (inc n);
    in take' 0;


  # Remove the first (at most) N elements of a list.
  drop = count: list:
    let
      len = length list;
      drop' = n:
        if n == minus1 || lessThan n count
          then []
        else
          drop' (dec n) ++ [ (elemAt list n) ];
    in drop' (dec len);


  # Return the last element of a list.
  last = list:
    assert list != []; elemAt list (dec (length list));


  # Zip two lists together.
  zipTwoLists = xs: ys:
    let
      len1 = length xs;
      len2 = length ys;
      len = if lessThan len1 len2 then len1 else len2;
      zipTwoLists' = n:
        if n != len then
          [ { first = elemAt xs n; second = elemAt ys n; } ]
          ++ zipTwoLists' (inc n)
        else [];
    in zipTwoLists' 0;


  deepSeqList = xs: y: if any (x: deepSeq x false) xs then y else y;

  crossLists = f: foldl (fs: args: concatMap (f: map f args) fs) [f];
}
