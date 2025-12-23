# Tests in: ./tests/linked-lists.nix
/**
  Linked list operations.

  This library provides operations on linked lists of the form `{ head; tail; }`
  with `null` representing the empty list. These are useful for streaming operations
  and solving stack overflow issues with recursive algorithms that need to process
  large amounts of data.

  :::{.warning}
  These operations tend to be significantly slower than native lists,
  so they should only be used when necessary (e.g., to avoid stack overflow or
  for streaming use cases).
  :::

  A linked list is represented as either:
  - `null` for an empty list
  - `{ head; tail; }` where `head` is the first element and `tail` is the rest of the list
*/
{ lib }:

# Algorithmic insights:
#
# We use two main strategies to avoid stack overflow:
#
# 1. Tiered Binary Reduce (for processing list elements):
#    - Process the list in exponentially growing chunks: 1, 2, 4, 8, 16, ...
#    - Build a binary tree traversal from leaves to root without knowing length upfront
#    - Stack depth: O(log n) where n is list length
#    - Used by: `tieredBinaryReduce`, `length`, `toList`
#
# 2. Divide and Conquer (for operations where the size of the work is a known quantity):
#    - Split the work in half recursively
#    - Stack depth: O(log n) where n is the parameter value
#    - Used by: `drop`
#
# Functions like `map` and `take` don't need these strategies because they produce
# output cells lazily: each output cell triggers evaluation of at most a bounded number
# of input cells (at most 1 for these functions). This keeps the stack bounded.
# Similarly, a function like `zip` would be fine as it evaluates one cell from each
# of two input lists (not stacked). Grouping consecutive elements is also safe as
# each output cell evaluates at most a small constant number of input cells before
# returning from the stack.
# Safely evaluating the full result is the responsibility of the consumer!

