# Nix Store Corruption {#sec-nix-store-corruption}

After a system crash, it's possible for files in the Nix store to become
corrupted. (For instance, the Ext4 file system has the tendency to
replace un-synced files with zero bytes.) NixOS tries hard to prevent
this from happening: it performs a `sync` before switching to a new
configuration, and Nix's database is fully transactional. If corruption
still occurs, you may be able to fix it automatically.

If the corruption is in a path in the closure of the NixOS system
configuration, you can fix it by doing

```ShellSession
# nixos-rebuild switch --repair
```

This will cause Nix to check every path in the closure, and if its
cryptographic hash differs from the hash recorded in Nix's database, the
path is rebuilt or redownloaded.

You can also scan the entire Nix store for corrupt paths:

```ShellSession
# nix-store --verify --check-contents --repair
```

Any corrupt paths will be redownloaded if they're available in a binary
cache; otherwise, they cannot be repaired.
