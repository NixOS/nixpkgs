# makeSetupHook' {#build-helpers-special-makeSetupHookPrime}

`makeSetupHook'` is a build helper which produces hooks which may be added to a derivation's `nativeBuildInputs`.

This helper differs from `makeSetupHook`[#sec-pkgs.makesetuphook] in several ways:

- it uses `pkgs.replaceVars` instead of the bash function `substituteAll`
- it uses `sourceGuard`[#setup-hook-sourceGuard] to source the script
- `strictDeps` is set to `true`
- script dependencies are provided using the `nativeBuildInputs` and `buildInputs` arguments rather than `propagatedBuildInputs` and `depsTargetTargetPropagated`
- the script argument must be a path and is interpolated into a string, causing Nix to create a store path for only it, enforcing isolation


:::{.example #ex-makeSetupHookPrime-doc-example}

# Usage example of makeSetupHook'

Re-using the example from [`makeSetupHook`](#sec-pkgs.makeSetupHook-usage-example):

```nix
pkgs.makeSetupHook' {
  name = "run-hello-hook";
  guardName = "runHelloHook";
  script = writeScript "run-hello-hook.sh" ''
    #!@shell@
    # the direct path to the executable has to be here because
    # this will be run when the file is sourced
    # at which point '$PATH' has not yet been populated with inputs
    @cowsay@ cow

    _printHelloHook() {
      hello
    }
    preConfigureHooks+=(_printHelloHook)
  '';
  nativeBuildInputs = [
    pkgs.cowsay
    pkgs.hello
  ];
  replacements = {
    cowsay = lib.getExe pkgs.cowsay;
    shell = lib.getExe pkgs.bash;
  };
}
```

Note that we must specify `guardName`, since `name` is not a valid bash identifier.

:::

## Inputs {#build-helpers-special-makeSetupHookPrime-inputs}

`name` (string)

: The name of the hook.

`guardName` (string, optional)

: The name of the guard.
  `guardName` must be a valid bash identifier.
  When `useSourceGuard` is enabled, `guardName` defaults to the value of `name`.

`script` (path-like)

: The derivation or store path to make into a hook.
  The script path is interpolated into a string, causing Nix to create a store path for only it, enforcing isolation.
  Values in the script may be replaced using the `replacements` argument.

`nativeBuildInputs` (array of path-like values, optional)
: A list of derivations or store paths which should be added to the `nativeBuildInputs` of derivations which include this hook in their `nativeBuildInputs`.
  When not provided, this value defaults to `[ ]`.

`buildInputs` (array of path-like values, optional)
: A list of derivations or store paths which should be added to the `buildInputs` of derivations which include this hook in their `nativeBuildInputs`.
  When not provided, this value defaults to `[ ]`.

`useSourceGuard` (boolean, optional)
: Whether to use `sourceGuard`[#setup-hook-sourceGuard] to source the hook.
  When not provided, this value defaults to `true`.

`replacements` (attribute set of string-like values, optional)
: A map of string-like values which are used to replace variables in `script`.
  When not provided, this value defaults to `{ }`.

`passthru` (attribute set, optional)
: A map of values which are passed to the `passthru` attribute of the hook derivation.
  When not provided, this value defaults to `{ }`.

`meta` (attribute set, optional)
: A map of values which are passed to the `meta` attribute of the hook derivation.
  When not provided, this value defaults to `{ }`.
