rec {

  # Identity function.
  id = x: x;

  # Constant function.
  const = x: y: x;

  # Named versions corresponding to some builtin operators.
  concat = x: y: x ++ y;
  or = x: y: x || y;
  and = x: y: x && y;
  mergeAttrs = x: y: x // y;

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

  # Flip the order of the arguments of a binary function.
  flip = f: a: b: f b a;

  # Pull in some builtins not included elsewhere.
  inherit (builtins)
    pathExists readFile isBool isFunction
    isInt add sub lessThan
    seq deepSeq genericClosure;

  inherit (import ./strings.nix) fileContents;

  # Return the Nixpkgs version number.
  nixpkgsVersion =
    let suffixFile = ../.version-suffix; in
    fileContents ../.version
    + (if pathExists suffixFile then fileContents suffixFile else "pre-git");

  # Whether we're being called by nix-shell.
  inNixShell = builtins.getEnv "IN_NIX_SHELL" != "";

  # Return minimum/maximum of two numbers.
  min = x: y: if x < y then x else y;
  max = x: y: if x > y then x else y;

  /* Reads a JSON file. It is useful to import pure data into other nix
     expressions.

     Example:

       mkDerivation {
         src = fetchgit (importJSON ./repo.json)
         #...
       }

       where repo.json contains:

       {
         "url": "git://some-domain/some/repo",
         "rev": "265de7283488964f44f0257a8b4a055ad8af984d",
         "sha256": "0sb3h3067pzf3a7mlxn1hikpcjrsvycjcnj9hl9b1c3ykcgvps7h"
       }

  */
  importJSON = path:
    builtins.fromJSON (builtins.readFile path);

  /* See https://github.com/NixOS/nix/issues/749. Eventually we'd like these
     to expand to Nix builtins that carry metadata so that Nix can filter out
     the INFO messages without parsing the message string.

     Usage:
     {
       foo = lib.warn "foo is deprecated" oldFoo;
     }

     TODO: figure out a clever way to integrate location information from
     something like __unsafeGetAttrPos.
  */
  warn = msg: builtins.trace "WARNING: ${msg}";
  info = msg: builtins.trace "INFO: ${msg}";
}
