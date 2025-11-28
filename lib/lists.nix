/**
  General list operations.
*/
{ lib }:
let
  inherit (lib.strings) toInt;
  inherit (lib.trivial)
    compare
    min
    id
    warn
    pipe
    ;
  inherit (lib.attrsets) mapAttrs attrNames attrValues;
  inherit (lib) max;
in
rec {

  inherit (builtins)
    head
    tail
    length
    isList
    elemAt
    concatLists
    filter
    elem
    genList
    map
    ;

  /**
    Create a list consisting of a single element. `singleton x` is
    sometimes more convenient with respect to indentation than `[x]`
    when x spans multiple lines.

    # Inputs

    `x`

    : 1\. Function argument

    # Type

    ```
    singleton :: a -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.singleton` usage example

    ```nix
    singleton "foo"
    => [ "foo" ]
    ```

    :::
  */
  singleton = x: [ x ];

  /**
    Apply the function to each element in the list.
    Same as `map`, but arguments flipped.

    # Inputs

    `xs`

    : 1\. Function argument

    `f`

    : 2\. Function argument

    # Type

    ```
    forEach :: [a] -> (a -> b) -> [b]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.forEach` usage example

    ```nix
    forEach [ 1 2 ] (x:
      toString x
    )
    => [ "1" "2" ]
    ```

    :::
  */
  forEach = xs: f: map f xs;

  /**
    “right fold” a binary function `op` between successive elements of
    `list` with `nul` as the starting value, i.e.,
    `foldr op nul [x_1 x_2 ... x_n] == op x_1 (op x_2 ... (op x_n nul))`.

    # Inputs

    `op`

    : 1\. Function argument

    `nul`

    : 2\. Function argument

    `list`

    : 3\. Function argument

    # Type

    ```
    foldr :: (a -> b -> b) -> b -> [a] -> b
    ```

    # Examples
    :::{.example}
    ## `lib.lists.foldr` usage example

    ```nix
    concat = foldr (a: b: a + b) "z"
    concat [ "a" "b" "c" ]
    => "abcz"
    # different types
    strange = foldr (int: str: toString (int + 1) + str) "a"
    strange [ 1 2 3 4 ]
    => "2345a"
    ```

    :::
  */
  foldr =
    op: nul: list:
    let
      len = length list;
      fold' = n: if n == len then nul else op (elemAt list n) (fold' (n + 1));
    in
    fold' 0;

  /**
    `fold` is an alias of `foldr` for historic reasons
  */
  # FIXME(Profpatsch): deprecate?
  fold = foldr;

  /**
    “left fold”, like `foldr`, but from the left:

    `foldl op nul [x_1 x_2 ... x_n] == op (... (op (op nul x_1) x_2) ... x_n)`.

    # Inputs

    `op`

    : 1\. Function argument

    `nul`

    : 2\. Function argument

    `list`

    : 3\. Function argument

    # Type

    ```
    foldl :: (b -> a -> b) -> b -> [a] -> b
    ```

    # Examples
    :::{.example}
    ## `lib.lists.foldl` usage example

    ```nix
    lconcat = foldl (a: b: a + b) "z"
    lconcat [ "a" "b" "c" ]
    => "zabc"
    # different types
    lstrange = foldl (str: int: str + toString (int + 1)) "a"
    lstrange [ 1 2 3 4 ]
    => "a2345"
    ```

    :::
  */
  foldl =
    op: nul: list:
    let
      foldl' = n: if n == -1 then nul else op (foldl' (n - 1)) (elemAt list n);
    in
    foldl' (length list - 1);

  /**
    Reduce a list by applying a binary operator from left to right,
    starting with an initial accumulator.

    Before each application of the operator, the accumulator value is evaluated.
    This behavior makes this function stricter than [`foldl`](#function-library-lib.lists.foldl).

    Unlike [`builtins.foldl'`](https://nixos.org/manual/nix/unstable/language/builtins.html#builtins-foldl'),
    the initial accumulator argument is evaluated before the first iteration.

    A call like

    ```nix
    foldl' op acc₀ [ x₀ x₁ x₂ ... xₙ₋₁ xₙ ]
    ```

    is (denotationally) equivalent to the following,
    but with the added benefit that `foldl'` itself will never overflow the stack.

    ```nix
    let
      acc₁   = builtins.seq acc₀   (op acc₀   x₀  );
      acc₂   = builtins.seq acc₁   (op acc₁   x₁  );
      acc₃   = builtins.seq acc₂   (op acc₂   x₂  );
      ...
      accₙ   = builtins.seq accₙ₋₁ (op accₙ₋₁ xₙ₋₁);
      accₙ₊₁ = builtins.seq accₙ   (op accₙ   xₙ  );
    in
    accₙ₊₁

    # Or ignoring builtins.seq
    op (op (... (op (op (op acc₀ x₀) x₁) x₂) ...) xₙ₋₁) xₙ
    ```

    # Inputs

    `op`

    : The binary operation to run, where the two arguments are:

    1. `acc`: The current accumulator value: Either the initial one for the first iteration, or the result of the previous iteration
    2. `x`: The corresponding list element for this iteration

    `acc`

    : The initial accumulator value.

      The accumulator value is evaluated in any case before the first iteration starts.

      To avoid evaluation even before the `list` argument is given an eta expansion can be used:

      ```nix
      list: lib.foldl' op acc list
      ```

    `list`

    : The list to fold

    # Type

    ```
    foldl' :: (acc -> x -> acc) -> acc -> [x] -> acc
    ```

    # Examples
    :::{.example}
    ## `lib.lists.foldl'` usage example

    ```nix
    foldl' (acc: x: acc + x) 0 [1 2 3]
    => 6
    ```

    :::
  */
  foldl' =
    op: acc:
    # The builtin `foldl'` is a bit lazier than one might expect.
    # See https://github.com/NixOS/nix/pull/7158.
    # In particular, the initial accumulator value is not forced before the first iteration starts.
    builtins.seq acc (builtins.foldl' op acc);

  /**
    Map with index starting from 0

    # Inputs

    `f`

    : 1\. Function argument

    `list`

    : 2\. Function argument

    # Type

    ```
    imap0 :: (int -> a -> b) -> [a] -> [b]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.imap0` usage example

    ```nix
    imap0 (i: v: "${v}-${toString i}") ["a" "b"]
    => [ "a-0" "b-1" ]
    ```

    :::
  */
  imap0 = f: list: genList (n: f n (elemAt list n)) (length list);

  /**
    Map with index starting from 1

    # Inputs

    `f`

    : 1\. Function argument

    `list`

    : 2\. Function argument

    # Type

    ```
    imap1 :: (int -> a -> b) -> [a] -> [b]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.imap1` usage example

    ```nix
    imap1 (i: v: "${v}-${toString i}") ["a" "b"]
    => [ "a-1" "b-2" ]
    ```

    :::
  */
  imap1 = f: list: genList (n: f (n + 1) (elemAt list n)) (length list);

  /**
    Filter a list for elements that satisfy a predicate function.
    The predicate function is called with both the index and value for each element.
    It must return `true`/`false` to include/exclude a given element in the result.
    This function is strict in the result of the predicate function for each element.
    This function has O(n) complexity.

    Also see [`builtins.filter`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-filter) (available as `lib.lists.filter`),
    which can be used instead when the index isn't needed.

    # Inputs

    `ipred`

    : The predicate function, it takes two arguments:
      - 1. (int): the index of the element.
      - 2. (a): the value of the element.

      It must return `true`/`false` to include/exclude a given element from the result.

    `list`

    : The list to filter using the predicate.

    # Type
    ```
    ifilter0 :: (int -> a -> bool) -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.ifilter0` usage example

    ```nix
    ifilter0 (i: v: i == 0 || v > 2) [ 1 2 3 ]
    => [ 1 3 ]
    ```
    :::
  */
  ifilter0 =
    ipred: input:
    map (idx: elemAt input idx) (
      filter (idx: ipred idx (elemAt input idx)) (genList (x: x) (length input))
    );

  /**
    Map and concatenate the result.

    # Type

    ```
    concatMap :: (a -> [b]) -> [a] -> [b]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.concatMap` usage example

    ```nix
    concatMap (x: [x] ++ ["z"]) ["a" "b"]
    => [ "a" "z" "b" "z" ]
    ```

    :::
  */
  concatMap = builtins.concatMap;

  /**
    Flatten the argument into a single list; that is, nested lists are
    spliced into the top-level lists.

    # Inputs

    `x`

    : 1\. Function argument

    # Examples
    :::{.example}
    ## `lib.lists.flatten` usage example

    ```nix
    flatten [1 [2 [3] 4] 5]
    => [1 2 3 4 5]
    flatten 1
    => [1]
    ```

    :::
  */
  flatten = x: if isList x then concatMap (y: flatten y) x else [ x ];

  /**
    Remove elements equal to 'e' from a list.  Useful for buildInputs.

    # Inputs

    `e`

    : Element to remove from `list`

    `list`

    : The list

    # Type

    ```
    remove :: a -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.remove` usage example

    ```nix
    remove 3 [ 1 3 4 3 ]
    => [ 1 4 ]
    ```

    :::
  */
  remove = e: filter (x: x != e);

  /**
    Find the sole element in the list matching the specified
    predicate.

    Returns `default` if no such element exists, or
    `multiple` if there are multiple matching elements.

    # Inputs

    `pred`

    : Predicate

    `default`

    : Default value to return if element was not found.

    `multiple`

    : Default value to return if more than one element was found

    `list`

    : Input list

    # Type

    ```
    findSingle :: (a -> bool) -> a -> a -> [a] -> a
    ```

    # Examples
    :::{.example}
    ## `lib.lists.findSingle` usage example

    ```nix
    findSingle (x: x == 3) "none" "multiple" [ 1 3 3 ]
    => "multiple"
    findSingle (x: x == 3) "none" "multiple" [ 1 3 ]
    => 3
    findSingle (x: x == 3) "none" "multiple" [ 1 9 ]
    => "none"
    ```

    :::
  */
  findSingle =
    pred: default: multiple: list:
    let
      found = filter pred list;
      len = length found;
    in
    if len == 0 then
      default
    else if len != 1 then
      multiple
    else
      head found;

  /**
    Find the first index in the list matching the specified
    predicate or return `default` if no such element exists.

    # Inputs

    `pred`

    : Predicate

    `default`

    : Default value to return

    `list`

    : Input list

    # Type

    ```
    findFirstIndex :: (a -> Bool) -> b -> [a] -> (Int | b)
    ```

    # Examples
    :::{.example}
    ## `lib.lists.findFirstIndex` usage example

    ```nix
    findFirstIndex (x: x > 3) null [ 0 6 4 ]
    => 1
    findFirstIndex (x: x > 9) null [ 0 6 4 ]
    => null
    ```

    :::
  */
  findFirstIndex =
    pred: default: list:
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
      resultIndex = foldl' (
        index: el:
        if index < 0 then
          # No match yet before the current index, we need to check the element
          if pred el then
            # We have a match! Turn it into the actual index to prevent future iterations from modifying it
            -index - 1
          else
            # Still no match, update the index to the next element (we're counting down, so minus one)
            index - 1
        else
          # There's already a match, propagate the index without evaluating anything
          index
      ) (-1) list;
    in
    if resultIndex < 0 then default else resultIndex;

  /**
    Find the first element in the list matching the specified
    predicate or return `default` if no such element exists.

    # Inputs

    `pred`

    : Predicate

    `default`

    : Default value to return

    `list`

    : Input list

    # Type

    ```
    findFirst :: (a -> bool) -> a -> [a] -> a
    ```

    # Examples
    :::{.example}
    ## `lib.lists.findFirst` usage example

    ```nix
    findFirst (x: x > 3) 7 [ 1 6 4 ]
    => 6
    findFirst (x: x > 9) 7 [ 1 6 4 ]
    => 7
    ```

    :::
  */
  findFirst =
    pred: default: list:
    let
      index = findFirstIndex pred null list;
    in
    if index == null then default else elemAt list index;

  /**
    Returns true if function `pred` returns true for at least one
    element of `list`.

    # Inputs

    `pred`

    : Predicate

    `list`

    : Input list

    # Type

    ```
    any :: (a -> bool) -> [a] -> bool
    ```

    # Examples
    :::{.example}
    ## `lib.lists.any` usage example

    ```nix
    any isString [ 1 "a" { } ]
    => true
    any isString [ 1 { } ]
    => false
    ```

    :::
  */
  any = builtins.any;

  /**
    Returns true if function `pred` returns true for all elements of
    `list`.

    # Inputs

    `pred`

    : Predicate

    `list`

    : Input list

    # Type

    ```
    all :: (a -> bool) -> [a] -> bool
    ```

    # Examples
    :::{.example}
    ## `lib.lists.all` usage example

    ```nix
    all (x: x < 3) [ 1 2 ]
    => true
    all (x: x < 3) [ 1 2 3 ]
    => false
    ```

    :::
  */
  all = builtins.all;

  /**
    Count how many elements of `list` match the supplied predicate
    function.

    # Inputs

    `pred`

    : Predicate

    # Type

    ```
    count :: (a -> bool) -> [a] -> int
    ```

    # Examples
    :::{.example}
    ## `lib.lists.count` usage example

    ```nix
    count (x: x == 3) [ 3 2 3 4 6 ]
    => 2
    ```

    :::
  */
  count = pred: foldl' (c: x: if pred x then c + 1 else c) 0;

  /**
    Return a singleton list or an empty list, depending on a boolean
    value.  Useful when building lists with optional elements
    (e.g. `++ optional (system == "i686-linux") firefox`).

    # Inputs

    `cond`

    : 1\. Function argument

    `elem`

    : 2\. Function argument

    # Type

    ```
    optional :: bool -> a -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.optional` usage example

    ```nix
    optional true "foo"
    => [ "foo" ]
    optional false "foo"
    => [ ]
    ```

    :::
  */
  optional = cond: elem: if cond then [ elem ] else [ ];

  /**
    Returns a list or an empty list, depending on a boolean value.

    # Inputs

    `cond`

    : Condition

    `elems`

    : List to return if condition is true

    # Type

    ```
    optionals :: bool -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.optionals` usage example

    ```nix
    optionals true [ 2 3 ]
    => [ 2 3 ]
    optionals false [ 2 3 ]
    => [ ]
    ```

    :::
  */
  optionals = cond: elems: if cond then elems else [ ];

  /**
    If argument is a list, return it; else, wrap it in a singleton
    list. If you're using this, you should almost certainly
    reconsider if there isn't a more "well-typed" approach.

    # Inputs

    `x`

    : 1\. Function argument

    # Examples
    :::{.example}
    ## `lib.lists.toList` usage example

    ```nix
    toList [ 1 2 ]
    => [ 1 2 ]
    toList "hi"
    => [ "hi" ]
    ```

    :::
  */
  toList = x: if isList x then x else [ x ];

  /**
    Returns a list of integers from `first` up to and including `last`.

    # Inputs

    `first`

    : First integer in the range

    `last`

    : Last integer in the range

    # Type

    ```
    range :: int -> int -> [int]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.range` usage example

    ```nix
    range 2 4
    => [ 2 3 4 ]
    range 3 2
    => [ ]
    ```

    :::
  */
  range = first: last: if first > last then [ ] else genList (n: first + n) (last - first + 1);

  /**
    Returns a list with `n` copies of an element.

    # Inputs

    `n`

    : 1\. Function argument

    `elem`

    : 2\. Function argument

    # Type

    ```
    replicate :: int -> a -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.replicate` usage example

    ```nix
    replicate 3 "a"
    => [ "a" "a" "a" ]
    replicate 2 true
    => [ true true ]
    ```

    :::
  */
  replicate = n: elem: genList (_: elem) n;

  /**
    Splits the elements of a list in two lists, `right` and
    `wrong`, depending on the evaluation of a predicate.

    # Inputs

    `pred`

    : Predicate

    `list`

    : Input list

    # Type

    ```
    (a -> bool) -> [a] -> { right :: [a]; wrong :: [a]; }
    ```

    # Examples
    :::{.example}
    ## `lib.lists.partition` usage example

    ```nix
    partition (x: x > 2) [ 5 1 2 3 4 ]
    => { right = [ 5 3 4 ]; wrong = [ 1 2 ]; }
    ```

    :::
  */
  partition = builtins.partition;

  /**
    Splits the elements of a list into many lists, using the return value of a predicate.
    Predicate should return a string which becomes keys of attrset `groupBy` returns.
    `groupBy'` allows to customise the combining function and initial value

    # Inputs

    `op`

    : 1\. Function argument

    `nul`

    : 2\. Function argument

    `pred`

    : 3\. Function argument

    `lst`

    : 4\. Function argument

    # Examples
    :::{.example}
    ## `lib.lists.groupBy'` usage example

    ```nix
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
    ```

    :::
  */
  groupBy' =
    op: nul: pred: lst:
    mapAttrs (name: foldl op nul) (groupBy pred lst);

  groupBy =
    builtins.groupBy or (
      pred:
      foldl' (
        r: e:
        let
          key = pred e;
        in
        r // { ${key} = (r.${key} or [ ]) ++ [ e ]; }
      ) { }
    );

  /**
    Merges two lists of the same size together. If the sizes aren't the same
    the merging stops at the shortest. How both lists are merged is defined
    by the first argument.

    # Inputs

    `f`

    : Function to zip elements of both lists

    `fst`

    : First list

    `snd`

    : Second list

    # Type

    ```
    zipListsWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.zipListsWith` usage example

    ```nix
    zipListsWith (a: b: a + b) ["h" "l"] ["e" "o"]
    => ["he" "lo"]
    ```

    :::
  */
  zipListsWith =
    f: fst: snd:
    genList (n: f (elemAt fst n) (elemAt snd n)) (min (length fst) (length snd));

  /**
    Merges two lists of the same size together. If the sizes aren't the same
    the merging stops at the shortest.

    # Inputs

    `fst`

    : First list

    `snd`

    : Second list

    # Type

    ```
    zipLists :: [a] -> [b] -> [{ fst :: a; snd :: b; }]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.zipLists` usage example

    ```nix
    zipLists [ 1 2 ] [ "a" "b" ]
    => [ { fst = 1; snd = "a"; } { fst = 2; snd = "b"; } ]
    ```

    :::
  */
  zipLists = zipListsWith (fst: snd: { inherit fst snd; });

  /**
    Reverse the order of the elements of a list.

    # Inputs

    `xs`

    : 1\. Function argument

    # Type

    ```
    reverseList :: [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.reverseList` usage example

    ```nix
    reverseList [ "b" "o" "j" ]
    => [ "j" "o" "b" ]
    ```

    :::
  */
  reverseList =
    xs:
    let
      l = length xs;
    in
    genList (n: elemAt xs (l - n - 1)) l;

  /**
    Depth-First Search (DFS) for lists `list != []`.

    `before a b == true` means that `b` depends on `a` (there's an
    edge from `b` to `a`).

    # Inputs

    `stopOnCycles`

    : 1\. Function argument

    `before`

    : 2\. Function argument

    `list`

    : 3\. Function argument

    # Examples
    :::{.example}
    ## `lib.lists.listDfs` usage example

    ```nix
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
    ```

    :::
  */
  listDfs =
    stopOnCycles: before: list:
    let
      dfs' =
        us: visited: rest:
        let
          c = filter (x: before x us) visited;
          b = partition (x: before x us) rest;
        in
        if stopOnCycles && (length c > 0) then
          {
            cycle = us;
            loops = c;
            inherit visited rest;
          }
        else if length b.right == 0 then
          # nothing is before us
          {
            minimal = us;
            inherit visited rest;
          }
        else
          # grab the first one before us and continue
          dfs' (head b.right) ([ us ] ++ visited) (tail b.right ++ b.wrong);
    in
    dfs' (head list) [ ] (tail list);

  /**
    Sort a list based on a partial ordering using DFS. This
    implementation is O(N^2), if your ordering is linear, use `sort`
    instead.

    `before a b == true` means that `b` should be after `a`
    in the result.

    # Inputs

    `before`

    : 1\. Function argument

    `list`

    : 2\. Function argument

    # Examples
    :::{.example}
    ## `lib.lists.toposort` usage example

    ```nix
    toposort hasPrefix [ "/home/user" "other" "/" "/home" ]
      == { result = [ "/" "/home" "/home/user" "other" ]; }

    toposort hasPrefix [ "/home/user" "other" "/" "/home" "/" ]
      == { cycle = [ "/home/user" "/" "/" ]; # path leading to a cycle
           loops = [ "/" ]; }                # loops back to these elements

    toposort hasPrefix [ "other" "/home/user" "/home" "/" ]
      == { result = [ "other" "/" "/home" "/home/user" ]; }

    toposort (a: b: a < b) [ 3 2 1 ] == { result = [ 1 2 3 ]; }
    ```

    :::
  */
  toposort =
    before: list:
    let
      dfsthis = listDfs true before list;
      toporest = toposort before (dfsthis.visited ++ dfsthis.rest);
    in
    if length list < 2 then
      # finish
      { result = list; }
    else if dfsthis ? cycle then
      # there's a cycle, starting from the current vertex, return it
      {
        cycle = reverseList ([ dfsthis.cycle ] ++ dfsthis.visited);
        inherit (dfsthis) loops;
      }
    else if toporest ? cycle then
      # there's a cycle somewhere else in the graph, return it
      toporest
    # Slow, but short. Can be made a bit faster with an explicit stack.
    else
      # there are no cycles
      { result = [ dfsthis.minimal ] ++ toporest.result; };

  /**
    Sort a list based on a comparator function which compares two
    elements and returns true if the first argument is strictly below
    the second argument.  The returned list is sorted in an increasing
    order.  The implementation does a quick-sort.

    See also [`sortOn`](#function-library-lib.lists.sortOn), which applies the
    default comparison on a function-derived property, and may be more efficient.

    # Inputs

    `comparator`

    : 1\. Function argument

    `list`

    : 2\. Function argument

    # Type

    ```
    sort :: (a -> a -> Bool) -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.sort` usage example

    ```nix
    sort (p: q: p < q) [ 5 3 7 ]
    => [ 3 5 7 ]
    ```

    :::
  */
  sort = builtins.sort;

  /**
    Sort a list based on the default comparison of a derived property `b`.

    The items are returned in `b`-increasing order.

    **Performance**:

    The passed function `f` is only evaluated once per item,
    unlike an unprepared [`sort`](#function-library-lib.lists.sort) using
    `f p < f q`.

    **Laws**:
    ```nix
    sortOn f == sort (p: q: f p < f q)
    ```

    # Inputs

    `f`

    : 1\. Function argument

    `list`

    : 2\. Function argument

    # Type

    ```
    sortOn :: (a -> b) -> [a] -> [a], for comparable b
    ```

    # Examples
    :::{.example}
    ## `lib.lists.sortOn` usage example

    ```nix
    sortOn stringLength [ "aa" "b" "cccc" ]
    => [ "b" "aa" "cccc" ]
    ```

    :::
  */
  sortOn =
    f: list:
    let
      # Heterogenous list as pair may be ugly, but requires minimal allocations.
      pairs = map (x: [
        (f x)
        x
      ]) list;
    in
    map (x: builtins.elemAt x 1) (
      sort
        # Compare the first element of the pairs
        # Do not factor out the `<`, to avoid calls in hot code; duplicate instead.
        (a: b: head a < head b)
        pairs
    );

  /**
    Compare two lists element-by-element with a comparison function `cmp`.

    List elements are compared pairwise in order by the provided comparison function `cmp`,
    the first non-equal pair of elements determines the result.

    :::{.note}
    The `<` operator can also be used to compare lists using a boolean condition. (e.g. `[1 2] < [1 3]` is `true`).
    See also [language operators](https://nix.dev/manual/nix/stable/language/operators#comparison) for more information.
    :::

    # Inputs

    `cmp`

    : The comparison function `a: b: ...` must return:
      - `0` if `a` and `b` are equal
      - `1` if `a` is greater than `b`
      - `-1` if `a` is less than `b`

      See [lib.compare](#function-library-lib.trivial.compare) for a an example implementation.

    `a`

    : The first list

    `b`

    : The second list

    # Examples
    :::{.example}
    ## `lib.lists.compareLists` usage examples

    ```nix
    compareLists lib.compare [] []
    => 0
    compareLists lib.compare [] [ "a" ]
    => -1
    compareLists lib.compare [ "a" ] []
    => 1
    compareLists lib.compare [ "a" "b" ] [ "a" "c" ]
    => -1
    ```

    :::
  */
  compareLists =
    cmp: a: b:
    if a == [ ] then
      if b == [ ] then 0 else -1
    else if b == [ ] then
      1
    else
      let
        rel = cmp (head a) (head b);
      in
      if rel == 0 then compareLists cmp (tail a) (tail b) else rel;

  /**
    Sort list using "Natural sorting".
    Numeric portions of strings are sorted in numeric order.

    # Inputs

    `lst`

    : 1\. Function argument

    # Examples
    :::{.example}
    ## `lib.lists.naturalSort` usage example

    ```nix
    naturalSort ["disk11" "disk8" "disk100" "disk9"]
    => ["disk8" "disk9" "disk11" "disk100"]
    naturalSort ["10.46.133.149" "10.5.16.62" "10.54.16.25"]
    => ["10.5.16.62" "10.46.133.149" "10.54.16.25"]
    naturalSort ["v0.2" "v0.15" "v0.0.9"]
    => [ "v0.0.9" "v0.2" "v0.15" ]
    ```

    :::
  */
  naturalSort =
    lst:
    let
      vectorise = s: map (x: if isList x then toInt (head x) else x) (builtins.split "(0|[1-9][0-9]*)" s);
      prepared = map (x: [
        (vectorise x)
        x
      ]) lst; # remember vectorised version for O(n) regex splits
      less = a: b: (compareLists compare (head a) (head b)) < 0;
    in
    map (x: elemAt x 1) (sort less prepared);

  /**
    Returns the first (at most) N elements of a list.

    # Inputs

    `count`

    : Number of elements to take

    `list`

    : Input list

    # Type

    ```
    take :: int -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.take` usage example

    ```nix
    take 2 [ "a" "b" "c" "d" ]
    => [ "a" "b" ]
    take 2 [ ]
    => [ ]
    ```

    :::
  */
  take = count: sublist 0 count;

  /**
    Returns the last (at most) N elements of a list.

    # Inputs

    `count`

    : Maximum number of elements to pick

    `list`

    : Input list

    # Type

    ```
    takeEnd :: int -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.takeEnd` usage example

    ```nix
    takeEnd 2 [ "a" "b" "c" "d" ]
    => [ "c" "d" ]
    takeEnd 2 [ ]
    => [ ]
    ```

    :::
  */
  takeEnd = n: xs: drop (max 0 (length xs - n)) xs;

  /**
    Remove the first (at most) N elements of a list.

    # Inputs

    `count`

    : Number of elements to drop

    `list`

    : Input list

    # Type

    ```
    drop :: int -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.drop` usage example

    ```nix
    drop 2 [ "a" "b" "c" "d" ]
    => [ "c" "d" ]
    drop 2 [ ]
    => [ ]
    ```

    :::
  */
  drop = count: list: sublist count (length list) list;

  /**
    Remove the last (at most) N elements of a list.

    # Inputs

    `count`

    : Number of elements to drop

    `list`

    : Input list

    # Type

    ```
    dropEnd :: Int -> [a] -> [a]
    ```

    # Examples

    :::{.example}
    ## `lib.lists.dropEnd` usage example

    ```nix
      dropEnd 2 [ "a" "b" "c" "d" ]
      => [ "a" "b" ]
      dropEnd 2 [ ]
      => [ ]
    ```
    :::
  */
  dropEnd = n: xs: take (max 0 (length xs - n)) xs;

  /**
    Whether the first list is a prefix of the second list.

    # Inputs

    `list1`

    : 1\. Function argument

    `list2`

    : 2\. Function argument

    # Type

    ```
    hasPrefix :: [a] -> [a] -> bool
    ```

    # Examples
    :::{.example}
    ## `lib.lists.hasPrefix` usage example

    ```nix
    hasPrefix [ 1 2 ] [ 1 2 3 4 ]
    => true
    hasPrefix [ 0 1 ] [ 1 2 3 4 ]
    => false
    ```

    :::
  */
  hasPrefix = list1: list2: take (length list1) list2 == list1;

  /**
    Remove the first list as a prefix from the second list.
    Error if the first list isn't a prefix of the second list.

    # Inputs

    `list1`

    : 1\. Function argument

    `list2`

    : 2\. Function argument

    # Type

    ```
    removePrefix :: [a] -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.removePrefix` usage example

    ```nix
    removePrefix [ 1 2 ] [ 1 2 3 4 ]
    => [ 3 4 ]
    removePrefix [ 0 1 ] [ 1 2 3 4 ]
    => <error>
    ```

    :::
  */
  removePrefix =
    list1: list2:
    if hasPrefix list1 list2 then
      drop (length list1) list2
    else
      throw "lib.lists.removePrefix: First argument is not a list prefix of the second argument";

  /**
    Returns a list consisting of at most `count` elements of `list`,
    starting at index `start`.

    # Inputs

    `start`

    : Index at which to start the sublist

    `count`

    : Number of elements to take

    `list`

    : Input list

    # Type

    ```
    sublist :: int -> int -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.sublist` usage example

    ```nix
    sublist 1 3 [ "a" "b" "c" "d" "e" ]
    => [ "b" "c" "d" ]
    sublist 1 3 [ ]
    => [ ]
    ```

    :::
  */
  sublist =
    start: count: list:
    let
      len = length list;
    in
    genList (n: elemAt list (n + start)) (
      if start >= len then
        0
      else if start + count > len then
        len - start
      else
        count
    );

  /**
    The common prefix of two lists.

    # Inputs

    `list1`

    : 1\. Function argument

    `list2`

    : 2\. Function argument

    # Type

    ```
    commonPrefix :: [a] -> [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.commonPrefix` usage example

    ```nix
    commonPrefix [ 1 2 3 4 5 6 ] [ 1 2 4 8 ]
    => [ 1 2 ]
    commonPrefix [ 1 2 3 ] [ 1 2 3 4 5 ]
    => [ 1 2 3 ]
    commonPrefix [ 1 2 3 ] [ 4 5 6 ]
    => [ ]
    ```

    :::
  */
  commonPrefix =
    list1: list2:
    let
      # Zip the lists together into a list of booleans whether each element matches
      matchings = zipListsWith (fst: snd: fst != snd) list1 list2;
      # Find the first index where the elements don't match,
      # which will then also be the length of the common prefix.
      # If all elements match, we fall back to the length of the zipped list,
      # which is the same as the length of the smaller list.
      commonPrefixLength = findFirstIndex id (length matchings) matchings;
    in
    take commonPrefixLength list1;

  /**
    Returns the last element of a list.

    This function throws an error if the list is empty.

    # Inputs

    `list`

    : 1\. Function argument

    # Type

    ```
    last :: [a] -> a
    ```

    # Examples
    :::{.example}
    ## `lib.lists.last` usage example

    ```nix
    last [ 1 2 3 ]
    => 3
    ```

    :::
  */
  last =
    list:
    assert lib.assertMsg (list != [ ]) "lists.last: list must not be empty!";
    elemAt list (length list - 1);

  /**
    Returns all elements but the last.

    This function throws an error if the list is empty.

    # Inputs

    `list`

    : 1\. Function argument

    # Type

    ```
    init :: [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.init` usage example

    ```nix
    init [ 1 2 3 ]
    => [ 1 2 ]
    ```

    :::
  */
  init =
    list:
    assert lib.assertMsg (list != [ ]) "lists.init: list must not be empty!";
    take (length list - 1) list;

  /**
    Returns the image of the cross product of some lists by a function.

    # Examples
    :::{.example}
    ## `lib.lists.crossLists` usage example

    ```nix
    crossLists (x: y: "${toString x}${toString y}") [[1 2] [3 4]]
    => [ "13" "14" "23" "24" ]
    ```

    If you have an attrset already, consider mapCartesianProduct:

    ```nix
    mapCartesianProduct (x: "${toString x.a}${toString x.b}") { a = [1 2]; b = [3 4]; }
    => [ "13" "14" "23" "24" ]
    ```
    :::
  */
  crossLists = f: foldl (fs: args: concatMap (f: map f args) fs) [ f ];

  /**
    Remove duplicate elements from the `list`. O(n^2) complexity.

    :::{.note}
    If the list only contains strings and order is not important, the complexity can be reduced to O(n log n) by using [`lib.lists.uniqueStrings`](#function-library-lib.lists.uniqueStrings) instead.
    :::

    # Inputs

    `list`

    : Input list

    # Type

    ```
    unique :: [a] -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.unique` usage example

    ```nix
    unique [ 3 2 3 4 ]
    => [ 3 2 4 ]
    ```

    :::
  */
  unique = foldl' (acc: e: if elem e acc then acc else acc ++ [ e ]) [ ];

  /**
    Removes duplicate strings from the `list`. O(n log n) complexity.

    :::{.note}
    Order is not preserved.

    All elements of the list must be strings without context.

    This function fails when the list contains a non-string element or a [string with context](https://nix.dev/manual/nix/latest/language/string-context.html).
    In that case use [`lib.lists.unique`](#function-library-lib.lists.unique) instead.
    :::

    # Inputs

    `list`

    : List of strings

    # Type

    ```
    uniqueStrings :: [ String ] -> [ String ]
    ```

    # Examples
    :::{.example}
    ## `lib.lists.uniqueStrings` usage example

    ```nix
    uniqueStrings [ "foo" "bar" "foo" ]
    => [ "bar" "foo" ] # order is not preserved
    ```

    :::
  */
  uniqueStrings = list: attrNames (groupBy id list);

  /**
    Check if list contains only unique elements. O(n^2) complexity.

    # Inputs

    `list`

    : 1\. Function argument

    # Type

    ```
    allUnique :: [a] -> bool
    ```

    # Examples
    :::{.example}
    ## `lib.lists.allUnique` usage example

    ```nix
    allUnique [ 3 2 3 4 ]
    => false
    allUnique [ 3 2 4 1 ]
    => true
    ```

    :::
  */
  allUnique = list: (length (unique list) == length list);

  /**
    Intersects list 'list1' and another list (`list2`).

    O(nm) complexity.

    # Inputs

    `list1`

    : First list

    `list2`

    : Second list

    # Examples
    :::{.example}
    ## `lib.lists.intersectLists` usage example

    ```nix
    intersectLists [ 1 2 3 ] [ 6 3 2 ]
    => [ 3 2 ]
    ```

    :::
  */
  intersectLists = e: filter (x: elem x e);

  /**
    Subtracts list 'e' from another list (`list2`).

    O(nm) complexity.

    # Inputs

    `e`

    : First list

    `list2`

    : Second list

    # Examples
    :::{.example}
    ## `lib.lists.subtractLists` usage example

    ```nix
    subtractLists [ 3 2 ] [ 1 2 3 4 5 3 ]
    => [ 1 4 5 ]
    ```

    :::
  */
  subtractLists = e: filter (x: !(elem x e));

  /**
    Test if two lists have no common element.
    It should be slightly more efficient than (intersectLists a b == [])

    # Inputs

    `a`

    : 1\. Function argument

    `b`

    : 2\. Function argument
  */
  mutuallyExclusive = a: b: length a == 0 || !(any (x: elem x a) b);

  /**
    Concatenate all attributes of an attribute set.
    This assumes that every attribute of the set is a list.

    # Inputs

    `set`

    : Attribute set with attributes that are lists

    # Examples
    :::{.example}
    ## `lib.concatAttrValues` usage example

    ```nix
    concatAttrValues { a = [ 1 2 ]; b = [ 3 ]; }
    => [ 1 2 3 ]
    ```

    :::
  */
  concatAttrValues = set: concatLists (attrValues set);
}
