# NixOS {#sec-nixos-state}

NixOS itself obviously needs `/nix` to be persistent, so the system environment
can be linked from the nix store during activation.

Moreover, `/boot` should also be persistent, as it contains the kernel, initrd,
and the command-line determining the system environment's path in the nix store.

Lastly, `users.mutableUsers` should be false, *or* the following files under
`/etc` should all persist:
- {manpage}`passwd(5)` and {manpage}`group(5)`,
- {manpage}`shadow(5)` and {manpage}`gshadow(5)`,
- {manpage}`subuid(5)` and {manpage}`subgid(5)`.
