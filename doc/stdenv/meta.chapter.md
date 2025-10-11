# Meta-attributes {#chap-meta}

Nix packages can declare *meta-attributes* that contain information about a package such as a description, its homepage, its license, and so on. For instance, the GNU Hello package has a `meta` declaration like this:

```nix
{
  meta = {
    description = "Program that produces a familiar, friendly greeting";
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

If the package is to be submitted to Nixpkgs, please check out the
[requirements for meta attributes](https://github.com/NixOS/nixpkgs/tree/master/pkgs#meta-attributes)
in the contributing documentation.

It is expected that each meta-attribute is one of the following:

### `description` {#var-meta-description}

A short (one-line) description of the package.
This is displayed on [search.nixos.org](https://search.nixos.org/packages).

The general requirements of a description are:

- Be short, just one sentence.
- Be capitalized.
- Not start with definite ("The") or indefinite ("A"/"An") article.
- Not start with the package name.
  - More generally, it should not refer to the package name.
- Not end with a period (or any punctuation for that matter).
- Provide factual information.
  - Avoid subjective language.


Wrong: `"libpng is a library that allows you to decode PNG images."`

Right: `"Library for decoding PNG images"`

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

### `sourceProvenance` {#var-meta-sourceProvenance}

A list containing the type or types of source inputs from which the package is built, e.g. original source code, pre-built binaries, etc.

For details, see [Source provenance](#sec-meta-sourceProvenance).

### `maintainers` {#var-meta-maintainers}

A list of the maintainers of this Nix expression. Maintainers are defined in [`nixpkgs/maintainers/maintainer-list.nix`](https://github.com/NixOS/nixpkgs/blob/master/maintainers/maintainer-list.nix). There is no restriction to becoming a maintainer, just add yourself to that list in a separate commit titled “maintainers: add alice” in the same pull request, and reference maintainers with `maintainers = with lib.maintainers; [ alice bob ]`.

### `teams` {#var-meta-teams}

A list of the teams of this Nix expression. Teams are defined in [`nixpkgs/maintainers/team-list.nix`](https://github.com/NixOS/nixpkgs/blob/master/maintainers/team-list.nix), and can be defined in a package with `meta.teams = with lib.teams; [ team1 team2 ]`.

### `mainProgram` {#var-meta-mainProgram}

The name of the main binary for the package. This affects the binary `nix run` executes. Example: `"rg"`

### `priority` {#var-meta-priority}

The *priority* of the package, used by `nix-env` to resolve file name conflicts between packages. See the [manual page for `nix-env`](https://nixos.org/manual/nix/stable/command-ref/nix-env) for details. Example: `"10"` (a low-priority package).

### `platforms` {#var-meta-platforms}

The list of Nix platform types on which the package is supported. Hydra builds packages according to the platform specified. If no platform is specified, the package does not have prebuilt binaries. An example is:

```nix
{ meta.platforms = lib.platforms.linux; }
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
  meta.hydraPlatforms = [ ];
}
```

### `broken` {#var-meta-broken}

If set to `true`, the package is marked as "broken", meaning that it won’t show up in [search.nixos.org](https://search.nixos.org/packages), and cannot be built or installed unless the environment variable [`NIXPKGS_ALLOW_BROKEN`](#opt-allowBroken) is set.
Such unconditionally-broken packages should be removed from Nixpkgs eventually unless they are fixed.

The value of this attribute can depend on a package's arguments, including `stdenv`.
This means that `broken` can be used to express constraints, for example:

- Does not cross compile

  ```nix
  { meta.broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform); }
  ```

- Broken if all of a certain set of its dependencies are broken

  ```nix
  {
    meta.broken = lib.all (
      map (p: p.meta.broken) [
        glibc
        musl
      ]
    );
  }
  ```

This makes `broken` strictly more powerful than `meta.badPlatforms`.
However `meta.availableOn` currently examines only `meta.platforms` and `meta.badPlatforms`, so `meta.broken` does not influence the default values for optional dependencies.

## `knownVulnerabilities` {#var-meta-knownVulnerabilities}

A list of known vulnerabilities affecting the package, usually identified by CVE identifiers.

This metadata allows users and tools to be aware of unresolved security issues before using the package, for example:

```nix
{
  meta.knownVulnerabilities = [
    "CVE-2024-3094: Malicious backdoor allowing unauthorized remote code execution"
  ];
}
```

If this list is not empty, the package is marked as "insecure", meaning that it cannot be built or installed unless the environment variable [`NIXPKGS_ALLOW_INSECURE`](#sec-allow-insecure) is set.

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

## Software identifiers {#sec-meta-identifiers}

Package's `meta.identifiers` attribute specifies information about software identifiers associated with this package. Software identifiers are used, for example:
* to generate Software Bill of Materials (SBOM) that lists all components used to build the software, which can later be used to perform vulnerability or license analysis of the resulting software;
* to lookup software in different vulnerability databases or report new vulnerabilities to them.

Overriding the default `meta.identifiers` attribute is optional, but it is recommended to fill in pieces to help tools mentioned above get precise data.
For example, we could get automatic notifications about potential vulnerabilities for users in the future.
All identifiers specified in `meta.identifiers` are expected to be unambiguous and valid.

`meta.identifiers` contains `v1` attribute which is an attribute set that guarantees backward compatibility of its constituents. Right now it contains copies of all other attributes in `meta.identifiers`.

### CPE {#sec-meta-identifiers-cpe}

Common Platform Enumeration (CPE) is a specification maintained by NIST as part of the Security Content Automation Protocol (SCAP). It is used to identify software in National Vulnerabilities Database (NVD, https://nvd.nist.gov) and other vulnerability databases.

Current version of CPE 2.3 consists of 13 parts:

```
cpe:2.3:a:<vendor>:<product>:<version>:<update>:<edition>:<language>:<sw_edition>:<target_sw>:<target_hw>:<other>
```

Some of them are as follows:

* *CPE version* - current version of CPE is `2.3`
* *part* - usually in Nixpkgs `a` for "application", can also be `o` for "operating system" or `h` for "hardware"
* *vendor* - can point to the source of the package, or to Nixpkgs itself
* *product* - name of the package
* *version* - version of the package
* *update* - name of the latest update, can be a patch version for semantically versioned packages
* *edition* - any additional specification about the version

You can find information about all of these attributes in the [official specification](https://csrc.nist.gov/projects/security-content-automation-protocol/specifications/cpe/naming) (heading 5.3.3, pages 11-13).

Any fields that don't have a value are set to either `-` if the value is not available or `*` when the field can match any value.

For example, for glibc 2.40.1 CPE would be `cpe:2.3:a:gnu:glibc:2.40:1:*:*:*:*:*:*`.

#### `meta.identifiers.cpeParts` {#var-meta-identifiers-cpeParts}

This attribute contains an attribute set of all parts of the CPE for this package. Most of the parts default to `*` (match any value), with some exceptions:

* `part` defaults to `a` (application), can also be set to `o` for operating systems, for example, Linux kernel, or to `h` for hardware
* `vendor` cannot be deduced from other sources, so it must be specified by the package author
* `product` defaults to provided derivation's `pname` attribute and must be provided explicitly if `pname` is missing
* `version` and `update` have no defaults and should be specified explicitly or using helper functions, when missing, `cpe` attribute will be empty, and all possible guesses using helper functions will be in `possibleCPEs` attribute.

It is up to the package author to make sure all parts are correct and match expected values in [NVD dictionary](https://nvd.nist.gov/products/cpe). Unknown values can be skipped, which would leave them with the default value of `*`.

Following functions help with filling out `version` and `update` fields:

* [`lib.meta.cpeFullVersionWithVendor`](#function-library-lib.meta.cpeFullVersionWithVendor)
* [`lib.meta.cpePatchVersionInUpdateWithVendor`](#function-library-lib.meta.cpePatchVersionInUpdateWithVendor)

For many packages to make CPE available it should be enough to specify only:

```nix
{
  # ...
  meta.identifiers.cpeParts = lib.meta.cpePatchVersionInUpdateWithVendor vendor version;
}
```

#### `meta.identifiers.cpe` {#var-meta-identifiers-cpe}

A readonly attribute that concatenates all CPE parts in one string.

#### `meta.identifiers.possibleCPEs` {#var-meta-identifiers-possibleCPEs}

A readonly attribute containing the list of guesses for what CPE for this package can look like. It includes all variants of version handling mentioned above. Each item is an attrset with attributes `cpeParts` and `cpe` for each guess.

### Package URL {#sec-meta-identifiers-purl}

[Package-URL](https://github.com/package-url/purl-spec) (PURL) is a specification to reliably identify and locate software packages. Through identification of software packages, additional (non-major) use cases are e.g. software license cross-verification via third party databases or initial vulnerability response management. Package URL's default to the mkDerivation.src, as the original consumed software package is the single point of truth.

#### `meta.identifiers.purlParts` {#var-meta-identifiers-purlParts}

This attribute contains an attribute set of all parts of the PURL for this package.

* `type` mandatory [type](https://github.com/package-url/purl-spec/blob/18fd3e395dda53c00bc8b11fe481666dc7b3807a/docs/standard/summary.md) which needs to be provided
* `spec` specify the PURL in accordance with the [purl-spec](https://github.com/package-url/purl-spec/blob/18fd3e395dda53c00bc8b11fe481666dc7b3807a/purl-specification.md)

#### `meta.identifiers.purl` {#var-meta-identifiers-purl}

An extendable attribute which is built based on purlParts. It is the main identifier, consumers should consider using the PURL's list interface to be prepared for edge cases.

#### `meta.identifiers.purls` {#var-meta-identifiers-purls}

An extendable attribute list which defaults to a single element equal to the main PURL. It provides an interface for additional identifiers of mkDerivation.src and / or vendored dependencies inside mkDerivation.src, which maintainers can conciously decide to use on top. Identifiers different to the default src identifier are not recommended by default as they might cause maintenance overhead or may diverge (e.g. differences between source distribution pkg:github and binary distribution like pkg:pypi).
