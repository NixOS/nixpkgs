{ replaceVarsWith }:

/**
  `replaceVars` is a wrapper around the [bash function `substitute`](https://nixos.org/manual/nixpkgs/stable/#fun-substitute)
  in the stdenv. It allows for terse replacement of names in the specified path, while checking
  for common mistakes such as naming a replacement that does nothing or forgetting a variable which
  needs to be replaced.

  As with the [`--subst-var-by`](https://nixos.org/manual/nixpkgs/stable/#fun-substitute-subst-var-by)
  flag, names are encoded as `@name@` in the provided file at the provided path.

  Any unmatched variable names in the file at the provided path will cause a build failure.

  By default, any remaining text that matches `@[A-Za-z_][0-9A-Za-z_'-]@` in the output after replacement
  has occurred will cause a build failure. Variables can be excluded from this check by passing "null" for them.

  # Inputs

  `src` ([Store Path](https://nixos.org/manual/nix/latest/store/store-path.html#store-path) String)
  : The file in which to replace variables.

  `replacements` (AttrsOf String)
  : Each entry in this set corresponds to a `--subst-var-by` entry in [`substitute`](https://nixos.org/manual/nixpkgs/stable/#fun-substitute) or
    null to keep it unchanged.

  # Example

  ```nix
  { replaceVars }:

  replaceVars ./greeting.txt { world = "hello"; }
  ```

  See `../../test/replace-vars/default.nix` for tests of this function.
*/
src: replacements: replaceVarsWith { inherit src replacements; }
