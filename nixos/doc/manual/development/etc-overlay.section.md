# `/etc` via overlay filesystem {#sec-etc-overlay}

::: {.note}
This is experimental and requires a kernel version >= 6.6 because it uses
new overlay features and relies on the new mount API.
:::

Instead of using a custom perl script to activate `/etc`, you activate it via an
overlay filesystem:

```nix
{ system.etc.overlay.enable = true; }
```

Using an overlay has two benefits:

1. it removes a dependency on perl
2. it makes activation faster (up to a few seconds)

By default, the `/etc` overlay is mounted writable (i.e. there is a writable
upper layer). However, you can also mount `/etc` immutably (i.e. read-only) by
setting:

```nix
{ system.etc.overlay.mutable = false; }
```

The overlay is atomically replaced during system switch. However, files that
have been modified will NOT be overwritten. This is the biggest change compared
to the perl-based system.

If you manually make changes to `/etc` on your system and then switch to a new
configuration where `system.etc.overlay.mutable = false;`, you will not be able
to see the previously made changes in `/etc` anymore. However the changes are
not completely gone, they are still in the upperdir of the previous overlay in
`/.rw-etc/upper`.
