# pkgs.mkProtonBinDerivation {#sec-pkgs-mkProtonBinDerivation}

`pkgs.mkProtonBinDerivation` packages a prebuilt release of Proton, or of another Steam compatibility tool, for use with the NixOS option [`programs.steam.extraCompatPackages`](https://search.nixos.org/options?show=programs.steam.extraCompatPackages).

The tool is installed into the `steamcompattool` output, which is what `programs.steam.extraCompatPackages` adds to Steam.
The release for the host system is symlinked into it, except for `compatibilitytool.vdf`, which is copied so the name of the tool can be replaced with `steamDisplayName`.
If the release has a `proton` script, `mkProtonBinDerivation` copies and patches it.
The patched script makes Wine re-apply `wine.inf` when Proton upgrades a prefix to a new version, for example to register new services.
Without the patch, Wine skips `wine.inf` on upgrades, because every file in the Nix store has the same modification time.

`mkProtonBinDerivation` supports [fixed-point arguments](#chap-build-helpers-finalAttrs), and accepts all the attributes of `stdenvNoCC.mkDerivation`.

## Inputs {#sec-pkgs-mkProtonBinDerivation-inputs}

`variants` (Attribute set; _required_)

: The release for each supported system, as an attribute set mapping a system to `{ src; toolName; }`:

  - `src`: the unpacked release, usually from `fetchzip`.
  - `toolName`: the name of the tool in the release's `compatibilitytool.vdf`.

  `variants` is not passed on to the derivation, so changing the release for one system does not rebuild the others.
  As a consequence it can't be changed with `overrideAttrs`; override `src` and `toolName` instead.

  `meta.platforms` defaults to the systems listed in `variants`.

`steamDisplayName` (String; _optional_)

: The name shown in Steam.
  Can be changed with `overrideAttrs`, which is useful to install several versions of a tool side by side.

  _Default value:_ `pname`.

## Update script {#sec-pkgs-mkProtonBinDerivation-update-script}

`pkgs.proton-bin-update-script` creates a `passthru.updateScript` for packages built with `mkProtonBinDerivation`.
It takes an attribute set with a single attribute:

`latestVersionCommand` (String)

: A shell snippet printing the latest upstream version.
  `curl` and `jq` are available to it.

The script updates `version` and the `src` of every system in `meta.platforms`, currently supporting `x86_64-linux` and `aarch64-linux`.
Each system's release is fetched on the local machine. It exits without changes when the package is already at the latest version.

The script reads the package to update from the environment set by `maintainers/scripts/update.nix`, so it has to be run through it:

```shell
nix-shell maintainers/scripts/update.nix --argstr package proton-ge-bin
```

## Examples {#sec-pkgs-mkProtonBinDerivation-examples}

:::{.example #ex-pkgs-mkProtonBinDerivation}

# Packaging a Proton release

```nix
{
  lib,
  mkProtonBinDerivation,
  proton-bin-update-script,
  fetchzip,
}:

mkProtonBinDerivation (finalAttrs: {
  pname = "proton-example-bin";
  version = "Proton-Example-1";
  steamDisplayName = "Proton-Example";

  variants = {
    "x86_64-linux" = {
      toolName = "${finalAttrs.version}-x86_64";
      src = fetchzip {
        url = "https://example.org/${finalAttrs.version}-x86_64.tar.gz";
        hash = "...";
      };
    };
  };

  passthru.updateScript = proton-bin-update-script {
    latestVersionCommand = ''
      curl -fsSL https://example.org/releases.json | jq -er '.[0].tag_name'
    '';
  };

  meta = {
    description = "Example Proton fork";
    license = lib.licenses.bsd3;
  };
})
```

:::

:::{.example #ex-pkgs-mkProtonBinDerivation-steamDisplayName}

# Changing the name shown in Steam

```nix
{ pkgs, ... }:
{
  programs.steam.extraCompatPackages = [
    (pkgs.proton-ge-bin.overrideAttrs { steamDisplayName = "GE-Proton (Nix)"; })
  ];
}
```

:::
