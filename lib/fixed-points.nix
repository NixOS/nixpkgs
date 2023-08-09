{ lib, ... }:
rec {
  /*
    Compute the fixed point of the given function `f`, which is usually an
    attribute set that expects its final, non-recursive representation as an
    argument:

    ```
    f = self: { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; }
    ```

    Nix evaluates this recursion until all references to `self` have been
    resolved. At that point, the final result is returned and `f x = x` holds:

    ```
    nix-repl> fix f
    { bar = "bar"; foo = "foo"; foobar = "foobar"; }
    ```

    Type: fix :: (a -> a) -> a

    See https://en.wikipedia.org/wiki/Fixed-point_combinator for further
    details.
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
    `extends overlay f` applies the overlay `overlay` to the fixed-point function `f` to get a new fixed-point function.
    Overlays allow modifying and extending fixed-point functions, specifically ones returning attribute sets.

    A fixed-point function is a function which is intended to be evaluated by passing the result of itself as the argument, only possible due to Nix's lazy evaluation.
    Here's an example of one:
    ```
    f = final: {
      # Constant value a
      a = 1;

      # b depends on the final value of a, available as final.a
      b = final.a + 2;
    }
    ```
    We can evaluated this using [`lib.fix`](#function-library-lib.fixedPoints.fix) to get the final result:
    ```
    fix f
    => { a = 1; b = 3; }
    ```

    An overlay represents a modification or extension of such a fixed-point function.
    Here's an example of an overlay:
    ```
    overlay = final: prev: {
      # Modify the previous value of a, available as prev.a
      a = prev.a + 10;

      # Extend the attribute set with c, letting it depend on the final values of a and b
      c = final.a + final.b;
    }
    ```

    We can now use `extends overlay f` to apply the overlay to the fixed-point function `f`, giving us a new fixed-point function `g` with the combined behavior of `f` and `overlay`.
    ```
    g = extends overlay f
    ```
    The result is a function, so we can't print it directly, but it's the same as:
    ```
    g = final: {
      # The constant from f, but changed with the overlay
      a = 1 + 10;

      # Unchanged from f
      b = final.a + 2;

      # Extended in the overlay
      c = final.a + final.b;
    }
    ```

    We can evaluate this using [`lib.fix`](#function-library-lib.fixedPoints.fix) again to get the final result:
    ```
    fix g
    => { a = 11; b = 13; c = 24; }
    ```

    Type:
      extends :: (Attrs -> Attrs -> Attrs) # The overlay to apply to the fixed-point function
              -> (Attrs -> Attrs) # A fixed-point function
              -> (Attrs -> Attrs) # The resulting fixed-point function

    Example:
      f = final: { a = 1; b = final.a + 2; }

      fix f
      => { a = 1; b = 3; }

      fix (extends (final: prev: { a = prev.a + 10; }) f)
      => { a = 11; b = 13; }

      fix (extends (final: prev: { b = final.a + 5; }) f)
      => { a = 1; b = 6; }

      fix (extends (final: prev: { c = final.a + final.b; }) f)
      => { a = 1; b = 3; c = 4; }
  */
  extends =
    # The overlay to apply to the fixed-point function
    overlay:
    # The fixed-point function
    f:
    # Wrap with parenthesis to prevent nixdoc from rendering the `final` argument in the documentation
    # The result should be thought of as a function, the argument of that function is not an argument to `extends` itself
    (
      final:
      let
        prev = f final;
      in
      prev // overlay final prev
    );

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
