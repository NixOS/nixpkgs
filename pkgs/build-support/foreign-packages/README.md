# Foreign packages (AUR / pacman / dnf / deb)

`pkgs.foreignPackages` converts a package archive from another distribution
into a Nix store overlay:

```nix
pkgs.foreignPackages {
  url = "https://repo.example.com/foo_1.0_amd64.deb";
  hash = "sha256-...";
}
```

Supported formats (auto-detected from the URL suffix, or set `format`):

- `deb` — Debian/Ubuntu packages
- `rpm` — Fedora/CentOS packages (dnf)
- `pkgtar` — Arch Linux / AUR built packages (`pkg.tar.zst`, `pkg.tar.xz`)

What the derivation does:

1. `fetchurl` downloads the archive.
2. The archive is extracted into the derivation output, preserving the
   package layout (`usr/`, `etc/`, `lib/`, `var/`, ...). The output is a
   filesystem overlay rooted at the store path.
3. The package's post-install script runs inside a bubblewrap sandbox with
   the overlay as its chroot root:
   - `deb`: `postinst configure`
   - `rpm`: `%post`
   - `pkgtar`: `.INSTALL post_install`
   An extra shell block can be supplied via `postInstall`.
4. Transient chroot helpers are removed and the output is made read-only.

The overlay can be merged into a running NixOS system with
`system.foreignPackages`; with `system.fhsCompatibility.enable` its files
are symlinked into the FHS rootfs (`/nix/store/<system>-fhs-rootfs/`), only
where they do not collide with existing rootfs entries.

AUR note: pass a *built* AUR package URL (pkg.tar.zst). AUR snapshots
(PKGBUILD + sources) require an Arch build environment and cannot be built
offline inside a Nix derivation.

For offline tests, `src` can be passed instead of `url`/`hash`.