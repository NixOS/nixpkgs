# GitHub specific CI scripts

This folder contains [`actions/github-script`](https://github.com/actions/github-script)-based JavaScript code.
It provides a `nix-shell` environment to run and test these actions locally.

To run any of the scripts locally:

- Enter `nix-shell` in `./ci/github-script`.
- Ensure `gh` is authenticated.

## Check commits

Run `./run commits OWNER REPO PR`, where OWNER is your username or "NixOS", REPO is the name of your fork or "nixpkgs" and PR is the number of the pull request to check.

## Labeler

Run `./run labels OWNER REPO`, where OWNER is your username or "NixOS" and REPO the name of your fork or "nixpkgs".

## Type checking

The JavaScript files can be type-checked using TypeScript with `--checkJs`. This catches common bugs like using `Set.length` instead of `Set.size`, undeclared variables, and mismatched function signatures.

To run the type checker:

```
nix-shell
tsc --project jsconfig.json
```

Editors that support `jsconfig.json` (VS Code, etc.) will show type errors inline.
