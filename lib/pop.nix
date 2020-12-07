# POP: Pure Object Prototypes

# Long explanations on top, short code at the end.
#
# BEWARE! This code is relatively new and lightly tested. It *is* being used, in
# pkgs/development/compilers/gerbil/gerbil-support.nix -- and though I wanted to
# put the code under pkgs.gerbil-support at first, that caused issues when
# trying to extend gerbil-support itself with functions defined in itself.
# Therefore I put it in lib, where it belongs eventually, as lib.POP,
# but without having lib inherit all the bindings from it. --- fare

/*  POP: classless Jsonnet-style prototypes meet CLOS-style inheritance DAG

    Like the many Jsonnet-style object systems already in Nix, POP combines
    instance field values and composable prototype info in a same attrset.
    However POP also implements CLOS-style inheritance DAG and field defaults.

 POP compared to Jsonnet: CLOS-style inheritance DAG

    POP objects (or "pops") each specify an ordered list `supers` of other pops
    from which it *directly* inherits. These pops may in turn inherit from
    further super pops, such that the inheritance structure formed by all the
    super pops from which a given pop directly or indirectly inherits is
    a finite directed acyclic graph, or DAG, known as its inheritance graph.

    From an object's inheritance DAG, a precedence list is computed:
    a list of all the super objects, topologically sorted in a total order
    that preserves the partial order of appearance in a walk of the DAG ---
    including the constraint that super objects in the precedence list must
    appear in the same order as they appear in the direct `supers` list.
    The instance field values of the object are then computed in sensibly the
    same way as if, in one of those many existing Jsonnet-style object systems,
    the prototypes in the precedence list had been composed together in order.

    Without an inheritance DAG, programmers must have manually maintain
    an implicit or explicit lists of prototypes to combine in the right order,
    so as to successfully compute their instances as a fixed-point.
    Now, two prototypes `A` and `B` that each override another prototype `C`
    might each be always better combined with into prototypes `A+C` and `B+C`;
    but without an inheritance DAG, this creates an incompatibility
    between using `A+C` and `B+C`, since whichever is specified first
    will pull a redundant copy of `C` that will undo the other one's overrides.
    Omitting `C`, on the other hand, forces every user of either `A` or `B`
    to track not just the prototypes they directly want to use, but also
    all their transitive dependencies, so as to manually compute and use
    the precedence list, and maintain it as the code evolves.
    This is a modularity disaster that prevents programmers from abstracting
    over the details of which prototype requires what other prototype when used.

    DAG inheritance solves these issues, and enables more incremental and
    more decentralized programming practices, with less manual maintenance.
    Combining prototypes for many disjoint aspects of a program can be done
    without a "central programmer" responsible for preserving a precedence list,
    synchronizing multiple parties, and learning about the implicit dependencies
    between prototype of the entire evolving set of libraries
    transitively used by his program.

 A free feature: Field Defaults

    Now, the fixed-point of a prototype is only defined given a base case.
    The obvious solution in a Jsonnet-style object system where the prototype
    is the only meta-information used, is to pick `{}` as the base case.
    But since, with DAG inheritance, the meta information for an object
    already includes a list of (direct) super objects, we may as well add
    information about the base case to each object's meta structure, and
    merge the incremental information from all supers into the base case.

    The result functionality interestingly enough subsumes that of both
    the default slot value and default method behavior features of CLOS.
    This is especially useful when those defaults come from prototypes
    in disjoint parts of the inheritance graph, that may appear later
    in the precedence list from explicit overrides that they must not cancel.
    Thus, each pop's meta information field will have a `defaults` field
    that contains its new specifications and/or overrides for fields of
    the base case of the fixed point computation of the object's instance.

    Carrying increments for defaults as well as for prototypes also
    paves the way to objects being used to incrementally specify
    instances of types other than Attrset.
    Thus, just by trying to make the code simpler and less arbitrary,
    we also made it more powerful and recovered for free a feature
    of a rival object system that no Jsonnet-style object system had.

 Prototypes of Attribute Extensions

    In POP as in Jsonnet-style object systems, the prototype associated to each
    object is specified as a function that takes arguments `self` and `super`,
    and returns an attrset with bindings that will override
    those inherited from the super computation within the fixed-point.

    However, the next step of "super" computation may differ greatly
    between those Jsonnet-style object systems and POP:
    if in those systems an object `A` is directly composed with an object `B`,
    then the `super` passed to the prototype of `A`
    will always have been computed directly by the prototype of `B`,
    for all objects that further extend this composition.
    However, in POP, when `A` inherits from `B`, and `O` inherits from `A`,
    `O` may possess other transitive super objects that inherit from `B` yet
    appear after `A` in the linearization of the graph into the precedence list.
    Thus, the computation that directly follows the prototype of `A`
    may not be that by the prototype of `B`.
    Only the partial order is guaranteed, not the exact sequence of prototypes.

 A winning combination: purity + laziness + dynamicity

    POP, after the Jsonnet-style object systems from which it evolved,
    combines composable prototype information and instance field values
    in a single entity, the "object".
    For that it uses the same trick as the other systems defined in Nix:
    it uses a special field to store this information,
    in an attrset that is otherwise mostly used for field values
    (in the case of POP, this field is called `__meta__`).

    This style makes sense thanks to the wonderful combination of
    purity, laziness, and dynamic typing, present in both Jsonnet and Nix
    (and in the subset of Gerbil Scheme I use for my own variant, POO):

      - Purity ensures that every prototype has only a unique instance,
        its fixed-point given the defaults as base case, up to deep equality.
        Thus it makes sense to carry this unique instance with each prototype,
        in a single entity, the object, that can "identifies" as both.

      - Laziness ensures that it makes sense to define these instances and
        carry them around with the prototypes, even though an eager computation
        of the fields might yield errors or non-termination for many of them.
        Laziness ensures that these erroneous behaviors only occur
        if the problematic values are explicitly being computed.
        This removes the need for fancy typing to distinguish between
        "complete" and "incomplete" objects, which may further cause
        program size and complexity to grow exponentially so as to distinguish
        at every moment which entities in a deeply nested datastructure are
        "only" prototypes, and which are already instances ready to be queried
        but incapable of being composed anymore.

      - Dynamic typing enables having all these fixed-points computations
        where static typing would require dependent types or at least some
        pretty fancy combination of subtyping and layered indexing.

  POP versus other Nix Object Systems

    There are too many object systems in Nixpkgs already. They are all
    more or less isomorphic to each other and to Jsonnet's object system,
    yet are all mutually incompatible, each with its own calling convention.
    They are insufficently documented, rarely consciously designed, often
    the reluctant product of necessity by programmers who are not well-versed
    in either or both of object systems and (pure lazy) functional programming
    (which is quite OK: not everyone has to be a programming language buff).

    The goal for POP would be to eventually replace all these systems
    with a single one, with a better more robust design, and hopefully
    feature parity and beyond (which it doesn't claim to have at the time).

    One notable feature that DAG inheritance might enable is that,
    if there are common aspects between packages for multiple languages,
    such as Haskell, OCaml, Python, Go, Gerbil Scheme, etc.,
    POP could modularly handle these aspects with shared prototypes,
    without each language reinventing their own hierarchy for whatever reason
    (e.g. absence of defaults, lozenge dependency conflicts, etc.).
    Also, a given package collection could independently mix and match
    alleles of multiple genes, such as the "stable" branch of all these but the
    "unstable" branch of all those, and the local checkout of those yet others.
    This could be done without having to maintain a lot of rigid yet fragile
    manual precedence lists for each combination of alleles used
    among an exponential number of possibilities.

  Informal Types for POP

    Let's give informal types for POP, in a notional type system that has both
    subtyping guards and dependencies to some first- or second- class type indexes.

    A `Proto A B` is a notional type for prototypes yielding an object of type `A`
    from a super object of type `B`, where `A` is a subtype of `B`. We write it thus:

       type Proto = A: B: A B -> A | A <: B;

    An `Extension A B` is a notional type for prototype extensions yielding
    overrides to a super object of type `B` sufficient to turn it into
    an object of type `A`:

       type Extension = A: B: Exists C: A B -> C | B // C <: A <: B;

    A `Default A` is a notional type for defaults for objects yielding
    an instance of type `A`:

       type Default = A: Exists C: C | C <: A;

    A `Meta A B` is a notional type for composable prototype meta-information:

       type Meta = A: B: Exists I: ExistsIndexed I M_: ExistsIndexed I B_: {
         name :: String,
         extension :: Extension A M,
         default :: Default A,
         supers :: IndexedList I i: Meta (M_ i) (B_ i),
       | A <: (Union I M_) <: M <: B <: (Union I B_)

    A `Pop A B` is a notional type for objects with fields of type `A`
    given defaults of type `B`:

       type Pop = A: B: A // { __meta__ :: Meta A B };

    Note that accessing the fields may be yield runtime errors
    if the defaults are not indeed of type `B`.
    Maybe for typing purposes, we should have separate fields
    `defaults :: D` and `bottomDefaults :: B`, where `D` is a subtype of `B`,
    and the `defaults` take precedence from left to right, then if not found
    the `bottomDefaults` are consulted from right to left.

    TODO: we can further generalize the idea (and our code does to point):
    - We need not in the general case carry the composable meta information with
      the instance values, and may make the final merge of the `__meta__` field
      an optional parameter of the object scheme --- a meta-meta object.
    - We can then parametrize the `merge` function, which need not be
      `mergeAttrs = A: B: B // A` but could be something depending on
      the kinds of things we want to incrementally and modularly specify.
    - The `computePrecedenceList` computation can also be specialized.
    - That meta-meta information could itself be stored in the meta-objects,
      themselves bootstrapped from prototypes in the style of the CLOS MOP.
    - Method combination, multiple-dispatch, access control, etc.,
      could then be added on top.
*/
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

  # Instantiate a prototype from B to A
  # instantiateProto :: (Proto A B) B -> A
  instantiateProto = proto: base: let instance = proto instance base; in instance;

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

  # Having a prototpe inherit from a list of further prototypes
  # inheritProtos :: forall3 A: I: B_:
  #   (Proto A (B_ 0)) (IndexedList I i: (Proto (B_ i) (B_ (i+1)))) -> Proto A (B_ (Card I))
  inheritProtos = proto: protos: builtins.foldl' composeProto proto protos;

  # Compose a list of prototypes in order.
  # composeProtos :: (IndexedList I i: Proto (A_ i) (A_ (i+1))) -> Proto (A_ 0) (A_ (Card I))
  composeProtos = inheritProtos identityProto;


