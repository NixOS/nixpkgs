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
  extends = f: rattrs: self: let super = rattrs self; in super // f self super;

  # Compose two extending functions of the type expected by 'extends'
  # into one where changes made in the first are available in the
  # 'super' of the second
  composeExtensions =
    f: g: self: super:
      let fApplied = f self super;
          super' = super // fApplied;
      in fApplied // g self super';

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
  makeExtensibleWithCustomName = extenderName: f: makeExtensibleWithInterface
    (fixedPoint: extend: fixedPoint // { ${extenderName} = ext: extend (_: ext); })
    (_: f);

  # A version of `makeExtensible` that allows the function being fixed
  # to return a different interface than the interface returned to the
  # user. Along with `self` and `super` views of the internal
  # interface, a `self` view of the output interface is also
  # provided. `extend` is not added to the output by default. This is
  # the job of the interface.
  #
  #     nix-repl> foo = {a, b}: {c = a + b;}
  #
  #     nix-repl> interface = {args, val, ...}: extend: val // {inherit extend;}
  #
  #     nix-repl> obj = makeExtensibleWithInterface interface (output: self: { args = {a = 1; b = 2;}; val = foo self.args; })
  #
  #     nix-repl> obj.c
  #     3
  #
  #     nix-repl> obj = obj.extend (output: self: super: { args = super.args // { b = output.d; }; })
  #
  #     nix-repl> obj = obj.extend (output: self: super: { val = super.val // { d = 10; }; })
  #
  #     nix-repl> { inherit (obj) c d; }
  #     { c = 11; d = 10; }
  makeExtensibleWithInterface = interface: f: let i = interface
    (fix' (f i))
    (fext: makeExtensibleWithInterface interface (i': (extends (fext i') (f i'))));
  in i;
}
