# Maintainers

- Note: We could always use more contributors, testers, etc. E.g.:
  - A dedicated maintainer for the NixOS stable channel
  - PRs with cleanups, improvements, fixes, etc. (but please try to make reviews
    as easy as possible)
  - People who handle stale issues/PRs
- Primary maintainer (responsible for all updates): @primeos
- Testers (test all stable channel updates)
  - `nixos-unstable`:
    - `x86_64`: @danielfullmer
    - `aarch64`: @thefloweringash
  - Stable channel:
    - `x86_64`: @Frostman
- Other relevant packages:
  - `chromiumBeta` and `chromiumDev`: For testing purposes only (not build on
    Hydra). We use these channels for testing and to fix build errors in advance
    so that `chromium` updates are trivial and can be merged fast.
  - `google-chrome`, `google-chrome-beta`, `google-chrome-dev`: Updated via
    Chromium's `upstream-info.json`
  - `ungoogled-chromium`: @squalus
  - `chromedriver`: Updated via Chromium's `upstream-info.json` and not built
    from source.

# Upstream links

- Source code: https://source.chromium.org/chromium/chromium/src
- Bugs: https://bugs.chromium.org/p/chromium/issues/list
- Release updates: https://chromereleases.googleblog.com/
  - Available as Atom or RSS feed (filter for
    "Stable Channel Update for Desktop")
  - Release API: https://developer.chrome.com/docs/versionhistory/guide/
  - Release schedule: https://chromiumdash.appspot.com/schedule

# Updating Chromium

Simply run `./pkgs/applications/networking/browsers/chromium/update.py` to
update `upstream-info.json`. After updates it is important to test at least
`nixosTests.chromium` (or basic manual testing) and `google-chrome` (which
reuses `upstream-info.json`).

Note: Due to the script downloading many large tarballs it might be
necessary to adjust the available tmpfs size (it defaults to 10% of the
systems memory)

```nix
services.logind.extraConfig = ''
  RuntimeDirectorySize=4G
'';
```

Note: The source tarball is often only available a few hours after the release
was announced. The CI/CD status can be tracked here:
- https://ci.chromium.org/p/infra/builders/cron/publish_tarball
- https://ci.chromium.org/p/infra/builders/cron/publish_tarball_dispatcher

To run all automated NixOS VM tests for Chromium, ungoogled-chromium,
and Google Chrome (not recommended, currently 6x tests!):
```
nix-build nixos/tests/chromium.nix
```

A single test can be selected, e.g. to test `ungoogled-chromium` (see
`channelMap` in `nixos/tests/chromium.nix` for all available options):
```
nix-build nixos/tests/chromium.nix -A ungoogled
```
(Note: Testing Google Chrome requires `export NIXPKGS_ALLOW_UNFREE=1`.)

For custom builds it's possible to "override" `channelMap`.

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

# Testing

Useful tests:
- Version: chrome://version/
- GPU acceleration: chrome://gpu/
- Essential functionality: Browsing, extensions, video+audio, JS, ...
- WebGL: https://get.webgl.org/
- VA-API: https://wiki.archlinux.org/index.php/chromium#Hardware_video_acceleration
- Optional: Widevine CDM (proprietary), Benchmarks, Ozone, etc.
