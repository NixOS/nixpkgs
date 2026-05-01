# Linphone

Linphone is a SIP softphone application developed by Belledonne Communications.

The main application is located in the [`linphone-desktop`](https://gitlab.linphone.org/BC/public/linphone-desktop) repository, and depends on many bespoke libraries, as well as third-party libraries with custom patches.
This scope provides all libraries and patches needed for Linphone to build.

BC-developed libraries are housed within the [`linphone-sdk`](https://gitlab.linphone.org/BC/public/linphone-sdk) monorepo.
Current stable versions of the monorepo utilize git submodules to link the respective package repos, but BC has since integrated all of their libraries into the monorepo proper, which is why we're already using a single source for the entire repo.
An auxiliary function `mkLinphoneDerivation` is provided in this scope, to streamline building libraries from that repository.

Other third-party libraries for which BC has provided custom patches, and are not included in the monorepo, are prefixed with `bc-`.

All libraries and packages are exposed in nixpkgs under the `linphonePackage` scope via `pkgs/all-packages.nix`.

## Updating

Updating is done in 3 steps:

1. Update the main Linphone application in the derivation directly
2. Update all libraries derived from the `linphone-sdk` monorepo, by updating the monorepo version and hash in `./default.nix`
3. Update all custom versions of third-party libraries individually (those prefixed with `bc-`)
4. Verify that the build is working by building (and running) `linphonePackages.linphone-desktop`.

> [!TIP]
>
> When testing, run the app with `./result/bin/linphone --verbose` to get useful logs in `stdout`.

## Adding new libraries

To add a new package to this scope, simply add a new subdirectory containing a `default.nix` file with the appropriate package name. The scope automatically picks up any directories and adds an according toplevel package.

If the package you are adding is contained within the `linphone-sdk` monorepo, it makes sense to use the `mkLinphoneDerivation` function to streamline the build process.

If the package you are adding is a third-party libary with custom patches from BC, it should be prefixed with `bc-` for easy recognizability, so e.g. if BC were to patch `ffmpeg`, you would call the package `bc-ffmpeg`.

## Notes for the future

As mentioned before, currently most libraries within `linphone-sdk` are simply git submodules, but in the future, they will be properly integrated into the monorepo (this is already the case for their main branch).

Also, currently the build relies on Qt5, but starting with Linphone 6.0.0, which as of 2025-09-20 is in its RC phase, the build will involve Qt6.
