{ lib, ... }:
rec {
  # Compute the fixed point of the given function `f`, which is usually an
  # attribute set that expects its final, non-recursive representation as an
  # argument:
  #
  #     f = self: { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; }
  #
  # Nix evaluates this recursion until all references to `self` have been
  # resolved. At that point, the final result is returned and `f x = x` holds:
  #
  #     nix-repl> fix f
  #     { bar = "bar"; foo = "foo"; foobar = "foobar"; }
  #
  #  Type: fix :: (a -> a) -> a
  #
  # See https://en.wikipedia.org/wiki/Fixed-point_combinator for further
  # details.
  fix = f: let x = f x; in x;

  # A variant of `fix` that records the original recursive attribute set in the
  # result. This is useful in combination with the `extends` function to
  # implement deep overriding. See pkgs/development/haskell-modules/default.nix
  # for a concrete example.
  fix' = f: let x = f x // { __unfix__ = f; }; in x;

  # Return the fixpoint that `f` converges to when called recursively, starting
  # with the input `x`.
  #
  #     nix-repl> converge (x: x / 2) 16
  #     0
  converge = f: x:
    let
      x' = f x;
    in
      if x' == x
      then x
      else converge f x';

  # Modify the contents of an explicitly recursive attribute set in a way that
  # honors `self`-references. This is accomplished with a function
  #
  #     g = self: super: { foo = super.foo + " + "; }
  #
  # that has access to the unmodified input (`super`) as well as the final
  # non-recursive representation of the attribute set (`self`). `extends`
  # differs from the native `//` operator insofar as that it's applied *before*
  # references to `self` are resolved:
  #
  #     nix-repl> fix (extends g f)
  #     { bar = "bar"; foo = "foo + "; foobar = "foo + bar"; }
  #
  # The name of the function is inspired by object-oriented inheritance, i.e.
  # think of it as an infix operator `g extends f` that mimics the syntax from
  # Java. It may seem counter-intuitive to have the "base class" as the second
  # argument, but it's nice this way if several uses of `extends` are cascaded.
  #
  # To get a better understanding how `extends` turns a function with a fix
  # point (the package set we start with) into a new function with a different fix
  # point (the desired packages set) lets just see, how `extends g f`
  # unfolds with `g` and `f` defined above:
  #
  # extends g f = self: let super = f self; in super // g self super;
  #             = self: let super = { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; }; in super // g self super
  #             = self: { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; } // g self { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; }
  #             = self: { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; } // { foo = "foo" + " + "; }
  #             = self: { foo = "foo + "; bar = "bar"; foobar = self.foo + self.bar; }
  #
  extends = f: rattrs: self: let super = rattrs self; in super // f self super;

  # Compose two extending functions of the type expected by 'extends'
  # into one where changes made in the first are available in the
  # 'super' of the second
  composeExtensions =
    f: g: final: prev:
      let fApplied = f final prev;
          prev' = prev // fApplied;
      in fApplied // g final prev';

  # Compose several extending functions of the type expected by 'extends' into
  # one where changes made in preceding functions are made available to
  # subsequent ones.
  #
  # composeManyExtensions : [packageSet -> packageSet -> packageSet] -> packageSet -> packageSet -> packageSet
  #                          ^final        ^prev         ^overrides     ^final        ^prev         ^overrides
  composeManyExtensions =
    lib.foldr (x: y: composeExtensions x y) (final: prev: {});

  # Create an overridable, recursive attribute set. For example:
  #
  #     nix-repl> obj = makeExtensible (self: { })
  #
  #     nix-repl> obj
  #     { __unfix__ = «lambda»; extend = «lambda»; }
  #
  #     nix-repl> obj = obj.extend (self: super: { foo = "foo"; })
  #
  #     nix-repl> obj
  #     { __unfix__ = «lambda»; extend = «lambda»; foo = "foo"; }
  #
  #     nix-repl> obj = obj.extend (self: super: { foo = super.foo + " + "; bar = "bar"; foobar = self.foo + self.bar; })
  #
  #     nix-repl> obj
  #     { __unfix__ = «lambda»; bar = "bar"; extend = «lambda»; foo = "foo + "; foobar = "foo + bar"; }
  makeExtensible = makeExtensibleWithCustomName "extend";

  # Same as `makeExtensible` but the name of the extending attribute is
  # customized.
  makeExtensibleWithCustomName = extenderName: rattrs:
    fix' rattrs // {
      ${extenderName} = f: makeExtensibleWithCustomName extenderName (extends f rattrs);
   };

  /*
    Creates an overridable attrset with encapsulation.

    This is like `makeExtensible`, but only the `public` attribute of the fixed
    point is returned.

    Synopsis:

        r = encapsulate (final@{extend, ...}: {

          # ... private attributes for `final` ...

          public = {
            # ... returned attributes for r, in terms of `final` ...
            inherit extend; # optional, don't invoke too often; see below
          };
        })

        s = r.extend (final: previous: {

          # ... updates to private attributes ...

          # optionally
          public = previous.public // {
            # ... updates to public attributes ...
          };
        })

    = Performance

    The `extend` function evaluates the whole fixed point all over, reusing
    no "intermediate results" from the existing object.
    This is necessary, because `final` has changed.
    So the cost is quadratic; O(n^2) where n = number of chained invocations.
    This has consequences for interface design.
    Although enticing, `extend` is not suitable for directly implementing "fluent interfaces", where the caller makes many calls to `extend` via domain-specific "setters" or `with*` functions.
    Fluent interfaces can not be implemented efficiently in Nix and have very little to offer over attribute sets in terms of usability.*

    Example:

        # cd nixpkgs; nix repl lib

        nix-repl> multiplier = encapsulate (self: {
          a = 1;
          b = 1;
          public = {
            r = self.a * self.b;

            # Publishing extend makes the attrset open for any kind of change.
            inherit (self) extend;

            # Instead, or additionally, you can add domain-specific functions.
            # Offer a single method with multiple arguments, and not a
            # "fluent interface" of a method per argument, because all extension
            # functions are called for every `extend`. See the Performance section.
            withParams = args@{ a ? null, b ? null }: # NB: defaults are not used
              self.extend (self: super: args);

          };
        })

        nix-repl> multiplier
        { extend = «lambda»; r = 1; withParams =«lambda»; }

        nix-repl> multiplier.withParams { a = 42; b = 10; }
        { extend = «lambda»; r = 420; withParams =«lambda»; }

        nix-repl> multiplier3 = multiplier.extend (self: super: {
          c = 1;
          public = super.public // {
            r = super.public.r * self.c;
          };
        })

        nix-repl> multiplier3.extend (self: super: { a = 2; b = 3; c = 10; })
        { extend = «lambda»; r = 60; withParams =«lambda»; }

    (*) Final note on Fluent APIs: While the asymptotic complexity can be fixed
        by avoiding overlay extension or perhaps using it only at the end of the
        chain only, one problem remains. Every method invocation has to produce
        a new, immutable state value, which means copying the whole state up to
        that point.

  */
  encapsulate = layerZero:
    let
      fixed = layerZero ({ extend = f: encapsulate (extends f layerZero); } // fixed);
    in fixed.public;

}
