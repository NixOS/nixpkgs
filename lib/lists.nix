# General list operations.

with import ./trivial.nix;

rec {

  inherit (builtins) head tail length isList elemAt concatLists filter elem genList;

  /*  Create a list consisting of a single element.  `singleton x' is
      sometimes more convenient with respect to indentation than `[x]'
      when x spans multiple lines.

      Example:
        singleton "foo"
        => [ "foo" ]
  */
  singleton = x: [x];

  /* "Fold" a binary function `op' between successive elements of
     `list' with `nul' as the starting value, i.e., `fold op nul [x_1
     x_2 ... x_n] == op x_1 (op x_2 ... (op x_n nul))'.  (This is
     Haskell's foldr).

     Example:
       concat = fold (a: b: a + b) "z"
       concat [ "a" "b" "c" ]
       => "abcz"
  */
  fold = op: nul: list:
    let
      len = length list;
      fold' = n:
        if n == len
        then nul
        else op (elemAt list n) (fold' (n + 1));
    in fold' 0;

  /* Left fold: `fold op nul [x_1 x_2 ... x_n] == op (... (op (op nul
     x_1) x_2) ... x_n)'.

     Example:
       lconcat = foldl (a: b: a + b) "z"
       lconcat [ "a" "b" "c" ]
       => "zabc"
  */
  foldl = op: nul: list:
    let
      len = length list;
      foldl' = n:
        if n == -1
        then nul
        else op (foldl' (n - 1)) (elemAt list n);
    in foldl' (length list - 1);

  /* Strict version of foldl.

     The difference is that evaluation is forced upon access. Usually used
     with small whole results (in contract with lazily-generated list or large
     lists where only a part is consumed.)
  */
  foldl' = builtins.foldl' or foldl;

  /* Map with index

     FIXME(zimbatm): why does this start to count at 1?

     Example:
       imap (i: v: "${v}-${toString i}") ["a" "b"]
       => [ "a-1" "b-2" ]
  */
  imap = f: list: genList (n: f (n + 1) (elemAt list n)) (length list);

  /* Map and concatenate the result.

     Example:
       concatMap (x: [x] ++ ["z"]) ["a" "b"]
       => [ "a" "z" "b" "z" ]
  */
  concatMap = f: list: concatLists (map f list);

  /* Flatten the argument into a single list; that is, nested lists are
     spliced into the top-level lists.

     Example:
       flatten [1 [2 [3] 4] 5]
       => [1 2 3 4 5]
       flatten 1
       => [1]
  */
  flatten = x:
    if isList x
    then concatMap (y: flatten y) x
    else [x];

  /* Remove elements equal to 'e' from a list.  Useful for buildInputs.

     Example:
       remove 3 [ 1 3 4 3 ]
       => [ 1 4 ]
  */
  remove = e: filter (x: x != e);

  /* Find the sole element in the list matching the specified
     predicate, returns `default' if no such element exists, or
     `multiple' if there are multiple matching elements.

     Example:
       findSingle (x: x == 3) "none" "multiple" [ 1 3 3 ]
       => "multiple"
       findSingle (x: x == 3) "none" "multiple" [ 1 3 ]
       => 3
       findSingle (x: x == 3) "none" "multiple" [ 1 9 ]
       => "none"
  */
  findSingle = pred: default: multiple: list:
    let found = filter pred list; len = length found;
    in if len == 0 then default
      else if len != 1 then multiple
      else head found;

  /* Find the first element in the list matching the specified
     predicate or returns `default' if no such element exists.

     Example:
       findFirst (x: x > 3) 7 [ 1 6 4 ]
       => 6
       findFirst (x: x > 9) 7 [ 1 6 4 ]
       => 7
  */
  findFirst = pred: default: list:
    let found = filter pred list;
    in if found == [] then default else head found;

  /* Return true iff function `pred' returns true for at least element
     of `list'.

     Example:
       any isString [ 1 "a" { } ]
       => true
       any isString [ 1 { } ]
       => false
  */
  any = builtins.any or (pred: fold (x: y: if pred x then true else y) false);

  /* Return true iff function `pred' returns true for all elements of
     `list'.

     Example:
       all (x: x < 3) [ 1 2 ]
       => true
       all (x: x < 3) [ 1 2 3 ]
       => false
  */
  all = builtins.all or (pred: fold (x: y: if pred x then y else false) true);

  /* Count how many times function `pred' returns true for the elements
     of `list'.

     Example:
       count (x: x == 3) [ 3 2 3 4 6 ]
       => 2
  */
  count = pred: foldl' (c: x: if pred x then c + 1 else c) 0;

  /* Return a singleton list or an empty list, depending on a boolean
     value.  Useful when building lists with optional elements
     (e.g. `++ optional (system == "i686-linux") flashplayer').

     Example:
       optional true "foo"
       => [ "foo" ]
       optional false "foo"
       => [ ]
  */
  optional = cond: elem: if cond then [elem] else [];

  /* Return a list or an empty list, dependening on a boolean value.

     Example:
       optionals true [ 2 3 ]
       => [ 2 3 ]
       optionals false [ 2 3 ]
       => [ ]
  */
  optionals = cond: elems: if cond then elems else [];


  /* If argument is a list, return it; else, wrap it in a singleton
     list.  If you're using this, you should almost certainly
     reconsider if there isn't a more "well-typed" approach.

     Example:
       toList [ 1 2 ]
       => [ 1 2 ]
       toList "hi"
       => [ "hi "]
  */
  toList = x: if isList x then x else [x];

  /* Return a list of integers from `first' up to and including `last'.

     Example:
       range 2 4
       => [ 2 3 4 ]
       range 3 2
       => [ ]
  */
  range = first: last:
    if first > last then
      []
    else
      genList (n: first + n) (last - first + 1);

  /* Splits the elements of a list in two lists, `right' and
     `wrong', depending on the evaluation of a predicate.

     Example:
       partition (x: x > 2) [ 5 1 2 3 4 ]
       => { right = [ 5 3 4 ]; wrong = [ 1 2 ]; }
  */
  partition = builtins.partition or (pred:
    fold (h: t:
      if pred h
      then { right = [h] ++ t.right; wrong = t.wrong; }
      else { right = t.right; wrong = [h] ++ t.wrong; }
    ) { right = []; wrong = []; });

  /* Merges two lists of the same size together. If the sizes aren't the same
     the merging stops at the shortest. How both lists are merged is defined
     by the first argument.

     Example:
       zipListsWith (a: b: a + b) ["h" "l"] ["e" "o"]
       => ["he" "lo"]
  */
  zipListsWith = f: fst: snd:
    genList
      (n: f (elemAt fst n) (elemAt snd n)) (min (length fst) (length snd));

  /* Merges two lists of the same size together. If the sizes aren't the same
     the merging stops at the shortest.

     Example:
       zipLists [ 1 2 ] [ "a" "b" ]
       => [ { fst = 1; snd = "a"; } { fst = 2; snd = "b"; } ]
  */
  zipLists = zipListsWith (fst: snd: { inherit fst snd; });

  /* Reverse the order of the elements of a list.

     Example:

       reverseList [ "b" "o" "j" ]
       => [ "j" "o" "b" ]
  */
  reverseList = xs:
    let l = length xs; in genList (n: elemAt xs (l - n - 1)) l;

  /* Depth-First Search (DFS) for lists `list != []`.

     `before a b == true` means that `b` depends on `a` (there's an
     edge from `b` to `a`).

     Examples:

         listDfs true hasPrefix [ "/home/user" "other" "/" "/home" ]
           == { minimal = "/";                  # minimal element
                visited = [ "/home/user" ];     # seen elements (in reverse order)
                rest    = [ "/home" "other" ];  # everything else
              }

         listDfs true hasPrefix [ "/home/user" "other" "/" "/home" "/" ]
           == { cycle   = "/";                  # cycle encountered at this element
                loops   = [ "/" ];              # and continues to these elements
                visited = [ "/" "/home/user" ]; # elements leading to the cycle (in reverse order)
                rest    = [ "/home" "other" ];  # everything else

   */

  listDfs = stopOnCycles: before: list:
    let
      dfs' = us: visited: rest:
        let
          c = filter (x: before x us) visited;
          b = partition (x: before x us) rest;
        in if stopOnCycles && (length c > 0)
           then { cycle = us; loops = c; inherit visited rest; }
           else if length b.right == 0
                then # nothing is before us
                     { minimal = us; inherit visited rest; }
                else # grab the first one before us and continue
                     dfs' (head b.right)
                          ([ us ] ++ visited)
                          (tail b.right ++ b.wrong);
    in dfs' (head list) [] (tail list);

  /* Sort a list based on a partial ordering using DFS. This
     implementation is O(N^2), if your ordering is linear, use `sort`
     instead.

     `before a b == true` means that `b` should be after `a`
     in the result.

     Examples:

         toposort hasPrefix [ "/home/user" "other" "/" "/home" ]
           == { result = [ "/" "/home" "/home/user" "other" ]; }

         toposort hasPrefix [ "/home/user" "other" "/" "/home" "/" ]
           == { cycle = [ "/home/user" "/" "/" ]; # path leading to a cycle
                loops = [ "/" ]; }                # loops back to these elements

         toposort hasPrefix [ "other" "/home/user" "/home" "/" ]
           == { result = [ "other" "/" "/home" "/home/user" ]; }

         toposort (a: b: a < b) [ 3 2 1 ] == { result = [ 1 2 3 ]; }

   */

  toposort = before: list:
    let
      dfsthis = listDfs true before list;
      toporest = toposort before (dfsthis.visited ++ dfsthis.rest);
    in
      if length list < 2
      then # finish
           { result =  list; }
      else if dfsthis ? "cycle"
           then # there's a cycle, starting from the current vertex, return it
                { cycle = reverseList ([ dfsthis.cycle ] ++ dfsthis.visited);
                  inherit (dfsthis) loops; }
           else if toporest ? "cycle"
                then # there's a cycle somewhere else in the graph, return it
                     toporest
                # Slow, but short. Can be made a bit faster with an explicit stack.
                else # there are no cycles
                     { result = [ dfsthis.minimal ] ++ toporest.result; };

  /* Sort a list based on a comparator function which compares two
     elements and returns true if the first argument is strictly below
     the second argument.  The returned list is sorted in an increasing
     order.  The implementation does a quick-sort.

     Example:
       sort (a: b: a < b) [ 5 3 7 ]
       => [ 3 5 7 ]
  */
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

  /* Return the first (at most) N elements of a list.

     Example:
       take 2 [ "a" "b" "c" "d" ]
       => [ "a" "b" ]
       take 2 [ ]
       => [ ]
  */
  take = count: sublist 0 count;

  /* Remove the first (at most) N elements of a list.

     Example:
       drop 2 [ "a" "b" "c" "d" ]
       => [ "c" "d" ]
       drop 2 [ ]
       => [ ]
  */
  drop = count: list: sublist count (length list) list;

  /* Return a list consisting of at most ‘count’ elements of ‘list’,
     starting at index ‘start’.

     Example:
       sublist 1 3 [ "a" "b" "c" "d" "e" ]
       => [ "b" "c" "d" ]
       sublist 1 3 [ ]
       => [ ]
  */
  sublist = start: count: list:
    let len = length list; in
    genList
      (n: elemAt list (n + start))
      (if start >= len then 0
       else if start + count > len then len - start
       else count);

  /* Return the last element of a list.

     Example:
       last [ 1 2 3 ]
       => 3
  */
  last = list:
    assert list != []; elemAt list (length list - 1);

  /* Return all elements but the last

     Example:
       init [ 1 2 3 ]
       => [ 1 2 ]
  */
  init = list: assert list != []; take (length list - 1) list;


  /* FIXME(zimbatm) Not used anywhere
   */
  crossLists = f: foldl (fs: args: concatMap (f: map f args) fs) [f];


  /* Remove duplicate elements from the list. O(n^2) complexity.

     Example:

       unique [ 3 2 3 4 ]
       => [ 3 2 4 ]
   */
  unique = list:
    if list == [] then
      []
    else
      let
        x = head list;
        xs = unique (drop 1 list);
      in [x] ++ remove x xs;

  /* Intersects list 'e' and another list. O(nm) complexity.

     Example:
       intersectLists [ 1 2 3 ] [ 6 3 2 ]
       => [ 3 2 ]
  */
  intersectLists = e: filter (x: elem x e);

  /* Subtracts list 'e' from another list. O(nm) complexity.

     Example:
       subtractLists [ 3 2 ] [ 1 2 3 4 5 3 ]
       => [ 1 4 5 ]
  */
  subtractLists = e: filter (x: !(elem x e));

}
