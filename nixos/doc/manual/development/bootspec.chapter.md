# Experimental feature: Bootspec {#sec-experimental-bootspec}

Bootspec is a experimental feature, introduced in the [RFC-0125 proposal](https://github.com/NixOS/rfcs/pull/125), the reference implementation can be found [there](https://github.com/NixOS/nixpkgs/pull/172237) in order to standardize bootloader support
and advanced boot workflows such as SecureBoot and potentially more.

You can enable the creation of bootspec documents through [`boot.bootspec.enable = true`](options.html#opt-boot.bootspec.enable), which will prompt a warning until [RFC-0125](https://github.com/NixOS/rfcs/pull/125) is officially merged.

## Schema {#sec-experimental-bootspec-schema}

The bootspec schema is versioned and validated against [a CUE schema file](https://cuelang.org/) which should considered as the source of truth for your applications.

You will find the current version [here](../../../modules/system/activation/bootspec.cue).

## Extensions mechanism {#sec-experimental-bootspec-extensions}

Bootspec cannot account for all usecases.

For this purpose, Bootspec offers a generic extension facility [`boot.bootspec.extensions`](options.html#opt-boot.bootspec.extensions) which can be used to inject any data needed for your usecases.

An example for SecureBoot is to get the Nix store path to `/etc/os-release` in order to bake it into a unified kernel image:

```nix
{ config, lib, ... }: {
  boot.bootspec.extensions = {
    "org.secureboot.osRelease" = config.environment.etc."os-release".source;
  };
}
```

To reduce incompatibility and prevent names from clashing between applications, it is **highly recommended** to use a unique namespace for your extensions.

## External bootloaders {#sec-experimental-bootspec-external-bootloaders}

It is possible to enable your own bootloader through [`boot.loader.external.installHook`](options.html#opt-boot.loader.external.installHook) which can wrap an existing bootloader.

Currently, there is no good story to compose existing bootloaders to enrich their features, e.g. SecureBoot, etc. It will be necessary to reimplement or reuse existing parts.
