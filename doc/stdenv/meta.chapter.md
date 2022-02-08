# Meta-attributes {#chap-meta}

Nix packages can declare *meta-attributes* that contain information about a package such as a description, its homepage, its license, and so on. For instance, the GNU Hello package has a `meta` declaration like this:

```nix
meta = with lib; {
  description = "A program that produces a familiar, friendly greeting";
  longDescription = ''
    GNU Hello is a program that prints "Hello, world!" when you run it.
    It is fully customizable.
  '';
  homepage = "https://www.gnu.org/software/hello/manual/";
  license = licenses.gpl3Plus;
  maintainers = [ maintainers.eelco ];
  platforms = platforms.all;
};
```

Meta-attributes are not passed to the builder of the package. Thus, a change to a meta-attribute doesn’t trigger a recompilation of the package. The value of a meta-attribute must be a string.

The meta-attributes of a package can be queried from the command-line using `nix-env`:

```ShellSession
$ nix-env -qa hello --json
{
    "hello": {
        "meta": {
            "description": "A program that produces a familiar, friendly greeting",
            "homepage": "https://www.gnu.org/software/hello/manual/",
            "license": {
                "fullName": "GNU General Public License version 3 or later",
                "shortName": "GPLv3+",
                "url": "http://www.fsf.org/licensing/licenses/gpl.html"
            },
            "longDescription": "GNU Hello is a program that prints \"Hello, world!\" when you run it.\nIt is fully customizable.\n",
            "maintainers": [
                "Ludovic Court\u00e8s <ludo@gnu.org>"
            ],
            "platforms": [
                "i686-linux",
                "x86_64-linux",
                "armv5tel-linux",
                "armv7l-linux",
                "mips32-linux",
                "x86_64-darwin",
                "i686-cygwin",
                "i686-freebsd",
                "x86_64-freebsd",
                "i686-openbsd",
                "x86_64-openbsd"
            ],
            "position": "/home/user/dev/nixpkgs/pkgs/applications/misc/hello/default.nix:14"
        },
        "name": "hello-2.9",
        "system": "x86_64-linux"
    }
}
```

`nix-env` knows about the `description` field specifically:

```ShellSession
$ nix-env -qa hello --description
hello-2.3  A program that produces a familiar, friendly greeting
```

## Standard meta-attributes {#sec-standard-meta-attributes}

It is expected that each meta-attribute is one of the following:

### `description` {#var-meta-description}

A short (one-line) description of the package. This is shown by `nix-env -q --description` and also on the Nixpkgs release pages.

Don’t include a period at the end. Don’t include newline characters. Capitalise the first character. For brevity, don’t repeat the name of package --- just describe what it does.

Wrong: `"libpng is a library that allows you to decode PNG images."`

Right: `"A library for decoding PNG images"`

### `longDescription` {#var-meta-longDescription}

An arbitrarily long description of the package.

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

A list of the maintainers of this Nix expression. Maintainers are defined in [`nixpkgs/maintainers/maintainer-list.nix`](https://github.com/NixOS/nixpkgs/blob/master/maintainers/maintainer-list.nix). There is no restriction to becoming a maintainer, just add yourself to that list in a separate commit titled “maintainers: add alice”, and reference maintainers with `maintainers = with lib.maintainers; [ alice bob ]`.

### `mainProgram` {#var-meta-mainProgram}

The name of the main binary for the package. This effects the binary `nix run` executes and falls back to the name of the package. Example: `"rg"`

### `priority` {#var-meta-priority}

The *priority* of the package, used by `nix-env` to resolve file name conflicts between packages. See the Nix manual page for `nix-env` for details. Example: `"10"` (a low-priority package).

### `platforms` {#var-meta-platforms}

The list of Nix platform types on which the package is supported. Hydra builds packages according to the platform specified. If no platform is specified, the package does not have prebuilt binaries. An example is:

```nix
meta.platforms = lib.platforms.linux;
```

Attribute Set `lib.platforms` defines [various common lists](https://github.com/NixOS/nixpkgs/blob/master/lib/systems/doubles.nix) of platforms types.

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

#### Package tests

Tests that are part of the source package are often executed in the `installCheckPhase`.

Prefer `passthru.tests` for tests that are introduced in nixpkgs because:

* `passthru.tests` tests the 'real' package, independently from the environment in which it was built
* we can run `passthru.tests` independently
* `installCheckPhase` adds overhead to each build

For more on how to write and run package tests, see <xref linkend="sec-package-tests"/>.

#### NixOS tests

The NixOS tests are available as `nixosTests` in parameters of derivations. For instance, the OpenSMTPD derivation includes lines similar to:

```nix
{ /* ... */, nixosTests }:
{
  # ...
  passthru.tests = {
    basic-functionality-and-dovecot-integration = nixosTests.opensmtpd;
  };
}
```

NixOS tests run in a VM, so they are slower than regular package tests. For more information see [NixOS module tests](https://nixos.org/manual/nixos/stable/#sec-nixos-tests).

### `timeout` {#var-meta-timeout}

A timeout (in seconds) for building the derivation. If the derivation takes longer than this time to build, it can fail due to breaking the timeout. However, all computers do not have the same computing power, hence some builders may decide to apply a multiplicative factor to this value. When filling this value in, try to keep it approximately consistent with other values already present in `nixpkgs`.

### `hydraPlatforms` {#var-meta-hydraPlatforms}

The list of Nix platform types for which the Hydra instance at `hydra.nixos.org` will build the package. (Hydra is the Nix-based continuous build system.) It defaults to the value of `meta.platforms`. Thus, the only reason to set `meta.hydraPlatforms` is if you want `hydra.nixos.org` to build the package on a subset of `meta.platforms`, or not at all, e.g.

```nix
meta.platforms = lib.platforms.linux;
meta.hydraPlatforms = [];
```

### `broken` {#var-meta-broken}

If set to `true`, the package is marked as "broken", meaning that it won’t show up in `nix-env -qa`, and cannot be built or installed. Such packages should be removed from Nixpkgs eventually unless they are fixed.

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
