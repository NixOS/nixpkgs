# POP: Pure Object Prototypes

This essay explains the design of [pop.nix](pop.nix),
a [prototype](https://en.wikipedia.org/wiki/Prototype-based_programming)
object system for Nix,
intended as an upgrade to Nix's traditional extension systems.
POP is based on systemizing the concepts underlying these extension systems,
and on leveraging four decades of experience with object systems.
See also this article published at the Scheme and Functional Programming Workshop 2021:
[Prototype Object Orientation Functionally](https://github.com/metareflection/poof)
[(PDF)](http://fare.tunes.org/files/cs/poof.pdf).

## POP: classless Jsonnet-style prototypes meet CLOS-style inheritance DAG

POP is an object system written in Nix. Like the many "extension mechanisms"
already present in [nixpkgs](https://github.com/NixOS/nixpkgs/),
it allows "attrsets" to be computed based on a set of "extension" functions
with two arguments `self:` and `super:`, that can be composed together.
However, POP *extends* those extension mechanisms, by embracing the fact that
they are a serendipitous reinvention of object systems,
in the surprisingly adequate setting of Nix:
a dynamic lazy pure functional programming language.

POP therefore deliberately imports concepts and designs invented in the context
of object systems in the 1980s to improve these extension mechanisms: the
improvements herein included are *multiple inheritance* and *default values*.
Conversely, POP illuminates the *essence* of these object systems, that was once
the topic of many debates and publications, in the retrospectively superior
framework of dynamic lazy pure functional programming.

### Plan of this essay

The first section below,
[Mapping common concepts with terminology](#mapping-common-concepts-with-terminology),
introduces the concepts that we build upon, with
a precise terminology we use in the rest of this document.

We then describe [multiple inheritance](#multiple-inheritance),
how it works, and what makes it useful.

In a section [POP compared to other object systems](#pop-compared-to-other-object-systems),
we compare our design to other designs:
what it has in common with other Nix extension mechanisms
that makes it interesting compared to other systems outside Nix, and
what it has in common with other systems outside Nix
that makes it interesting compared to those Nix extension mechanisms.

Finally, we have a section that provides
[Informal Types for POP](#informal-types-for-pop),
in a notional type system with subtyping and some notion of type indexing.
This is obviously expressible with dependent types.
A type system that can usefully express these types, yet is weaker than dependent types,
and maybe also has decidable or principal typing, is left as an exercise to the reader.

We conclude with a TODO list for future work on POP.

### Some historical context

Nixpkgs already has many ad-hoc variants of the same extension mechanism,
as notably seen in [lib/fixed-points.nix](fixed-points.nix) and
[lib/customisation.nix](customisation.nix) and initially introduced in 2015.
Surprisingly, several users have noticed how this extension mechanism is
essentially isomorphic to the object system of Jsonnet (2014), introduced a
year earlier. The equivalent design was not the product of purposeful choice,
but an accident that suggests that they independently discovered a same
essential concept in the space of software design. Indeed, the Nix extension
mechanisms and the Jsonnet object system are themselves independent reinventions
in the same dynamic lazy pure functional framework, of
the classless object systems first seen in Thinglab (1979) or T (1981),
once made popular by Self (1987) and JavaScript (1995) and these days known as
"prototype object systems".

The developers of Nix's extension mechanisms don't look like they ever intended
these mechanisms to be object systems at all; and though they are now aware of
how the "equivalence" of these mechanisms to such object systems, they seem
to mostly dismiss the fact as a mere curiosity, trivial, irrelevant, or even
annoying—a distraction. Instead, I suggest it can be a inspiration, both ways:
Nix can learn from past object system designs to improve its modularity;
and programming language designers can learn a lot from Nix to better understand
the essence of object systems, and the value of Nix's semantic framework.

## Mapping common concepts with terminology

Object systems, their documentation, and research papers about them, have
through the years used a variety of terminologies, but never seem agree with
each other, and sometimes not even with themselves through time. I will thus
pick the terms that seem the most prevalent today to retrospectively describe
the essential concepts common to all these systems, while trying to cite the
terms used by some of them.

The two main concepts I am interested in I will call "prototype" and "instance":
the prototype will be the composable entity from which a fixed point is computed
whereas the instance will be the end-value that results from the fixed point.
I will discuss later how I will use the often overloaded term "object".

### Prototypes and Instances

I call "prototype" what in various systems has been called "object", "pattern",
"component", "prototype", "mixin", "trait". In Nix, the corresponding notion is
that of an "extension" — a function from two attrsets `self` and `super:` to an
attrset of bindings that override the super attrset (for non-nixers, an attrset
is a finite mapping from strings to arbitrary values, akin to a JSON "object",
though in Nix values also include higher-order functions and lazy computations).
I will also use the word "extension" to describe that precise case, and will
use the word "prototype" for a slightly more general notion, that doesn't
necessarily have to deal with attrsets, but may involve values of any type.

I call "instance" what in various systems has been called "object", "instance",
"pattern". In Nix it's just referred to as the "fixed-point", the "scope", or
the "attrset that was extended". An "instance" has with "fields" or "slots"
that can be accessed, or "methods" or "operations" that can be invoked.
An "instance" is created by "instantiating" or "computing the fixed point of"
a prototype, or a list of prototypes to be composed, often with an implicit or
explicit "base" entity at the other end of the fixed point (more on that later).
While computing the set of values and behaviors of the instance, each prototype
may either (1) "pass to", "inherit from", "delegate to" its (transitive) "super"
prototypes the unchanged computation of values and behaviors, or it may
(2) "override" these values and behaviors, in a computation that may itself
both invoke other values and behaviors of the final instance as consulted with
the `self` argument (hence the need for a fixed-point), or consult and amend
the "inherited" values as extracted from the `super` argument.

### Inheritance Lists

I call "inheritance list" the reified or notional list of prototypes involved in
computing the values and methods of an instance. For the purpose of this
discussion, I will follow the convention that the first or leftmost prototype
in the inheritance list contains the behaviors most directly associated to the
"instance", then the second those associated to its direct "super" prototype,
and so on, with the last prototype being those behaviors closest to the "base"
entity.

This convention is common in the rich Lisp object tradition. It is covariant
with argument order `self: super:` rather than `super: self:`, but is notably
opposite to the convention used in nixpkgs and Jsonnet: in nixpkgs'
`lib.fixedPoints`, `composeExtensions` and `composeManyExtensions` have the
prototypes on the right override those on the left, and similarly in Jsonnet,
`{ a: 1 }` + `{ a: 2 }` similarly yields `{ a: 2 }`.

### Base values

The starting value from which to compute the fixed-point I will call the "base"
entity. It comes at or after the conceptual rightmost end of the list of
composed prototypes in my convention, though that would be the leftmost start in
the Nix or Jsonnet convention. In most object systems, a special "base object"
(or for class-based systems, "base class") is used, typically an empty object,
or a lazy bottoming or erroring value that is better left unforced, sometimes
an escape to some reflective facility to handle methods in a reified "message".

In the case of Nix extensions, the starting point is usually a function with a
single fix-point `self` argument. This is computationally equivalent to using
the empty attrset `{}` as base object, where the "last" prototype (in my order,
the "first" in the usual Nix convention) not only ignores that value, but does
not even bother to explicitly take it as `super` argument. The resulting API is
slightly different, though.

### Objects and Classes

I will call "object" an entity that combines *both* "prototype" and "instance".
This is the case in Jsonnet, and in some variants of the Nix extension mechanism
in which an attrset has a magic `__unfix__` or `override` field, such that
"normal" fields yield the values of the entity as instance, whereas the magic
fields give access to the entity as prototype.

Not all object systems have this feature. Many call "object" just what we call
"instance". There might be systems out there that only call "object" what we
call "prototype". And then, there are systems in which they may be neither.

Indeed, if we look at existing "class-based" object systems as special cases of
prototype systems with two stages, their "objects" are all merely "instances" at
stage 0: you cannot extract an object's behavior and compose it via inheritance.
Only "classes" in these systems are both an "instance" (a type descriptor) and a
"prototype" (function from self and super type descriptors to type descriptor),
at stage -1 (metaprogramming, usually in a very limited meta-language). However,
proponents and teachers of class systems almost never conceptualize this
distinction, leading to much confusion in teachers, users, prononents and
detractors alike.

## Multiple inheritance

POP objects (or "pops") are similar to Jsonnet and Nix objects: they embody both
an "instance" that carries bindings from field name to field value, and some
"prototype" information providing a partial, incremental, computation from which
the instance was computed as a fixed-point, but that can be composed with other
prototypes to yield extended instances with different fixed-points.

However, POP objects implement *multiple inheritance*, where Jsonnet and
previous Nix extension mechanisms only implement *single inheritance*.

### Single vs Multiple Inheritance

In *single inheritance*, when you compose prototypes, each prototype
has one single direct super prototype, and the overall resulting inheritance
structure is a *list*. This list can be explicit in some cases, or can remain
implicit in the history of how the prototype was computed as the result of
composing individual `self: super:` functions.

In *multiple inheritance*, when you compose prototypes, each prototype
has multiple direct super prototypes, and the overall resulting inheritance
structure is a *DAG* (directed acyclic graph). This DAG can also be implicit
or explicit, and a list is obviously a special case of DAG, but importantly,
this DAG means that you can declare dependencies between prototypes, have
multiple prototypes depend on a same "super" prototypes, and be safe that
each "super" prototypes will be processed only once, in a correct order.

### The Inheritance Model

When you define a prototype, you can specify an ordered list `supers` of
other prototypes from which it *directly* inherits. Prototypes may in turn
inherit from further super prototypes, such that the inheritance structure
formed by all the super prototypes from which a given prototype directly or
indirectly inherits is a finite directed acyclic graph, or DAG. We call it
the *inheritance graph* of the prototype (as contrasted to the inheritance list
of a prototype in a single inheritance systems).

From an prototypes's inheritance DAG, a *precedence list* is computed: a list
of all the super prototypes, topologically sorted in a total order that
preserves the partial order of appearance of prototypes in the DAG —
including the constraint that super prototypes in the precedence list must
appear in the same order as they appear in the prototype's direct `supers` list.

When instantiating a prototype, the field values of the instance are computed
as if, in one of those many single inheritance prototype systems, the prototypes
in the precedence list had been composed together in that specific order.

### Advantages of multiple inheritance

Without multiple inheritance, programmers must have manually maintain an
implicit or explicit list of prototypes to combine *in the right order*,
so as to successfully compute their instances as a fixed-point.

Now, two prototypes `A` and `B` that each override another prototype `C`
might each be always better combined with into prototypes `A+C` and `B+C`,
so users don't have to always remember to include `C` with them. But
without multiple inheritance, this creates an incompatibility between
using `A+C` and `B+C`, since whichever is specified first will pull a redundant
copy of `C` that will undo the other one's overrides.
Omitting `C`, on the other hand, forces every user of either `A` or `B`
to track not just the prototypes they directly want to use, but also
all their transitive dependencies, so as to manually compute and use
the precedence list, and maintain it as the code evolves.
This is a modularity disaster that prevents programmers from abstracting
over the details of which prototype requires what other prototype when used.

Multiple inheritance solves these issues, and enables more incremental and
more decentralized programming practices, with more modularity and less
manual maintenance. Combining prototypes for many disjoint aspects of a program
can be done without a "central programmer" responsible for preserving a
precedence list, synchronizing multiple parties, and learning about the
implicit dependencies between prototype of the entire evolving set of
libraries transitively used by his program.

### A free feature: Field Defaults

Now, the fixed-point of a prototype is only defined given a base entity.
The obvious solution in a Jsonnet-style object system where the prototype
is the only meta-information used, is to pick `{}` as the base case.
But since, with multiple inheritance, the prototype information already includes
a list of (direct) super objects in addition to the "extension" function,
we may as well add incremental information about the base entity.
The object system will then merge the incremental information from all the
prototypes in the precedence list to compute the effective base entity.

The result functionality interestingly enough subsumes that of both
the *default slot value* and *default method behavior* features of CLOS.
This functionality is especially useful when those defaults come from prototypes
in disjoint parts of the inheritance graph, that may appear later in the
precedence list from explicit overrides that they must not cancel.
Thus, each prototype will have a `defaults` field that contains
its new specifications and/or overrides for fields of the base entity
for the fixed point computation resulting in the object's instance.

Carrying increments for defaults as well as for supers and extensions also
paves the way to objects being used to incrementally specify instances of
types other than attrset: extensions can be defined for any type with a
"merge" function, including "merging" by ignoring the super.
Thus, just by trying to make a Nix extension mechanism simpler, less arbitrary,
and more up-to-date with decades of object system practices, we also made it
more powerful and recovered for free a feature of rival object systems,
that neither Jsonnet nor any current Nix extension mechanism possesses.

### Precedence List Instability

In POP as in existing Nix extension mechanisms, the prototype associated to each
object is specified as a function that takes arguments `self` and `super`,
and returns an attrset with bindings that will override those inherited from the
`super` computation within the fixed-point.

However, the next step of `super` computation may differ greatly between those
single inheritance prototype systems and multiple inheritance prototype systems:
if in a single inheritance systems a prototype `A` directly inherits from a
prototype `B`, then the `super` value passed to the prototype of `A` will always
have been directly computed by the prototype of `B`, for all objects that
further extend this composition. By contrast, in multiple inheritance systems,
when `A` inherits from `B`, and `O` inherits from `A`, `O` may possess other
transitive super objects that inherit from `B` yet appear after `A` in the
linearization of the graph into `O`'s precedence list. Thus, the computation
that directly follows the prototype of `A` may not be that by the prototype
of `B`. Only the partial order is guaranteed, not the exact sequence of
prototypes.

It is possible to recover some stability in these precedence lists and ensure
that prototypes in a DAG always appear in the same relative order, whatever
larger DAG containing it might be linearized. But this stability requires
assigning a total order to all prototypes, i.e. by registering them to some
central service (e.g. using the memory address, in a mark and sweep GC that
preserves object order, or server issuing UUIDs to include in the source code).
Thus, a prototype with an lower ID shall always we included later (closer to
the base object) in the precedence list. Maintaining this object order is costly
though and an unstable order of prototypes should not be a problem if the
prototypes are well-written and no dependencies is missing.

## POP compared to other object systems

### A winning combination: purity + laziness + dynamicity

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

### POP versus other Nix extension mechanisms

There are too many extension mechanisms in Nixpkgs already. Semantically,
they are all isomorphic to each other and to Jsonnet's object system,
with single-inheritance and `self: super:` extensions, yet
they are all mutually incompatible, each with its own calling convention.
They are insufficently documented, rarely consciously designed, often
the reluctant product of necessity by programmers who are not well-versed
in either or both of object systems and (pure lazy) functional programming
(which is quite OK: not everyone has to be a programming language buff).

The goal for POP would be to eventually replace all these systems with
a single one, with a better more robust design, and hopefully feature parity
and beyond (which it doesn't claim to have at the time).

One notable feature that multiple inheritance might enable is that,
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

## Informal Types for POP

Let's give informal types for POP, in a notional type system that has both
subtyping guards and dependencies to some first- or second- class type indexes.
These types are probably expressible in systems weaker than dependent types,
but are not available in the typesystems of common programming languages,
beyond the trivial unindexed monomorphic case.

A `Proto A B` is a notional type for prototypes yielding an object of type `A`
from a super object of type `B`, where `A` is a subtype of `B`. We write it thus:

   type Proto = A: B: A B -> A | A <: B;

An `Extension A B` is a notional type for prototype extensions each yielding
some override `C` to a super object of type `B` sufficient to turn it into
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

Note that accessing the fields may yield runtime errors if the defaults
are not indeed of type `B`. Maybe for typing purposes, we should have separate
fields `defaults :: D` and `bottomDefaults :: B`, where `D` is a subtype of `B`,
and the `defaults` take precedence from left to right, then if not found
the `bottomDefaults` are consulted from right to left.

## TODO for POP

We can further generalize the idea (and our code does to point):
  - We need not in the general case carry the composable meta information with
    the instance values, and may make the final merge of the `__meta__` field
    an optional parameter of the object scheme — a meta-meta object.
  - We can then parametrize the `merge` function, which need not be
    `mergeAttrs = A: B: B // A` but could be something depending on
    the kinds of things we want to incrementally and modularly specify.
  - The `computePrecedenceList` computation can also be specialized.
  - That meta-meta information could itself be stored in the meta-objects,
    themselves bootstrapped from prototypes in the style of the CLOS MOP.
  - Method combination, multiple-dispatch, access control, etc.,
    could then be added on top.
