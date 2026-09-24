# ZFS {#sec-zfs-state}

When using ZFS, `/etc/zfs/zpool.cache` should be persistent (or a symlink to a persistent
location) as it is the default value for the `cachefile` [property](man:zpoolprops(7)).

This cachefile is used on system startup to discover ZFS pools, so ZFS pools
holding the `rootfs` and/or early-boot datasets such as `/nix` can be set to
`cachefile=none`.

In principle, if there are no other pools attached to the system, `zpool.cache`
does not need to be persisted; it is however *strongly recommended* to persist
it, in case additional pools are added later on, temporarily or permanently:

While mishandling the cachefile does not lead to data loss by itself, it may
cause zpools not to be imported during boot, and services may then write to a
location where a dataset was expected to be mounted.
