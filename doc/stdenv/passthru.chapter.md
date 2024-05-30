# Passthru-attributes {#chap-passthru}
[]{#var-stdenv-passthru} []{#special-variables} <!-- legacy anchors -->

`passthru` is an attribute set which can be filled with arbitrary values.
For example:

```nix
{
  passthru = {
    foo = "bar";
    baz = {
      value1 = 4;
      value2 = 5;
    };
  };
}
```

Much of the passthru's power comes from two features:
- You can access passthru attributes as if they were set inside a derivation (e.g. `hello.baz.value1`).
- These values are not passed to the builder, so you can change them without triggering a rebuild.

One example of the passthru's power is how it enables us to associate the package for an interpreter Python or Ruby with a set of modules built for that specific interpreter (e.g., `python.pkgs` and `ruby.gems`) and to build runtime environments with a collection of those modules (e.g., (`python.withPackages`)[#python.withpackages-function] and `ruby.withPackages`).
<!-- python.pkgs, ruby.gems, and ruby.withPackages are mentioned but don't have dedicated sections to link -->

::: {.note}
Since `passthru` is meant for values that are useful outside the derivation (e.g. in other derivations), it has no strict schema.
:::

<!--
I'm extracting this statement from the old text because I feel like it isn't very clearly-phrased and doesn't help connect with something most people know already.
I still think we should try to make sure the pattern it models is represented in the list of common attributes, though:

convey a specific dependency of your derivation which contains a program with plugins support.
Later, others who make derivations with plugins can use passed-through dependency to ensure that their plugin would be binary-compatible with built program.
-->

## Common passthru-attributes {#sec-common-passthru-attributes}

Many `passthru` attributes are situational, so this section only attempts to list recurring attributes and patterns.
Very broadly, passthru attributes listed here fall in one of these categories:
<!--
Very broadly, an attribute is worth documenting here if it fits either description below.
Attributes that apply only to a single builder or language ecosystem are best documented alongside the builder or related docs.
-->

- Attributes that are (at least in theory) globally relevant--you could find them on any derivation in nixpkgs (generally because they don't entail any special support be built into the derivation they're added to).
  Common examples of this type are `passthru.tests` and `passthru.updateScript`.
- Common patterns for adding extra functionality to a derivation (which do tend to entail building support into the derivation or its passthru).
  Common examples of this type are `passthru.optional-dependencies`, `passthru.withPlugins`, and `passthru.withPackages`.

### `passthru.tests` {#var-passthru-tests}
[]{#var-meta-tests} <!-- legacy anchor -->

An attribute set with tests as values.
A test is a derivation that builds when the test passes and fails to build otherwise.

You can run these tests with:

```ShellSession
$ cd path/to/nixpkgs
$ nix-build -A your-package.tests
```

Note that Hydra and [`nixpkgs-review`](https://github.com/Mic92/nixpkgs-review) don't build these derivations by default, and that ([`@ofborg`](https://github.com/NixOS/ofborg)) only builds them when evaluating PRs for that particular package (or when manually instructed).

#### Package tests {#var-passthru-tests-packages}
[]{#var-meta-tests-packages} <!-- legacy anchor -->

Tests that are part of the source package are often executed in the `installCheckPhase`.
This phase is also suitable for performing a `--version` test for packages that support such flag.
Here's an example:

```nix
# Say the package is git
stdenv.mkDerivation(finalAttrs: {
  pname = "git";
  version = "...";
  # ...

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo checking if 'git --version' mentions ${finalAttrs.version}
    $out/bin/git --version | grep ${finalAttrs.version}

    runHook postInstallCheck
  '';
  # ...
})
```

Most programs distributed by Nixpkgs support such a `--version` flag, and it can help give confidence that the package at least got compiled properly.
However, tests that are slightly non trivial will better fit into `passthru.tests` because:

* `passthru.tests` tests the 'real' package, independently from the environment in which it was built
* we can run and debug `passthru.tests` without rebuilding the package (useful if it takes a long time)
* `installCheckPhase` adds overhead to each build

It is also possible to use `passthru.tests` to test the version with [testVersion](#tester-testVersion).

For more on how to write and run package tests, see [`pkgs/README.md`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#package-tests).

#### NixOS tests {#var-passthru-tests-nixos}
[]{#var-meta-tests-nixos} <!-- legacy anchor -->

The NixOS tests are available as `nixosTests` in parameters of derivations.
For instance, the OpenSMTPD derivation includes lines similar to:

```nix
{ /* ... , */ nixosTests }:
{
  # ...
  passthru.tests = {
    basic-functionality-and-dovecot-integration = nixosTests.opensmtpd;
  };
}
```

NixOS tests run in a VM, so they are slower than regular package tests.
For more information see [NixOS module tests](https://nixos.org/manual/nixos/stable/#sec-nixos-tests).

Alternatively, you can specify other derivations as tests.
You can make use of the optional parameter to inject the correct package without relying on non-local definitions, even in the presence of `overrideAttrs`.
Here that's `finalAttrs.finalPackage`, but you could choose a different name if `finalAttrs` already exists in your scope.

`(mypkg.overrideAttrs f).passthru.tests` will be as expected, as long as the definition of `tests` does not rely on the original `mypkg` or overrides it in all places.

```nix
# my-package/default.nix
{ stdenv, callPackage }:
stdenv.mkDerivation (finalAttrs: {
  # ...
  passthru.tests.example = callPackage ./example.nix { my-package = finalAttrs.finalPackage; };
})
```

```nix
# my-package/example.nix
{ runCommand, lib, my-package, ... }:
runCommand "my-package-test" {
  nativeBuildInputs = [ my-package ];
  src = lib.sources.sourcesByRegex ./. [ ".*.in" ".*.expected" ];
} ''
  my-package --help
  my-package <example.in >example.actual
  diff -U3 --color=auto example.expected example.actual
  mkdir $out
''
```


### `passthru.updateScript` {#var-passthru-updateScript}

A script to be run by `maintainers/scripts/update.nix` when the package is matched.
The attribute can contain one of the following:

- []{#var-passthru-updateScript-command} an executable file, either on the file system:

  ```nix
  {
    passthru.updateScript = ./update.sh;
  }
  ```

  or inside the expression itself:

  ```nix
  {
    passthru.updateScript = writeScript "update-zoom-us" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre2 common-updater-scripts

      set -eu -o pipefail

      version="$(curl -sI https://zoom.us/client/latest/zoom_x86_64.tar.xz | grep -Fi 'Location:' | pcre2grep -o1 '/(([0-9]\.?)+)/')"
      update-source-version zoom-us "$version"
    '';
  }
  ```

- a list, a script followed by arguments to be passed to it:

  ```nix
  {
    passthru.updateScript = [ ../../update.sh pname "--requested-release=unstable" ];
  }
  ```

- an attribute set containing:
  - [`command`]{#var-passthru-updateScript-set-command} – a string or list in the [format expected by `passthru.updateScript`](#var-passthru-updateScript-command).
  - [`attrPath`]{#var-passthru-updateScript-set-attrPath} (optional) – a string containing the canonical attribute path for the package.
    If present, it will be passed to the update script instead of the attribute path on which the package was discovered during Nixpkgs traversal.
  - [`supportedFeatures`]{#var-passthru-updateScript-set-supportedFeatures} (optional) – a list of the [extra features](#var-passthru-updateScript-supported-features) the script supports.

  ```nix
  {
    passthru.updateScript = {
      command = [ ../../update.sh pname ];
      attrPath = pname;
      supportedFeatures = [ /* ... */ ];
    };
  }
  ```

::: {.tip}
A common pattern is to use the [`nix-update-script`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/common-updater/nix-update.nix) attribute provided in Nixpkgs, which runs [`nix-update`](https://github.com/Mic92/nix-update):

```nix
{
  passthru.updateScript = nix-update-script { };
}
```

For simple packages, this is often enough, and will ensure that the package is updated automatically by [`nixpkgs-update`](https://ryantm.github.io/nixpkgs-update) when a new version is released.
The [update bot](https://nix-community.org/update-bot) runs periodically to attempt to automatically update packages, and will run `passthru.updateScript` if set.
While not strictly necessary if the project is listed on [Repology](https://repology.org), using `nix-update-script` allows the package to update via many more sources (e.g. GitHub releases).
:::

#### How update scripts are executed? {#var-passthru-updateScript-execution}

Update scripts are to be invoked by `maintainers/scripts/update.nix` script.
You can run `nix-shell maintainers/scripts/update.nix` in the root of Nixpkgs repository for information on how to use it.
`update.nix` offers several modes for selecting packages to update (e.g. select by attribute path, traverse Nixpkgs and filter by maintainer, etc.), and it will execute update scripts for all matched packages that have an `updateScript` attribute.

Each update script will be passed the following environment variables:

- [`UPDATE_NIX_NAME`]{#var-passthru-updateScript-env-UPDATE_NIX_NAME} – content of the `name` attribute of the updated package.
- [`UPDATE_NIX_PNAME`]{#var-passthru-updateScript-env-UPDATE_NIX_PNAME} – content of the `pname` attribute of the updated package.
- [`UPDATE_NIX_OLD_VERSION`]{#var-passthru-updateScript-env-UPDATE_NIX_OLD_VERSION} – content of the `version` attribute of the updated package.
- [`UPDATE_NIX_ATTR_PATH`]{#var-passthru-updateScript-env-UPDATE_NIX_ATTR_PATH} – attribute path the `update.nix` discovered the package on (or the [canonical `attrPath`](#var-passthru-updateScript-set-attrPath) when available). Example: `pantheon.elementary-terminal`

::: {.note}
An update script will be usually run from the root of the Nixpkgs repository but you should not rely on that.
Also note that `update.nix` executes update scripts in parallel by default so you should avoid running `git commit` or any other commands that cannot handle that.
:::

::: {.tip}
While update scripts should not create commits themselves, `maintainers/scripts/update.nix` supports automatically creating commits when running it with `--argstr commit true`.
If you need to customize commit message, you can have the update script implement [`commit`](#var-passthru-updateScript-commit) feature.
:::

#### Supported features {#var-passthru-updateScript-supported-features}
##### `commit` {#var-passthru-updateScript-commit}

This feature allows update scripts to *ask* `update.nix` to create Git commits.

When support of this feature is declared, whenever the update script exits with `0` return status, it is expected to print a JSON list containing an object described below for each updated attribute to standard output.

When `update.nix` is run with `--argstr commit true` arguments, it will create a separate commit for each of the objects.
An empty list can be returned when the script did not update any files, for example, when the package is already at the latest version.

The commit object contains the following values:

- [`attrPath`]{#var-passthru-updateScript-commit-attrPath} – a string containing attribute path.
- [`oldVersion`]{#var-passthru-updateScript-commit-oldVersion} – a string containing old version.
- [`newVersion`]{#var-passthru-updateScript-commit-newVersion} – a string containing new version.
- [`files`]{#var-passthru-updateScript-commit-files} – a non-empty list of file paths (as strings) to add to the commit.
- [`commitBody`]{#var-passthru-updateScript-commit-commitBody} (optional) – a string with extra content to be appended to the default commit message (useful for adding changelog links).
- [`commitMessage`]{#var-passthru-updateScript-commit-commitMessage} (optional) – a string to use instead of the default commit message.

If the returned array contains exactly one object (e.g. `[{}]`), all values are optional and will be determined automatically.

::: {.example #var-passthru-updateScript-example-commit}
# Standard output of an update script using commit feature

```json
[
  {
    "attrPath": "volume_key",
    "oldVersion": "0.3.11",
    "newVersion": "0.3.12",
    "files": [
      "/path/to/nixpkgs/pkgs/development/libraries/volume-key/default.nix"
    ]
  }
]
```
:::
