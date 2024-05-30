# Meta-attributes {#chap-meta}

Nix packages can declare *meta-attributes* that contain information about a package such as a description, its homepage, its license, and so on. For instance, the GNU Hello package has a `meta` declaration like this:

```nix
{
  meta = {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = "https://www.gnu.org/software/hello/manual/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eelco ];
    platforms = lib.platforms.all;
  };
}
```

Meta-attributes are not passed to the builder of the package. Thus, a change to a meta-attribute doesn’t trigger a recompilation of the package.

## Standard meta-attributes {#sec-standard-meta-attributes}

It is expected that each meta-attribute is one of the following:

### `description` {#var-meta-description}

A short (one-line) description of the package.
This is displayed on [search.nixos.org](https://search.nixos.org/packages).

Don’t include a period at the end. Don’t include newline characters. Capitalise the first character. For brevity, don’t repeat the name of package --- just describe what it does.

Wrong: `"libpng is a library that allows you to decode PNG images."`

Right: `"A library for decoding PNG images"`

### `longDescription` {#var-meta-longDescription}

An arbitrarily long description of the package in [CommonMark](https://commonmark.org) Markdown.

### `branch` {#var-meta-branch}

Release branch. Used to specify that a package is not going to receive updates that are not in this branch; for example, Linux kernel 3.0 is supposed to be updated to 3.0.X, not 3.1.

### `homepage` {#var-meta-homepage}

The package’s homepage. Example: `https://www.gnu.org/software/hello/manual/`

### `downloadPage` {#var-meta-downloadPage}

The page where a link to the current version can be found. Example: `https://ftp.gnu.org/gnu/hello/`

### `changelog` {#var-meta-changelog}

A link or a list of links to the location of Changelog for a package. A link may use expansion to refer to the correct changelog version. Example: `"https://git.savannah.gnu.org/cgit/hello.git/plain/NEWS?h=v${version}"`

### `license` {#var-meta-license}

The license, or licenses, for the package. One from the attribute set defined in [`nixpkgs/lib/licenses.nix`](https://github.com/NixOS/nixpkgs/blob/master/lib/licenses.nix). At this moment using both a list of licenses and a single license is valid. If the license field is in the form of a list representation, then it means that parts of the package are licensed differently. Each license should preferably be referenced by their attribute. The non-list attribute value can also be a space delimited string representation of the contained attribute `shortNames` or `spdxIds`. The following are all valid examples:

- Single license referenced by attribute (preferred) `lib.licenses.gpl3Only`.
- Single license referenced by its attribute shortName (frowned upon) `"gpl3Only"`.
- Single license referenced by its attribute spdxId (frowned upon) `"GPL-3.0-only"`.
- Multiple licenses referenced by attribute (preferred) `with lib.licenses; [ asl20 free ofl ]`.
- Multiple licenses referenced as a space delimited string of attribute shortNames (frowned upon) `"asl20 free ofl"`.

For details, see [Licenses](#sec-meta-license).

### `maintainers` {#var-meta-maintainers}

A list of the maintainers of this Nix expression. Maintainers are defined in [`nixpkgs/maintainers/maintainer-list.nix`](https://github.com/NixOS/nixpkgs/blob/master/maintainers/maintainer-list.nix). There is no restriction to becoming a maintainer, just add yourself to that list in a separate commit titled “maintainers: add alice” in the same pull request, and reference maintainers with `maintainers = with lib.maintainers; [ alice bob ]`.

### `mainProgram` {#var-meta-mainProgram}

The name of the main binary for the package. This affects the binary `nix run` executes. Example: `"rg"`

### `priority` {#var-meta-priority}

The *priority* of the package, used by `nix-env` to resolve file name conflicts between packages. See the [manual page for `nix-env`](https://nixos.org/manual/nix/stable/command-ref/nix-env) for details. Example: `"10"` (a low-priority package).

### `platforms` {#var-meta-platforms}

The list of Nix platform types on which the package is supported. Hydra builds packages according to the platform specified. If no platform is specified, the package does not have prebuilt binaries. An example is:

```nix
{
  meta.platforms = lib.platforms.linux;
}
```

Attribute Set `lib.platforms` defines [various common lists](https://github.com/NixOS/nixpkgs/blob/master/lib/systems/doubles.nix) of platforms types.

### `badPlatforms` {#var-meta-badPlatforms}

The list of Nix [platform types](https://github.com/NixOS/nixpkgs/blob/b03ac42b0734da3e7be9bf8d94433a5195734b19/lib/meta.nix#L75-L81) on which the package is known not to be buildable.
Hydra will never create prebuilt binaries for these platform types, even if they are in [`meta.platforms`](#var-meta-platforms).
In general it is preferable to set `meta.platforms = lib.platforms.all` and then exclude any platforms on which the package is known not to build.
For example, a package which requires dynamic linking and cannot be linked statically could use this:

```nix
{
  meta.platforms = lib.platforms.all;
  meta.badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
}
```

The [`lib.meta.availableOn`](https://github.com/NixOS/nixpkgs/blob/b03ac42b0734da3e7be9bf8d94433a5195734b19/lib/meta.nix#L95-L106) function can be used to test whether or not a package is available (i.e. buildable) on a given platform.
Some packages use this to automatically detect the maximum set of features with which they can be built.
For example, `systemd` [requires dynamic linking](https://github.com/systemd/systemd/issues/20600#issuecomment-912338965), and [has a `meta.badPlatforms` setting](https://github.com/NixOS/nixpkgs/blob/b03ac42b0734da3e7be9bf8d94433a5195734b19/pkgs/os-specific/linux/systemd/default.nix#L752) similar to the one above.
Packages which can be built with or without `systemd` support will use `lib.meta.availableOn` to detect whether or not `systemd` is available on the [`hostPlatform`](#ssec-cross-platform-parameters) for which they are being built; if it is not available (e.g. due to a statically-linked host platform like `pkgsStatic`) this support will be disabled by default.

### `tests` {#var-meta-tests}

::: {.warning}
This attribute is special in that it is not actually under the `meta` attribute set but rather under the `passthru` attribute set. This is due to how `meta` attributes work, and the fact that they are supposed to contain only metadata, not derivations.
:::

An attribute set with tests as values. A test is a derivation that builds when the test passes and fails to build otherwise.

You can run these tests with:

```ShellSession
$ cd path/to/nixpkgs
$ nix-build -A your-package.tests
```

Note that Hydra and [`nixpkgs-review`](https://github.com/Mic92/nixpkgs-review) don't build these derivations by default, and that ([`@ofborg`](https://github.com/NixOS/ofborg)) only builds them when evaluating PRs for that particular package (or when manually instructed).

#### Package tests {#var-meta-tests-packages}

Tests that are part of the source package are often executed in the `installCheckPhase`. This phase is also suitable for performing a `--version` test for packages that support such flag. Here's an example:

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

Most programs distributed by Nixpkgs support such a `--version` flag, and it can help give confidence that the package at least got compiled properly. However, tests that are slightly non trivial will better fit into `passthru.tests`, because:

* `passthru.tests` tests the 'real' package, independently from the environment in which it was built
* We can run and debug a `passthru.tests` independently, after the package was built (useful if it takes a long time).
* `installCheckPhase` adds overhead to each build

It is also possible to still use `passthru.tests` to test the version, with [testVersion](#tester-testVersion).

For more on how to write and run package tests, see [`pkgs/README.md`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#package-tests).

#### NixOS tests {#var-meta-tests-nixos}

The NixOS tests are available as `nixosTests` in parameters of derivations. For instance, the OpenSMTPD derivation includes lines similar to:

```nix
{ /* ... , */ nixosTests }:
{
  # ...
  passthru.tests = {
    basic-functionality-and-dovecot-integration = nixosTests.opensmtpd;
  };
}
```

NixOS tests run in a VM, so they are slower than regular package tests. For more information see [NixOS module tests](https://nixos.org/manual/nixos/stable/#sec-nixos-tests).

Alternatively, you can specify other derivations as tests. You can make use of
the optional parameter to inject the correct package without
relying on non-local definitions, even in the presence of `overrideAttrs`.
Here that's `finalAttrs.finalPackage`, but you could choose a different name if
`finalAttrs` already exists in your scope.

`(mypkg.overrideAttrs f).passthru.tests` will be as expected, as long as the
definition of `tests` does not rely on the original `mypkg` or overrides it in
all places.

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


### `timeout` {#var-meta-timeout}

A timeout (in seconds) for building the derivation. If the derivation takes longer than this time to build, Hydra will fail it due to breaking the timeout. However, all computers do not have the same computing power, hence some builders may decide to apply a multiplicative factor to this value. When filling this value in, try to keep it approximately consistent with other values already present in `nixpkgs`.

`meta` attributes are not stored in the instantiated derivation.
Therefore, this setting may be lost when the package is used as a dependency.
To be effective, it must be presented directly to an evaluation process that handles the `meta.timeout` attribute.

### `hydraPlatforms` {#var-meta-hydraPlatforms}

The list of Nix platform types for which the [Hydra](https://github.com/nixos/hydra) [instance at `hydra.nixos.org`](https://nixos.org/hydra) will build the package. (Hydra is the Nix-based continuous build system.) It defaults to the value of `meta.platforms`. Thus, the only reason to set `meta.hydraPlatforms` is if you want `hydra.nixos.org` to build the package on a subset of `meta.platforms`, or not at all, e.g.

```nix
{
  meta.platforms = lib.platforms.linux;
  meta.hydraPlatforms = [];
}
```

### `broken` {#var-meta-broken}

If set to `true`, the package is marked as "broken", meaning that it won’t show up in [search.nixos.org](https://search.nixos.org/packages), and cannot be built or installed unless the environment variable [`NIXPKGS_ALLOW_BROKEN`](#opt-allowBroken) is set.
Such unconditionally-broken packages should be removed from Nixpkgs eventually unless they are fixed.

The value of this attribute can depend on a package's arguments, including `stdenv`.
This means that `broken` can be used to express constraints, for example:

- Does not cross compile

  ```nix
  {
    meta.broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  }
  ```

- Broken if all of a certain set of its dependencies are broken

  ```nix
  {
    meta.broken = lib.all (map (p: p.meta.broken) [ glibc musl ]);
  }
  ```

This makes `broken` strictly more powerful than `meta.badPlatforms`.
However `meta.availableOn` currently examines only `meta.platforms` and `meta.badPlatforms`, so `meta.broken` does not influence the default values for optional dependencies.

## Licenses {#sec-meta-license}

The `meta.license` attribute should preferably contain a value from `lib.licenses` defined in [`nixpkgs/lib/licenses.nix`](https://github.com/NixOS/nixpkgs/blob/master/lib/licenses.nix), or in-place license description of the same format if the license is unlikely to be useful in another expression.

Although it’s typically better to indicate the specific license, a few generic options are available:

### `lib.licenses.free`, `"free"` {#lib.licenses.free-free}

Catch-all for free software licenses not listed above.

### `lib.licenses.unfreeRedistributable`, `"unfree-redistributable"` {#lib.licenses.unfreeredistributable-unfree-redistributable}

Unfree package that can be redistributed in binary form. That is, it’s legal to redistribute the *output* of the derivation. This means that the package can be included in the Nixpkgs channel.

Sometimes proprietary software can only be redistributed unmodified. Make sure the builder doesn’t actually modify the original binaries; otherwise we’re breaking the license. For instance, the NVIDIA X11 drivers can be redistributed unmodified, but our builder applies `patchelf` to make them work. Thus, its license is `"unfree"` and it cannot be included in the Nixpkgs channel.

### `lib.licenses.unfree`, `"unfree"` {#lib.licenses.unfree-unfree}

Unfree package that cannot be redistributed. You can build it yourself, but you cannot redistribute the output of the derivation. Thus it cannot be included in the Nixpkgs channel.

### `lib.licenses.unfreeRedistributableFirmware`, `"unfree-redistributable-firmware"` {#lib.licenses.unfreeredistributablefirmware-unfree-redistributable-firmware}

This package supplies unfree, redistributable firmware. This is a separate value from `unfree-redistributable` because not everybody cares whether firmware is free.

## Source provenance {#sec-meta-sourceProvenance}

The value of a package's `meta.sourceProvenance` attribute specifies the provenance of the package's derivation outputs.

If a package contains elements that are not built from the original source by a nixpkgs derivation, the `meta.sourceProvenance` attribute should be a list containing one or more value from `lib.sourceTypes` defined in [`nixpkgs/lib/source-types.nix`](https://github.com/NixOS/nixpkgs/blob/master/lib/source-types.nix).

Adding this information helps users who have needs related to build transparency and supply-chain security to gain some visibility into their installed software or set policy to allow or disallow installation based on source provenance.

The presence of a particular `sourceType` in a package's `meta.sourceProvenance` list indicates that the package contains some components falling into that category, though the *absence* of that `sourceType` does not *guarantee* the absence of that category of `sourceType` in the package's contents. A package with no `meta.sourceProvenance` set implies it has no *known* `sourceType`s other than `fromSource`.

The meaning of the `meta.sourceProvenance` attribute does not depend on the value of the `meta.license` attribute.

### `lib.sourceTypes.fromSource` {#lib.sourceTypes.fromSource}

Package elements which are produced by a nixpkgs derivation which builds them from source code.

### `lib.sourceTypes.binaryNativeCode` {#lib.sourceTypes.binaryNativeCode}

Native code to be executed on the target system's CPU, built by a third party. This includes packages which wrap a downloaded AppImage or Debian package.

### `lib.sourceTypes.binaryFirmware` {#lib.sourceTypes.binaryFirmware}

Code to be executed on a peripheral device or embedded controller, built by a third party.

### `lib.sourceTypes.binaryBytecode` {#lib.sourceTypes.binaryBytecode}

Code to run on a VM interpreter or JIT compiled into bytecode by a third party. This includes packages which download Java `.jar` files from another source.
