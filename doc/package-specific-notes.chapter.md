---
title: Package-specific notes
author: Michael Raskin
date: 2019-05-01
---

# Package-specific notes

This chapters includes some notes that apply to specific packages and should
answer some of the frequently asked questions.

## OpenGL

Packages that use OpenGL have NixOS desktop as their primary target. The
current solution for loading the GPU-specific drivers is based on `libglvnd`
and looks for the driver implementation in `LD_LIBRARY_PATH`. If you are using
a non-NixOS GNU/Linux/X11 desktop with free software video drivers, consider
launching OpenGL-dependent programs from Nixpkgs with Nixpkgs versions of
`libglvnd` and `mesa_drivers` in `LD_LIBRARY_PATH`. For proprietary video
drivers you might have luck with also adding the corresponding video driver
package.

## Locales

To allow simultaneous use of packages linked against different versions of
`glibc` with different locale archive formats Nixpkgs patches `glibc` to rely
on `LOCALE_ARCHIVE` environment variable.

On non-NixOS distributions this variable is obviously not set. This can cause
regressions in language support or even crashes in some Nixpkgs-provided
programs. The simplest way to mitigate this problem is exporting the
`LOCALE_ARCHIVE` variable pointing to
`${glibcLocales}/lib/locale/locale-archive`. The drawback (and the reason this
is not the default) is the relatively large (a hundred MiB) size of the full
set of locales. It is possible to build a custom set of locales by overriding
parameters `allLocales` and `locales` of the package.

## Unfree software

All users of Nixpkgs are free software users, and many users (and developers)
of Nixpkgs want to limit and tightly control their exposure to unfree
software. At the same many users need (or want) to run some specific pieces of
proprietary software. Nixpkgs includes some expressions for unfree software
packages. By default unfree software cannot be installed and doesn't show up
in searches. To allow installing unfree software in a single Nix invocation
one can export `NIXPKGS_ALLOW_UNFREE=1`. For a persistent solution, users can 
set `allowUnfree` in the Nixpkgs configuration.

Fine-grained control is
possible by defining `allowUnfreePredicate` function in config; it takes the
`mkDerivation` parameter attrset and returns `true` for unfree packages that
should be allowed.
