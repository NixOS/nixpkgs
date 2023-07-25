# Cleaning the Nix Store {#sec-nix-gc}

Nix has a purely functional model, meaning that packages are never
upgraded in place. Instead new versions of packages end up in a
different location in the Nix store (`/nix/store`). You should
periodically run Nix's *garbage collector* to remove old, unreferenced
packages. This is easy:

```ShellSession
$ nix-collect-garbage
```

Alternatively, you can use a systemd unit that does the same in the
background:

```ShellSession
# systemctl start nix-gc.service
```

You can tell NixOS in `configuration.nix` to run this unit automatically
at certain points in time, for instance, every night at 03:15:

```nix
nix.gc.automatic = true;
nix.gc.dates = "03:15";
```

The commands above do not remove garbage collector roots, such as old
system configurations. Thus they do not remove the ability to roll back
to previous configurations. The following command deletes old roots,
removing the ability to roll back to them:

```ShellSession
$ nix-collect-garbage -d
```

You can also do this for specific profiles, e.g.

```ShellSession
$ nix-env -p /nix/var/nix/profiles/per-user/eelco/profile --delete-generations old
```

Note that NixOS system configurations are stored in the profile
`/nix/var/nix/profiles/system`.

Another way to reclaim disk space (often as much as 40% of the size of
the Nix store) is to run Nix's store optimiser, which seeks out
identical files in the store and replaces them with hard links to a
single copy.

```ShellSession
$ nix-store --optimise
```

Since this command needs to read the entire Nix store, it can take quite
a while to finish.

## NixOS Boot Entries {#sect-nixos-gc-boot-entries}

If your `/boot` partition runs out of space, after clearing old profiles
you must rebuild your system with `nixos-rebuild boot` or `nixos-rebuild
switch` to update the `/boot` partition and clear space.
