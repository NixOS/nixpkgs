# Bazel {#bazel}

[Bazel](https://bazel.build/) is a build system emphasizing speed, support for multiple languages, and extensibility.

It is typically used by packages that use multiple languages.

## `buildBazelPackage` {#buildBazelPackage}

`buildBazelPackage` is a builder used for building Bazel packages.

### Parameters {#buildBazelPackage-parameters}

`bazel`
:    The package containing the version of Bazel you want to use (for example, `bazel_6`). **Required**.
`bazelFlags`
:    A list of flags to pass to all invocations of Bazel in the builder ([flags reference]).
`bazelBuildFlags`
:    A list of flags to pass to the invocation of Bazel when running `bazel build` ([flags reference]).
bazelTestFlags
:    A list of flags to pass to the invocation of Bazel when running `bazel test` ([flags reference]).
bazelRunFlags
:    A list of flags to pass to the invocation of Bazel when running `bazel run` ([flags reference]).
runTargetFlags
:    A list of flags to pass to the executable when running `bazel run` ([flags reference]).
bazelFetchFlags
:    A list of flags to pass to the executable when running `bazel fetch` when downloading dependencies ([flags reference]).
bazelTargets
:    A list of [target]s to pass to all invocations of Bazel in the builder.
bazelTestTargets
:    A list of [target]s to pass to the invocation of Bazel when running `bazel test`.
bazelRunTarget
:    The [target] to pass to the invocation of Bazel when running `bazel run`.
buildAttrs
:    An attribute set containing values that will be passed to `stdenv.mkDerivation` inside `buildBazelPackage`.
fetchAttrs
:    An attribute set containing values that will be passed to the fixed-output derivation's `stdenv.mkDerivation` inside `buildBazelPackage`. **`hash` is required.**
removeRulesCC
:    When set to `false`, the built-in `rules_cc` is preserved, which is often needed in some older packages. Bazel is attempting to move these rules to [a separate repository](https://github.com/bazelbuild/rules_cc).
removeLocalConfigCc
:    When set to `false`, the built-in `local_config_cc` is preserved, which is often needed in some older packages.
removeLocal
:    When set to `false`, all built-in rules starting with `local_` are preserved.

[flags reference]: https://bazel.build/docs/user-manual
[target]: https://bazel.build/concepts/build-ref#targets
