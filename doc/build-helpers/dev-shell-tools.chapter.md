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
# => "/nix/store/...-foo"
```

```nix
devShellTools.valueToString false
# => ""
```

:::

## `devShellTools.unstructuredDerivationInputEnv` {#sec-devShellTools-unstructuredDerivationInputEnv}

Convert a set of derivation attributes (as would be passed to [`derivation`]) to a set of environment variables that can be used in a shell script.
This function does not support `__structuredAttrs`, but does support `passAsFile`.

:::{.example}
## `unstructuredDerivationInputEnv` usage example

```nix
devShellTools.unstructuredDerivationInputEnv {
  drvAttrs = {
    name = "foo";
    buildInputs = [
      hello
      figlet
    ];
    builder = bash;
    args = [
      "-c"
      "${./builder.sh}"
    ];
  };
}
# => {
#  name = "foo";
#  buildInputs = "/nix/store/...-hello /nix/store/...-figlet";
#  builder = "/nix/store/...-bash";
#}
```

Note that `args` is not included, because Nix does not added it to the builder process environment.

:::

## `devShellTools.derivationOutputEnv` {#sec-devShellTools-derivationOutputEnv}

Takes the relevant parts of a derivation and returns a set of environment variables, that would be present in the derivation.

:::{.example}
## `derivationOutputEnv` usage example

```nix
let
  pkg = hello;
in
devShellTools.derivationOutputEnv {
  outputList = pkg.outputs;
  outputMap = pkg;
}
```

:::
