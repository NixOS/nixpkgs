# versionCheckHook {#versioncheckhook}

This hook adds a `versionCheckPhase` to the [`preInstallCheckHooks`](#ssec-installCheck-phase) that runs the main program of the derivation with a `--help` or `--version` argument, and verifies if the `${version}` string is found in the output.

Here is a typical usage:

:::{.example #ex-versioncheckhook-phantom}

```nix
{
  lib,
  stdenv,
  versionCheckHook,
  # ...
}:

stdenv.mkDerivation (finalAttrs: {
  # ...

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  # ...
})
```

It does so in a clean environment (using `env --ignore-environment`), and it checks for the `${version}` string in both the `stdout` and the `stderr` of the command. It will report to you in the build log the output it received and it will fail the build if it failed to find `${version}`.

Note that `doInstallCheck` is enabled by default for [`buildPythonPackage`](#buildpythonpackage-function) and [`buildPythonApplication`](#buildpythonapplication-function).

## Attributes controlling versionCheckHook {#versioncheckhook-attributes-controlling}

The following attributes control `versionCheckHook`:

- `dontVersionCheck`: When set as `true`, the hook is not added to the [`preInstallCheckHooks`](#ssec-installCheck-phase).

  Useful when one wants to load the function defined by the hook, so that it can be used for a different purpose.

  Defaults to false.

- `versionCheckProgram`: The full path to the program to be executed.

   Defaults to `${placeholder "out"}/bin/${pname}`, roughly speaking.

   The usage of `placeholder "out"` instead of `$out` here is unavoidable, since the hook does not expand environment variables.

- `versionCheckProgramArg`: The argument to be passed to `versionCheckProgram`.

  When not defined, the hook tries `--help` first and then `--version`.

  Examples: `version`, `-V`, `-v`.

- `preVersionCheck`: Hook that runs before the check is done. Defaults to an empty string.

- `postVersionCheck`: Hook that runs after the check is done. Defaults to an empty string.

Note: see also [`testers.testVersion`](#tester-testVersion).
