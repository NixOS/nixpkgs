{ lib, ... }:
rec {
  /**
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

    # Inputs

    `f`

    : 1\. Function argument

    # Type

    ```
    fix :: (a -> a) -> a
    ```

    # Examples
    :::{.example}
    ## `lib.fixedPoints.fix` usage example

    ```nix
    fix (self: { foo = "foo"; bar = "bar"; foobar = self.foo + self.bar; })
    => { bar = "bar"; foo = "foo"; foobar = "foobar"; }

    fix (self: [ 1 2 (elemAt self 0 + elemAt self 1) ])
    => [ 1 2 3 ]
    ```

    :::
  */
  fix =
    f:
    let
      x = f x;
    in
    x;

  /**
    A variant of `fix` that records the original recursive attribute set in the
    result, in an attribute named `__unfix__`.

    This is useful in combination with the `extends` function to
    implement deep overriding.

    # Inputs

    `f`

    : 1\. Function argument
  */
  fix' =
    f:
    let
      x = f x // {
        __unfix__ = f;
      };
    in
    x;

  /**
    Return the fixpoint that `f` converges to when called iteratively, starting
    with the input `x`.

    ```
    nix-repl> converge (x: x / 2) 16
    0
    ```

    # Inputs

    `f`

    : 1\. Function argument

    `x`

    : 2\. Function argument

    # Type

    ```
    (a -> a) -> a -> a
    ```
  */
  converge =
    f: x:
    let
      x' = f x;
    in
    if x' == x then x else converge f x';

  /**
    Extend a function using an overlay.

    Overlays allow modifying and extending fixed-point functions, specifically ones returning attribute sets.
    A fixed-point function is a function which is intended to be evaluated by passing the result of itself as the argument.
    This is possible due to Nix's lazy evaluation.

    A fixed-point function returning an attribute set has the form

    ```nix
    final: { # attributes }
    ```

    where `final` refers to the lazily evaluated attribute set returned by the fixed-point function.

    An overlay to such a fixed-point function has the form

    ```nix
    final: prev: { # attributes }
    ```

    where `prev` refers to the result of the original function to `final`, and `final` is the result of the composition of the overlay and the original function.

    Applying an overlay is done with `extends`:

    ```nix
    let
      f = final: { # attributes };
      overlay = final: prev: { # attributes };
    in extends overlay f;
    ```

    To get the value of `final`, use `lib.fix`:

    ```nix
    let
      f = final: { # attributes };
      overlay = final: prev: { # attributes };
      g = extends overlay f;
    in fix g
    ```

    :::{.note}
    The argument to the given fixed-point function after applying an overlay will *not* refer to its own return value, but rather to the value after evaluating the overlay function.

    The given fixed-point function is called with a separate argument than if it was evaluated with `lib.fix`.
    :::

    :::{.example}

    # Extend a fixed-point function with an overlay

    Define a fixed-point function `f` that expects its own output as the argument `final`:

    ```nix-repl
    f = final: {
      # Constant value a
      a = 1;

      # b depends on the final value of a, available as final.a
      b = final.a + 2;
    }
    ```

    Evaluate this using [`lib.fix`](#function-library-lib.fixedPoints.fix) to get the final result:

    ```nix-repl
    fix f
    => { a = 1; b = 3; }
    ```

    An overlay represents a modification or extension of such a fixed-point function.
    Here's an example of an overlay:

    ```nix-repl
    overlay = final: prev: {
      # Modify the previous value of a, available as prev.a
      a = prev.a + 10;

      # Extend the attribute set with c, letting it depend on the final values of a and b
      c = final.a + final.b;
    }
    ```

    Use `extends overlay f` to apply the overlay to the fixed-point function `f`.
    This produces a new fixed-point function `g` with the combined behavior of `f` and `overlay`:

    ```nix-repl
    g = extends overlay f
    ```

    The result is a function, so we can't print it directly, but it's the same as:

    ```nix-repl
    g' = final: {
      # The constant from f, but changed with the overlay
      a = 1 + 10;

      # Unchanged from f
      b = final.a + 2;

      # Extended in the overlay
      c = final.a + final.b;
    }
    ```

    Evaluate this using [`lib.fix`](#function-library-lib.fixedPoints.fix) again to get the final result:

    ```nix-repl
    fix g
    => { a = 11; b = 13; c = 24; }
    ```
    :::

    # Inputs

    `overlay`

    : The overlay to apply to the fixed-point function

    `f`

    : The fixed-point function

    # Type

    ```
    extends :: (Attrs -> Attrs -> Attrs) # The overlay to apply to the fixed-point function
            -> (Attrs -> Attrs) # A fixed-point function
            -> (Attrs -> Attrs) # The resulting fixed-point function
    ```

    # Examples
    :::{.example}
    ## `lib.fixedPoints.extends` usage example

    ```nix
    f = final: { a = 1; b = final.a + 2; }

    fix f
    => { a = 1; b = 3; }

    fix (extends (final: prev: { a = prev.a + 10; }) f)
    => { a = 11; b = 13; }

    fix (extends (final: prev: { b = final.a + 5; }) f)
    => { a = 1; b = 6; }

    fix (extends (final: prev: { c = final.a + final.b; }) f)
    => { a = 1; b = 3; c = 4; }
    ```

    :::
  */
  extends =
    overlay: f:
    # The result should be thought of as a function, the argument of that function is not an argument to `extends` itself
    (
      final:
      let
        prev = f final;
      in
      prev // overlay final prev
    );

  /**
    Compose two overlay functions and return a single overlay function that combines them.
    For more details see: [composeManyExtensions](#function-library-lib.fixedPoints.composeManyExtensions).
  */
  composeExtensions =
    f: g: final: prev:
    let
      fApplied = f final prev;
      prev' = prev // fApplied;
    in
    fApplied // g final prev';

  /**
    Composes a list of [`overlays`](#chap-overlays) and returns a single overlay function that combines them.

    :::{.note}
    The result is produced by using the update operator `//`.
    This means nested values of previous overlays are not merged recursively.
    In other words, previously defined attributes are replaced, ignoring the previous value, unless referenced by the overlay; for example `final: prev: { foo = final.foo + 1; }`.
    :::

    # Inputs

    `extensions`

    : A list of overlay functions
      :::{.note}
      The order of the overlays in the list is important.
      :::

    : Each overlay function takes two arguments, by convention `final` and `prev`, and returns an attribute set.
      - `final` is the result of the fixed-point function, with all overlays applied.
      - `prev` is the result of the previous overlay function(s).

    # Type

    ```
    # Pseudo code
    let
      #               final      prev
      #                 ↓          ↓
      OverlayFn = { ... } -> { ... } -> { ... };
    in
      composeManyExtensions :: ListOf OverlayFn -> OverlayFn
    ```

    # Examples
    :::{.example}
    ## `lib.fixedPoints.composeManyExtensions` usage example

    ```nix
    let
      # The "original function" that is extended by the overlays.
      # Note that it doesn't have prev: as argument since no overlay function precedes it.
      original = final: { a = 1; };

      # Each overlay function has 'final' and 'prev' as arguments.
      overlayA = final: prev: { b = final.c; c = 3; };
      overlayB = final: prev: { c = 10; x = prev.c or 5; };

      extensions = composeManyExtensions [ overlayA overlayB ];

      # Caluculate the fixed point of all composed overlays.
      fixedpoint = lib.fix (lib.extends extensions original );

    in fixedpoint
    =>
    {
      a = 1;
      b = 10;
      c = 10;
      x = 3;
    }
    ```
    :::
  */
  composeManyExtensions = lib.foldr (x: y: composeExtensions x y) (final: prev: { });

  /**
    Create an overridable, recursive attribute set. For example:

    ```
    nix-repl> obj = makeExtensible (final: { })

    nix-repl> obj
    { __unfix__ = «lambda»; extend = «lambda»; }

    nix-repl> obj = obj.extend (final: prev: { foo = "foo"; })

    nix-repl> obj
    { __unfix__ = «lambda»; extend = «lambda»; foo = "foo"; }

    nix-repl> obj = obj.extend (final: prev: { foo = prev.foo + " + "; bar = "bar"; foobar = final.foo + final.bar; })

    nix-repl> obj
    { __unfix__ = «lambda»; bar = "bar"; extend = «lambda»; foo = "foo + "; foobar = "foo + bar"; }
    ```
  */
  makeExtensible = makeExtensibleWithCustomName "extend";

  /**
    Same as `makeExtensible` but the name of the extending attribute is
    customized.

    # Inputs

    `extenderName`

    : 1\. Function argument

    `rattrs`

    : 2\. Function argument
  */
  makeExtensibleWithCustomName =
    extenderName: rattrs:
    fix' (
      self:
      (rattrs self)
      // {
        ${extenderName} = f: makeExtensibleWithCustomName extenderName (extends f rattrs);
      }
    );

  /**
    Convert to an extending function (overlay).

    `toExtension` is the `toFunction` for extending functions (a.k.a. extensions or overlays).
    It converts a non-function or a single-argument function to an extending function,
    while returning a two-argument function as-is.

    That is, it takes a value of the shape `x`, `prev: x`, or `final: prev: x`,
    and returns `final: prev: x`, assuming `x` is not a function.

    This function takes care of the input to `stdenv.mkDerivation`'s
    `overrideAttrs` function.
    It bridges the gap between `<pkg>.overrideAttrs`
    before and after the overlay-style support.

    # Inputs

    `f`
    : The function or value to convert to an extending function.

    # Type

    ```
    toExtension ::
      b' -> Any -> Any -> b'
    or
    toExtension ::
      (a -> b') -> Any -> a -> b'
    or
    toExtension ::
      (a -> a -> b) -> a -> a -> b
    where b' = ! Callable

    Set a = b = b' = AttrSet & ! Callable to make toExtension return an extending function.
    ```

    # Examples
    :::{.example}
    ## `lib.fixedPoints.toExtension` usage example

    ```nix
    fix (final: { a = 0; c = final.a; })
    => { a = 0; c = 0; };

    fix (extends (toExtension { a = 1; b = 2; }) (final: { a = 0; c = final.a; }))
    => { a = 1; b = 2; c = 1; };

    fix (extends (toExtension (prev: { a = 1; b = prev.a; })) (final: { a = 0; c = final.a; }))
    => { a = 1; b = 0; c = 1; };

    fix (extends (toExtension (final: prev: { a = 1; b = prev.a; c = final.a + 1 })) (final: { a = 0; c = final.a; }))
    => { a = 1; b = 0; c = 2; };
    ```
    :::
  */
  toExtension =
    f:
    if lib.isFunction f then
      final: prev:
      let
        fPrev = f prev;
      in
      if lib.isFunction fPrev then
        # f is (final: prev: { ... })
        f final prev
      else
        # f is (prev: { ... })
        fPrev
    else
      # f is not a function; probably { ... }
      final: prev: f;
}
