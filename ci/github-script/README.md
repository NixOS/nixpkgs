# GitHub specific CI scripts

This folder contains [`actions/github-script`](https://github.com/actions/github-script)-based JavaScript code.
It provides a `nix-shell` environment to run and test these actions locally.

To run any of the scripts locally:

- Provide `gh` on `PATH` and make sure it's authenticated.
- Enter `nix-shell` in `./ci/github-script`.

## Labeler

Run `./run labels OWNER REPO`, where OWNER is your username or "NixOS" and REPO the name of your fork or "nixpkgs".
