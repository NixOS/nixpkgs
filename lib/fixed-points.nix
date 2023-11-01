{ lib, ... }:
rec {
  /*
    `fix f` computes the fixed point of the given function `f`. In other words, the return value is `x` in `x = f x`.

    `f` must be a lazy function.
    This means that `x` must be a value that can be partially evaluated,
    such as an attribute set, a list, or a function.
    This way, `f` can use one part of `x` to compute another part.

    **Relation to syntactic recursion**

    This section explains `fix` by refactoring from syntactic recursion to a call of `fix` instead.

    For context, Nix lets you define attributes in terms of other attributes syntactically using the [`rec { }` syntax](https://nixos.org/manual/nix/stable/language/constructs.html#recursive-sets).

    ```nix
    nix-repl> rec {
      foo = "foo";
      bar = "bar";
      foobar = foo + bar;
    }
    { bar = "bar"; foo = "foo"; foobar = "foobar"; }
    ```

    This is convenient when constructing a value to pass to a function for example,
    but an equivalent effect can be achieved with the `let` binding syntax:

    ```nix
    nix-repl> let self = {
      foo = "foo";
      bar = "bar";
      foobar = self.foo + self.bar;
    }; in self
    { bar = "bar"; foo = "foo"; foobar = "foobar"; }
    ```

    But in general you can get more reuse out of `let` bindings by refactoring them to a function.

    ```nix
    nix-repl> f = self: {
      foo = "foo";
      bar = "bar";
      foobar = self.foo + self.bar;
    }
    ```

    This is where `fix` comes in, it contains the syntactic recursion that's not in `f` anymore.

    ```nix
    nix-repl> fix = f:
      let self = f self; in self;
    ```

    By applying `fix` we get the final result.

    ```nix
    nix-repl> fix f
    { bar = "bar"; foo = "foo"; foobar = "foobar"; }
    ```

    Such a refactored `f` using `fix` is not useful by itself.
    See [`extends`](#function-library-lib.fixedPoints.extends) for an example use case.
    There `self` is also often called `final`.

    Type: fix :: (a -> a) -> a

    Example:
      fix (self: { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; })
      => { bar = "bar"; foo = "foo"; foobar = "foobar"; }

      fix (self: [ 1 2 (elemAt self 0 + elemAt self 1) ])
      => [ 1 2 3 ]
  */
  fix = f: let x = f x; in x;

  /*
    A variant of `fix` that records the original recursive attribute set in the
    result, in an attribute named `__unfix__`.

    This is useful in combination with the `extends` function to
    implement deep overriding.
  */
  fix' = f: let x = f x // { __unfix__ = f; }; in x;

  /*
    Return the fixpoint that `f` converges to when called iteratively, starting
    with the input `x`.

    ```
    nix-repl> converge (x: x / 2) 16
    0
    ```

    Type: (a -> a) -> a -> a
  */
  converge = f: x:
    let
      x' = f x;
    in
      if x' == x
      then x
      else converge f x';

  /*
    Modify the contents of an explicitly recursive attribute set in a way that
    honors `self`-references. This is accomplished with a function

    ```nix
    g = self: super: { foo = super.foo + " + "; }
    ```

    that has access to the unmodified input (`super`) as well as the final
    non-recursive representation of the attribute set (`self`). `extends`
    differs from the native `//` operator insofar as that it's applied *before*
    references to `self` are resolved:

    ```
    nix-repl> fix (extends g f)
    { bar = "bar"; foo = "foo + "; foobar = "foo + bar"; }
    ```

    The name of the function is inspired by object-oriented inheritance, i.e.
    think of it as an infix operator `g extends f` that mimics the syntax from
    Java. It may seem counter-intuitive to have the "base class" as the second
    argument, but it's nice this way if several uses of `extends` are cascaded.

    To get a better understanding how `extends` turns a function with a fix
    point (the package set we start with) into a new function with a different fix
    point (the desired packages set) lets just see, how `extends g f`
    unfolds with `g` and `f` defined above:

    ```
    extends g f = self: let super = f self; in super // g self super;
                = self: let super = { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; }; in super // g self super
                = self: { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; } // g self { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; }
                = self: { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; } // { foo = "foo" + " + "; }
                = self: { foo = "foo + "; bar = "bar"; foobar = self.foo + self.bar; }
    ```
  */
  extends = f: rattrs: self: let super = rattrs self; in super // f self super;

  /*
    Compose two extending functions of the type expected by 'extends'
    into one where changes made in the first are available in the
    'super' of the second
  */
  composeExtensions =
    f: g: final: prev:
      let fApplied = f final prev;
          prev' = prev // fApplied;
      in fApplied // g final prev';

  /*
    Compose several extending functions of the type expected by 'extends' into
    one where changes made in preceding functions are made available to
    subsequent ones.

    ```
    composeManyExtensions : [packageSet -> packageSet -> packageSet] -> packageSet -> packageSet -> packageSet
                              ^final        ^prev         ^overrides     ^final        ^prev         ^overrides
    ```
  */
  composeManyExtensions =
    lib.foldr (x: y: composeExtensions x y) (final: prev: {});

  /*
    Create an overridable, recursive attribute set. For example:

    ```
    nix-repl> obj = makeExtensible (self: { })

    nix-repl> obj
    { __unfix__ = «lambda»; extend = «lambda»; }

    nix-repl> obj = obj.extend (self: super: { foo = "foo"; })

    nix-repl> obj
    { __unfix__ = «lambda»; extend = «lambda»; foo = "foo"; }

    nix-repl> obj = obj.extend (self: super: { foo = super.foo + " + "; bar = "bar"; foobar = self.foo + self.bar; })

    nix-repl> obj
    { __unfix__ = «lambda»; bar = "bar"; extend = «lambda»; foo = "foo + "; foobar = "foo + bar"; }
    ```
  */
  makeExtensible = makeExtensibleWithCustomName "extend";

  /*
    Same as `makeExtensible` but the name of the extending attribute is
    customized.
  */
  makeExtensibleWithCustomName = extenderName: rattrs:
    fix' (self: (rattrs self) // {
      ${extenderName} = f: makeExtensibleWithCustomName extenderName (extends f rattrs);
    });
}
