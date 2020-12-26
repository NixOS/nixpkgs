# POP: Pure Object Prototypes

# See pop.md for an explanation of this object system's design.
#
# See pkgs/development/compilers/gerbil/gerbil-support.nix and the extensions at
# https://gitlab.com/mukn/glow/-/blob/master/pkgs.nix for example uses.
#
# BEWARE! This code is relatively new and lightly tested. It *is* being used, in
# pkgs/development/compilers/gerbil/gerbil-support.nix -- and though I wanted to
# put the code under pkgs.gerbil-support at first, that caused issues when
# trying to extend gerbil-support with functions defined in itself. Therefore
# I put it in lib, where it belongs eventually, as lib.POP, but without
# importing its bindings directly in lib since it's experimental. ---fare

{lib, ...}:
rec {
/*  First, let's defined a general notion of prototypes, valid for any type
    of instance, absent any requirement that the instance should somehow carry
    the prototype information to remain composable via inheritance.

    Notice the subtle way that our prototypes resemble or differ from extensions
    as commonly used by Nixpkgs's `fixed-points.nix` and `customization.nix`.
    In these files, the "base case" is already a initial function `f` from which
    a fixed-point must be computed via `fix` or `fix'`. In POP, the base case is
    simply a value of the same general shape as that yielded by the fixed-point,
    though the base value in general will be of a super-type `B` of the type `A`
    of the final value that will result from the fixed-point.

    The POP approach slightly simplifies the conceptual landscape: we only deal
    with two kinds of concepts, values and extensions, whereas `lib.fixedPoints`
    deals with three kinds, values, extensions and initial functions.
    POP's concept of prototypes is also more general than that extensions, even
    though in practice, the only prototypes we actually use at this time are
    derived from the very same type of extensions as `lib.fixedPoints`, via our
    function `extensionProto` below.

    Beyond the conceptual simplification and generalization, putting a focus
    on values rather than initial functions as the "start" of the extension
    enables a new feature: default field values, that can themselves be
    incrementally specified, like "slot defaults" and "default methods" in CLOS.
    By contrast, the `lib.fixedPoints` approach is isomorphic to requiring a
    "base" extension that ignores its super, and/or equivalently declaring that
    the "base case" is the bottom value the evaluation of which never returns.
*/

  # Instantiate a prototype from B to A. A trivial fixed-point function.
  # instantiateProto :: (Proto A B) B -> A
  instantiateProto = proto: base:
    let instance = proto instance base; in instance;

  # Compose two prototypes by inheritance
  # composeProto :: (Proto A B) (Proto B C) -> (Proto A C)
  composeProto = this: parent: self: super:
    this self (parent self super);
/*  Note that in `composeProto` above takes arguments in *reverse* order of
    `fixedPoints.composeExtensions`. `composeProto` takes a `this` prototype
    first (the "child", computed later, closer to the fixed-point), and a
    `parent` prototype second (computed earlier, closer to the base case),
    in an order co-variant with that of the `self` and `super` arguments,
    whereas `composeExtensions` has a co-variant order.
*/

  # The identity prototype, that does nothing.
  # identityProto :: (Proto A A)
  identityProto = self: super: super;
/*  Obviously, computing its fixed-point bottoms away indefinitely, but since
    evaluation is lazy, you can still define and carry around its fixed-point
    as long as you never try to look *inside* it.
*/

  # Compose a list of prototypes in order.
  # composeProtos :: (IndexedList I i: Proto (A_ i) (A_ (i+1))) -> Proto (A_ 0) (A_ (Card I))
  composeProtos = lib.foldr composeProto identityProto;
/*  foldr works much better in a lazy setting, by providing short-cut behavior
    when child behavior shadows parent behavior without calling super.
      https://www.well-typed.com/blog/2014/04/fixing-foldl/
*/


/*  Now for multiply-inheriting prototype meta information. Like prototypes,
    this notion is useful on its own, even to produce values other than objects
    that carry this composable meta information together with the instance
    containing values from the fixed point. */

  # instantiateMeta :: ? -> Meta A B -> A
  instantiateMeta = {computePrecedenceList, mergeInstance, bottomInstance, topProto,
                     getSupers, getDefaults, getProto, ...}: meta:
    let precedenceList = computePrecedenceList getSupers meta;
        defaults = lib.foldr mergeInstance bottomInstance (map getDefaults precedenceList);
        proto = composeProtos ([(topProto meta)] ++ (map getProto precedenceList)); in
        instantiateProto proto defaults;
/*  foldr works much better in a lazy setting, by providing short-cut behavior
    when child behavior shadows parent behavior without calling super.
    However, this won't make much change in the usual case that deals with extensions,
    because // is stricter than it could be and thus calls super anyway.
*/

/*  The below topological sorting algorithm to linearize the inheritance DAG
    into a precedenceList is optimized for code size: we just walk the structure
    depth-first and adds supers LIFO into the tail. By contrast, CLOS
    specifies a more elaborate algorithm that walks the structure breadth-first
    and accumulate supers FIFO into the head.
       http://www.lispworks.com/documentation/HyperSpec/Body/04_cea.htm
    The C3 algorithm is used by Dylan, Python, Raku, Parrot, Solidity:
       https://en.wikipedia.org/wiki/C3_linearization
    I'm not sure what C++ and other languages with multiple inheritance use.
    Yet another option could be to optimize for stability by having a global
    ordering in which to include classes, either at the head or tail.
*/
  # simplePrecedenceList :: (? -> Meta ? ?) -> (Meta ? ?) -> List (Meta ? ?)
  simplePrecedenceList = getSupers: meta: walkSimplePrecedenceList getSupers [] meta [];

  # walkSimplePrecedenceList :: (List (Meta ? ?)) (Meta ? ?) (List (Meta ? ?)) -> List (Meta ? ?)
  walkSimplePrecedenceList = getSupers: heads: meta: tails:
    if builtins.elem meta tails then
      tails
    else if builtins.elem meta heads then
      throw ("circular precedence list: " +
             builtins.concatStringsSep " < "
               (map (m: m.name) (heads ++ [meta])))
    else
      # The prefix handling ensure that `supers` will be contained *in order*
      # within the final `precedenceList`.
      [meta] ++
      foldrPrefixes (childmost-supers:
                      walkSimplePrecedenceList getSupers (heads ++ [meta] ++ childmost-supers))
                    (getSupers meta) tails;

  # Fold a function `f` over the elements of a list `bs`, from the end,
  # each time passing to the folding function `f`:
  # (1) the list `prefix` of elements that precede the current element,
  # (2) the current element `b`, and (3) the accumulator `a`.
  # Return the final value of the accumulator.
  # foldrPrefixes :: ([b] b a -> a) [b] a -> a
  foldrPrefixes = f: bs: a:
    let i = (builtins.length bs) - 1; in
    if i < 0 then a else
    let b = builtins.elemAt bs i; prefix = lib.lists.sublist 0 i bs; in
    foldrPrefixes f prefix (f prefix b a);
/*  Note that the argument order was chosen specifically to enable
    eta-conversion in the recursive call of `walkPrecedenceList`.
*/


/*  Extensions as prototypes to be merged into attrsets.
    This is the same notion of extensions as in `lib.fixedPoints`,
    with the exact same calling convention.
*/
  # mergeAttrsets :: A B -> B // A | A <: Attrset, B <: Attrset
  mergeAttrset = a: b: b // a; # NB: bindings from `a` override those from `b`

  # mergeAttrsets :: IndexedList I A -> Union I A | forall I i: (A i) <: Attrset
  mergeAttrsets = builtins.foldl' mergeAttrset {}; # NB: leftmost bindings win.
/* Note that lib.foldr would be better if // weren't so strict that you can't
    (throw "foo" // {a=1;}).a  without throwing.
*/

  # extensionProto :: Extension A B -> Proto A B
  extensionProto = extension: self: super: (super // extension self super);
/*  Note how, as explained previously, we have the equation:
        fixedPoints.composeExtensions f g ==
            composeProto (extensionProto g) (extensionProto f)
*/

  # identityExtension :: Extension A A
  identityExtension = self: super: {};
/*  Note how the fixed-point for this extension as pop prototype is not
    bottom, but the empty object `{}` (plus an appropriate `__meta__` field).
*/


/*  Finally, here are our objects with both CLOS-style multiple inheritance and
    the winning Jsonnet-style combination of instance and meta information into
    a same entity, the object.
*/
  # Parameter to specialize `instantiateMeta` above.
  PopInstantiator = rec {
    computePrecedenceList = simplePrecedenceList;
    mergeInstance = mergeAttrset;
    bottomInstance = {};
    topProto = __meta__: self: super: super // { inherit __meta__; };
    getSupers = m: m.supers;
    getDefaults = m: m.defaults;
    getProto = m: extensionProto m.extension;
  };
/*  TODO: make that an object too, put it in the `__meta__` of `__meta__`, and
    bootstrap an entire meta-object protocol in the style of the CLOS MOP.
*/

  # Instantiate a `Pop` from a `Meta`
  # instantiatePop :: Meta A B -> Pop A B
  instantiatePop = instantiateMeta PopInstantiator;

  # Extract the `Meta` information from an instantiated `Pop` object.
  # If it's an `Attrset` that isn't a `Pop` object, treat it as if it were
  # a `kPop` of its value as instance.
  # getMeta :: Pop A B -> Meta A B
  getMeta = p: if p ? __meta__ then p.__meta__ else
    { supers=[]; extension=_: _: p; defaults={}; name="attrs"; };

  # General purpose constructor for a `pop` object, based on an optional `name`,
  # an optional list `supers` of super pops, an `extension` as above, and
  # an attrset `defaults` for default bindings.
  # pop :: { name ? :: String, supers ? :: (IndexedList I i: Pop (M_ i) (B_ i)),
  #          extension ? :: Extension A M, defaults ? :: Defaults A, ... }
  #         -> Pop A B | A <: (Union I M_) <: M <: B <: (Union I B_)
  pop = { supers?[], extension?identityExtension, defaults?{}, name?"pop", ...}@meta:
    let supers_=supers; in let supers=map getMeta supers_; in
    instantiatePop (meta // { inherit extension defaults name supers; });

  # A base pop, in case you need a shared one.
  # basePop :: (Pop A A)
  basePop = pop { name="basePop"; };
/*  Note that you don't usually need a base case: an attrset of default bindings
    will already be computed from the inherited defaults.
    You could also use `(pop {})` or `{}` as an explicit base case if needed.
*/

  # `kPop`, the K combinator for POP, whose extension returns a constant attrset
  # Note how `getMeta` already treats any non-pop attrset as an implicit `kPop`.
  # kPop :: A -> (Pop A B)
  kPop = attrs: pop { name="kPop"; extension = _: _: attrs; };

  # `selfPop`, for an "extension" that doesn't care about super attributes,
  # just like the initial functions used by `lib.fixedPoints`.
  # selfPop :: (B -> A) -> (Pop A B)
  selfPop = f: pop { name="selfPop"; extension = self: _: f self; };

  # `simplePop` for just an extension without supers, defaults, nor name.
  # simplePop :: (Extension A B) -> (Pop A B)
  simplePop = extension: pop { inherit extension; };

  # `mergePops` combines multiple pops in order by multiple inheritance,
  # without local overrides by prototype extension, without defaults or name.
  # mergePops :: (IndexedList I i: Proto (A_ i) (B_ i)) -> Proto (Union I A_) (Union I B_)
  mergePops = supers: pop {
    name="merge"; inherit supers; };

  # `extendPop` for single inheritance case with no defaults and no name.
  # extendPop :: (Pop A B) (Extensions C A) -> (Pop C B)
  extendPop = p: extension: pop {
    name="extendPop"; supers=[p]; inherit extension; };

  # `kxPop` for single inheritance case with just extension by constants.
  # kxPop :: (Pop A B) C -> (Pop (A \\ C) B)
  kxPop = p: x: pop {
    name="kxPop"; supers=[p]; extension=_: _: x; };

  # `defaultsPop` for single inheritance case with just defaults.
  # defaultsPop :: D (Pop A B) -> Pop A B | D <: A
  defaultsPop = defaults: p: pop {
    name="defaultsPop"; supers = [p]; inherit defaults; };

  # `namePop` to override the name of a pop
  # namePop :: String (Pop A B) -> Pop A B
  namePop = name: p: p // { __meta__ = (getMeta p) // { inherit name; };};

  # Turn a pop into a normal attrset by erasing its `__meta__` information.
  # unpop :: Pop A B -> A
  unpop = p: builtins.removeAttrs p ["__meta__"];
}
