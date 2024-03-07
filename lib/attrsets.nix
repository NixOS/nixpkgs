/* Operations on attribute sets. */
{ lib }:

let
  inherit (builtins) head tail length;
  inherit (lib.trivial) id mergeAttrs;
  inherit (lib.strings) concatStringsSep concatMapStringsSep escapeNixIdentifier sanitizeDerivationName;
  inherit (lib.lists) foldr foldl' concatMap concatLists elemAt all partition groupBy take foldl;
in

rec {
  inherit (builtins) attrNames listToAttrs hasAttr isAttrs getAttr removeAttrs;


  /* Return an attribute from nested attribute sets.

     Nix has an [attribute selection operator `. or`](https://nixos.org/manual/nix/stable/language/operators#attribute-selection) which is sufficient for such queries, as long as the number of attributes is static. For example:

     ```nix
     (x.a.b or 6) == attrByPath ["a" "b"] 6 x
     # and
     (x.${f p}."example.com" or 6) == attrByPath [ (f p) "example.com" ] 6 x
     ```

     Example:
       x = { a = { b = 3; }; }
       # ["a" "b"] is equivalent to x.a.b
       # 6 is a default value to return if the path does not exist in attrset
       attrByPath ["a" "b"] 6 x
       => 3
       attrByPath ["z" "z"] 6 x
       => 6

     Type:
       attrByPath :: [String] -> Any -> AttrSet -> Any

  */
  attrByPath =
    # A list of strings representing the attribute path to return from `set`
    attrPath:
    # Default value if `attrPath` does not resolve to an existing value
    default:
    # The nested attribute set to select values from
    set:
    let
      lenAttrPath = length attrPath;
      attrByPath' = n: s: (
        if n == lenAttrPath then s
        else (
          let
            attr = elemAt attrPath n;
          in
          if s ? ${attr} then attrByPath' (n + 1) s.${attr}
          else default
        )
      );
    in
      attrByPath' 0 set;

  /* Return if an attribute from nested attribute set exists.

     Nix has a [has attribute operator `?`](https://nixos.org/manual/nix/stable/language/operators#has-attribute), which is sufficient for such queries, as long as the number of attributes is static. For example:

     ```nix
     (x?a.b) == hasAttryByPath ["a" "b"] x
     # and
     (x?${f p}."example.com") == hasAttryByPath [ (f p) "example.com" ] x
     ```

     **Laws**:
      1.  ```nix
          hasAttrByPath [] x == true
          ```

     Example:
       x = { a = { b = 3; }; }
       hasAttrByPath ["a" "b"] x
       => true
       hasAttrByPath ["z" "z"] x
       => false
       hasAttrByPath [] (throw "no need")
       => true

    Type:
      hasAttrByPath :: [String] -> AttrSet -> Bool
  */
  hasAttrByPath =
    # A list of strings representing the attribute path to check from `set`
    attrPath:
    # The nested attribute set to check
    e:
    let
      lenAttrPath = length attrPath;
      hasAttrByPath' = n: s: (
        n == lenAttrPath || (
          let
            attr = elemAt attrPath n;
          in
          if s ? ${attr} then hasAttrByPath' (n + 1) s.${attr}
          else false
        )
      );
    in
      hasAttrByPath' 0 e;

  /*
    Return the longest prefix of an attribute path that refers to an existing attribute in a nesting of attribute sets.

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

    Example:
      x = { a = { b = 3; }; }
      attrsets.longestValidPathPrefix ["a" "b" "c"] x
      => ["a" "b"]
      attrsets.longestValidPathPrefix ["a"] x
      => ["a"]
      attrsets.longestValidPathPrefix ["z" "z"] x
      => []
      attrsets.longestValidPathPrefix ["z" "z"] (throw "no need")
      => []

    Type:
      attrsets.longestValidPathPrefix :: [String] -> Value -> [String]
  */
  longestValidPathPrefix =
    # A list of strings representing the longest possible path that may be returned.
    attrPath:
    # The nested attribute set to check.
    v:
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
              getPrefixForSetAtIndex
                remainingSet.${attr}      # advance from the set to the attribute value
                (remainingPathIndex + 1)  # advance the path
            else
              # The attribute doesn't exist, so we return the prefix up to the
              # previously checked length.
              take remainingPathIndex attrPath;
    in
      getPrefixForSetAtIndex v 0;

  /* Create a new attribute set with `value` set at the nested attribute location specified in `attrPath`.

     Example:
       setAttrByPath ["a" "b"] 3
       => { a = { b = 3; }; }

     Type:
       setAttrByPath :: [String] -> Any -> AttrSet
  */
  setAttrByPath =
    # A list of strings representing the attribute path to set
    attrPath:
    # The value to set at the location described by `attrPath`
    value:
    let
      len = length attrPath;
      atDepth = n:
        if n == len
        then value
        else { ${elemAt attrPath n} = atDepth (n + 1); };
    in atDepth 0;

  /* Like `attrByPath`, but without a default value. If it doesn't find the
     path it will throw an error.

     Nix has an [attribute selection operator](https://nixos.org/manual/nix/stable/language/operators#attribute-selection) which is sufficient for such queries, as long as the number of attributes is static. For example:

    ```nix
     x.a.b == getAttrByPath ["a" "b"] x
     # and
     x.${f p}."example.com" == getAttrByPath [ (f p) "example.com" ] x
     ```

     Example:
       x = { a = { b = 3; }; }
       getAttrFromPath ["a" "b"] x
       => 3
       getAttrFromPath ["z" "z"] x
       => error: cannot find attribute `z.z'

     Type:
       getAttrFromPath :: [String] -> AttrSet -> Any
  */
  getAttrFromPath =
    # A list of strings representing the attribute path to get from `set`
    attrPath:
    # The nested attribute set to find the value in.
    set:
    let errorMsg = "cannot find attribute `" + concatStringsSep "." attrPath + "'";
    in attrByPath attrPath (abort errorMsg) set;

  /* Map each attribute in the given set and merge them into a new attribute set.

     Type:
       concatMapAttrs :: (String -> a -> AttrSet) -> AttrSet -> AttrSet

     Example:
       concatMapAttrs
         (name: value: {
           ${name} = value;
           ${name + value} = value;
         })
         { x = "a"; y = "b"; }
       => { x = "a"; xa = "a"; y = "b"; yb = "b"; }
  */
  concatMapAttrs = f: v:
    foldl' mergeAttrs { }
      (attrValues
        (mapAttrs f v)
      );


  /* Update or set specific paths of an attribute set.

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

     Example:
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

    Type: updateManyAttrsByPath :: [{ path :: [String]; update :: (Any -> Any); }] -> AttrSet -> AttrSet
  */
  updateManyAttrsByPath = let
    # When recursing into attributes, instead of updating the `path` of each
    # update using `tail`, which needs to allocate an entirely new list,
    # we just pass a prefix length to use and make sure to only look at the
    # path without the prefix length, so that we can reuse the original list
    # entries.
    go = prefixLength: hasValue: value: updates:
      let
        # Splits updates into ones on this level (split.right)
        # And ones on levels further down (split.wrong)
        split = partition (el: length el.path == prefixLength) updates;

        # Groups updates on further down levels into the attributes they modify
        nested = groupBy (el: elemAt el.path prefixLength) split.wrong;

        # Applies only nested modification to the input value
        withNestedMods =
          # Return the value directly if we don't have any nested modifications
          if split.wrong == [] then
            if hasValue then value
            else
              # Throw an error if there is no value. This `head` call here is
              # safe, but only in this branch since `go` could only be called
              # with `hasValue == false` for nested updates, in which case
              # it's also always called with at least one update
              let updatePath = (head split.right).path; in
              throw
              ( "updateManyAttrsByPath: Path '${showAttrPath updatePath}' does "
              + "not exist in the given value, but the first update to this "
              + "path tries to access the existing value.")
          else
            # If there are nested modifications, try to apply them to the value
            if ! hasValue then
              # But if we don't have a value, just use an empty attribute set
              # as the value, but simplify the code a bit
              mapAttrs (name: go (prefixLength + 1) false null) nested
            else if isAttrs value then
              # If we do have a value and it's an attribute set, override it
              # with the nested modifications
              value //
              mapAttrs (name: go (prefixLength + 1) (value ? ${name}) value.${name}) nested
            else
              # However if it's not an attribute set, we can't apply the nested
              # modifications, throw an error
              let updatePath = (head split.wrong).path; in
              throw
              ( "updateManyAttrsByPath: Path '${showAttrPath updatePath}' needs to "
              + "be updated, but path '${showAttrPath (take prefixLength updatePath)}' "
              + "of the given value is not an attribute set, so we can't "
              + "update an attribute inside of it.");

        # We get the final result by applying all the updates on this level
        # after having applied all the nested updates
        # We use foldl instead of foldl' so that in case of multiple updates,
        # intermediate values aren't evaluated if not needed
      in foldl (acc: el: el.update acc) withNestedMods split.right;

  in updates: value: go 0 true value updates;

  /* Return the specified attributes from a set.

     Example:
       attrVals ["a" "b" "c"] as
       => [as.a as.b as.c]

     Type:
       attrVals :: [String] -> AttrSet -> [Any]
  */
  attrVals =
    # The list of attributes to fetch from `set`. Each attribute name must exist on the attrbitue set
    nameList:
    # The set to get attribute values from
    set: map (x: set.${x}) nameList;


  /* Return the values of all attributes in the given set, sorted by
     attribute name.

     Example:
       attrValues {c = 3; a = 1; b = 2;}
       => [1 2 3]

     Type:
       attrValues :: AttrSet -> [Any]
  */
  attrValues = builtins.attrValues or (attrs: attrVals (attrNames attrs) attrs);


  /* Given a set of attribute names, return the set of the corresponding
     attributes from the given set.

     Example:
       getAttrs [ "a" "b" ] { a = 1; b = 2; c = 3; }
       => { a = 1; b = 2; }

     Type:
       getAttrs :: [String] -> AttrSet -> AttrSet
  */
  getAttrs =
    # A list of attribute names to get out of `set`
    names:
    # The set to get the named attributes from
    attrs: genAttrs names (name: attrs.${name});

  /* Collect each attribute named `attr` from a list of attribute
     sets.  Sets that don't contain the named attribute are ignored.

     Example:
       catAttrs "a" [{a = 1;} {b = 0;} {a = 2;}]
       => [1 2]

     Type:
       catAttrs :: String -> [AttrSet] -> [Any]
  */
  catAttrs = builtins.catAttrs or
    (attr: l: concatLists (map (s: if s ? ${attr} then [s.${attr}] else []) l));


  /* Filter an attribute set by removing all attributes for which the
     given predicate return false.

     Example:
       filterAttrs (n: v: n == "foo") { foo = 1; bar = 2; }
       => { foo = 1; }

     Type:
       filterAttrs :: (String -> Any -> Bool) -> AttrSet -> AttrSet
  */
  filterAttrs =
    # Predicate taking an attribute name and an attribute value, which returns `true` to include the attribute, or `false` to exclude the attribute.
    pred:
    # The attribute set to filter
    set:
    listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [(nameValuePair name v)] else []) (attrNames set));


  /* Filter an attribute set recursively by removing all attributes for
     which the given predicate return false.

     Example:
       filterAttrsRecursive (n: v: v != null) { foo = { bar = null; }; }
       => { foo = {}; }

     Type:
       filterAttrsRecursive :: (String -> Any -> Bool) -> AttrSet -> AttrSet
  */
  filterAttrsRecursive =
    # Predicate taking an attribute name and an attribute value, which returns `true` to include the attribute, or `false` to exclude the attribute.
    pred:
    # The attribute set to filter
    set:
    listToAttrs (
      concatMap (name:
        let v = set.${name}; in
        if pred name v then [
          (nameValuePair name (
            if isAttrs v then filterAttrsRecursive pred v
            else v
          ))
        ] else []
      ) (attrNames set)
    );

   /*
    Like [`lib.lists.foldl'`](#function-library-lib.lists.foldl-prime) but for attribute sets.
    Iterates over every name-value pair in the given attribute set.
    The result of the callback function is often called `acc` for accumulator. It is passed between callbacks from left to right and the final `acc` is the return value of `foldlAttrs`.

    Attention:
      There is a completely different function
      `lib.foldAttrs`
      which has nothing to do with this function, despite the similar name.

    Example:
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

    Type:
      foldlAttrs :: ( a -> String -> b -> a ) -> a -> { ... :: b } -> a
  */
  foldlAttrs = f: init: set:
    foldl'
      (acc: name: f acc name set.${name})
      init
      (attrNames set);

  /* Apply fold functions to values grouped by key.

     Example:
       foldAttrs (item: acc: [item] ++ acc) [] [{ a = 2; } { a = 3; }]
       => { a = [ 2 3 ]; }

     Type:
       foldAttrs :: (Any -> Any -> Any) -> Any -> [AttrSets] -> Any

  */
  foldAttrs =
    # A function, given a value and a collector combines the two.
    op:
    # The starting value.
    nul:
    # A list of attribute sets to fold together by key.
    list_of_attrs:
    foldr (n: a:
        foldr (name: o:
          o // { ${name} = op n.${name} (a.${name} or nul); }
        ) a (attrNames n)
    ) {} list_of_attrs;


  /* Recursively collect sets that verify a given predicate named `pred`
     from the set `attrs`.  The recursion is stopped when the predicate is
     verified.

     Example:
       collect isList { a = { b = ["b"]; }; c = [1]; }
       => [["b"] [1]]

       collect (x: x ? outPath)
          { a = { outPath = "a/"; }; b = { outPath = "b/"; }; }
       => [{ outPath = "a/"; } { outPath = "b/"; }]

     Type:
       collect :: (AttrSet -> Bool) -> AttrSet -> [x]
  */
  collect =
  # Given an attribute's value, determine if recursion should stop.
  pred:
  # The attribute set to recursively collect.
  attrs:
    if pred attrs then
      [ attrs ]
    else if isAttrs attrs then
      concatMap (collect pred) (attrValues attrs)
    else
      [];

  /* Return the cartesian product of attribute set value combinations.

    Example:
      cartesianProductOfSets { a = [ 1 2 ]; b = [ 10 20 ]; }
      => [
           { a = 1; b = 10; }
           { a = 1; b = 20; }
           { a = 2; b = 10; }
           { a = 2; b = 20; }
         ]
     Type:
       cartesianProductOfSets :: AttrSet -> [AttrSet]
  */
  cartesianProductOfSets =
    # Attribute set with attributes that are lists of values
    attrsOfLists:
    foldl' (listOfAttrs: attrName:
      concatMap (attrs:
        map (listValue: attrs // { ${attrName} = listValue; }) attrsOfLists.${attrName}
      ) listOfAttrs
    ) [{}] (attrNames attrsOfLists);


  /* Utility function that creates a `{name, value}` pair as expected by `builtins.listToAttrs`.

     Example:
       nameValuePair "some" 6
       => { name = "some"; value = 6; }

     Type:
       nameValuePair :: String -> Any -> { name :: String; value :: Any; }
  */
  nameValuePair =
    # Attribute name
    name:
    # Attribute value
    value:
    { inherit name value; };


  /* Apply a function to each element in an attribute set, creating a new attribute set.

     Example:
       mapAttrs (name: value: name + "-" + value)
          { x = "foo"; y = "bar"; }
       => { x = "x-foo"; y = "y-bar"; }

     Type:
       mapAttrs :: (String -> Any -> Any) -> AttrSet -> AttrSet
  */
  mapAttrs = builtins.mapAttrs or
    (f: set:
      listToAttrs (map (attr: { name = attr; value = f attr set.${attr}; }) (attrNames set)));


  /* Like `mapAttrs`, but allows the name of each attribute to be
     changed in addition to the value.  The applied function should
     return both the new name and value as a `nameValuePair`.

     Example:
       mapAttrs' (name: value: nameValuePair ("foo_" + name) ("bar-" + value))
          { x = "a"; y = "b"; }
       => { foo_x = "bar-a"; foo_y = "bar-b"; }

     Type:
       mapAttrs' :: (String -> Any -> { name :: String; value :: Any; }) -> AttrSet -> AttrSet
  */
  mapAttrs' =
    # A function, given an attribute's name and value, returns a new `nameValuePair`.
    f:
    # Attribute set to map over.
    set:
    listToAttrs (map (attr: f attr set.${attr}) (attrNames set));


  /* Call a function for each attribute in the given set and return
     the result in a list.

     Example:
       mapAttrsToList (name: value: name + value)
          { x = "a"; y = "b"; }
       => [ "xa" "yb" ]

     Type:
       mapAttrsToList :: (String -> a -> b) -> AttrSet -> [b]

  */
  mapAttrsToList =
    # A function, given an attribute's name and value, returns a new value.
    f:
    # Attribute set to map over.
    attrs:
    map (name: f name attrs.${name}) (attrNames attrs);

  /*
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

    Example:
      attrsToList { foo = 1; bar = "asdf"; }
      => [ { name = "bar"; value = "asdf"; } { name = "foo"; value = 1; } ]

    Type:
      attrsToList :: AttrSet -> [ { name :: String; value :: Any; } ]

  */
  attrsToList = mapAttrsToList nameValuePair;


  /* Like `mapAttrs`, except that it recursively applies itself to
     the *leaf* attributes of a potentially-nested attribute set:
     the second argument of the function will never be an attrset.
     Also, the first argument of the argument function is a *list*
     of the attribute names that form the path to the leaf attribute.

     For a function that gives you control over what counts as a leaf,
     see `mapAttrsRecursiveCond`.

     Example:
       mapAttrsRecursive (path: value: concatStringsSep "-" (path ++ [value]))
         { n = { a = "A"; m = { b = "B"; c = "C"; }; }; d = "D"; }
       => { n = { a = "n-a-A"; m = { b = "n-m-b-B"; c = "n-m-c-C"; }; }; d = "d-D"; }

     Type:
       mapAttrsRecursive :: ([String] -> a -> b) -> AttrSet -> AttrSet
  */
  mapAttrsRecursive =
    # A function, given a list of attribute names and a value, returns a new value.
    f:
    # Set to recursively map over.
    set:
    mapAttrsRecursiveCond (as: true) f set;


  /* Like `mapAttrsRecursive`, but it takes an additional predicate
     function that tells it whether to recurse into an attribute
     set.  If it returns false, `mapAttrsRecursiveCond` does not
     recurse, but does apply the map function.  If it returns true, it
     does recurse, and does not apply the map function.

     Example:
       # To prevent recursing into derivations (which are attribute
       # sets with the attribute "type" equal to "derivation"):
       mapAttrsRecursiveCond
         (as: !(as ? "type" && as.type == "derivation"))
         (x: ... do something ...)
         attrs

     Type:
       mapAttrsRecursiveCond :: (AttrSet -> Bool) -> ([String] -> a -> b) -> AttrSet -> AttrSet
  */
  mapAttrsRecursiveCond =
    # A function, given the attribute set the recursion is currently at, determine if to recurse deeper into that attribute set.
    cond:
    # A function, given a list of attribute names and a value, returns a new value.
    f:
    # Attribute set to recursively map over.
    set:
    let
      recurse = path:
        let
          g =
            name: value:
            if isAttrs value && cond value
              then recurse (path ++ [name]) value
              else f (path ++ [name]) value;
        in mapAttrs g;
    in recurse [] set;


  /* Generate an attribute set by mapping a function over a list of
     attribute names.

     Example:
       genAttrs [ "foo" "bar" ] (name: "x_" + name)
       => { foo = "x_foo"; bar = "x_bar"; }

     Type:
       genAttrs :: [ String ] -> (String -> Any) -> AttrSet
  */
  genAttrs =
    # Names of values in the resulting attribute set.
    names:
    # A function, given the name of the attribute, returns the attribute's value.
    f:
    listToAttrs (map (n: nameValuePair n (f n)) names);


  /* Check whether the argument is a derivation. Any set with
     `{ type = "derivation"; }` counts as a derivation.

     Example:
       nixpkgs = import <nixpkgs> {}
       isDerivation nixpkgs.ruby
       => true
       isDerivation "foobar"
       => false

     Type:
       isDerivation :: Any -> Bool
  */
  isDerivation =
    # Value to check.
    value: value.type or null == "derivation";

   /* Converts a store path to a fake derivation.

      Type:
        toDerivation :: Path -> Derivation
   */
   toDerivation =
     # A store path to convert to a derivation.
     path:
     let
       path' = builtins.storePath path;
       res =
         { type = "derivation";
           name = sanitizeDerivationName (builtins.substring 33 (-1) (baseNameOf path'));
           outPath = path';
           outputs = [ "out" ];
           out = res;
           outputName = "out";
         };
    in res;


  /* If `cond` is true, return the attribute set `as`,
     otherwise an empty attribute set.

     Example:
       optionalAttrs (true) { my = "set"; }
       => { my = "set"; }
       optionalAttrs (false) { my = "set"; }
       => { }

     Type:
       optionalAttrs :: Bool -> AttrSet -> AttrSet
  */
  optionalAttrs =
    # Condition under which the `as` attribute set is returned.
    cond:
    # The attribute set to return if `cond` is `true`.
    as:
    if cond then as else {};


  /* Merge sets of attributes and use the function `f` to merge attributes
     values.

     Example:
       zipAttrsWithNames ["a"] (name: vs: vs) [{a = "x";} {a = "y"; b = "z";}]
       => { a = ["x" "y"]; }

     Type:
       zipAttrsWithNames :: [ String ] -> (String -> [ Any ] -> Any) -> [ AttrSet ] -> AttrSet
  */
  zipAttrsWithNames =
    # List of attribute names to zip.
    names:
    # A function, accepts an attribute name, all the values, and returns a combined value.
    f:
    # List of values from the list of attribute sets.
    sets:
    listToAttrs (map (name: {
      inherit name;
      value = f name (catAttrs name sets);
    }) names);


  /* Merge sets of attributes and use the function f to merge attribute values.
     Like `lib.attrsets.zipAttrsWithNames` with all key names are passed for `names`.

     Implementation note: Common names appear multiple times in the list of
     names, hopefully this does not affect the system because the maximal
     laziness avoid computing twice the same expression and `listToAttrs` does
     not care about duplicated attribute names.

     Example:
       zipAttrsWith (name: values: values) [{a = "x";} {a = "y"; b = "z";}]
       => { a = ["x" "y"]; b = ["z"]; }

     Type:
       zipAttrsWith :: (String -> [ Any ] -> Any) -> [ AttrSet ] -> AttrSet
  */
  zipAttrsWith =
    builtins.zipAttrsWith or (f: sets: zipAttrsWithNames (concatMap attrNames sets) f sets);


  /* Merge sets of attributes and combine each attribute value in to a list.

     Like `lib.attrsets.zipAttrsWith` with `(name: values: values)` as the function.

     Example:
       zipAttrs [{a = "x";} {a = "y"; b = "z";}]
       => { a = ["x" "y"]; b = ["z"]; }

     Type:
       zipAttrs :: [ AttrSet ] -> AttrSet
  */
  zipAttrs =
    # List of attribute sets to zip together.
    sets:
    zipAttrsWith (name: values: values) sets;

  /*
    Merge a list of attribute sets together using the `//` operator.
    In case of duplicate attributes, values from later list elements take precedence over earlier ones.
    The result is the same as `foldl mergeAttrs { }`, but the performance is better for large inputs.
    For n list elements, each with an attribute set containing m unique attributes, the complexity of this operation is O(nm log n).

    Type:
      mergeAttrsList :: [ Attrs ] -> Attrs

    Example:
      mergeAttrsList [ { a = 0; b = 1; } { c = 2; d = 3; } ]
      => { a = 0; b = 1; c = 2; d = 3; }
      mergeAttrsList [ { a = 0; } { a = 1; } ]
      => { a = 1; }
  */
  mergeAttrsList = list:
    let
      # `binaryMerge start end` merges the elements at indices `index` of `list` such that `start <= index < end`
      # Type: Int -> Int -> Attrs
      binaryMerge = start: end:
        # assert start < end; # Invariant
        if end - start >= 2 then
          # If there's at least 2 elements, split the range in two, recurse on each part and merge the result
          # The invariant is satisfied because each half will have at least 1 element
          binaryMerge start (start + (end - start) / 2)
          // binaryMerge (start + (end - start) / 2) end
        else
          # Otherwise there will be exactly 1 element due to the invariant, in which case we just return it directly
          elemAt list start;
    in
    if list == [ ] then
      # Calling binaryMerge as below would not satisfy its invariant
      { }
    else
      binaryMerge 0 (length list);


  /* Does the same as the update operator '//' except that attributes are
     merged until the given predicate is verified.  The predicate should
     accept 3 arguments which are the path to reach the attribute, a part of
     the first attribute set and a part of the second attribute set.  When
     the predicate is satisfied, the value of the first attribute set is
     replaced by the value of the second attribute set.

     Example:
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

     Type:
       recursiveUpdateUntil :: ( [ String ] -> AttrSet -> AttrSet -> Bool ) -> AttrSet -> AttrSet -> AttrSet
  */
  recursiveUpdateUntil =
    # Predicate, taking the path to the current attribute as a list of strings for attribute names, and the two values at that path from the original arguments.
    pred:
    # Left attribute set of the merge.
    lhs:
    # Right attribute set of the merge.
    rhs:
    let f = attrPath:
      zipAttrsWith (n: values:
        let here = attrPath ++ [n]; in
        if length values == 1
        || pred here (elemAt values 1) (head values) then
          head values
        else
          f here values
      );
    in f [] [rhs lhs];


  /* A recursive variant of the update operator ‘//’.  The recursion
     stops when one of the attribute values is not an attribute set,
     in which case the right hand side value takes precedence over the
     left hand side value.

     Example:
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

     Type:
       recursiveUpdate :: AttrSet -> AttrSet -> AttrSet
  */
  recursiveUpdate =
    # Left attribute set of the merge.
    lhs:
    # Right attribute set of the merge.
    rhs:
    recursiveUpdateUntil (path: lhs: rhs: !(isAttrs lhs && isAttrs rhs)) lhs rhs;


  /*
    Recurse into every attribute set of the first argument and check that:
    - Each attribute path also exists in the second argument.
    - If the attribute's value is not a nested attribute set, it must have the same value in the right argument.

     Example:
       matchAttrs { cpu = {}; } { cpu = { bits = 64; }; }
       => true

     Type:
       matchAttrs :: AttrSet -> AttrSet -> Bool
  */
  matchAttrs =
    # Attribute set structure to match
    pattern:
    # Attribute set to check
    attrs:
    assert isAttrs pattern;
    all
    ( # Compare equality between `pattern` & `attrs`.
      attr:
      # Missing attr, not equal.
      attrs ? ${attr} && (
        let
          lhs = pattern.${attr};
          rhs = attrs.${attr};
        in
        # If attrset check recursively
        if isAttrs lhs then isAttrs rhs && matchAttrs lhs rhs
        else lhs == rhs
      )
    )
    (attrNames pattern);

  /* Override only the attributes that are already present in the old set
    useful for deep-overriding.

    Example:
      overrideExisting {} { a = 1; }
      => {}
      overrideExisting { b = 2; } { a = 1; }
      => { b = 2; }
      overrideExisting { a = 3; b = 2; } { a = 1; }
      => { a = 1; b = 2; }

    Type:
      overrideExisting :: AttrSet -> AttrSet -> AttrSet
  */
  overrideExisting =
    # Original attribute set
    old:
    # Attribute set with attributes to override in `old`.
    new:
    mapAttrs (name: value: new.${name} or value) old;


  /* Turns a list of strings into a human-readable description of those
    strings represented as an attribute path. The result of this function is
    not intended to be machine-readable.
    Create a new attribute set with `value` set at the nested attribute location specified in `attrPath`.

    Example:
      showAttrPath [ "foo" "10" "bar" ]
      => "foo.\"10\".bar"
      showAttrPath []
      => "<root attribute path>"

    Type:
      showAttrPath :: [String] -> String
  */
  showAttrPath =
    # Attribute path to render to a string
    path:
    if path == [] then "<root attribute path>"
    else concatMapStringsSep "." escapeNixIdentifier path;


  /* Get a package output.
     If no output is found, fallback to `.out` and then to the default.

     Example:
       getOutput "dev" pkgs.openssl
       => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev"

     Type:
       getOutput :: String -> Derivation -> String
  */
  getOutput = output: pkg:
    if ! pkg ? outputSpecified || ! pkg.outputSpecified
      then pkg.${output} or pkg.out or pkg
      else pkg;

  /* Get a package's `bin` output.
     If the output does not exist, fallback to `.out` and then to the default.

     Example:
       getBin pkgs.openssl
       => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r"

     Type:
       getBin :: Derivation -> String
  */
  getBin = getOutput "bin";


  /* Get a package's `lib` output.
     If the output does not exist, fallback to `.out` and then to the default.

     Example:
       getLib pkgs.openssl
       => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-lib"

     Type:
       getLib :: Derivation -> String
  */
  getLib = getOutput "lib";


  /* Get a package's `dev` output.
     If the output does not exist, fallback to `.out` and then to the default.

     Example:
       getDev pkgs.openssl
       => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev"

     Type:
       getDev :: Derivation -> String
  */
  getDev = getOutput "dev";


  /* Get a package's `man` output.
     If the output does not exist, fallback to `.out` and then to the default.

     Example:
       getMan pkgs.openssl
       => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-man"

     Type:
       getMan :: Derivation -> String
  */
  getMan = getOutput "man";

  /* Pick the outputs of packages to place in `buildInputs`

   Type: chooseDevOutputs :: [Derivation] -> [String]

  */
  chooseDevOutputs =
    # List of packages to pick `dev` outputs from
    drvs:
    builtins.map getDev drvs;

  /* Make various Nix tools consider the contents of the resulting
     attribute set when looking for what to build, find, etc.

     This function only affects a single attribute set; it does not
     apply itself recursively for nested attribute sets.

     Example:
       { pkgs ? import <nixpkgs> {} }:
       {
         myTools = pkgs.lib.recurseIntoAttrs {
           inherit (pkgs) hello figlet;
         };
       }

     Type:
       recurseIntoAttrs :: AttrSet -> AttrSet

   */
  recurseIntoAttrs =
    # An attribute set to scan for derivations.
    attrs:
    attrs // { recurseForDerivations = true; };

  /* Undo the effect of recurseIntoAttrs.

     Type:
       dontRecurseIntoAttrs :: AttrSet -> AttrSet
   */
  dontRecurseIntoAttrs =
    # An attribute set to not scan for derivations.
    attrs:
    attrs // { recurseForDerivations = false; };

  /* `unionOfDisjoint x y` is equal to `x // y // z` where the
     attrnames in `z` are the intersection of the attrnames in `x` and
     `y`, and all values `assert` with an error message.  This
      operator is commutative, unlike (//).

     Type: unionOfDisjoint :: AttrSet -> AttrSet -> AttrSet
  */
  unionOfDisjoint = x: y:
    let
      intersection = builtins.intersectAttrs x y;
      collisions = lib.concatStringsSep " " (builtins.attrNames intersection);
      mask = builtins.mapAttrs (name: value: builtins.throw
        "unionOfDisjoint: collision on ${name}; complete list: ${collisions}")
        intersection;
    in
      (x // y) // mask;

  # DEPRECATED
  zipWithNames = zipAttrsWithNames;

  # DEPRECATED
  zip = builtins.trace
    "lib.zip is deprecated, use lib.zipAttrsWith instead" zipAttrsWith;
}
