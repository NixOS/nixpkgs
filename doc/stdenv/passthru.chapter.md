# Passthru-attributes {#chap-passthru}
[]{#var-stdenv-passthru} []{#special-variables} <!-- legacy anchors -->

As opposed to most other `mkDerivation` input attributes, `passthru` is not passed to the derivation's [`builder` executable](https://nixos.org/manual/nix/stable/expressions/derivations.html#attr-builder).
Changing it will not trigger a rebuild – it is "passed through".
Its value can be accessed as if it was set inside a derivation.

::: {.note}
`passthru` attributes follow no particular schema, but there are a few [conventional patterns](#sec-common-passthru-attributes).
:::

:::{.example #ex-accessing-passthru}

## Setting and accessing `passthru` attributes

```nix
{ stdenv, fetchGit }:
let
  hello = stdenv.mkDerivation {
    pname = "hello";
    src = fetchGit { /* ... */ };

    passthru = {
      foo = "bar";
      baz = {
        value1 = 4;
        value2 = 5;
      };
    };
  };
in
hello.baz.value1
```

```
4
```
:::

## Common `passthru`-attributes {#sec-common-passthru-attributes}

Many `passthru` attributes are situational, so this section only lists recurring patterns.
They fall in one of these categories:

- Global conventions, which are applied almost universally in Nixpkgs.

  Generally these don't entail any special support built into the derivation they belong to.
  Common examples of this type are [`passthru.tests`](#var-passthru-tests) and [`passthru.updateScript`](#var-passthru-updateScript).

- Conventions for adding extra functionality to a derivation.

  These tend to entail support from the derivation or the `passthru` attribute in question.
  Common examples of this type are `passthru.optional-dependencies`, `passthru.withPlugins`, and `passthru.withPackages`.
  All of those allow associating the package with a set of components built for that specific package, such as when building Python runtime environments using (`python.withPackages`)[#python.withpackages-function].

Attributes that apply only to particular [build helpers](#part-builders) or [language ecosystems](#chap-language-support) are documented there.

### `passthru.tests` {#var-passthru-tests}
[]{#var-meta-tests} <!-- legacy anchor -->

An attribute set with tests as values.
A test is a derivation that builds when the test passes and fails to build otherwise.

Run these tests with:

```ShellSession
$ cd path/to/nixpkgs
$ nix-build -A your-package.tests
```

:::{.note}
The Nixpkgs systems for continuous integration [Hydra](https://hydra.nixos.org/) and [`nixpkgs-review`](https://github.com/Mic92/nixpkgs-review) don't build these derivations by default, and ([`@ofborg`](https://github.com/NixOS/ofborg)) only builds them when evaluating pull requests for that particular package, or when manually instructed.
:::

#### Package tests {#var-passthru-tests-packages}
[]{#var-meta-tests-packages} <!-- legacy anchor -->

Besides tests provided by upstream, usually executed during the [`checkPhase`](#ssec-check-phase), you may want to define test derivations in the `passthru.tests` attribute, which won't change the build. `passthru.tests` have several advantages over running tests during any of the [standard phases](#sec-stdenv-phases):

- They are derivations themselves, therefore they have access to the whole feature set provided by Nix and Nixpkgs.
  - For example, they can invoke extra tools, build reverse dependencies, fetch external files etc.
- They access the package as consumers would, independently from the environment in which it was built.
- They can be executed and debugged without rebuilding the package, which is useful when that rebuild takes a long time.
- For content-addressed derivations, they test the executable __after__ rewriting instead of _before_, catching cases when the rewriting would break the executable.
- They don't add overhead to each build, as opposed to checks added by the [`installCheckPhase`](#ssec-installCheck-phase), such as [`versionCheckHook`](#versioncheckhook).

Note: Especifically for version-testing, Nixpkgs provides [`testers.testVersion`](#tester-testVersion), traditionally used as `passthru.tests.version` attribute, as well as the `versionCheckHook` mentioned above.

Note: As shown in this [comparison](#versioncheckhook-comparison-testversion), `versionCheckHook` fits better than `testers.testVersion` in most of typical situations.

<!-- NOTE(@fricklerhandwerk): one may argue whether that testing guide should rather be in the user's manual -->
For more on how to write and run package tests for Nixpkgs, see the [testing section in the package contributor guide](https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#package-tests).

#### NixOS tests {#var-passthru-tests-nixos}
[]{#var-meta-tests-nixos} <!-- legacy anchor -->

Tests written for NixOS are available as the `nixosTests` argument to package recipes.
For instance, the [OpenSMTPD derivation](https://search.nixos.org/packages?show=opensmtpd) includes lines similar to:

```nix
{ nixosTests, ... }:
{
  # ...
  passthru.tests = {
    basic-functionality-and-dovecot-integration = nixosTests.opensmtpd;
  };
}
```

NixOS tests run in a virtual machine (VM), so they are slower than regular package tests.
For more information see the NixOS manual on [NixOS module tests](https://nixos.org/manual/nixos/stable/#sec-nixos-tests).

### `passthru.updateScript` {#var-passthru-updateScript}
<!-- legacy anchors -->
[]{#var-passthru-updateScript-command}
[]{#var-passthru-updateScript-set-command}
[]{#var-passthru-updateScript-set-attrPath}
[]{#var-passthru-updateScript-set-supportedFeatures}
[]{#var-passthru-updateScript-env-UPDATE_NIX_NAME}
[]{#var-passthru-updateScript-env-UPDATE_NIX_PNAME}
[]{#var-passthru-updateScript-env-UPDATE_NIX_OLD_VERSION}
[]{#var-passthru-updateScript-env-UPDATE_NIX_ATTR_PATH}
[]{#var-passthru-updateScript-execution}
[]{#var-passthru-updateScript-supported-features}
[]{#var-passthru-updateScript-commit}
[]{#var-passthru-updateScript-commit-attrPath}
[]{#var-passthru-updateScript-commit-oldVersion}
[]{#var-passthru-updateScript-commit-newVersion}
[]{#var-passthru-updateScript-commit-files}
[]{#var-passthru-updateScript-commit-commitBody}
[]{#var-passthru-updateScript-commit-commitMessage}
[]{#var-passthru-updateScript-example-commit}

Nixpkgs tries to automatically update all packages that have an `passthru.updateScript` attribute.
See the [section on automatic package updates in the package contributor guide](https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#automatic-package-updates) for details.