/*  Now for multiply-inheriting prototype meta information. Like prototypes,
    this notion is useful on its own, even to produce values other than objects
    that carry this composable meta information together with the instance
    containing values from the fixed point. */

  # instantiateMeta :: ? -> Meta A B -> A
  instantiateMeta = {computePrecedenceList, mergeInstance, bottomInstance, topProto,
                     getDefaults, getProto, ...}: meta:
    let precedenceList = computePrecedenceList meta;
        defaults = builtins.foldl' mergeInstance bottomInstance (map getDefaults precedenceList);
        proto = inheritProtos (topProto meta) (map getProto precedenceList); in
        instantiateProto proto defaults;
/*  Someone needs to think harder about which to use of foldl' vs foldr.
    I strongly suspect that one of them causes unnecessary evaluation and
    potentially avoidable bottoming in cases where the lazy evaluation leads
    to only the "childmost" prototypes being needed while the "parentmost"
    prototypes are ignored. But I haven't thought too hard which is better.
*/

  # walkPrecedenceList :: (Meta ? ?) -> List (Meta ? ?)
  computePrecedenceList = meta: walkPrecedenceList [] meta [];

  # walkPrecedenceList :: (List (Meta ? ?)) (Meta ? ?) (List (Meta ? ?)) -> List (Meta ? ?)
  walkPrecedenceList = heads: meta: tails:
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
                      walkPrecedenceList (heads ++ [meta] ++ childmost-supers))
                    meta.supers tails;

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

  # extensionProto :: Extension A B -> Proto A B
  extensionProto = extension: self: super: (super // extension self super);
/*  Note how, as explained previously, we have the equation:
        fixedPoints.composeExtension f g ==
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
    inherit computePrecedenceList;
    mergeInstance = mergeAttrset;
    bottomInstance = {};
    topProto = __meta__: self: super: super // { inherit __meta__; };
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
