# versionCheckHook {#versioncheckhook}

This hook adds a `versionCheckPhase` to the [`preInstallCheckHooks`](#ssec-installCheck-phase) that runs the main program of the derivation with a `--help` or `--version` argument, and checks that the `${version}` string is found in that output. If this check fails then the whole build will fail. _(A softer option is [`testers.testVersion`](#tester-testVersion).)_

You use it like this:

```nix
{
  lib,
  stdenv,
  versionCheckHook,
# ...
}:

stdenv.mkDerivation (finalAttrs: {
  # ...

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # ...
})
```

Note that for [`buildPythonPackage`](#buildpythonpackage-function) and [`buildPythonApplication`](#buildpythonapplication-function), `doInstallCheck` is enabled by default.

It does so in a clean environment (using `env --ignore-environment`), and it checks for the `${version}` string in both the `stdout` and the `stderr` of the command. It will report to you in the build log the output it received and it will fail the build if it failed to find `${version}`.

The variables that this phase control are:

- `dontVersionCheck`: Disable adding this hook to the [`preInstallCheckHooks`](#ssec-installCheck-phase). Useful if you do want to load the bash functions of the hook, but run them differently.
- `versionCheckProgram`: The full path to the program that should print the `${version}` string. Defaults to using the first non-empty value `$binary` out of `${NIX_MAIN_PROGRAM}` and `${pname}`, in that order, to build roughly `${placeholder "out"}/bin/$binary`. `${NIX_MAIN_PROGRAM}`'s value comes from `meta.mainProgram`, and does not normally need to be set explicitly. When setting `versionCheckProgram`, using `$out` directly won't work, as environment variables from this variable are not expanded by the hook. Hence using `placeholder "out"` is unavoidable.
- `versionCheckProgramArg`: The argument that needs to be passed to `versionCheckProgram`. If undefined the hook tries first `--help` and then `--version`. Examples: `version`, `-V`, `-v`.
- `versionCheckKeepEnvironment`: A list of environment variables to keep and pass to the command. Only those variables should be added to this list that are actually required for the version command to work. If it is not feasible to explicitly list all these environment variables you can set this parameter to the special value `"*"` to disable the `--ignore-environment` flag and thus keep all environment variables.
- `preVersionCheck`: A hook to run before the check is done.
- `postVersionCheck`: A hook to run after the check is done.

This check assumes the executable is _hermetic_. If environment variables such as `PATH` or `HOME` are required for the program to function, then [`testers.testVersion`](#tester-testVersion) is currently the better alternative.
