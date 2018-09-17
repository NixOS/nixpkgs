{ ... }:
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
}
