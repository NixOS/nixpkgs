# versionCheckHook {#versioncheckhook}

This hook adds a `versionCheckPhase` to the [`preInstallCheckHooks`](#ssec-installCheck-phase) that runs the main program of the derivation with a `--help` or `--version` argument, and verifies if the `${version}` string is found in the output.

Here is a typical usage:

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

Note that some builders, e.g. [`buildPythonPackage`](#buildpythonpackage-function) and [`buildPythonApplication`](#buildpythonapplication-function), enable `doInstallCheck` by default.

It does so in a clean environment (using `env --ignore-environment`), and it checks for the `${version}` string in both the `stdout` and the `stderr` of the command. It will report to you in the build log the output it received and it will fail the build if it failed to find `${version}`.

The attributes below control this hook:

- `dontVersionCheck`: When set as `true`, the hook is not added to the [`preInstallCheckHooks`](#ssec-installCheck-phase).

  Useful when one wants to load the function defined by the hook, in order to use them differently.

  Defaults to false.

- `versionCheckProgram`: The full path to the program to be executed.

   Defaults to `${placeholder "out"}/bin/${pname}`, roughly speaking.

   The usage of `placeholder "out"` instead of `$out` here is unavoidable, since the hook does not expand environment variables.

- `versionCheckProgramArg`: The argument to be passed to `versionCheckProgram`.

  When not defined, the hook tries `--help` first and then `--version`.

   Examples: `version`, `-V`, `-v`.

- `preVersionCheck`: Hook that runs before the check is done. Defaults to an empty string.

- `postVersionCheck`: Hook that runs after the check is done. Defaults to an empty string.

## Comparison between `versionCheckHook` and `testers.testVersion` {#versioncheckhook-comparison-testversion}

Nixpkgs provides a similar test tool, namely [`testers.testVersion`](#tester-testVersion).

The most notable difference between `versionCheckHook` and `testers.testVersion` is that `versionCheckHook` runs at the build time of the package, while `passthru.tests.versions` executes a whole derivation that depends on the package.

The advantages of `testers.testVersion` over `versionCheckHook` are listed at [Package tests](#var-passthru-tests-packages) already. Below we will list some advantages of `versionCheckHook` over `testers.testVersion`:

- Since [`nixpkgs-review`](https://github.com/Mic92/nixpkgs-review) does not execute `passthru.tests` attributes, it will not execute `passthru.tests.version`.

  On the other hand, `versionCheckPhase` will be executed as a regular phase during the build time of the derivation, therefore it will be indirectly catched by `nixpkgs-review`, working around this limitation.

- When a pull request is opened against Nixpkgs repository, [ofborg](https://github.com/NixOS/ofborg)'s CI will automatically run `passthru.tests` attributes for the packages that are [directly changed by your PR (according to your commits' messages)](https://github.com/NixOS/ofborg?tab=readme-ov-file#automatic-building).

  However, ofBorg does not run the `passthru.tests` attributes for _transitive dependencies_ of those packages. To execute them, commands like [`@ofborg build dependency1 dependency2 ...`](https://github.com/NixOS/ofborg?tab=readme-ov-file#build) are needed.

  On the other hand, `versionCheckPhase` will be executed as a regular phase during the build time of the derivation, therefore it will be indirectly catched by ofBorg, working around this limitation.

- Sometimes a package triggers no errors while being build, especially when the upstream provides no tests, however it fails at runtime. If you don't use such a tool in a regular basis, such a silent breakage may rot in your system / profile configuration, not being noticed until the next usage of this package.

  Although `passthru.tests` fills the same purpose, it is more prone to be forgotten by human beings; on the other hand, `versionCheckPhase` will be executed as a regular phase during the build time of the derivation, therefore it will not be accidentally ignored.

Despite having an almost identical functioning and a huge overlap, `versionCheckHook` and `testers.testVersion` have complementary roles, and there are no impediments for using both at the same time.
