# General list operations.

with import ./trivial.nix;

rec {

  inherit (builtins) head tail length isList elemAt concatLists filter elem genList;


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
        else op (elemAt list n) (fold' (n + 1));
    in fold' 0;

  # Left fold: `fold op nul [x_1 x_2 ... x_n] == op (... (op (op nul
  # x_1) x_2) ... x_n)'.
  foldl = op: nul: list:
    let
      len = length list;
      foldl' = n:
        if n == -1
        then nul
        else op (foldl' (n - 1)) (elemAt list n);
    in foldl' (length list - 1);


  # Strict version of foldl.
  foldl' = builtins.foldl' or foldl;


  # Map with index: `imap (i: v: "${v}-${toString i}") ["a" "b"] ==
  # ["a-1" "b-2"]'. FIXME: why does this start to count at 1?
  imap =
    if builtins ? genList then
      f: list: genList (n: f (n + 1) (elemAt list n)) (length list)
    else
      f: list:
      let
        len = length list;
        imap' = n:
          if n == len
            then []
            else [ (f (n + 1) (elemAt list n)) ] ++ imap' (n + 1);
      in imap' 0;


  # Map and concatenate the result.
  concatMap = f: list: concatLists (map f list);


  # Flatten the argument into a single list; that is, nested lists are
  # spliced into the top-level lists.  E.g., `flatten [1 [2 [3] 4] 5]
  # == [1 2 3 4 5]' and `flatten 1 == [1]'.
  flatten = x:
    if isList x
    then foldl' (x: y: x ++ (flatten y)) [] x
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
  any = builtins.any or (pred: fold (x: y: if pred x then true else y) false);


  # Return true iff function `pred' returns true for all elements of
  # `list'.
  all = builtins.all or (pred: fold (x: y: if pred x then y else false) true);


  # Count how many times function `pred' returns true for the elements
  # of `list'.
  count = pred: foldl' (c: x: if pred x then c + 1 else c) 0;


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
  range =
    if builtins ? genList then
      first: last:
        if first > last
        then []
        else genList (n: first + n) (last - first + 1)
    else
      first: last:
        if last < first
        then []
        else [first] ++ range (first + 1) last;


  # Partition the elements of a list in two lists, `right' and
  # `wrong', depending on the evaluation of a predicate.
  partition = pred:
    fold (h: t:
      if pred h
      then { right = [h] ++ t.right; wrong = t.wrong; }
      else { right = t.right; wrong = [h] ++ t.wrong; }
    ) { right = []; wrong = []; };


  zipListsWith =
    if builtins ? genList then
      f: fst: snd: genList (n: f (elemAt fst n) (elemAt snd n)) (min (length fst) (length snd))
    else
      f: fst: snd:
      let
        len = min (length fst) (length snd);
        zipListsWith' = n:
          if n != len then
            [ (f (elemAt fst n) (elemAt snd n)) ]
            ++ zipListsWith' (n + 1)
          else [];
      in zipListsWith' 0;

  zipLists = zipListsWith (fst: snd: { inherit fst snd; });


  # Reverse the order of the elements of a list.
  reverseList =
    if builtins ? genList then
      xs: let l = length xs; in genList (n: elemAt xs (l - n - 1)) l
    else
      fold (e: acc: acc ++ [ e ]) [];


  # Sort a list based on a comparator function which compares two
  # elements and returns true if the first argument is strictly below
  # the second argument.  The returned list is sorted in an increasing
  # order.  The implementation does a quick-sort.
  sort = builtins.sort or (
    strictLess: list:
    let
      len = length list;
      first = head list;
      pivot' = n: acc@{ left, right }: let el = elemAt list n; next = pivot' (n + 1); in
        if n == len
          then acc
        else if strictLess first el
          then next { inherit left; right = [ el ] ++ right; }
        else
          next { left = [ el ] ++ left; inherit right; };
      pivot = pivot' 1 { left = []; right = []; };
    in
      if len < 2 then list
      else (sort strictLess pivot.left) ++  [ first ] ++  (sort strictLess pivot.right));


  # Return the first (at most) N elements of a list.
  take =
    if builtins ? genList then
      count: sublist 0 count
    else
      count: list:
        let
          len = length list;
          take' = n:
            if n == len || n == count
              then []
            else
              [ (elemAt list n) ] ++ take' (n + 1);
        in take' 0;


  # Remove the first (at most) N elements of a list.
  drop =
    if builtins ? genList then
      count: list: sublist count (length list) list
    else
      count: list:
        let
          len = length list;
          drop' = n:
            if n == -1 || n < count
              then []
            else
              drop' (n - 1) ++ [ (elemAt list n) ];
        in drop' (len - 1);


  # Return a list consisting of at most ‘count’ elements of ‘list’,
  # starting at index ‘start’.
  sublist = start: count: list:
    let len = length list; in
    genList
      (n: elemAt list (n + start))
      (if start >= len then 0
       else if start + count > len then len - start
       else count);


  # Return the last element of a list.
  last = list:
    assert list != []; elemAt list (length list - 1);


  # Return all elements but the last
  init = list: assert list != []; take (length list - 1) list;


  crossLists = f: foldl (fs: args: concatMap (f: map f args) fs) [f];


  # Remove duplicate elements from the list. O(n^2) complexity.
  unique = list:
    if list == [] then
      []
    else
      let
        x = head list;
        xs = unique (drop 1 list);
      in [x] ++ remove x xs;


  # Intersects list 'e' and another list. O(nm) complexity.
  intersectLists = e: filter (x: elem x e);


  # Subtracts list 'e' from another list. O(nm) complexity.
  subtractLists = e: filter (x: !(elem x e));

  deepSeqList = throw "removed 2016-02-29 because unused and broken";


}
