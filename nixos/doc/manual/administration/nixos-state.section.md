# NixOS {#sec-nixos-state}

## `/nix` {#sec-state-nix}

NixOS needs the entirety of `/nix` to be persistent, as it includes:
- `/nix/store`, which contains all the system's executables, libraries, and supporting data;
- `/nix/var/nix`, which contains:
  - the Nix daemon's database;
  - roots whose transitive closure is preserved when garbage-collecting the Nix store;
  - system-wide and per-user profiles.

## `/boot` {#sec-state-boot}

`/boot` should also be persistent, as it contains:
- the kernel and initrd which the bootloader loads,
- the bootloader's configuration, including the kernel's command-line which
  determines the store path to use as system environment.


## Users and groups {#sec-state-users}

- `/var/lib/nixos` should persist: it holds state needed to generate stable
  uids and gids for declaratively-managed users and groups, etc.
- `users.mutableUsers` should be false, *or* the following files under `/etc`
  should all persist:
  - {manpage}`passwd(5)` and {manpage}`group(5)`,
  - {manpage}`shadow(5)` and {manpage}`gshadow(5)`,
  - {manpage}`subuid(5)` and {manpage}`subgid(5)`.
