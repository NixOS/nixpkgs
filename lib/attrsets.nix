{ lib }:
# Operations on attribute sets.

let
  inherit (builtins) head tail length;
  inherit (lib.trivial) and;
  inherit (lib.strings) concatStringsSep sanitizeDerivationName;
  inherit (lib.lists) fold concatMap concatLists;
in

rec {
  inherit (builtins) attrNames listToAttrs hasAttr isAttrs getAttr;


  /* Return an attribute from nested attribute sets.

     Type:
       attrByPath :: [String] -> Any -> AttrSet -> Any

     Example:
       x = { a = { b = 3; }; }
       attrByPath ["a" "b"] 6 x
       => 3
       attrByPath ["z" "z"] 6 x
       => 6
  */
  attrByPath =
    # A list of strings representing the path through the nested attribute set `set`
    attrPath:
    # Default value if `attrPath` does not resolve to an existing value
    default:
    # The nested attributeset to select values from
    e:
    let attr = head attrPath;
    in
      if attrPath == [] then e
      else if e ? ${attr}
      then attrByPath (tail attrPath) default e.${attr}
      else default;

  /* Return if an attribute from nested attribute set exists.

     Type:
       hasAttrByPath :: [String] -> AttrSet -> Bool

     Example:
       x = { a = { b = 3; }; }
       hasAttrByPath ["a" "b"] x
       => true
       hasAttrByPath ["z" "z"] x
       => false
  */
  hasAttrByPath =
    # A list of strings representing the path through the nested attribute set `set`
    attrPath:
    # The nested attributeset to check
    e:
    let attr = head attrPath;
    in
      if attrPath == [] then true
      else if e ? ${attr}
      then hasAttrByPath (tail attrPath) e.${attr}
      else false;


  /* Return nested attribute set in which an attribute is set.

     Type:
       setAttrByPath :: [String] -> Any -> AttrSet

     Example:
       setAttrByPath ["a" "b"] 3
       => { a = { b = 3; }; }
  */
  setAttrByPath =
    # A list of strings representing the path through the nested attribute set
    attrPath:
    # The value to set at the location described by `attrPath`
    value:
    if attrPath == [] then value
    else listToAttrs
      [ { name = head attrPath; value = setAttrByPath (tail attrPath) value; } ];


  /* Like `attrByPath` without a default value. If it doesn't find the
     path it will throw.

     Type:
       getAttrFromPath :: [String] -> AttrSet -> Value

     Example:
       x = { a = { b = 3; }; }
       getAttrFromPath ["a" "b"] x
       => 3
       getAttrFromPath ["z" "z"] x
       => error: cannot find attribute `z.z'
  */
  getAttrFromPath =
    # A list of strings representing the path through the nested attribute set `set`
    attrPath:
    # The nested attribute set to find the value in
    set:
    let errorMsg = "cannot find attribute `" + concatStringsSep "." attrPath + "'";
    in attrByPath attrPath (abort errorMsg) set;


  /* Return the specified attributes from a set.

     Type:
       attrVals :: [String] -> AttrSet -> [Any]

     Example:
       attrVals ["a" "b" "c"] as
       => [as.a as.b as.c]
  */
  attrVals =
    # The list of attributes to fetch from `set`. Each attribute name must exist on the attrbitue set
    nameList:
    # The set to get attribute values from
    set: map (x: set.${x}) nameList;


  /* Return the values of all attributes in the given set, sorted by
     attribute name.

     Type:
       attrValues :: AttrSet -> [Any]

     Example:
       attrValues {c = 3; a = 1; b = 2;}
       => [1 2 3]
  */
  attrValues = builtins.attrValues or (attrs: attrVals (attrNames attrs) attrs);


  /* Given a set of attribute names, return the set of the corresponding
     attributes from the given set.

     Type:
       getAttrs :: [String] -> AttrSet -> AttrSet

     Example:
       getAttrs [ "a" "b" ] { a = 1; b = 2; c = 3; }
       => { a = 1; b = 2; }
  */
  getAttrs =
    # A list of attribute names to get out of `set`
    names:
    # The set to get the named attributes from
    attrs: genAttrs names (name: attrs.${name});

  /* Collect each attribute named `attr` from a list of attribute
     sets.  Sets that don't contain the named attribute are ignored.

     Type:
       catAttrs :: String -> [AttrSet] -> [Any]

     Example:
       catAttrs "a" [{a = 1;} {b = 0;} {a = 2;}]
       => [1 2]
  */
  catAttrs = builtins.catAttrs or
    (attr: l: concatLists (map (s: if s ? ${attr} then [s.${attr}] else []) l));


  /* Filter an attribute set by removing all attributes for which the
     given predicate return false.

     Type:
       filterAttrs :: (String -> Any -> Bool) -> AttrSet -> AttrSet

     Example:
       filterAttrs (n: v: n == "foo") { foo = 1; bar = 2; }
       => { foo = 1; }
  */
  filterAttrs =
    # A predicate function that takes the attribute's name (`name`) and the attribute's value (`value`), and returns `true` to include the attribute or `false` to exclude the attribute.
    pred:
    # The attribute set to filter
    set:
    listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [(nameValuePair name v)] else []) (attrNames set));


  /* Filter an attribute set recursively by removing all attributes for
     which the given predicate return false.

     Type:
       filterAttrsRecursive :: (String -> Any -> Bool) -> AttrSet -> AttrSet

     Example:
       filterAttrsRecursive (n: v: v != null) { foo = { bar = null; }; }
       => { foo = {}; }
  */
  filterAttrsRecursive =
    # A predicate function that takes the attribute's name (`name`) and the attribute's value (`value`), and returns `true` to include the attribute or `false` to exclude the attribute.
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

  /* Apply fold functions to values grouped by key.

     Type:
       foldAttrs :: (Any -> Any -> Any) -> Any -> [AttrSets] -> Any

     Example:
       foldAttrs (n: a: [n] ++ a) [] [{ a = 2; } { a = 3; }]
       => { a = [ 2 3 ]; }
  */
  foldAttrs =
    # A function that takes a value and an accumulator, and returns the an updated accumulator.
    op:
    # The starting accumulator value
    nul:
    # A list of attribute sets to fold together by key
    list_of_attrs:
    fold (n: a:
        fold (name: o:
          o // { ${name} = op n.${name} (a.${name} or nul); }
        ) a (attrNames n)
    ) {} list_of_attrs;


  /* Recursively collect values that verify a given predicate named `pred`
     from the set `attrs'.  The recursion is stopped when the predicate is
     verified.

     Type:
       collect :: (Any -> Bool) -> AttrSet -> [x]

     Example:
       collect isList { a = { b = ["b"]; }; c = [1]; }
       => [["b"] [1]]

       collect (x: x ? outPath)
          { a = { outPath = "a/"; }; b = { outPath = "b/"; }; }
       => [{ outPath = "a/"; } { outPath = "b/"; }]
  */
  collect =
    # A predicate function that takes an attributes value `attrs`, and returns `true` if the value should be collected, or `false` if the recursive descent should continue.
    pred:
    # An attrset
    attrs:
    if pred attrs then
      [ attrs ]
    else if isAttrs attrs then
      concatMap (collect pred) (attrValues attrs)
    else
      [];

  /* Return the cartesian product of attribute set value combinations.

    Type:
      cartesianProductOfSets :: AttrSet -> [AttrSet]

    Example:
      cartesianProductOfSets { a = [ 1 2 ]; b = [ 10 20 ]; }
      => [
           { a = 1; b = 10; }
           { a = 1; b = 20; }
           { a = 2; b = 10; }
           { a = 2; b = 20; }
         ]
  */
  cartesianProductOfSets =
    # An attribute set whose values are all lists
    attrsOfLists:
    lib.foldl' (listOfAttrs: attrName:
      concatMap (attrs:
        map (listValue: attrs // { ${attrName} = listValue; }) attrsOfLists.${attrName}
      ) listOfAttrs
    ) [{}] (attrNames attrsOfLists);


  /* Utility function that creates a {name, value} pair as expected by
     builtins.listToAttrs.

     Type:
       nameValuePair :: String -> Any -> AttrSet

     Example:
       nameValuePair "some" 6
       => { name = "some"; value = 6; }
  */
  nameValuePair =
    # The attribute name
    name:
    # The attribute value
    value: { inherit name value; };


  /* Apply a function to each element in an attribute set.  The
     function takes two arguments --- the attribute name and its value
     --- and returns the new value for the attribute.  The result is a
     new attribute set.

     Type:
       mapAttrs :: (String -> Any -> Any) -> AttrSet -> AttrSet

     Example:
       mapAttrs (name: value: name + "-" + value)
          { x = "foo"; y = "bar"; }
       => { x = "x-foo"; y = "y-bar"; }
  */
  mapAttrs = builtins.mapAttrs or
    (f: set:
      listToAttrs (map (attr: { name = attr; value = f attr set.${attr}; }) (attrNames set)));


  /* Like `mapAttrs`, but allows the name of each attribute to be
     changed in addition to the value.  The applied function should
     return both the new name and value as a `nameValuePair`.

     Type:
       mapAttrs' :: (String -> Any -> { name = String; value = Any }) -> AttrSet -> AttrSet 

     Example:
       mapAttrs' (name: value: nameValuePair ("foo_" + name) ("bar-" + value))
          { x = "a"; y = "b"; }
       => { foo_x = "bar-a"; foo_y = "bar-b"; }
  */
  mapAttrs' =
    # A function when given an attribute's name and value, returns a new [name-value pair](#function-library-lib.attrsets.nameValuePair)
    f:
    # The attribute set to map over
    set:
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
  mapAttrsToList =
    # A function when given an attribute's name and value, returns a new value
    f:
    # The attribute set to map over
    attrs:
    map (name: f name attrs.${name}) (attrNames attrs);


  /* Like `mapAttrs`, except that it recursively applies itself to
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


  /* Like `mapAttrsRecursive`, but it takes an additional predicate
     function that tells it whether to recursive into an attribute
     set.  If it returns false, `mapAttrsRecursiveCond` does not
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
  mapAttrsRecursiveCond =
    # A function when given an attribute set, returns `true` if it should recurse deeper and `false` if the attrset should be applied to `f`
    cond:
    # A function given a list of attribute names, `name_path` and a value, returns a new value
    f:
    # The attribute set to recursively map over
    set:
    let
      recurse = path: set:
        let
          g =
            name: value:
            if isAttrs value && cond value
              then recurse (path ++ [name]) value
              else f (path ++ [name]) value;
        in mapAttrs g set;
    in recurse [] set;


  /* Generate an attribute set by mapping a function over a list of
     attribute names.

     Type:
       genAttrs :: [ String ] -> (String -> Any) -> AttrSet

     Example:
       genAttrs [ "foo" "bar" ] (name: "x_" + name)
       => { foo = "x_foo"; bar = "x_bar"; }
  */
  genAttrs =
    # Names of values int he resulting attribute set
    names:
    # A function that takes the name of the attribute set and returns the attribute's value
    f:
    listToAttrs (map (n: nameValuePair n (f n)) names);


  /* Check whether the argument is a derivation. Any set with
     { type = "derivation"; } counts as a derivation.

     Type:
       isDerivation :: Any -> Bool

     Example:
       nixpkgs = import <nixpkgs> {}
       isDerivation nixpkgs.ruby
       => true
       isDerivation "foobar"
       => false
  */
  isDerivation =
    # The value which is possibly a derivation
    x: isAttrs x && x ? type && x.type == "derivation";

  /* Converts a store path to a fake derivation.

     Type:
       toDerivation :: Path -> Derivation
  */
  toDerivation =
    # A store path to convert to a derivation
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

     Type:
       optionalAttrs :: Bool -> AttrSet

     Example:
       optionalAttrs (true) { my = "set"; }
       => { my = "set"; }
       optionalAttrs (false) { my = "set"; }
       => { }
  */
  optionalAttrs =
    # Condition under which the `as` attribute set is returned
    cond:
    # The attribute set to return if `cond` is true
    as: if cond then as else {};


  /* Merge sets of attributes and use the function f to merge attributes
     values.

     Type:
       zipAttrsWithNames :: [ String ] -> (String -> [ Any ] -> Any) -> [ AttrSet ] -> AttrSet

     Example:
       zipAttrsWithNames ["a"] (name: vs: vs) [{a = "x";} {a = "y"; b = "z";}]
       => { a = ["x" "y"]; }
  */
  zipAttrsWithNames =
    # A list of attribute names to zip
    names:
    /* A function that takes an attribute name, all the values, and
       returns a combined value.
    */
    f:
    # A list of attribute sets to zip together
    sets:
    listToAttrs (map (name: {
      inherit name;
      value = f name (catAttrs name sets);
    }) names);

  /* Merge sets of attributes and use the function `f` to merge attribute values.
     Similar to [](#function-library-lib.attrsets.zipAttrsWithNames) where all
     key names are passed for names.

     Type:
       zipAttrsWith :: (String -> [ Any ] -> Any) -> [ AttrSet ] -> AttrSet

     Example:
       zipAttrsWith (name: values: values) [{a = "x";} {a = "y"; b = "z";}]
       => { a = ["x" "y"]; b = ["z"] }
  */
  zipAttrsWith =
    # Accepts an attribute name, all the values, and returns a combined value.
    f:
    # A list of attribute sets to zip together
    sets:
    /*
     Implementation note: Common names  appear multiple times in the list of
     names, hopefully this does not affect the system because the maximal
     laziness avoid computing twice the same expression and listToAttrs does
     not care about duplicated attribute names.
    */
    zipAttrsWithNames (concatMap attrNames sets) f sets;

  /* Like [`zipAttrsWith`](#function-library-lib.attrsets.zipAttrsWith) with
     `(name: values: values)` as the function.

     Type:
       zipAttrs :: [ AttrSet ] -> AttrSet

     Example:
       zipAttrs [{a = "x";} {a = "y"; b = "z";}]
       => { a = ["x" "y"]; b = ["z"] }
  */
  zipAttrs =
    # A list of attribute sets to zip together
    sets:
    zipAttrsWith (name: values: values) sets;

  /* Does the same as the update operator `//` except that attributes are
     merged until the given predicate is verified.  The predicate should
     accept 3 arguments which are the path to reach the attribute, a part of
     the first attribute set and a part of the second attribute set.  When
     the predicate is verified, the value of the first attribute set is
     replaced by the value of the second attribute set.

     Type:
       recursiveUpdateUntil :: ( [ String ] -> AttrSet -> AttrSet -> Bool ) -> AttrSet -> AttrSet -> AttrSet

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
  recursiveUpdateUntil =
    # A function when given a list of values on the left and right hand sides (`path`), a left-hand side value, and a right-hand side value, returns `true` when the the right-hand side value should no-longer be substituted, and `false` when the recursive update should recurse
    pred:
    # The left-hand attribute set of the merge
    lhs:
    # The right-hand attribute set of the merge
    rhs:
    let f = attrPath:
      zipAttrsWith (n: values:
        let here = attrPath ++ [n]; in
        if tail values == []
        || pred here (head (tail values)) (head values) then
          head values
        else
          f here values
      );
    in f [] [rhs lhs];

  /* A recursive variant of the update operator ‘//’.  The recursion
     stops when one of the attribute values is not an attribute set,
     in which case the right hand side value takes precedence over the
     left hand side value.

     Type:
       recursiveUpdate :: AttrSet -> AttrSet -> AttrSet

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
  recursiveUpdate =
    # The left-hand attribute set of the merge
    lhs:
    # The right-hand attribute set of the merge
    rhs:
    recursiveUpdateUntil (path: lhs: rhs:
      !(isAttrs lhs && isAttrs rhs)
    ) lhs rhs;

  /* Returns true if the pattern is contained in the set. False otherwise.

     Type:
       AttrSet -> AttrSet -> Bool

     Example:
       matchAttrs { cpu = {}; } { cpu = { bits = 64; }; }
       => true
  */
  matchAttrs =
    # An attrset to match
    pattern:
    # An attrset in which to look for the `pattern`
    attrs: assert isAttrs pattern;
    fold and true (attrValues (zipAttrsWithNames (attrNames pattern) (n: values:
      let pat = head values; val = head (tail values); in
      if length values == 1 then false
      else if isAttrs pat then isAttrs val && matchAttrs pat val
      else pat == val
    ) [pattern attrs]));

  /* Override only the attributes that are already present in the old set
    useful for deep-overriding.

    Type:
      AttrSet -> AttrSet -> AttrSet

    Example:
      overrideExisting {} { a = 1; }
      => {}
      overrideExisting { b = 2; } { a = 1; }
      => { b = 2; }
      overrideExisting { a = 3; b = 2; } { a = 1; }
      => { a = 1; b = 2; }
  */
  overrideExisting =
    # An attribute set containing all the keys that will be present in the result set
    old:
    # An attribute set containing the keys that might override the `old` set
    new:
    mapAttrs (name: value: new.${name} or value) old;

  /* Get a package output.
     If no output is found, fallback to `.out` and then to the default.

     Type:
       String -> Derivation -> Derivation

     Example:
       getOutput "dev" pkgs.openssl
       => "/nix/store/9rz8gxhzf8sw4kf2j2f1grr49w8zx5vj-openssl-1.0.1r-dev"
  */
  getOutput =
    # A string name of a `pkg`'s output
    output:
    # A derivation that might have output `output`
    pkg:
    if pkg.outputUnspecified or false
      then pkg.${output} or pkg.out or pkg
      else pkg;

  /* Get a package's "bin" output
     If no output is found, fallback to `.out` and then to the default.

     Type:
       Derivation -> Derivation
  */
  getBin = getOutput "bin";

  /* Get a package's "lib" output
     If no output is found, fallback to `.out` and then to the default.

     Type:
       Derivation -> Derivation
  */
  getLib = getOutput "lib";

  /* Get a package's "dev" output
     If no output is found, fallback to `.out` and then to the default.

     Type:
       Derivation -> Derivation
  */
  getDev = getOutput "dev";

  /* Get a package's "man" output
     If no output is found, fallback to `.out` and then to the default.

     Type:
       Derivation -> Derivation
  */
  getMan = getOutput "man";

  /* Pick the "dev" outputs of packages to place in buildInputs
     If no output is found, fallback to `.out` and then to the default.

     Type:
       [Derivation] -> [Derivation]
  */
  chooseDevOutputs =
    # A list of derivations to get "dev" outputs from
    drvs: builtins.map getDev drvs;

  /* Make various Nix tools consider the contents of the resulting
     attribute set when looking for what to build, find, etc.

     This function only affects a single attribute set; it does not
     apply itself recursively for nested attribute sets.

     Type:
       AttrSet -> AttrSet
   */
  recurseIntoAttrs =
    # An attribute set to be marked for recursing into for derivations
    attrs: attrs // { recurseForDerivations = true; };

  /* Undo the effect of `recurseIntoAttrs`.

     Type:
       AttrSet -> AttrSet
   */
  dontRecurseIntoAttrs =
    # An attribute set to un-mark for recursing into for derivations
    attrs: attrs // { recurseForDerivations = false; };

  # Deprecated
  zipWithNames = zipAttrsWithNames;

  # Deprecated
  zip = builtins.trace
    "lib.zip is deprecated, use lib.zipAttrsWith instead" zipAttrsWith;
}
