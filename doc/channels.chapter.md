# How channels work {#how-channels-work}

nixpkgs uses the [channels feature](https://nixos.org/nix/manual/#sec-channels) of nix.

nixpkgs is distributed for users of Nix on non-NixOS distributions through the channel
`nixpkgs-unstable`. Users of NixOS generally use one of the `nixos-*` channels,
e.g. `nixos-22.11`, which includes all packages and modules for the stable NixOS
22.11. Stable NixOS releases are generally only given
security updates. More up to date packages and modules are available via the
`nixos-unstable` channel.

Both `nixos-unstable` and `nixpkgs-unstable` follow the `master` branch of the
nixpkgs repository, although both do lag the `master` branch by generally
[a couple of days](https://status.nixos.org/). Updates to a channel are
distributed as soon as all tests for that channel pass, e.g.
[this table](https://hydra.nixos.org/job/nixpkgs/trunk/unstable#tabs-constituents)
shows the status of tests for the `nixpkgs-unstable` channel.

The tests are conducted by a cluster called [Hydra](https://nixos.org/hydra/),
which also builds binary packages from the Nix expressions in Nixpkgs for
`x86_64-linux`, `aarch64-linux`, `x86_64-darwin` and `aarch64-darwin`.
The binaries are made available via a [binary cache](https://cache.nixos.org).

The current Nix expressions of the channels are available in the
[nixpkgs repository](https://github.com/NixOS/nixpkgs) in branches
that correspond to the channel names (e.g. `nixos-22.11-small`).
