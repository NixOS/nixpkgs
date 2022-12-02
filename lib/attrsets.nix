{ lib }:
# Operations on attribute sets.

let
  inherit (builtins) head tail length;
  inherit (lib.trivial) flip id mergeAttrs pipe;
  inherit (lib.strings) concatStringsSep concatMapStringsSep escapeNixIdentifier sanitizeDerivationName;
  inherit (lib.lists) foldr foldl' concatMap concatLists elemAt all partition groupBy take foldl;
in

rec {
  inherit (builtins) attrNames listToAttrs hasAttr isAttrs getAttr;


  /* Return an attribute from nested attribute sets.

     Example:
       x = { a = { b = 3; }; }
       attrByPath ["a" "b"] 6 x
       => 3
       attrByPath ["z" "z"] 6 x
       => 6
  */
  attrByPath = attrPath: default: e:
    let attr = head attrPath;
    in
      if attrPath == [] then e
      else if e ? ${attr}
      then attrByPath (tail attrPath) default e.${attr}
      else default;

  /* Return if an attribute from nested attribute set exists.

     Example:
       x = { a = { b = 3; }; }
       hasAttrByPath ["a" "b"] x
       => true
       hasAttrByPath ["z" "z"] x
       => false

  */
  hasAttrByPath = attrPath: e:
    let attr = head attrPath;
    in
      if attrPath == [] then true
      else if e ? ${attr}
      then hasAttrByPath (tail attrPath) e.${attr}
      else false;


  /* Return nested attribute set in which an attribute is set.

     Example:
       setAttrByPath ["a" "b"] 3
       => { a = { b = 3; }; }
  */
  setAttrByPath = attrPath: value:
    let
      len = length attrPath;
      atDepth = n:
        if n == len
        then value
        else { ${elemAt attrPath n} = atDepth (n + 1); };
    in atDepth 0;

  /* Like `attrByPath' without a default value. If it doesn't find the
     path it will throw.

     Example:
       x = { a = { b = 3; }; }
       getAttrFromPath ["a" "b"] x
       => 3
       getAttrFromPath ["z" "z"] x
       => error: cannot find attribute `z.z'
  */
  getAttrFromPath = attrPath:
    let errorMsg = "cannot find attribute `" + concatStringsSep "." attrPath + "'";
    in attrByPath attrPath (abort errorMsg);

  /* Map each attribute in the given set and merge them into a new attribute set.

     Type:
       concatMapAttrs ::
         (String -> a -> AttrSet)
         -> AttrSet
         -> AttrSet

     Example:
       concatMapAttrs
         (name: value: {
           ${name} = value;
           ${name + value} = value;
         })
         { x = "a"; y = "b"; }
       => { x = "a"; xa = "a"; y = "b"; yb = "b"; }
  */
  concatMapAttrs = f: flip pipe [ (mapAttrs f) attrValues (foldl' mergeAttrs { }) ];


  /* Update or set specific paths of an attribute set.

     Takes a list of updates to apply and an attribute set to apply them to,
     and returns the attribute set with the updates applied. Updates are
     represented as { path = ...; update = ...; } values, where `path` is a
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
  */
  attrVals = nameList: set: map (x: set.${x}) nameList;


  /* Return the values of all attributes in the given set, sorted by
     attribute name.

     Example:
       attrValues {c = 3; a = 1; b = 2;}
       => [1 2 3]
  */
  attrValues = builtins.attrValues or (attrs: attrVals (attrNames attrs) attrs);


  /* Given a set of attribute names, return the set of the corresponding
     attributes from the given set.

     Example:
       getAttrs [ "a" "b" ] { a = 1; b = 2; c = 3; }
       => { a = 1; b = 2; }
  */
  getAttrs = names: attrs: genAttrs names (name: attrs.${name});

  /* Collect each attribute named `attr' from a list of attribute
     sets.  Sets that don't contain the named attribute are ignored.

     Example:
       catAttrs "a" [{a = 1;} {b = 0;} {a = 2;}]
       => [1 2]
  */
  catAttrs = builtins.catAttrs or
    (attr: l: concatLists (map (s: if s ? ${attr} then [s.${attr}] else []) l));


  /* Filter an attribute set by removing all attributes for which the
     given predicate return false.

     Example:
       filterAttrs (n: v: n == "foo") { foo = 1; bar = 2; }
       => { foo = 1; }
  */
  filterAttrs = pred: set:
    listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [(nameValuePair name v)] else []) (attrNames set));


  /* Filter an attribute set recursively by removing all attributes for
     which the given predicate return false.

     Example:
       filterAttrsRecursive (n: v: v != null) { foo = { bar = null; }; }
       => { foo = {}; }
  */
  filterAttrsRecursive = pred: set:
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

  /* Apply fold functions to values grouped by key.

     Example:
       foldAttrs (item: acc: [item] ++ acc) [] [{ a = 2; } { a = 3; }]
       => { a = [ 2 3 ]; }
  */
  foldAttrs = op: nul:
    foldr (n: a:
        foldr (name: o:
          o // { ${name} = op n.${name} (a.${name} or nul); }
        ) a (attrNames n)
    ) {};


  /* Recursively collect sets that verify a given predicate named `pred'
     from the set `attrs'.  The recursion is stopped when the predicate is
     verified.

     Type:
       collect ::
         (AttrSet -> Bool) -> AttrSet -> [x]

     Example:
       collect isList { a = { b = ["b"]; }; c = [1]; }
       => [["b"] [1]]

       collect (x: x ? outPath)
          { a = { outPath = "a/"; }; b = { outPath = "b/"; }; }
       => [{ outPath = "a/"; } { outPath = "b/"; }]
  */
  collect = pred: attrs:
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
  */
  cartesianProductOfSets = attrsOfLists:
    foldl' (listOfAttrs: attrName:
      concatMap (attrs:
        map (listValue: attrs // { ${attrName} = listValue; }) attrsOfLists.${attrName}
      ) listOfAttrs
    ) [{}] (attrNames attrsOfLists);


  /* Utility function that creates a {name, value} pair as expected by
     builtins.listToAttrs.

     Example:
       nameValuePair "some" 6
       => { name = "some"; value = 6; }
  */
  nameValuePair = name: value: { inherit name value; };


  /* Apply a function to each element in an attribute set.  The
     function takes two arguments --- the attribute name and its value
     --- and returns the new value for the attribute.  The result is a
     new attribute set.

     Example:
       mapAttrs (name: value: name + "-" + value)
          { x = "foo"; y = "bar"; }
       => { x = "x-foo"; y = "y-bar"; }
  */
  mapAttrs = builtins.mapAttrs or
    (f: set:
      listToAttrs (map (attr: { name = attr; value = f attr set.${attr}; }) (attrNames set)));


  /* Like `mapAttrs', but allows the name of each attribute to be
     changed in addition to the value.  The applied function should
     return both the new name and value as a `nameValuePair'.

     Example:
       mapAttrs' (name: value: nameValuePair ("foo_" + name) ("bar-" + value))
          { x = "a"; y = "b"; }
       => { foo_x = "bar-a"; foo_y = "bar-b"; }
  */
  mapAttrs' = f: set:
    listToAttrs (map (attr: f attr set.${attr}) (attrNames set));


  /* Call a function for each attribute in the given set and return
     the result in a list.

     Type:
       mapAttrsToList ::
         (String -> a -> b) -> AttrSet -> [b]

     Example:
       mapAttrsToList (name: value: name + value)
          { x = "a"; y = "b"; }
       => [ "xa" "yb" ]
  */
  mapAttrsToList = f: attrs:
    map (name: f name attrs.${name}) (attrNames attrs);


  /* Like `mapAttrs', except that it recursively applies itself to
     attribute sets.  Also, the first argument of the argument
     function is a *list* of the names of the containing attributes.

     Type:
       mapAttrsRecursive ::
         ([String] -> a -> b) -> AttrSet -> AttrSet

     Example:
       mapAttrsRecursive (path: value: concatStringsSep "-" (path ++ [value]))
         { n = { a = "A"; m = { b = "B"; c = "C"; }; }; d = "D"; }
       => { n = { a = "n-a-A"; m = { b = "n-m-b-B"; c = "n-m-c-C"; }; }; d = "d-D"; }
  */
  mapAttrsRecursive = mapAttrsRecursiveCond (as: true);


  /* Like `mapAttrsRecursive', but it takes an additional predicate
     function that tells it whether to recurse into an attribute
     set.  If it returns false, `mapAttrsRecursiveCond' does not
     recurse, but does apply the map function.  If it returns true, it
     does recurse, and does not apply the map function.

     Type:
       mapAttrsRecursiveCond ::
         (AttrSet -> Bool) -> ([String] -> a -> b) -> AttrSet -> AttrSet

     Example:
       # To prevent recursing into derivations (which are attribute
       # sets with the attribute "type" equal to "derivation"):
       mapAttrsRecursiveCond
         (as: !(as ? "type" && as.type == "derivation"))
         (x: ... do something ...)
         attrs
  */
  mapAttrsRecursiveCond = cond: f: set:
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
  */
  genAttrs = names: f:
    listToAttrs (map (n: nameValuePair n (f n)) names);


  /* Check whether the argument is a derivation. Any set with
     { type = "derivation"; } counts as a derivation.

     Example:
       nixpkgs = import <nixpkgs> {}
       isDerivation nixpkgs.ruby
       => true
       isDerivation "foobar"
       => false
  */
  isDerivation = x: x.type or null == "derivation";

  /* Converts a store path to a fake derivation. */
  toDerivation = path:
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


  /* If `cond' is true, return the attribute set `as',
     otherwise an empty attribute set.

     Example:
       optionalAttrs (true) { my = "set"; }
       => { my = "set"; }
       optionalAttrs (false) { my = "set"; }
       => { }
  */
  optionalAttrs = cond: as: if cond then as else {};


  /* Merge sets of attributes and use the function f to merge attributes
     values.

     Example:
       zipAttrsWithNames ["a"] (name: vs: vs) [{a = "x";} {a = "y"; b = "z";}]
       => { a = ["x" "y"]; }
  */
  zipAttrsWithNames = names: f: sets:
    listToAttrs (map (name: {
      inherit name;
      value = f name (catAttrs name sets);
    }) names);

  /* Implementation note: Common names appear multiple times in the list of
     names, hopefully this does not affect the system because the maximal
     laziness avoid computing twice the same expression and listToAttrs does
     not care about duplicated attribute names.

     Example:
       zipAttrsWith (name: values: values) [{a = "x";} {a = "y"; b = "z";}]
       => { a = ["x" "y"]; b = ["z"] }
  */
  zipAttrsWith =
    builtins.zipAttrsWith or (f: sets: zipAttrsWithNames (concatMap attrNames sets) f sets);
  /* Like `zipAttrsWith' with `(name: values: values)' as the function.

    Example:
      zipAttrs [{a = "x";} {a = "y"; b = "z";}]
      => { a = ["x" "y"]; b = ["z"] }
  */
  zipAttrs = zipAttrsWith (name: values: values);

  /* Does the same as the update operator '//' except that attributes are
     merged until the given predicate is verified.  The predicate should
     accept 3 arguments which are the path to reach the attribute, a part of
     the first attribute set and a part of the second attribute set.  When
     the predicate is verified, the value of the first attribute set is
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

       returns: {
         foo.bar = 1; # 'foo.*' from the second set
         foo.quz = 2; #
         bar = 3;     # 'bar' from the first set
         baz = 4;     # 'baz' from the second set
       }

     */
  recursiveUpdateUntil = pred: lhs: rhs:
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

     */
  recursiveUpdate = recursiveUpdateUntil (path: lhs: rhs: !(isAttrs lhs && isAttrs rhs));

  /* Returns true if the pattern is contained in the set. False otherwise.

     Example:
       matchAttrs { cpu = {}; } { cpu = { bits = 64; }; }
       => true
   */
  matchAttrs = pattern: attrs: assert isAttrs pattern;
    all id (attrValues (zipAttrsWithNames (attrNames pattern) (n: values:
      let pat = head values; val = elemAt values 1; in
      if length values == 1 then false
      else if isAttrs pat then isAttrs val && matchAttrs pat val
      else pat == val
    ) [pattern attrs]));

  /* Override only the attributes that are already present in the old set
    useful for deep-overriding.

    Example:
      overrideExisting {} { a = 1; }
      => {}
      overrideExisting { b = 2; } { a = 1; }
      => { b = 2; }
      overrideExisting { a = 3; b = 2; } { a = 1; }
      => { a = 1; b = 2; }
  */
  overrideExisting = old: new:
    mapAttrs (name: value: new.${name} or value) old;

  /* Turns a list of strings into a human-readable description of those
    strings represented as an attribute path. The result of this function is
    not intended to be machine-readable.

    Example:
      showAttrPath [ "foo" "10" "bar" ]
      => "foo.\"10\".bar"
      showAttrPath []
      => "<root attribute path>"
  */
  showAttrPath = path:
    if path == [] then "<root attribute path>"
    else concatMapStringsSep "." escapeNixIdentifier path;

  /* Get a package output.
     If no output is found, fallback to `.out` and then to the default.

     Example:
       getOutput "dev" pkgs.openssl
       => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev"
  */
  getOutput = output: pkg:
    if ! pkg ? outputSpecified || ! pkg.outputSpecified
      then pkg.${output} or pkg.out or pkg
      else pkg;

  getBin = getOutput "bin";
  getLib = getOutput "lib";
  getDev = getOutput "dev";
  getMan = getOutput "man";

  /* Pick the outputs of packages to place in buildInputs */
  chooseDevOutputs = builtins.map getDev;

  /* Make various Nix tools consider the contents of the resulting
     attribute set when looking for what to build, find, etc.

     This function only affects a single attribute set; it does not
     apply itself recursively for nested attribute sets.
   */
  recurseIntoAttrs =
    attrs: attrs // { recurseForDerivations = true; };

  /* Undo the effect of recurseIntoAttrs.
   */
  dontRecurseIntoAttrs =
    attrs: attrs // { recurseForDerivations = false; };

  /* `unionOfDisjoint x y` is equal to `x // y // z` where the
     attrnames in `z` are the intersection of the attrnames in `x` and
     `y`, and all values `assert` with an error message.  This
      operator is commutative, unlike (//). */
  unionOfDisjoint = x: y:
    let
      intersection = builtins.intersectAttrs x y;
      collisions = lib.concatStringsSep " " (builtins.attrNames intersection);
      mask = builtins.mapAttrs (name: value: builtins.throw
        "unionOfDisjoint: collision on ${name}; complete list: ${collisions}")
        intersection;
    in
      (x // y) // mask;

  /*** deprecated stuff ***/

  zipWithNames = zipAttrsWithNames;
  zip = builtins.trace
    "lib.zip is deprecated, use lib.zipAttrsWith instead" zipAttrsWith;
}
