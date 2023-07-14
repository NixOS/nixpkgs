# General list operations.

{ lib }:
let
  inherit (lib.strings) toInt;
  inherit (lib.trivial) compare min;
  inherit (lib.attrsets) mapAttrs;
in
rec {

  inherit (builtins) head tail length isList elemAt concatLists filter elem genList map;

  /*  Create a list consisting of a single element.  `singleton x` is
      sometimes more convenient with respect to indentation than `[x]`
      when x spans multiple lines.

      Type: singleton :: a -> [a]

      Example:
        singleton "foo"
        => [ "foo" ]
  */
  singleton = x: [x];

  /*  Apply the function to each element in the list. Same as `map`, but arguments
      flipped.

      Type: forEach :: [a] -> (a -> b) -> [b]

      Example:
        forEach [ 1 2 ] (x:
          toString x
        )
        => [ "1" "2" ]
  */
  forEach = xs: f: map f xs;

  /* “right fold” a binary function `op` between successive elements of
     `list` with `nul` as the starting value, i.e.,
     `foldr op nul [x_1 x_2 ... x_n] == op x_1 (op x_2 ... (op x_n nul))`.

     Type: foldr :: (a -> b -> b) -> b -> [a] -> b

     Example:
       concat = foldr (a: b: a + b) "z"
       concat [ "a" "b" "c" ]
       => "abcz"
       # different types
       strange = foldr (int: str: toString (int + 1) + str) "a"
       strange [ 1 2 3 4 ]
       => "2345a"
  */
  foldr = op: nul: list:
    let
      len = length list;
      fold' = n:
        if n == len
        then nul
        else op (elemAt list n) (fold' (n + 1));
    in fold' 0;

  /* `fold` is an alias of `foldr` for historic reasons */
  # FIXME(Profpatsch): deprecate?
  fold = foldr;


  /* “left fold”, like `foldr`, but from the left:
     `foldl op nul [x_1 x_2 ... x_n] == op (... (op (op nul x_1) x_2) ... x_n)`.

     Type: foldl :: (b -> a -> b) -> b -> [a] -> b

     Example:
       lconcat = foldl (a: b: a + b) "z"
       lconcat [ "a" "b" "c" ]
       => "zabc"
       # different types
       lstrange = foldl (str: int: str + toString (int + 1)) "a"
       lstrange [ 1 2 3 4 ]
       => "a2345"
  */
  foldl = op: nul: list:
    let
      foldl' = n:
        if n == -1
        then nul
        else op (foldl' (n - 1)) (elemAt list n);
    in foldl' (length list - 1);

  /* Strict version of `foldl`.

     The difference is that evaluation is forced upon access. Usually used
     with small whole results (in contrast with lazily-generated list or large
     lists where only a part is consumed.)

     Type: foldl' :: (b -> a -> b) -> b -> [a] -> b
  */
  foldl' = builtins.foldl' or foldl;

  /* Map with index starting from 0

     Type: imap0 :: (int -> a -> b) -> [a] -> [b]

     Example:
       imap0 (i: v: "${v}-${toString i}") ["a" "b"]
       => [ "a-0" "b-1" ]
  */
  imap0 = f: list: genList (n: f n (elemAt list n)) (length list);

  /* Map with index starting from 1

     Type: imap1 :: (int -> a -> b) -> [a] -> [b]

     Example:
       imap1 (i: v: "${v}-${toString i}") ["a" "b"]
       => [ "a-1" "b-2" ]
  */
  imap1 = f: list: genList (n: f (n + 1) (elemAt list n)) (length list);

  /* Map and concatenate the result.

     Type: concatMap :: (a -> [b]) -> [a] -> [b]

     Example:
       concatMap (x: [x] ++ ["z"]) ["a" "b"]
       => [ "a" "z" "b" "z" ]
  */
  concatMap = builtins.concatMap or (f: list: concatLists (map f list));

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

     Type: remove :: a -> [a] -> [a]

     Example:
       remove 3 [ 1 3 4 3 ]
       => [ 1 4 ]
  */
  remove =
    # Element to remove from the list
    e: filter (x: x != e);

  /* Find the sole element in the list matching the specified
     predicate, returns `default` if no such element exists, or
     `multiple` if there are multiple matching elements.

     Type: findSingle :: (a -> bool) -> a -> a -> [a] -> a

     Example:
       findSingle (x: x == 3) "none" "multiple" [ 1 3 3 ]
       => "multiple"
       findSingle (x: x == 3) "none" "multiple" [ 1 3 ]
       => 3
       findSingle (x: x == 3) "none" "multiple" [ 1 9 ]
       => "none"
  */
  findSingle =
    # Predicate
    pred:
    # Default value to return if element was not found.
    default:
    # Default value to return if more than one element was found
    multiple:
    # Input list
    list:
    let found = filter pred list; len = length found;
    in if len == 0 then default
      else if len != 1 then multiple
      else head found;

  /* Find the first element in the list matching the specified
     predicate or return `default` if no such element exists.

     Type: findFirst :: (a -> bool) -> a -> [a] -> a

     Example:
       findFirst (x: x > 3) 7 [ 1 6 4 ]
       => 6
       findFirst (x: x > 9) 7 [ 1 6 4 ]
       => 7
  */
  findFirst =
    # Predicate
    pred:
    # Default value to return
    default:
    # Input list
    list:
    let
      # A naive recursive implementation would be much simpler, but
      # would also overflow the evaluator stack. We use `foldl'` as a workaround
      # because it reuses the same stack space, evaluating the function for one
      # element after another. We can't return early, so this means that we
      # sacrifice early cutoff, but that appears to be an acceptable cost. A
      # clever scheme with "exponential search" is possible, but appears over-
      # engineered for now. See https://github.com/NixOS/nixpkgs/pull/235267

      # Invariant:
      # - if index < 0 then el == elemAt list (- index - 1) and all elements before el didn't satisfy pred
      # - if index >= 0 then pred (elemAt list index) and all elements before (elemAt list index) didn't satisfy pred
      #
      # We start with index -1 and the 0'th element of the list, which satisfies the invariant
      resultIndex = foldl' (index: el:
        if index < 0 then
          # No match yet before the current index, we need to check the element
          if pred el then
            # We have a match! Turn it into the actual index to prevent future iterations from modifying it
            - index - 1
          else
            # Still no match, update the index to the next element (we're counting down, so minus one)
            index - 1
        else
          # There's already a match, propagate the index without evaluating anything
          index
      ) (-1) list;
    in
    if resultIndex < 0 then
      default
    else
      elemAt list resultIndex;

  /* Return true if function `pred` returns true for at least one
     element of `list`.

     Type: any :: (a -> bool) -> [a] -> bool

     Example:
       any isString [ 1 "a" { } ]
       => true
       any isString [ 1 { } ]
       => false
  */
  any = builtins.any or (pred: foldr (x: y: if pred x then true else y) false);

  /* Return true if function `pred` returns true for all elements of
     `list`.

     Type: all :: (a -> bool) -> [a] -> bool

     Example:
       all (x: x < 3) [ 1 2 ]
       => true
       all (x: x < 3) [ 1 2 3 ]
       => false
  */
  all = builtins.all or (pred: foldr (x: y: if pred x then y else false) true);

  /* Count how many elements of `list` match the supplied predicate
     function.

     Type: count :: (a -> bool) -> [a] -> int

     Example:
       count (x: x == 3) [ 3 2 3 4 6 ]
       => 2
  */
  count =
    # Predicate
    pred: foldl' (c: x: if pred x then c + 1 else c) 0;

  /* Return a singleton list or an empty list, depending on a boolean
     value.  Useful when building lists with optional elements
     (e.g. `++ optional (system == "i686-linux") firefox`).

     Type: optional :: bool -> a -> [a]

     Example:
       optional true "foo"
       => [ "foo" ]
       optional false "foo"
       => [ ]
  */
  optional = cond: elem: if cond then [elem] else [];

  /* Return a list or an empty list, depending on a boolean value.

     Type: optionals :: bool -> [a] -> [a]

     Example:
       optionals true [ 2 3 ]
       => [ 2 3 ]
       optionals false [ 2 3 ]
       => [ ]
  */
  optionals =
    # Condition
    cond:
    # List to return if condition is true
    elems: if cond then elems else [];


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

  /* Return a list of integers from `first` up to and including `last`.

     Type: range :: int -> int -> [int]

     Example:
       range 2 4
       => [ 2 3 4 ]
       range 3 2
       => [ ]
  */
  range =
    # First integer in the range
    first:
    # Last integer in the range
    last:
    if first > last then
      []
    else
      genList (n: first + n) (last - first + 1);

  /* Return a list with `n` copies of an element.

    Type: replicate :: int -> a -> [a]

    Example:
      replicate 3 "a"
      => [ "a" "a" "a" ]
      replicate 2 true
      => [ true true ]
  */
  replicate = n: elem: genList (_: elem) n;

  /* Splits the elements of a list in two lists, `right` and
     `wrong`, depending on the evaluation of a predicate.

     Type: (a -> bool) -> [a] -> { right :: [a]; wrong :: [a]; }

     Example:
       partition (x: x > 2) [ 5 1 2 3 4 ]
       => { right = [ 5 3 4 ]; wrong = [ 1 2 ]; }
  */
  partition = builtins.partition or (pred:
    foldr (h: t:
      if pred h
      then { right = [h] ++ t.right; wrong = t.wrong; }
      else { right = t.right; wrong = [h] ++ t.wrong; }
    ) { right = []; wrong = []; });

  /* Splits the elements of a list into many lists, using the return value of a predicate.
     Predicate should return a string which becomes keys of attrset `groupBy` returns.

     `groupBy'` allows to customise the combining function and initial value

     Example:
       groupBy (x: boolToString (x > 2)) [ 5 1 2 3 4 ]
       => { true = [ 5 3 4 ]; false = [ 1 2 ]; }
       groupBy (x: x.name) [ {name = "icewm"; script = "icewm &";}
                             {name = "xfce";  script = "xfce4-session &";}
                             {name = "icewm"; script = "icewmbg &";}
                             {name = "mate";  script = "gnome-session &";}
                           ]
       => { icewm = [ { name = "icewm"; script = "icewm &"; }
                      { name = "icewm"; script = "icewmbg &"; } ];
            mate  = [ { name = "mate";  script = "gnome-session &"; } ];
            xfce  = [ { name = "xfce";  script = "xfce4-session &"; } ];
          }

       groupBy' builtins.add 0 (x: boolToString (x > 2)) [ 5 1 2 3 4 ]
       => { true = 12; false = 3; }
  */
  groupBy' = op: nul: pred: lst: mapAttrs (name: foldl op nul) (groupBy pred lst);

  groupBy = builtins.groupBy or (
    pred: foldl' (r: e:
       let
         key = pred e;
       in
         r // { ${key} = (r.${key} or []) ++ [e]; }
    ) {});

  /* Merges two lists of the same size together. If the sizes aren't the same
     the merging stops at the shortest. How both lists are merged is defined
     by the first argument.

     Type: zipListsWith :: (a -> b -> c) -> [a] -> [b] -> [c]

     Example:
       zipListsWith (a: b: a + b) ["h" "l"] ["e" "o"]
       => ["he" "lo"]
  */
  zipListsWith =
    # Function to zip elements of both lists
    f:
    # First list
    fst:
    # Second list
    snd:
    genList
      (n: f (elemAt fst n) (elemAt snd n)) (min (length fst) (length snd));

  /* Merges two lists of the same size together. If the sizes aren't the same
     the merging stops at the shortest.

     Type: zipLists :: [a] -> [b] -> [{ fst :: a; snd :: b; }]

     Example:
       zipLists [ 1 2 ] [ "a" "b" ]
       => [ { fst = 1; snd = "a"; } { fst = 2; snd = "b"; } ]
  */
  zipLists = zipListsWith (fst: snd: { inherit fst snd; });

  /* Reverse the order of the elements of a list.

     Type: reverseList :: [a] -> [a]

     Example:

       reverseList [ "b" "o" "j" ]
       => [ "j" "o" "b" ]
  */
  reverseList = xs:
    let l = length xs; in genList (n: elemAt xs (l - n - 1)) l;

  /* Depth-First Search (DFS) for lists `list != []`.

     `before a b == true` means that `b` depends on `a` (there's an
     edge from `b` to `a`).

     Example:
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

     Example:

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
      else if dfsthis ? cycle
           then # there's a cycle, starting from the current vertex, return it
                { cycle = reverseList ([ dfsthis.cycle ] ++ dfsthis.visited);
                  inherit (dfsthis) loops; }
           else if toporest ? cycle
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

  /* Compare two lists element-by-element.

     Example:
       compareLists compare [] []
       => 0
       compareLists compare [] [ "a" ]
       => -1
       compareLists compare [ "a" ] []
       => 1
       compareLists compare [ "a" "b" ] [ "a" "c" ]
       => -1
  */
  compareLists = cmp: a: b:
    if a == []
    then if b == []
         then 0
         else -1
    else if b == []
         then 1
         else let rel = cmp (head a) (head b); in
              if rel == 0
              then compareLists cmp (tail a) (tail b)
              else rel;

  /* Sort list using "Natural sorting".
     Numeric portions of strings are sorted in numeric order.

     Example:
       naturalSort ["disk11" "disk8" "disk100" "disk9"]
       => ["disk8" "disk9" "disk11" "disk100"]
       naturalSort ["10.46.133.149" "10.5.16.62" "10.54.16.25"]
       => ["10.5.16.62" "10.46.133.149" "10.54.16.25"]
       naturalSort ["v0.2" "v0.15" "v0.0.9"]
       => [ "v0.0.9" "v0.2" "v0.15" ]
  */
  naturalSort = lst:
    let
      vectorise = s: map (x: if isList x then toInt (head x) else x) (builtins.split "(0|[1-9][0-9]*)" s);
      prepared = map (x: [ (vectorise x) x ]) lst; # remember vectorised version for O(n) regex splits
      less = a: b: (compareLists compare (head a) (head b)) < 0;
    in
      map (x: elemAt x 1) (sort less prepared);

  /* Return the first (at most) N elements of a list.

     Type: take :: int -> [a] -> [a]

     Example:
       take 2 [ "a" "b" "c" "d" ]
       => [ "a" "b" ]
       take 2 [ ]
       => [ ]
  */
  take =
    # Number of elements to take
    count: sublist 0 count;

  /* Remove the first (at most) N elements of a list.

     Type: drop :: int -> [a] -> [a]

     Example:
       drop 2 [ "a" "b" "c" "d" ]
       => [ "c" "d" ]
       drop 2 [ ]
       => [ ]
  */
  drop =
    # Number of elements to drop
    count:
    # Input list
    list: sublist count (length list) list;

  /* Whether the first list is a prefix of the second list.

  Type: hasPrefix :: [a] -> [a] -> bool

  Example:
    hasPrefix [ 1 2 ] [ 1 2 3 4 ]
    => true
    hasPrefix [ 0 1 ] [ 1 2 3 4 ]
    => false
  */
  hasPrefix =
    list1:
    list2:
    take (length list1) list2 == list1;

  /* Return a list consisting of at most `count` elements of `list`,
     starting at index `start`.

     Type: sublist :: int -> int -> [a] -> [a]

     Example:
       sublist 1 3 [ "a" "b" "c" "d" "e" ]
       => [ "b" "c" "d" ]
       sublist 1 3 [ ]
       => [ ]
  */
  sublist =
    # Index at which to start the sublist
    start:
    # Number of elements to take
    count:
    # Input list
    list:
    let len = length list; in
    genList
      (n: elemAt list (n + start))
      (if start >= len then 0
       else if start + count > len then len - start
       else count);

  /* Return the last element of a list.

     This function throws an error if the list is empty.

     Type: last :: [a] -> a

     Example:
       last [ 1 2 3 ]
       => 3
  */
  last = list:
    assert lib.assertMsg (list != []) "lists.last: list must not be empty!";
    elemAt list (length list - 1);

  /* Return all elements but the last.

     This function throws an error if the list is empty.

     Type: init :: [a] -> [a]

     Example:
       init [ 1 2 3 ]
       => [ 1 2 ]
  */
  init = list:
    assert lib.assertMsg (list != []) "lists.init: list must not be empty!";
    take (length list - 1) list;


  /* Return the image of the cross product of some lists by a function.

    Example:
      crossLists (x:y: "${toString x}${toString y}") [[1 2] [3 4]]
      => [ "13" "14" "23" "24" ]
  */
  crossLists = builtins.trace
    "lib.crossLists is deprecated, use lib.cartesianProductOfSets instead"
    (f: foldl (fs: args: concatMap (f: map f args) fs) [f]);


  /* Remove duplicate elements from the list. O(n^2) complexity.

     Type: unique :: [a] -> [a]

     Example:
       unique [ 3 2 3 4 ]
       => [ 3 2 4 ]
   */
  unique = foldl' (acc: e: if elem e acc then acc else acc ++ [ e ]) [];

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

  /* Test if two lists have no common element.
     It should be slightly more efficient than (intersectLists a b == [])
  */
  mutuallyExclusive = a: b: length a == 0 || !(any (x: elem x a) b);

}
