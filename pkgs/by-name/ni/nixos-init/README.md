# `nixos-init`

A system for the initialization of NixOS.

The most important task of `nixos-init` is to work around the constraints of the
Filesystem Hierarchy Standard (FHS) that are imposed by other tools (most
importantly systemd itself).

The primary design principle is to do the minimal work required to start
systemd. Everything that can be done later SHOULD be done later (i.e. after
systemd has already started). This isn't controversial either, this is the
basic principle behind initrds in the first place.

Adding functionality to this init should be done with care and only when
strictly necessary. It should always be a last resort. It is explicitly not
designed to be extended dynamically by downstream users of NixOS.

The goal of `nixos-init` is to eventually entirely replace
`system.activationScripts` for booting, enable bashless activation and
ultimately make NixOS overall more
robust.

## Reasoning

- We already have a native API that can be used to easily extend the system
  (`systemd.services`). This is in all ways superior to the stringified and
  sequential nature of `system.activationScripts`.
- For the remaining functionality, a fully fledged programming language makes
  writing correct software easier and should improve the quality of the NixOS
  boot code.
- Most things can be started much later than one might assume. Because systemd
  services are parallelized, this should improve start up time.

## Invariants

For now, this does not try to replace all uses of `system.activationScripts`.
For the first iteration it only tries to offer an alternative to the
prepare-root in the systemd initrd.

It never intends to improve or replace scripted initrd. Scripted initrd is
being phased out, supporting it is out of scope.

## Components

`nixos-init` consists of a few components split into separate entrypoints.
However, these are not separate binaries but a single multicall binary. This
allows us to re-use the libc of the main binary and thus reduce the size of the
closure. Currently nixos-init comes in at ~500 KiB.

- `initrd-init`: Initializes the system on boot, setting up the tree for
  systemd to start.
- `find-etc`: Finds the `/etc` paths in `/sysroot` so that the initrd doesn't
  directly depend on the toplevel reducing the need to rebuild the initrd on
  every generation.
- `chroot-realpath`: Figures out the canonical path inside a chroot.

## Future

Current usages of `activationScripts`:

1. Initialization of the system
  1.1. In initrd
  1.2. As PID 1 if there is no initrd (e.g. for containers or cloud VMs).
2. Re-activation of the system via switch-to-configuration.
3. Installation of a system with `nixos-enter` (chroot).

Currently, `nixos-init` only addresses 1.1. At least 1.2 is also in scope.