rec {

  /**
    Convert a native Nix list (array) to a linked list.

    # Inputs

    `list`

    : A native Nix list to convert

    # Type

    ```
    fromList :: List a -> LinkedList a
    ```

    where `LinkedList a` is either `null` or `{ head :: a; tail :: LinkedList a; }`

    # Examples
    :::{.example}
    ## `lib.linkedLists.fromList` usage example

    ```nix
    fromList []
    => null

    fromList [ 1 ]
    => { head = 1; tail = null; }

    fromList [ 1 2 3 ]
    => { head = 1; tail = { head = 2; tail = { head = 3; tail = null; }; }; }
    ```

    :::
  */
  fromList =
    list:
    builtins.foldl' (acc: elem: {
      head = elem;
      tail = acc;
    }) null (lib.lists.reverseList list);

  /**
    Generic tiered binary reduce for linked lists.

    Uses exponentially growing chunks (1, 2, 4, 8, ...) to keep stack depth
    at O(log n). This builds a binary tree traversal from leaves to root
    without knowing the total length upfront.

    :::{.warning}
    The identity value is used O(log n) times (once per chunk), and
    the binary operation is called O(n + log n) times. This matters if
    either the identity or operation have side effects or are expensive.
    :::

    # Inputs

    `identity`

    : Identity/zero value for the binary operation

    `op`

    : Binary operation to combine values (left -> right -> combined)

    `linkedList`

    : A linked list of values to reduce

    # Type

    ```
    tieredBinaryReduce :: a -> (a -> a -> a) -> LinkedList a -> a
    ```

    # Examples
    :::{.example}
    ## `lib.linkedLists.tieredBinaryReduce` usage example

    ```nix
    tieredBinaryReduce 0 (a: b: a + b) (fromList [ 1 2 3 4 ])
    => 10

    tieredBinaryReduce 1 (a: b: a * b) (fromList [ 2 3 4 ])
    => 24
    ```

    :::
  */
  tieredBinaryReduce =
    identity: op: linkedList:
    let
      # Process chunks of exponentially growing size: 1, 2, 4, 8, ...
      # Returns { result = reduced value; rest = remaining list }
      processChunks =
        chunkSize: ll:
        if ll == null then
          {
            result = identity;
            rest = null;
          }
        else
          let
            # Reduce elements in this chunk using binary tree style
            reduceChunk =
              size: current:
              if size <= 0 || current == null then
                {
                  result = identity;
                  rest = current;
                }
              else if size == 1 then
                {
                  result = current.head;
                  rest = current.tail;
                }
              else
                let
                  half = size / 2;
                  leftResult = reduceChunk half current;
                  rightResult = reduceChunk (size - half) leftResult.rest;
                in
                {
                  result = op leftResult.result rightResult.result;
                  rest = rightResult.rest;
                };

            thisChunk = reduceChunk chunkSize ll;

            # Recursively process next chunk (double the size)
            nextResult = processChunks (chunkSize * 2) thisChunk.rest;
          in
          {
            result = op thisChunk.result nextResult.result;
            rest = nextResult.rest;
          };
    in
    (processChunks 1 linkedList).result;

  /**
    Get the length of a linked list.

    Uses a tiered binary reduce strategy to keep stack depth at O(log n).
    Processes the list in exponentially growing chunks (1, 2, 4, 8, ...),
    building a binary tree traversal from leaves to root without knowing
    the total length upfront.

    # Inputs

    `linkedList`

    : A linked list

    # Type

    ```
    length :: LinkedList a -> Int
    ```

    # Examples
    :::{.example}
    ## `lib.linkedLists.length` usage example

    ```nix
    length null
    => 0

    length (fromList [ 1 2 3 ])
    => 3
    ```

    :::
  */
  length = linkedList: tieredBinaryReduce 0 (a: b: a + b) (map (_: 1) linkedList);

  /**
    Map a function to operate on linked list elements.

    # Inputs

    `f`

    : Function to apply to each element

    `linkedList`

    : A linked list

    # Type

    ```
    map :: (a -> b) -> LinkedList a -> LinkedList b
    ```

    # Examples
    :::{.example}
    ## `lib.linkedLists.map` usage example

    ```nix
    map (x: x * 2) (fromList [ 1 2 3 ])
    => fromList [ 2 4 6 ]

    map (s: s + "!") (fromList [ "a" "b" ])
    => fromList [ "a!" "b!" ]
    ```

    :::
  */
  map =
    f: linkedList:
    if linkedList == null then
      null
    else
      {
        head = f linkedList.head;
        tail = map f linkedList.tail;
      };

  /**
    Drop the first n elements from a linked list.

    Uses a divide and conquer strategy to keep stack depth at O(log n)
    for large n values.

    # Inputs

    `n`

    : Number of elements to drop

    `linkedList`

    : A linked list

    # Type

    ```
    drop :: Int -> LinkedList a -> LinkedList a
    ```

    # Examples
    :::{.example}
    ## `lib.linkedLists.drop` usage example

    ```nix
    drop 0 (fromList [ 1 2 3 ])
    => fromList [ 1 2 3 ]

    drop 2 (fromList [ 1 2 3 4 5 ])
    => fromList [ 3 4 5 ]

    drop 5 (fromList [ 1 2 3 ])
    => null
    ```

    :::
  */
  drop =
    n: linkedList:
    if n <= 0 || linkedList == null then
      linkedList
    else if n == 1 then
      linkedList.tail
    else
      # Divide and conquer: drop half, then drop the remaining half
      let
        half = n / 2;
        afterHalf = drop half linkedList;
      in
      drop (n - half) afterHalf;

  /**
    Take the first n elements from a linked list.

    # Inputs

    `n`

    : Number of elements to take

    `linkedList`

    : A linked list

    # Type

    ```
    take :: Int -> LinkedList a -> LinkedList a
    ```

    # Examples
    :::{.example}
    ## `lib.linkedLists.take` usage example

    ```nix
    take 0 (fromList [ 1 2 3 ])
    => null

    take 2 (fromList [ 1 2 3 ])
    => { head = 1; tail = { head = 2; tail = null; }; }

    take 5 (fromList [ 1 2 3 ])
    => { head = 1; tail = { head = 2; tail = { head = 3; tail = null; }; }; }
    ```

    :::
  */
  take =
    n: linkedList:
    if n <= 0 || linkedList == null then
      null
    else
      {
        head = linkedList.head;
        tail = take (n - 1) linkedList.tail;
      };

  /**
    Convert a linked list to a native Nix list (array).

    Uses a tiered binary reduce strategy to keep stack depth at O(log n)
    for large lists.

    # Inputs

    `linkedList`

    : A linked list to convert (either `null` or `{ head; tail; }`)

    # Type

    ```
    toList :: LinkedList a -> List a
    ```

    where `LinkedList a` is either `null` or `{ head :: a; tail :: LinkedList a; }`

    # Examples
    :::{.example}
    ## `lib.linkedLists.toList` usage example

    ```nix
    toList null
    => []

    toList { head = 1; tail = null; }
    => [ 1 ]

    toList { head = 1; tail = { head = 2; tail = { head = 3; tail = null; }; }; }
    => [ 1 2 3 ]
    ```

    :::
  */
  toList = linkedList: tieredBinaryReduce [ ] (a: b: a ++ b) (map (x: [ x ]) linkedList);

}
