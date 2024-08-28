# CI support files

This directory contains files to support CI, such as [GitHub Actions](https://github.com/NixOS/nixpkgs/tree/master/.github/workflows) and [Ofborg](https://github.com/nixos/ofborg).
This is in contrast with [`maintainers/scripts`](`../maintainers/scripts`) which is for human use instead.

## Pinned Nixpkgs

CI may need certain packages from Nixpkgs.
In order to ensure that the needed packages are generally available without building,
[`pinned-nixpkgs.json`](./pinned-nixpkgs.json) contains a pinned Nixpkgs version tested by Hydra.

Run [`update-pinned-nixpkgs.sh`](./update-pinned-nixpkgs.sh) to update it.
