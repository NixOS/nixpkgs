# Maintainers

- TODO: We need more maintainers:
  - https://github.com/NixOS/nixpkgs/issues/78450
  - If you just want to help out without becoming a maintainer:
    - Look for open Nixpkgs issues or PRs related to Chromium
    - Make your own PRs (but please try to make reviews as easy as possible)
- Primary maintainer (responsible for updating Chromium): @primeos
- Testers (test all stable channel updates)
  - `nixos-unstable`:
    - `x86_64`: @danielfullmer
    - `aarch64`: @thefloweringash
  - Stable channel:
    - `x86_64`: @Frostman
- Other relevant packages:
  - `chromiumBeta` and `chromiumDev`: For testing purposes (not build on Hydra)
  - `google-chrome`, `google-chrome-beta`, `google-chrome-dev`: Updated via
    Chromium's `upstream-info.json`
  - `ungoogled-chromium`: Based on `chromium` (the expressions are regularly
    copied over and patched accordingly)

# Upstream links

- Source code: https://source.chromium.org/chromium/chromium/src
- Bugs: https://bugs.chromium.org/p/chromium/issues/list
- Release updates: https://chromereleases.googleblog.com/
  - Available as Atom or RSS feed (filter for
    "Stable Channel Update for Desktop")
  - Channel overview: https://omahaproxy.appspot.com/
  - Release schedule: https://chromiumdash.appspot.com/schedule

# Updating Chromium

Simply run `./pkgs/applications/networking/browsers/chromium/update.py` to
update `upstream-info.json`. After updates it is important to test at least
`nixosTests.chromium` (or basic manual testing) and `google-chrome` (which
reuses `upstream-info.json`).

## Backports

All updates are considered security critical and should be ported to the stable
channel ASAP. When there is a new stable release the old one should receive
security updates for roughly one month. After that it is important to mark
Chromium as insecure (see 69e4ae56c4b for an example; it is important that the
tested job still succeeds and that all browsers that use `upstream-info.json`
are marked as insecure).

## Major version updates

Unfortunately, Chromium regularly breaks on major updates and might need
various patches. Either due to issues with the Nix build sandbox (e.g. we cannot
fetch dependencies via the network and do not use standard FHS paths) or due to
missing upstream fixes that need to be backported.

Good sources for such patches and other hints:
- https://github.com/archlinux/svntogit-packages/tree/packages/chromium/trunk
- https://gitweb.gentoo.org/repo/gentoo.git/tree/www-client/chromium
- https://src.fedoraproject.org/rpms/chromium/tree/master

If the build fails immediately due to unknown compiler flags this usually means
that a new major release of LLVM is required.

## Beta and Dev channels

Those channels are only used to test and fix builds in advance. They may be
broken at times and must not delay stable channel updates.
