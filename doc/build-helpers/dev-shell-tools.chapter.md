# Development Shell helpers {#chap-devShellTools}

The `nix-shell` command has popularized the concept of transient shell environments for development or testing purposes.
<!--
  We should try to document the product, not its development process in the Nixpkgs reference manual,
  but *something* needs to be said to provide context for this library.
  This is the most future proof sentence I could come up with while Nix itself does yet make use of this.
  Relevant is the current status of the devShell attribute "project": https://github.com/NixOS/nix/issues/7501
  -->
However, `nix-shell` is not the only way to create such environments, and even `nix-shell` itself can indirectly benefit from this library.

This library provides a set of functions that help create such environments.

## `devShellTools.valueToString` {#sec-devShellTools-valueToString}

Converts Nix values to strings in the way the [`derivation` built-in function](https://nix.dev/manual/nix/2.23/language/derivations) does.

:::{.example}
## `valueToString` usage examples

```nix
devShellTools.valueToString (builtins.toFile "foo" "bar")
=> "/nix/store/...-foo"
```

```nix
devShellTools.valueToString false
=> ""
```
