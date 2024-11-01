# versionCheckHook {#versioncheckhook}

This hook adds a `versionCheckPhase` to the [`preInstallCheckHooks`](#ssec-installCheck-phase) that runs the main program of the derivation with a `--help` or `--version` argument, and verifies if the `${version}` string is found in the output.

It does so in a clean environment (using `env --ignore-environment --chdir=/`), and it checks for the `${version}` string in both the `stdout` and the `stderr` of the command. It will report to you in the build log the output it received and it will fail the build if it failed to find `${version}`.

Here is a typical usage example:

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

:::

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

## Comparison between `versionCheckHook` and `testers.testVersion` {#versioncheckhook-comparison-testversion}

The most notable difference between `versionCheckHook` and `testers.testVersion` is that `versionCheckHook` runs as a phase during the build time of the package, while `passthru.tests.versions` executes a whole derivation that depends on the package.

Given the current limitations of Nixpkgs's tooling and CI, `versionCheckHook` fits better in most of typical situations.

Below we tabulate the differences between `versionCheckHook` and `testers.testVersion`.

| Item                                      | `versionCheckHook`                                                                                                                                                      | `testers.testVersion` via `passthru.tests.version`                                                                                           |
|-------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| Customization                             | Besides the attributes described above, `versionCheckHook` provides no other methods for controlling it.                                                                | `tests.version` has access to the whole feature set of Nixpkgs, like multiple version test derivations and tools outside the package inputs. |
| Execution time                            | `versionCheckHook` is executed automatically whenever the package is executed, e.g. `nix-build -A pkg`, since it is a phase executed during the package build time.     | `tests.version` is executed only when explicitly called, e.g. `nix-build -A pkg.tests.version`; it is executed after package build time.     |
| Execution environment                     | `versionCheckHook` uses `env --ignore-environment --chdir=/` to run the executables in an environment as clean as possible, but there is no way to change its behavior. | `tests.version` executes in an environment identical to that of a consumer, independent from the package build environment.                  |
| Rebuild after modification                | Modifying `versionCheckHook` triggers the package rebuild.                                                                                                              | `tests.version` does not rebuild the package, since it runs after package build time.                                                        |
| Overhead during package build time        | Negligible. Although executed during the the package build time, `versionCheckHook` is lean and executes few commands.                                                  | Zero, since `tests.version` is a derivation that runs after package build time.                                                              |
| Failure detection time                    | `versionCheckHook` runs during the package build time, therefore it does not deal with failures happening after that.                                                   | `tests.version` detects failures after package build time, like rewritings and relocations.                                                  |
| Package breakage awareness                | Loud and clear as soon as `versionCheckHook` is reached during the package build time.                                                                                  | Requires specific commands to be noticed, e.g. `nix-build -A pkg.tests.version`.                                                             |
| OfBorg CI                                 | `versionCheckHook` will be executed by OfBorg, since ofBorg automatically executes the packages affected by the pull request (PR).                                      | OfBorg supports automatic execution of `passthru.tests` for _packages directly affected_ by the PR.                                          |
| OfBorg CI, transitive dependencies        | `versionCheckHook` will executed by OfBorg, since it builds transitive dependencies of a package affected by the PR. (????)                                             | OfBorg does not support automatic execution of `passthru.tests` for transitive dependencies,  requiring extra commands for this.             |
| `nixpkgs-review`                          | `versionCheckHook` will be executed by `nixpkgs-review`.                                                                                                                | `nixpkgs-review` has no support for executing `passthru.tests` at all. [^1]                                                                  |
| `nixpkgs-review`, transitive dependencies | `versionCheckHook` will be executed by `nixpkgs-review`, since the tool reaches transitive dependencies automatically.                                                  | `nixpkgs-review` has no support for executing `passthru.tests` at all,  even for transitive dependencies. [^1]                               |

[^1]: There is a [pull request proposal](https://github.com/Mic92/nixpkgs-review/pull/397) against [`nixpkgs-review`](https://github.com/Mic92/nixpkgs-review) for adding support to `passthru.tests` execution.
