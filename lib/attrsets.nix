/**
  Operations on attribute sets.
*/
{ lib }:

let
  inherit (builtins) head length typeOf;
  inherit (lib.asserts) assertMsg;
  inherit (lib.trivial) oldestSupportedReleaseIsAtLeast mergeAttrs;
  inherit (lib.strings)
    concatStringsSep
    concatMapStringsSep
    escapeNixIdentifier
    sanitizeDerivationName
    ;
  inherit (lib.lists)
    filter
    foldr
    foldl'
    concatMap
    elemAt
    all
    partition
    groupBy
    take
    foldl
    ;
in

rec {
  inherit (builtins)
    attrNames
    listToAttrs
    hasAttr
    isAttrs
    getAttr
    removeAttrs
    intersectAttrs
    ;

  /**
    Returns an attribute from nested attribute sets.

    Nix has an [attribute selection operator `.`](https://nixos.org/manual/nix/stable/language/operators#attribute-selection) which is sufficient for such queries, as long as the number of attributes is static. For example:

    ```nix
    (x.a.b or 6) == attrByPath ["a" "b"] 6 x
    # and
    (x.${f p}."example.com" or 6) == attrByPath [ (f p) "example.com" ] 6 x
    ```

    # Inputs

    `attrPath`

    : A list of strings representing the attribute path to return from `set`

    `default`

    : Default value if `attrPath` does not resolve to an existing value

    `set`

    : The nested attribute set to select values from

    # Type

    ```
    attrByPath :: [String] -> Any -> AttrSet -> Any
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.attrByPath` usage example

    ```nix
    x = { a = { b = 3; }; }
    # ["a" "b"] is equivalent to x.a.b
    # 6 is a default value to return if the path does not exist in attrset
    attrByPath ["a" "b"] 6 x
    => 3
    attrByPath ["z" "z"] 6 x
    => 6
    ```

    :::
  */
  attrByPath =
    attrPath: default: set:
    let
      lenAttrPath = length attrPath;
      attrByPath' =
        n: s:
        (
          if n == lenAttrPath then
            s
          else
            (
              let
                attr = elemAt attrPath n;
              in
              if s ? ${attr} then attrByPath' (n + 1) s.${attr} else default
            )
        );
    in
    attrByPath' 0 set;

  /**
    Returns if an attribute from nested attribute set exists.

    Nix has a [has attribute operator `?`](https://nixos.org/manual/nix/stable/language/operators#has-attribute), which is sufficient for such queries, as long as the number of attributes is static. For example:

    ```nix
    (x?a.b) == hasAttrByPath ["a" "b"] x
    # and
    (x?${f p}."example.com") == hasAttrByPath [ (f p) "example.com" ] x
    ```

    **Laws**:
     1.  ```nix
         hasAttrByPath [] x == true
         ```

    # Inputs

    `attrPath`

    : A list of strings representing the attribute path to check from `set`

    `e`

    : The nested attribute set to check

    # Type

    ```
    hasAttrByPath :: [String] -> AttrSet -> Bool
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.hasAttrByPath` usage example

    ```nix
    x = { a = { b = 3; }; }
    hasAttrByPath ["a" "b"] x
    => true
    hasAttrByPath ["z" "z"] x
    => false
    hasAttrByPath [] (throw "no need")
    => true
    ```

    :::
  */
  hasAttrByPath =
    attrPath: e:
    let
      lenAttrPath = length attrPath;
      hasAttrByPath' =
        n: s:
        (
          n == lenAttrPath
          || (
            let
              attr = elemAt attrPath n;
            in
            if s ? ${attr} then hasAttrByPath' (n + 1) s.${attr} else false
          )
        );
    in
    hasAttrByPath' 0 e;

  /**
    Returns the longest prefix of an attribute path that refers to an existing attribute in a nesting of attribute sets.

    Can be used after [`mapAttrsRecursiveCond`](#function-library-lib.attrsets.mapAttrsRecursiveCond) to apply a condition,
    although this will evaluate the predicate function on sibling attributes as well.

    Note that the empty attribute path is valid for all values, so this function only throws an exception if any of its inputs does.

    **Laws**:
    1.  ```nix
        attrsets.longestValidPathPrefix [] x == []
        ```

    2.  ```nix
        hasAttrByPath (attrsets.longestValidPathPrefix p x) x == true
        ```

    # Inputs

    `attrPath`

    : A list of strings representing the longest possible path that may be returned.

    `v`

    : The nested attribute set to check.

    # Type

    ```
    attrsets.longestValidPathPrefix :: [String] -> Value -> [String]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.longestValidPathPrefix` usage example

    ```nix
    x = { a = { b = 3; }; }
    attrsets.longestValidPathPrefix ["a" "b" "c"] x
    => ["a" "b"]
    attrsets.longestValidPathPrefix ["a"] x
    => ["a"]
    attrsets.longestValidPathPrefix ["z" "z"] x
    => []
    attrsets.longestValidPathPrefix ["z" "z"] (throw "no need")
    => []
    ```

    :::
  */
  longestValidPathPrefix =
    attrPath: v:
    let
      lenAttrPath = length attrPath;
      getPrefixForSetAtIndex =
        # The nested attribute set to check, if it is an attribute set, which
        # is not a given.
        remainingSet:
        # The index of the attribute we're about to check, as well as
        # the length of the prefix we've already checked.
        remainingPathIndex:

        if remainingPathIndex == lenAttrPath then
          # All previously checked attributes exist, and no attr names left,
          # so we return the whole path.
          attrPath
        else
          let
            attr = elemAt attrPath remainingPathIndex;
          in
          if remainingSet ? ${attr} then
            getPrefixForSetAtIndex remainingSet.${attr} # advance from the set to the attribute value
              (remainingPathIndex + 1) # advance the path
          else
            # The attribute doesn't exist, so we return the prefix up to the
            # previously checked length.
            take remainingPathIndex attrPath;
    in
    getPrefixForSetAtIndex v 0;

  /**
    Create a new attribute set with `value` set at the nested attribute location specified in `attrPath`.

    # Inputs

    `attrPath`

    : A list of strings representing the attribute path to set

    `value`

    : The value to set at the location described by `attrPath`

    # Type

    ```
    setAttrByPath :: [String] -> Any -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.setAttrByPath` usage example

    ```nix
    setAttrByPath ["a" "b"] 3
    => { a = { b = 3; }; }
    ```

    :::
  */
  setAttrByPath =
    attrPath: value:
    let
      len = length attrPath;
      atDepth = n: if n == len then value else { ${elemAt attrPath n} = atDepth (n + 1); };
    in
    atDepth 0;

  /**
    Like `attrByPath`, but without a default value. If it doesn't find the
    path it will throw an error.

    Nix has an [attribute selection operator](https://nixos.org/manual/nix/stable/language/operators#attribute-selection) which is sufficient for such queries, as long as the number of attributes is static. For example:

    ```nix
    x.a.b == getAttrFromPath ["a" "b"] x
    # and
    x.${f p}."example.com" == getAttrFromPath [ (f p) "example.com" ] x
    ```

    # Inputs

    `attrPath`

    : A list of strings representing the attribute path to get from `set`

    `set`

    : The nested attribute set to find the value in.

    # Type

    ```
    getAttrFromPath :: [String] -> AttrSet -> Any
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.getAttrFromPath` usage example

    ```nix
    x = { a = { b = 3; }; }
    getAttrFromPath ["a" "b"] x
    => 3
    getAttrFromPath ["z" "z"] x
    => error: cannot find attribute `z.z'
    ```

    :::
  */
  getAttrFromPath =
    attrPath: set:
    attrByPath attrPath (abort ("cannot find attribute '" + concatStringsSep "." attrPath + "'")) set;

  /**
    Map each attribute in the given set and merge them into a new attribute set.

    # Inputs

    `f`

    : 1\. Function argument

    `v`

    : 2\. Function argument

    # Type

    ```
    concatMapAttrs :: (String -> a -> AttrSet) -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.concatMapAttrs` usage example

    ```nix
    concatMapAttrs
      (name: value: {
        ${name} = value;
        ${name + value} = value;
      })
      { x = "a"; y = "b"; }
    => { x = "a"; xa = "a"; y = "b"; yb = "b"; }
    ```

    :::
  */
  concatMapAttrs = f: v: foldl' mergeAttrs { } (attrValues (mapAttrs f v));

  /**
    Update or set specific paths of an attribute set.

    Takes a list of updates to apply and an attribute set to apply them to,
    and returns the attribute set with the updates applied. Updates are
    represented as `{ path = ...; update = ...; }` values, where `path` is a
    list of strings representing the attribute path that should be updated,
    and `update` is a function that takes the old value at that attribute path
    as an argument and returns the new
    value it should be.

    Properties:

    - Updates to deeper attribute paths are applied before updates to more
      shallow attribute paths

    - Multiple updates to the same attribute path are applied in the order
      they appear in the update list

    - If any but the last `path` element leads into a value that is not an
      attribute set, an error is thrown

    - If there is an update for an attribute path that doesn't exist,
      accessing the argument in the update function causes an error, but
      intermediate attribute sets are implicitly created as needed

    # Type

    ```
    updateManyAttrsByPath :: [{ path :: [String]; update :: (Any -> Any); }] -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.updateManyAttrsByPath` usage example

    ```nix
    updateManyAttrsByPath [
      {
        path = [ "a" "b" ];
        update = old: { d = old.c; };
      }
      {
        path = [ "a" "b" "c" ];
        update = old: old + 1;
      }
      {
        path = [ "x" "y" ];
        update = old: "xy";
      }
    ] { a.b.c = 0; }
    => { a = { b = { d = 1; }; }; x = { y = "xy"; }; }
    ```

    :::
  */
  updateManyAttrsByPath =
    let
      # When recursing into attributes, instead of updating the `path` of each
      # update using `tail`, which needs to allocate an entirely new list,
      # we just pass a prefix length to use and make sure to only look at the
      # path without the prefix length, so that we can reuse the original list
      # entries.
      go =
        prefixLength: hasValue: value: updates:
        let
          # Splits updates into ones on this level (split.right)
          # And ones on levels further down (split.wrong)
          split = partition (el: length el.path == prefixLength) updates;

          # Groups updates on further down levels into the attributes they modify
          nested = groupBy (el: elemAt el.path prefixLength) split.wrong;

          # Applies only nested modification to the input value
          withNestedMods =
            # Return the value directly if we don't have any nested modifications
            if split.wrong == [ ] then
              if hasValue then
                value
              else
                # Throw an error if there is no value. This `head` call here is
                # safe, but only in this branch since `go` could only be called
                # with `hasValue == false` for nested updates, in which case
                # it's also always called with at least one update
                let
                  updatePath = (head split.right).path;
                in
                throw (
                  "updateManyAttrsByPath: Path '${showAttrPath updatePath}' does "
                  + "not exist in the given value, but the first update to this "
                  + "path tries to access the existing value."
                )
            else
            # If there are nested modifications, try to apply them to the value
            if !hasValue then
              # But if we don't have a value, just use an empty attribute set
              # as the value, but simplify the code a bit
              mapAttrs (name: go (prefixLength + 1) false null) nested
            else if isAttrs value then
              # If we do have a value and it's an attribute set, override it
              # with the nested modifications
              value // mapAttrs (name: go (prefixLength + 1) (value ? ${name}) value.${name}) nested
            else
              # However if it's not an attribute set, we can't apply the nested
              # modifications, throw an error
              let
                updatePath = (head split.wrong).path;
              in
              throw (
                "updateManyAttrsByPath: Path '${showAttrPath updatePath}' needs to "
                + "be updated, but path '${showAttrPath (take prefixLength updatePath)}' "
                + "of the given value is not an attribute set, so we can't "
                + "update an attribute inside of it."
              );

          # We get the final result by applying all the updates on this level
          # after having applied all the nested updates
          # We use foldl instead of foldl' so that in case of multiple updates,
          # intermediate values aren't evaluated if not needed
        in
        foldl (acc: el: el.update acc) withNestedMods split.right;

    in
    updates: value: go 0 true value updates;

  /**
    Returns the specified attributes from a set.

    # Inputs

    `nameList`

    : The list of attributes to fetch from `set`. Each attribute name must exist on the attribute set

    `set`

    : The set to get attribute values from

    # Type

    ```
    attrVals :: [String] -> AttrSet -> [Any]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.attrVals` usage example

    ```nix
    attrVals ["a" "b" "c"] as
    => [as.a as.b as.c]
    ```

    :::
  */
  attrVals = nameList: set: map (x: set.${x}) nameList;

  /**
    Returns the values of all attributes in the given set, sorted by
    attribute name.

    # Type

    ```
    attrValues :: AttrSet -> [Any]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.attrValues` usage example

    ```nix
    attrValues {c = 3; a = 1; b = 2;}
    => [1 2 3]
    ```

    :::
  */
  attrValues = builtins.attrValues;

  /**
    Given a set of attribute names, return the set of the corresponding
    attributes from the given set.

    # Inputs

    `names`

    : A list of attribute names to get out of `set`

    `attrs`

    : The set to get the named attributes from

    # Type

    ```
    getAttrs :: [String] -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.getAttrs` usage example

    ```nix
    getAttrs [ "a" "b" ] { a = 1; b = 2; c = 3; }
    => { a = 1; b = 2; }
    ```

    :::
  */
  getAttrs = names: attrs: genAttrs names (name: attrs.${name});

  /**
    Collect each attribute named `attr` from a list of attribute
    sets.  Sets that don't contain the named attribute are ignored.

    # Inputs

    `attr`

    : The attribute name to get out of the sets.

    `list`

    : The list of attribute sets to go through

    # Type

    ```
    catAttrs :: String -> [AttrSet] -> [Any]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.catAttrs` usage example

    ```nix
    catAttrs "a" [{a = 1;} {b = 0;} {a = 2;}]
    => [1 2]
    ```

    :::
  */
  catAttrs = builtins.catAttrs;

  /**
    Filter an attribute set by removing all attributes for which the
    given predicate return false.

    # Inputs

    `pred`

    : Predicate taking an attribute name and an attribute value, which returns `true` to include the attribute, or `false` to exclude the attribute.

      <!-- TIP -->
      If possible, decide on `name` first and on `value` only if necessary.
      This avoids evaluating the value if the name is already enough, making it possible, potentially, to have the argument reference the return value.
      (Depending on context, that could still be considered a self reference by users; a common pattern in Nix.)

      <!-- TIP -->
      `filterAttrs` is occasionally the cause of infinite recursion in configuration systems that allow self-references.
      To support the widest range of user-provided logic, perform the `filterAttrs` call as late as possible.
      Typically that's right before using it in a derivation, as opposed to an implicit conversion whose result is accessible to the user's expressions.

    `set`

    : The attribute set to filter

    # Type

    ```
    filterAttrs :: (String -> Any -> Bool) -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.filterAttrs` usage example

    ```nix
    filterAttrs (n: v: n == "foo") { foo = 1; bar = 2; }
    => { foo = 1; }
    ```

    :::
  */
  filterAttrs = pred: set: removeAttrs set (filter (name: !pred name set.${name}) (attrNames set));

  /**
    Filter an attribute set recursively by removing all attributes for
    which the given predicate return false.

    # Inputs

    `pred`

    : Predicate taking an attribute name and an attribute value, which returns `true` to include the attribute, or `false` to exclude the attribute.

    `set`

    : The attribute set to filter

    # Type

    ```
    filterAttrsRecursive :: (String -> Any -> Bool) -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.filterAttrsRecursive` usage example

    ```nix
    filterAttrsRecursive (n: v: v != null) { foo = { bar = null; }; }
    => { foo = {}; }
    ```

    :::
  */
  filterAttrsRecursive =
    pred: set:
    listToAttrs (
      concatMap (
        name:
        let
          v = set.${name};
        in
        if pred name v then
          [
            (nameValuePair name (if isAttrs v then filterAttrsRecursive pred v else v))
          ]
        else
          [ ]
      ) (attrNames set)
    );

  /**
    Like [`lib.lists.foldl'`](#function-library-lib.lists.foldl-prime) but for attribute sets.
    Iterates over every name-value pair in the given attribute set.
    The result of the callback function is often called `acc` for accumulator. It is passed between callbacks from left to right and the final `acc` is the return value of `foldlAttrs`.

    ::: {.note}
    There is a completely different function `lib.foldAttrs`
    which has nothing to do with this function, despite the similar name.
    :::

    # Inputs

    `f`

    : 1\. Function argument

    `init`

    : 2\. Function argument

    `set`

    : 3\. Function argument

    # Type

    ```
    foldlAttrs :: ( a -> String -> b -> a ) -> a -> { ... :: b } -> a
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.foldlAttrs` usage example

    ```nix
    foldlAttrs
      (acc: name: value: {
        sum = acc.sum + value;
        names = acc.names ++ [name];
      })
      { sum = 0; names = []; }
      {
        foo = 1;
        bar = 10;
      }
    ->
      {
        sum = 11;
        names = ["bar" "foo"];
      }

    foldlAttrs
      (throw "function not needed")
      123
      {};
    ->
      123

    foldlAttrs
      (acc: _: _: acc)
      3
      { z = throw "value not needed"; a = throw "value not needed"; };
    ->
      3

    The accumulator doesn't have to be an attrset.
    It can be as simple as a number or string.

    foldlAttrs
      (acc: _: v: acc * 10 + v)
      1
      { z = 1; a = 2; };
    ->
      121
    ```

    :::
  */
  foldlAttrs =
    f: init: set:
    foldl' (acc: name: f acc name set.${name}) init (attrNames set);

  /**
    Apply fold functions to values grouped by key.

    # Inputs

    `op`

    : A function, given a value and a collector combines the two.

    `nul`

    : The starting value.

    `list_of_attrs`

    : A list of attribute sets to fold together by key.

    # Type

    ```
    foldAttrs :: (Any -> Any -> Any) -> Any -> [AttrSets] -> Any
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.foldAttrs` usage example

    ```nix
    foldAttrs (item: acc: [item] ++ acc) [] [{ a = 2; } { a = 3; }]
    => { a = [ 2 3 ]; }
    ```

    :::
  */
  foldAttrs =
    op: nul: list_of_attrs:
    foldr (
      n: a: foldr (name: o: o // { ${name} = op n.${name} (a.${name} or nul); }) a (attrNames n)
    ) { } list_of_attrs;

  /**
    Recursively collect sets that verify a given predicate named `pred`
    from the set `attrs`. The recursion is stopped when the predicate is
    verified.

    # Inputs

    `pred`

    : Given an attribute's value, determine if recursion should stop.

    `attrs`

    : The attribute set to recursively collect.

    # Type

    ```
    collect :: (AttrSet -> Bool) -> AttrSet -> [x]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.collect` usage example

    ```nix
    collect isList { a = { b = ["b"]; }; c = [1]; }
    => [["b"] [1]]

    collect (x: x ? outPath)
       { a = { outPath = "a/"; }; b = { outPath = "b/"; }; }
    => [{ outPath = "a/"; } { outPath = "b/"; }]
    ```

    :::
  */
  collect =
    pred: attrs:
    if pred attrs then
      [ attrs ]
    else if isAttrs attrs then
      concatMap (collect pred) (attrValues attrs)
    else
      [ ];

  /**
    Return the cartesian product of attribute set value combinations.

    # Inputs

    `attrsOfLists`

    : Attribute set with attributes that are lists of values

    # Type

    ```
    cartesianProduct :: AttrSet -> [AttrSet]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.cartesianProduct` usage example

    ```nix
    cartesianProduct { a = [ 1 2 ]; b = [ 10 20 ]; }
    => [
         { a = 1; b = 10; }
         { a = 1; b = 20; }
         { a = 2; b = 10; }
         { a = 2; b = 20; }
       ]
    ```

    :::
  */
  cartesianProduct =
    attrsOfLists:
    foldl' (
      listOfAttrs: attrName:
      concatMap (
        attrs: map (listValue: attrs // { ${attrName} = listValue; }) attrsOfLists.${attrName}
      ) listOfAttrs
    ) [ { } ] (attrNames attrsOfLists);

  /**
    Return the result of function `f` applied to the cartesian product of attribute set value combinations.
    Equivalent to using `cartesianProduct` followed by `map`.

    # Inputs

    `f`

    : A function, given an attribute set, it returns a new value.

    `attrsOfLists`

    : Attribute set with attributes that are lists of values

    # Type

    ```
    mapCartesianProduct :: (AttrSet -> a) -> AttrSet -> [a]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.mapCartesianProduct` usage example

    ```nix
    mapCartesianProduct ({a, b}: "${a}-${b}") { a = [ "1" "2" ]; b = [ "3" "4" ]; }
    => [ "1-3" "1-4" "2-3" "2-4" ]
    ```

    :::
  */
  mapCartesianProduct = f: attrsOfLists: map f (cartesianProduct attrsOfLists);

  /**
    Utility function that creates a `{name, value}` pair as expected by `builtins.listToAttrs`.

    # Inputs

    `name`

    : Attribute name

    `value`

    : Attribute value

    # Type

    ```
    nameValuePair :: String -> Any -> { name :: String; value :: Any; }
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.nameValuePair` usage example

    ```nix
    nameValuePair "some" 6
    => { name = "some"; value = 6; }
    ```

    :::
  */
  nameValuePair = name: value: { inherit name value; };

  /**
    Apply a function to each element in an attribute set, creating a new attribute set.

    # Inputs

    `f`

    : A function that takes an attribute name and its value, and returns the new value for the attribute.

    `attrset`

    : The attribute set to iterate through.

    # Type

    ```
    mapAttrs :: (String -> Any -> Any) -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.mapAttrs` usage example

    ```nix
    mapAttrs (name: value: name + "-" + value)
       { x = "foo"; y = "bar"; }
    => { x = "x-foo"; y = "y-bar"; }
    ```

    :::
  */
  mapAttrs = builtins.mapAttrs;

  /**
    Like `mapAttrs`, but allows the name of each attribute to be
    changed in addition to the value.  The applied function should
    return both the new name and value as a `nameValuePair`.

    # Inputs

    `f`

    : A function, given an attribute's name and value, returns a new `nameValuePair`.

    `set`

    : Attribute set to map over.

    # Type

    ```
    mapAttrs' :: (String -> Any -> { name :: String; value :: Any; }) -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.mapAttrs'` usage example

    ```nix
    mapAttrs' (name: value: nameValuePair ("foo_" + name) ("bar-" + value))
       { x = "a"; y = "b"; }
    => { foo_x = "bar-a"; foo_y = "bar-b"; }
    ```

    :::
  */
  mapAttrs' = f: set: listToAttrs (mapAttrsToList f set);

  /**
    Call a function for each attribute in the given set and return
    the result in a list.

    # Inputs

    `f`

    : A function, given an attribute's name and value, returns a new value.

    `attrs`

    : Attribute set to map over.

    # Type

    ```
    mapAttrsToList :: (String -> a -> b) -> AttrSet -> [b]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.mapAttrsToList` usage example

    ```nix
    mapAttrsToList (name: value: name + value)
       { x = "a"; y = "b"; }
    => [ "xa" "yb" ]
    ```

    :::
  */
  mapAttrsToList = f: attrs: attrValues (mapAttrs f attrs);

  /**
    Deconstruct an attrset to a list of name-value pairs as expected by [`builtins.listToAttrs`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-listToAttrs).
    Each element of the resulting list is an attribute set with these attributes:
    - `name` (string): The name of the attribute
    - `value` (any): The value of the attribute

    The following is always true:
    ```nix
    builtins.listToAttrs (attrsToList attrs) == attrs
    ```

    :::{.warning}
    The opposite is not always true. In general expect that
    ```nix
    attrsToList (builtins.listToAttrs list) != list
    ```

    This is because the `listToAttrs` removes duplicate names and doesn't preserve the order of the list.
    :::

    # Inputs

    `set`

    : The attribute set to deconstruct.

    # Type

    ```
    attrsToList :: AttrSet -> [ { name :: String; value :: Any; } ]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.attrsToList` usage example

    ```nix
    attrsToList { foo = 1; bar = "asdf"; }
    => [ { name = "bar"; value = "asdf"; } { name = "foo"; value = 1; } ]
    ```

    :::
  */
  attrsToList = mapAttrsToList nameValuePair;

  /**
    Like `mapAttrs`, except that it recursively applies itself to the *leaf* attributes of a potentially-nested attribute set:
    the second argument of the function will never be an attrset.
    Also, the first argument of the mapping function is a *list* of the attribute names that form the path to the leaf attribute.

    For a function that gives you control over what counts as a leaf, see `mapAttrsRecursiveCond`.

    :::{#map-attrs-recursive-example .example}
    # Map over leaf attributes

    ```nix
    mapAttrsRecursive (path: value: concatStringsSep "-" (path ++ [value]))
      { n = { a = "A"; m = { b = "B"; c = "C"; }; }; d = "D"; }
    ```
    evaluates to
    ```nix
    { n = { a = "n-a-A"; m = { b = "n-m-b-B"; c = "n-m-c-C"; }; }; d = "d-D"; }
    ```
    :::

    # Type
    ```
    mapAttrsRecursive :: ([String] -> a -> b) -> AttrSet -> AttrSet
    ```
  */
  mapAttrsRecursive = f: set: mapAttrsRecursiveCond (as: true) f set;

  /**
    Like `mapAttrsRecursive`, but it takes an additional predicate that tells it whether to recurse into an attribute set.
    If the predicate returns false, `mapAttrsRecursiveCond` does not recurse, but instead applies the mapping function.
    If the predicate returns true, it does recurse, and does not apply the mapping function.

    :::{#map-attrs-recursive-cond-example .example}
    # Map over an leaf attributes defined by a condition

    Map derivations to their `name` attribute.
    Derivatons are identified as attribute sets that contain `{ type = "derivation"; }`.
    ```nix
    mapAttrsRecursiveCond
      (as: !(as ? "type" && as.type == "derivation"))
      (path: x: x.name)
      attrs
    ```
    :::

    # Type
    ```
    mapAttrsRecursiveCond :: (AttrSet -> Bool) -> ([String] -> a -> b) -> AttrSet -> AttrSet
    ```
  */
  mapAttrsRecursiveCond =
    cond: f: set:
    let
      recurse =
        path:
        mapAttrs (
          name: value:
          if isAttrs value && cond value then recurse (path ++ [ name ]) value else f (path ++ [ name ]) value
        );
    in
    recurse [ ] set;

  /**
    Apply a function to each leaf (non‐attribute‐set attribute) of a tree of
    nested attribute sets, returning the results of the function as a list,
    ordered lexicographically by their attribute paths.

    Like `mapAttrsRecursive`, but concatenates the mapping function results
    into a list.

    # Inputs

    `f`

    : Mapping function which, given an attribute’s path and value, returns a
      new value.

      This value will be an element of the list returned by
      `mapAttrsToListRecursive`.

      The first argument to the mapping function is a list of attribute names
      forming the path to the leaf attribute. The second argument is the leaf
      attribute value, which will never be an attribute set.

    `set`

    : Attribute set to map over.

    # Type

    ```
    mapAttrsToListRecursive :: ([String] -> a -> b) -> AttrSet -> [b]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.mapAttrsToListRecursive` usage example

    ```nix
    mapAttrsToListRecursive (path: value: "${concatStringsSep "." path}=${value}")
      { n = { a = "A"; m = { b = "B"; c = "C"; }; }; d = "D"; }
    => [ "n.a=A" "n.m.b=B" "n.m.c=C" "d=D" ]
    ```
    :::
  */
  mapAttrsToListRecursive = mapAttrsToListRecursiveCond (_: _: true);

  /**
    Determine the nodes of a tree of nested attribute sets by applying a
    predicate, then apply a function to the leaves, returning the results
    as a list, ordered lexicographically by their attribute paths.

    Like `mapAttrsToListRecursive`, but takes an additional predicate to
    decide whether to recurse into an attribute set.

    Unlike `mapAttrsRecursiveCond` this predicate receives the attribute path
    as its first argument, in addition to the attribute set.

    # Inputs

    `pred`

    : Predicate to decide whether to recurse into an attribute set.

      If the predicate returns true, `mapAttrsToListRecursiveCond` recurses into
      the attribute set. If the predicate returns false, it does not recurse
      but instead applies the mapping function, treating the attribute set as
      a leaf.

      The first argument to the predicate is a list of attribute names forming
      the path to the attribute set. The second argument is the attribute set.

    `f`

    : Mapping function which, given an attribute’s path and value, returns a
      new value.

      This value will be an element of the list returned by
      `mapAttrsToListRecursiveCond`.

      The first argument to the mapping function is a list of attribute names
      forming the path to the leaf attribute. The second argument is the leaf
      attribute value, which may be an attribute set if the predicate returned
      false.

    `set`

    : Attribute set to map over.

    # Type
    ```
    mapAttrsToListRecursiveCond :: ([String] -> AttrSet -> Bool) -> ([String] -> a -> b) -> AttrSet -> [b]
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.mapAttrsToListRecursiveCond` usage example

    ```nix
    mapAttrsToListRecursiveCond
      (path: as: !(lib.isDerivation as))
      (path: value: "--set=${lib.concatStringsSep "." path}=${toString value}")
      {
        rust.optimize = 2;
        target = {
          riscv64-unknown-linux-gnu.linker = pkgs.lld;
        };
      }
    => [ "--set=rust.optimize=2" "--set=target.riscv64-unknown-linux-gnu.linker=/nix/store/sjw4h1k…" ]
    ```
    :::
  */
  mapAttrsToListRecursiveCond =
    pred: f: set:
    let
      mapRecursive =
        path: value: if isAttrs value && pred path value then recurse path value else [ (f path value) ];
      recurse = path: set: concatMap (name: mapRecursive (path ++ [ name ]) set.${name}) (attrNames set);
    in
    recurse [ ] set;

  /**
    Generate an attribute set by mapping a function over a list of
    attribute names.

    # Inputs

    `names`

    : Names of values in the resulting attribute set.

    `f`

    : A function, given the name of the attribute, returns the attribute's value.

    # Type

    ```
    genAttrs :: [ String ] -> (String -> Any) -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.genAttrs` usage example

    ```nix
    genAttrs [ "foo" "bar" ] (name: "x_" + name)
    => { foo = "x_foo"; bar = "x_bar"; }
    ```

    :::
  */
  genAttrs = names: f: genAttrs' names (n: nameValuePair n (f n));

  /**
    Like `genAttrs`, but allows the name of each attribute to be specified in addition to the value.
    The applied function should return both the new name and value as a `nameValuePair`.
    ::: {.warning}
    In case of attribute name collision the first entry determines the value,
    all subsequent conflicting entries for the same name are silently ignored.
    :::

    # Inputs

    `xs`

    : A list of strings `s` used as generator.

    `f`

    : A function, given a string `s` from the list `xs`, returns a new `nameValuePair`.

    # Type

    ```
    genAttrs' :: [ Any ] -> (Any -> { name :: String; value :: Any; }) -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.genAttrs'` usage example

    ```nix
    genAttrs' [ "foo" "bar" ] (s: nameValuePair ("x_" + s) ("y_" + s))
    => { x_foo = "y_foo"; x_bar = "y_bar"; }
    ```

    :::
  */
  genAttrs' = xs: f: listToAttrs (map f xs);

  /**
    Check whether the argument is a derivation. Any set with
    `{ type = "derivation"; }` counts as a derivation.

    # Inputs

    `value`

    : Value to check.

    # Type

    ```
    isDerivation :: Any -> Bool
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.isDerivation` usage example

    ```nix
    nixpkgs = import <nixpkgs> {}
    isDerivation nixpkgs.ruby
    => true
    isDerivation "foobar"
    => false
    ```

    :::
  */
  isDerivation = value: value.type or null == "derivation";

  /**
    Converts a store path to a fake derivation.

    # Inputs

    `path`

    : A store path to convert to a derivation.

    # Type

    ```
    toDerivation :: Path -> Derivation
    ```
  */
  toDerivation =
    path:
    let
      path' = builtins.storePath path;
      res = {
        type = "derivation";
        name = sanitizeDerivationName (builtins.substring 33 (-1) (baseNameOf path'));
        outPath = path';
        outputs = [ "out" ];
        out = res;
        outputName = "out";
      };
    in
    res;

  /**
    If `cond` is true, return the attribute set `as`,
    otherwise an empty attribute set.

    # Inputs

    `cond`

    : Condition under which the `as` attribute set is returned.

    `as`

    : The attribute set to return if `cond` is `true`.

    # Type

    ```
    optionalAttrs :: Bool -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.optionalAttrs` usage example

    ```nix
    optionalAttrs (true) { my = "set"; }
    => { my = "set"; }
    optionalAttrs (false) { my = "set"; }
    => { }
    ```

    :::
  */
  optionalAttrs = cond: as: if cond then as else { };

  /**
    Merge sets of attributes and use the function `f` to merge attributes
    values.

    # Inputs

    `names`

    : List of attribute names to zip.

    `f`

    : A function, accepts an attribute name, all the values, and returns a combined value.

    `sets`

    : List of values from the list of attribute sets.

    # Type

    ```
    zipAttrsWithNames :: [ String ] -> (String -> [ Any ] -> Any) -> [ AttrSet ] -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.zipAttrsWithNames` usage example

    ```nix
    zipAttrsWithNames ["a"] (name: vs: vs) [{a = "x";} {a = "y"; b = "z";}]
    => { a = ["x" "y"]; }
    ```

    :::
  */
  zipAttrsWithNames =
    names: f: sets:
    listToAttrs (
      map (name: {
        inherit name;
        value = f name (catAttrs name sets);
      }) names
    );

  /**
    Merge sets of attributes and use the function `f` to merge attribute values.
    Like `lib.attrsets.zipAttrsWithNames` with all key names are passed for `names`.

    Implementation note: Common names appear multiple times in the list of
    names, hopefully this does not affect the system because the maximal
    laziness avoid computing twice the same expression and `listToAttrs` does
    not care about duplicated attribute names.

    # Type

    ```
    zipAttrsWith :: (String -> [ Any ] -> Any) -> [ AttrSet ] -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.zipAttrsWith` usage example

    ```nix
    zipAttrsWith (name: values: values) [{a = "x";} {a = "y"; b = "z";}]
    => { a = ["x" "y"]; b = ["z"]; }
    ```

    :::
  */
  zipAttrsWith =
    builtins.zipAttrsWith or (f: sets: zipAttrsWithNames (concatMap attrNames sets) f sets);

  /**
    Merge sets of attributes and combine each attribute value in to a list.

    Like `lib.attrsets.zipAttrsWith` with `(name: values: values)` as the function.

    # Type

    ```
    zipAttrs :: [ AttrSet ] -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.zipAttrs` usage example

    ```nix
    zipAttrs [{a = "x";} {a = "y"; b = "z";}]
    => { a = ["x" "y"]; b = ["z"]; }
    ```

    :::
  */
  zipAttrs = zipAttrsWith (name: values: values);

  /**
    Merge a list of attribute sets together using the `//` operator.
    In case of duplicate attributes, values from later list elements take precedence over earlier ones.
    The result is the same as `foldl mergeAttrs { }`, but the performance is better for large inputs.
    For n list elements, each with an attribute set containing m unique attributes, the complexity of this operation is O(nm log n).

    # Inputs

    `list`

    : 1\. Function argument

    # Type

    ```
    mergeAttrsList :: [ Attrs ] -> Attrs
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.mergeAttrsList` usage example

    ```nix
    mergeAttrsList [ { a = 0; b = 1; } { c = 2; d = 3; } ]
    => { a = 0; b = 1; c = 2; d = 3; }
    mergeAttrsList [ { a = 0; } { a = 1; } ]
    => { a = 1; }
    ```

    :::
  */
  mergeAttrsList =
    list:
    let
      # `binaryMerge start end` merges the elements at indices `index` of `list` such that `start <= index < end`
      # Type: Int -> Int -> Attrs
      binaryMerge =
        start: end:
        # assert start < end; # Invariant
        if end - start >= 2 then
          # If there's at least 2 elements, split the range in two, recurse on each part and merge the result
          # The invariant is satisfied because each half will have at least 1 element
          binaryMerge start (start + (end - start) / 2) // binaryMerge (start + (end - start) / 2) end
        else
          # Otherwise there will be exactly 1 element due to the invariant, in which case we just return it directly
          elemAt list start;
    in
    if list == [ ] then
      # Calling binaryMerge as below would not satisfy its invariant
      { }
    else
      binaryMerge 0 (length list);

  /**
    Does the same as the update operator `//` except that attributes are
    merged until the given predicate is verified.  The predicate should
    accept 3 arguments which are the path to reach the attribute, a part of
    the first attribute set and a part of the second attribute set.  When
    the predicate is satisfied, the value of the first attribute set is
    replaced by the value of the second attribute set.

    # Inputs

    `pred`

    : Predicate, taking the path to the current attribute as a list of strings for attribute names, and the two values at that path from the original arguments.

    `lhs`

    : Left attribute set of the merge.

    `rhs`

    : Right attribute set of the merge.

    # Type

    ```
    recursiveUpdateUntil :: ( [ String ] -> AttrSet -> AttrSet -> Bool ) -> AttrSet -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.recursiveUpdateUntil` usage example

    ```nix
    recursiveUpdateUntil (path: l: r: path == ["foo"]) {
      # first attribute set
      foo.bar = 1;
      foo.baz = 2;
      bar = 3;
    } {
      #second attribute set
      foo.bar = 1;
      foo.quz = 2;
      baz = 4;
    }

    => {
      foo.bar = 1; # 'foo.*' from the second set
      foo.quz = 2; #
      bar = 3;     # 'bar' from the first set
      baz = 4;     # 'baz' from the second set
    }
    ```

    :::
  */
  recursiveUpdateUntil =
    pred: lhs: rhs:
    let
      f =
        attrPath:
        zipAttrsWith (
          n: values:
          let
            here = attrPath ++ [ n ];
          in
          if length values == 1 || pred here (elemAt values 1) (head values) then
            head values
          else
            f here values
        );
    in
    f [ ] [ rhs lhs ];

  /**
    A recursive variant of the update operator `//`.  The recursion
    stops when one of the attribute values is not an attribute set,
    in which case the right hand side value takes precedence over the
    left hand side value.

    # Inputs

    `lhs`

    : Left attribute set of the merge.

    `rhs`

    : Right attribute set of the merge.

    # Type

    ```
    recursiveUpdate :: AttrSet -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.recursiveUpdate` usage example

    ```nix
    recursiveUpdate {
      boot.loader.grub.enable = true;
      boot.loader.grub.device = "/dev/hda";
    } {
      boot.loader.grub.device = "";
    }

    returns: {
      boot.loader.grub.enable = true;
      boot.loader.grub.device = "";
    }
    ```

    :::
  */
  recursiveUpdate =
    lhs: rhs:
    recursiveUpdateUntil (
      path: lhs: rhs:
      !(isAttrs lhs && isAttrs rhs)
    ) lhs rhs;

  /**
    Recurse into every attribute set of the first argument and check that:
    - Each attribute path also exists in the second argument.
    - If the attribute's value is not a nested attribute set, it must have the same value in the right argument.

    # Inputs

    `pattern`

    : Attribute set structure to match

    `attrs`

    : Attribute set to check

    # Type

    ```
    matchAttrs :: AttrSet -> AttrSet -> Bool
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.matchAttrs` usage example

    ```nix
    matchAttrs { cpu = {}; } { cpu = { bits = 64; }; }
    => true
    ```

    :::
  */
  matchAttrs =
    pattern: attrs:
    assert isAttrs pattern;
    all (
      # Compare equality between `pattern` & `attrs`.
      attr:
      # Missing attr, not equal.
      attrs ? ${attr}
      && (
        let
          lhs = pattern.${attr};
          rhs = attrs.${attr};
        in
        # If attrset check recursively
        if isAttrs lhs then isAttrs rhs && matchAttrs lhs rhs else lhs == rhs
      )
    ) (attrNames pattern);

  /**
    Override only the attributes that are already present in the old set
    useful for deep-overriding.

    # Inputs

    `old`

    : Original attribute set

    `new`

    : Attribute set with attributes to override in `old`.

    # Type

    ```
    overrideExisting :: AttrSet -> AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.overrideExisting` usage example

    ```nix
    overrideExisting {} { a = 1; }
    => {}
    overrideExisting { b = 2; } { a = 1; }
    => { b = 2; }
    overrideExisting { a = 3; b = 2; } { a = 1; }
    => { a = 1; b = 2; }
    ```

    :::
  */
  overrideExisting = old: new: mapAttrs (name: value: new.${name} or value) old;

  /**
    Turns a list of strings into a human-readable description of those
    strings represented as an attribute path. The result of this function is
    not intended to be machine-readable.
    Create a new attribute set with `value` set at the nested attribute location specified in `attrPath`.

    # Inputs

    `path`

    : Attribute path to render to a string

    # Type

    ```
    showAttrPath :: [String] -> String
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.showAttrPath` usage example

    ```nix
    showAttrPath [ "foo" "10" "bar" ]
    => "foo.\"10\".bar"
    showAttrPath []
    => "<root attribute path>"
    ```

    :::
  */
  showAttrPath =
    path:
    if path == [ ] then "<root attribute path>" else concatMapStringsSep "." escapeNixIdentifier path;

  /**
    Get a package output.
    If no output is found, fallback to `.out` and then to the default.
    The function is idempotent: `getOutput "b" (getOutput "a" p) == getOutput "a" p`.

    # Inputs

    `output`

    : 1\. Function argument

    `pkg`

    : 2\. Function argument

    # Type

    ```
    getOutput :: String -> :: Derivation -> Derivation
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.getOutput` usage example

    ```nix
    "${getOutput "dev" pkgs.openssl}"
    => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev"
    ```

    :::
  */
  getOutput =
    output: pkg:
    if !pkg ? outputSpecified || !pkg.outputSpecified then pkg.${output} or pkg.out or pkg else pkg;

  /**
    Get the first of the `outputs` provided by the package, or the default.
    This function is aligned with `_overrideFirst()` from the `multiple-outputs.sh` setup hook.
    Like `getOutput`, the function is idempotent.

    # Inputs

    `outputs`

    : 1\. Function argument

    `pkg`

    : 2\. Function argument

    # Type

    ```
    getFirstOutput :: [String] -> Derivation -> Derivation
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.getFirstOutput` usage example

    ```nix
    "${getFirstOutput [ "include" "dev" ] pkgs.openssl}"
    => "/nix/store/00000000000000000000000000000000-openssl-1.0.1r-dev"
    ```

    :::
  */
  getFirstOutput =
    candidates: pkg:
    let
      outputs = builtins.filter (name: hasAttr name pkg) candidates;
      output = builtins.head outputs;
    in
    if pkg.outputSpecified or false || outputs == [ ] then pkg else pkg.${output};

  /**
    Get a package's `bin` output.
    If the output does not exist, fallback to `.out` and then to the default.

    # Inputs

    `pkg`

    : The package whose `bin` output will be retrieved.

    # Type

    ```
    getBin :: Derivation -> Derivation
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.getBin` usage example

    ```nix
    "${getBin pkgs.openssl}"
    => "/nix/store/00000000000000000000000000000000-openssl-1.0.1r"
    ```

    :::
  */
  getBin = getOutput "bin";

  /**
    Get a package's `lib` output.
    If the output does not exist, fallback to `.out` and then to the default.

    # Inputs

    `pkg`

    : The package whose `lib` output will be retrieved.

    # Type

    ```
    getLib :: Derivation -> Derivation
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.getLib` usage example

    ```nix
    "${getLib pkgs.openssl}"
    => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-lib"
    ```

    :::
  */
  getLib = getOutput "lib";

  /**
    Get a package's `static` output.
    If the output does not exist, fallback to `.lib`, then to `.out`, and then to the default.

    # Inputs

    `pkg`

    : The package whose `static` output will be retrieved.

    # Type

    ```
    getStatic :: Derivation -> Derivation
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.getStatic` usage example

    ```nix
    "${lib.getStatic pkgs.glibc}"
    => "/nix/store/00000000000000000000000000000000-glibc-2.39-52-static"
    ```

    :::
  */
  getStatic = getFirstOutput [
    "static"
    "lib"
    "out"
  ];

  /**
    Get a package's `dev` output.
    If the output does not exist, fallback to `.out` and then to the default.

    # Inputs

    `pkg`

    : The package whose `dev` output will be retrieved.

    # Type

    ```
    getDev :: Derivation -> Derivation
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.getDev` usage example

    ```nix
    "${getDev pkgs.openssl}"
    => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev"
    ```

    :::
  */
  getDev = getOutput "dev";

  /**
    Get a package's `include` output.
    If the output does not exist, fallback to `.dev`, then to `.out`, and then to the default.

    # Inputs

    `pkg`

    : The package whose `include` output will be retrieved.

    # Type

    ```
    getInclude :: Derivation -> Derivation
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.getInclude` usage example

    ```nix
    "${getInclude pkgs.openssl}"
    => "/nix/store/00000000000000000000000000000000-openssl-1.0.1r-dev"
    ```

    :::
  */
  getInclude = getFirstOutput [
    "include"
    "dev"
    "out"
  ];

  /**
    Get a package's `man` output.
    If the output does not exist, fallback to `.out` and then to the default.

    # Inputs

    `pkg`

    : The package whose `man` output will be retrieved.

    # Type

    ```
    getMan :: Derivation -> Derivation
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.getMan` usage example

    ```nix
    "${getMan pkgs.openssl}"
    => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-man"
    ```

    :::
  */
  getMan = getOutput "man";

  /**
    Pick the outputs of packages to place in `buildInputs`

    # Inputs

    `pkgs`

    : List of packages.

    # Type

    ```
    chooseDevOutputs :: [Derivation] -> [Derivation]
    ```
  */
  chooseDevOutputs = map getDev;

  /**
    Make various Nix tools consider the contents of the resulting
    attribute set when looking for what to build, find, etc.

    This function only affects a single attribute set; it does not
    apply itself recursively for nested attribute sets.

    # Inputs

    `attrs`

    : An attribute set to scan for derivations.

    # Type

    ```
    recurseIntoAttrs :: AttrSet -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `lib.attrsets.recurseIntoAttrs` usage example

    ```nix
    { pkgs ? import <nixpkgs> {} }:
    {
      myTools = pkgs.lib.recurseIntoAttrs {
        inherit (pkgs) hello figlet;
      };
    }
    ```

    :::
  */
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  /**
    Undo the effect of `recurseIntoAttrs`.

    # Inputs

    `attrs`

    : An attribute set to not scan for derivations.

    # Type

    ```
    dontRecurseIntoAttrs :: AttrSet -> AttrSet
    ```
  */
  dontRecurseIntoAttrs = attrs: attrs // { recurseForDerivations = false; };

  /**
    `unionOfDisjoint x y` is equal to `x // y`, but accessing attributes present
    in both `x` and `y` will throw an error.  This operator is commutative, unlike `//`.

    # Inputs

    `x`

    : 1\. Function argument

    `y`

    : 2\. Function argument

    # Type

    ```
    unionOfDisjoint :: AttrSet -> AttrSet -> AttrSet
    ```
  */
  unionOfDisjoint =
    x: y:
    let
      intersection = builtins.intersectAttrs x y;
      collisions = lib.concatStringsSep " " (builtins.attrNames intersection);
      mask = builtins.mapAttrs (
        name: value: throw "unionOfDisjoint: collision on ${name}; complete list: ${collisions}"
      ) intersection;
    in
    (x // y) // mask;
}
