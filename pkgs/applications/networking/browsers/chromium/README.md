# Maintainers

- Note: We could always use more contributors, testers, etc. E.g.:
  - Dedicated maintainers for the NixOS stable channel
  - PRs with cleanups, improvements, fixes, etc. (but please try to make reviews
    as easy as possible)
  - People who handle stale issues/PRs

- Other relevant packages:
  - `google-chrome`: Updated via Chromium's `upstream-info.nix`.
  - `ungoogled-chromium`: A patch set for Chromium, that has its own entry in Chromium's `upstream-info.nix`.
  - `chromedriver`: Updated via Chromium's `upstream-info.nix` and not built
    from source. Must match Chromium's major version.
  - `electron-source`: Various versions of electron that are built from source using Chromium's
    `-unwrapped` derivation, due to electron being based on Chromium.

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
update `upstream-info.nix`. After updates it is important to test at least
`nixosTests.chromium` (or basic manual testing) and `google-chrome` (which
reuses `upstream-info.nix`).

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
tested job still succeeds and that all browsers that use `upstream-info.nix`
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
