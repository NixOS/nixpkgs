# Emacs Lisp Packages Framework

This directory includes a framework for packaging Emacs Lisp (henceforth, Elisp)
packages to Nixpkgs.

## Bulk Updating

There are basically two methods for updating the Elisp package sets.

### From `nix-community` Overlay

The easiest one is to download and commit the package sets from [`nix-community`
Emacs Overlay](https://github.com/nix-community/emacs-overlay). The script
`./update-from-overlay` does all the work:

- It downloads and overwrites the files `elpa-generated.nix`,
  `elpa-devel-generated.nix`, `recipes-archive-melpa.json`,
  `nongnu-generated.nix` and `nongnu-devel-generated.nix`;
- Tests each package set;
- Commits the changes.

### From local update scripts

We have the following scripts:

- `update-elpa-devel`

  It updates `elpa-devel-generated.nix` file and its corresponding
  `emacsPackages.elpaDevelPackages` package set.

  After running it, and before committing its changes, it is mandatory to run
  the following smoke test:

  ```
  env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace /../../../../../ -A "emacsPackages.elpaDevelPackages"
  ```

  The commit should be generated with the command below:

  ```
  git commit -m "emacsPackages.elpaDevelPackages: updated at $(date --iso) (from local scripts)" -- elpa-devel-generated.nix
  ```

- `update-elpa`

  It updates `elpa-generated.nix` file and its corresponding
  `emacsPackages.elpaPackages` package set.

  After running it, and before committing its changes, it is mandatory to run
  the following smoke test:

  ```
    env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace /../../../../../ -A "emacsPackages.elpaPackages"
  ```

  The commit should be generated with the command below:

  ```
  git commit -m "emacsPackages.elpaPackages: updated at $(date --iso) (from local scripts)" -- elpa-generated.nix
  ```

- `update-melpa`

  It updates `recipes-archive-melpa.json` file and its corresponding
  `emacsPackages.melpaPackages` and `emacsPackages.melpaStablePackages`
  package sets.

  After running it, and before committing its changes, it is mandatory to run
  the following smoke test:

  ```
    env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace /../../../../../ -A "emacsPackages.melpaPackages"
    env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace /../../../../../ -A "emacsPackages.melpaStablePackages"
  ```

  The commit should be generated with the command below:

  ```
  git commit -m "emacsPackages.{melpaPackages,melpaStablePackages}: updated at $(date --iso) (from local scripts)" -- `recipes-archive-melpa.json`
  ```

- `update-nongnu-devel`

  It updates `nongnu-devel-generated.nix` file and its corresponding
  `emacsPackages.nongnuDevelPackages` package set.

  After running it, and before committing its changes, it is mandatory to run
  the following smoke test:

  ```
    env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace /../../../../../ -A "emacsPackages.nongnuDevelPackages"
  ```

  The commit should be generated with the command below:

  ```
  git commit -m "emacsPackages.nongnuDevelPackages: updated at $(date --iso) (from local scripts)" -- nongnu-devel-generated.nix
  ```

- `update-nongnu`

  It updates `nongnu-generated.nix` file and its corresponding
  `emacsPackages.nongnuPackages` package set.

  After running it, and before committing its changes, it is mandatory to run
  the following smoke test:

  ```
    env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate --show-trace /../../../../../ -A "emacsPackages.nongnuPackages"
  ```

  The commit should be generated with the command below:

  ```
  git commit -m "emacsPackages.nongnuPackages: updated at $(date --iso) (from local scripts)" -- nongnu-generated.nix
  ```
