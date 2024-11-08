# CycloneDX {#chap-interop-cyclonedx}

[OWASP](https://owasp.org/) [CycloneDX](https://cyclonedx.org/) is a Software [Bill of Materials](https://en.wikipedia.org/wiki/Bill_of_materials) (SBOM) standard.
The standards described here are for including Nix specific information within SBOMs in a way that is interoperable with external SBOM tooling.

## `nix` Namespace Property Taxonomy  {#sec-interop.cylonedx-nix}

The following tables describe namespaces for [properties](https://cyclonedx.org/docs/1.6/json/#components_items_properties) that may be attached to components within SBOMs.
Component properties are lists of name-value-pairs where values must be strings.
Properties with the same name may appear more than once.
Names and values are case-sensitive.

| Property         | Description |
|------------------|-------------|
| `nix:store_path` | A Nix store path for the given component. This property should be contextualized by additional properties that describe the production of the store path, such as those from the `nix:narinfo:` and `nix:fod` namespaces. |


| Namespace     | Description |
|---------------|-------------|
| [`nix:narinfo`](#sec-interop.cylonedx-narinfo) | Namespace for properties that are specific to how a component is stored as a [Nix archive](https://nixos.org/manual/nix/stable/glossary#gloss-nar) (NAR) in a [binary cache](https://nixos.org/manual/nix/stable/glossary#gloss-binary-cache). |
| [`nix:fod`](#sec-interop.cylonedx-fod) | Namespace for properties that describe a [fixed-output derivation](https://nixos.org/manual/nix/stable/glossary#gloss-fixed-output-derivation). |


### `nix:narinfo` {#sec-interop.cylonedx-narinfo}

Narinfo properties describe component archives that may be available from binary caches.
The `nix:narinfo` properties should be accompanied by a `nix:store_path` property within the same property list.

| Property                  | Description |
|---------------------------|-------------|
| `nix:narinfo:store_path`  | Store path for the given store component. |
| `nix:narinfo:url`         | URL path component. |
| `nix:narinfo:nar_hash`    | Hash of the file system object part of the component when serialized as a Nix Archive. |
| `nix:narinfo:nar_size`    | Size of the component when serialized as a Nix Archive. |
| `nix:narinfo:compression` | The compression format that component archive is in. |
| `nix:narinfo:file_hash`   | A digest for the compressed component archive itself, as opposed to the data contained within. |
| `nix:narinfo:file_size`   | The size of the compressed component archive itself. |
| `nix:narinfo:deriver`     | The path to the derivation from which this component is produced. |
| `nix:narinfo:system`      | The hardware and software platform on which this component is produced. |
| `nix:narinfo:sig`         | Signatures claiming that this component is what it claims to be. |
| `nix:narinfo:ca`          | Content address of this store object's file system object, used to compute its store path. |
| `nix:narinfo:references`  | A whitespace separated array of store paths that this component references. |

### `nix:fod` {#sec-interop.cylonedx-fod}

FOD properties describe a [fixed-output derivation](https://nixos.org/manual/nix/stable/glossary#gloss-fixed-output-derivation).
The `nix:fod:method` property is required and must be accompanied by a `nix:store_path` property within the same property list.
All other properties in this namespace are method-specific.
To reproduce the build of a component the `nix:fod:method` value is resolved to an [appropriate function](#chap-pkgs-fetchers) within Nixpkgs whose arguments intersect with the given properties.
When generating `nix:fod` properties the method selected should be a stable function with a minimal number arguments.
For example, the `fetchFromGitHub` is commonly used within Nixpkgs but should be reduced to a call to the function by which it is implemented, `fetchzip`.

| Property         | Description |
|------------------|-------------|
| `nix:fod:method` | Nixpkg function that produces this FOD. Required. Examples: `"fetchzip"`, `"fetchgit"` |
| `nix:fod:name`   | Derivation name, present when method is `"fetchzip"` |
| `nix:fod:ref`    | [Git ref](https://git-scm.com/docs/gitglossary#Documentation/gitglossary.txt-aiddefrefaref), present when method is `"fetchgit"` |
| `nix:fod:rev`    | [Git rev](https://git-scm.com/docs/gitglossary#Documentation/gitglossary.txt-aiddefrevisionarevision), present when method is `"fetchgit"` |
| `nix:fod:sha256` | FOD hash |
| `nix:fod:url`    | URL to fetch |


`nix:fod` properties may be extracted and evaluated to a derivation using code similar to the following, assuming a fictitious function `filterPropertiesToAttrs`:

```nix
{ pkgs, filterPropertiesToAttrs, properties }:
let
  fodProps = filterPropertiesToAttrs "nix:fod:" properties;

  methods = {
    fetchzip =
      { name, url, sha256, ... }:
      pkgs.fetchzip {
        inherit name url sha256;
      };
  };

in methods.${fodProps.method} fodProps
```
