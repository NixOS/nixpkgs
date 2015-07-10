# How to contribute

## Opening issues

* Make sure you have a [GitHub account](https://github.com/signup/free)
* [Submit an issue](https://github.com/NixOS/nixpkgs/issues) - assuming one does not already exist.
  * Clearly describe the issue including steps to reproduce when it is a bug.
  * Include information what version of nixpkgs and Nix are you using (nixos-version or git revision).

## Making patches

* Read [Manual (How to write packages for Nix)](https://nixos.org/nixpkgs/manual/).
* Fork the repository on GitHub.
* Create a branch for your future fix.
  * You can make branch from a commit of your local `nixos-version`. That will help you to avoid additional local compilations. Because you will recieve packages from binary cache.
    * For example: `nixos-version` returns `15.05.git.0998212 (Dingo)`. So you can do:

        ```bash
        git checkout 0998212
        git checkout -b 'fix/pkg-name-update'
        ```
  * Please avoid working directly on the `master` branch.
* Make commits of logical units. 
  * If you removed pkgs, made some major NixOS changes etc., write about them in `nixos/doc/manual/release-notes/rl-unstable.xml`.
* Check for unnecessary whitespace with `git diff --check` before committing.
* Format the commit in a following way:

        ```
        (pkg-name | service-name): (from -> to | init at version | refactor | etc)

        Additional information.
        ```
  * Examples:
    * `nginx: init at 2.0.1`
    * `firefox: 3.0 -> 3.1.1`
    * `hydra service: add bazBaz option`
    * `nginx service: refactor config generation`
* Test your changes. If you work with
  * nixpkgs:
    * update pkg -> 
      * `nix-env -i pkg-name -f <path to your local nixpkgs folder>`
    * add pkg -> 
      * Make sure it's in `pkgs/top-level/all-packages.nix`
      * `nix-env -i pkg-name -f <path to your local nixpkgs folder>`
    * _If you don't want to install pkg in you profile_. 
      * `nix-build -A pkg-attribute-name <path to your local nixpkgs folder>/default.nix` and check results in the folder `result`. It will appear in the same directory where you did `nix-build`.
    * If you did `nix-env -i pkg-name` you can do `nix-env -e pkg-name` to uninstall it from your system.
  * NixOS and its modules:
    * You can add new module to your NixOS configuration file (usually it's `/etc/nixos/configuration.nix`).
    And do `sudo nixos-rebuild test -I nixpkgs=<path to your local nixpkgs folder> --fast`.
* If you have commits `pkg-name: oh, forgot to insert whitespace`: squash commits in this case. Use `git rebase -i`.
* Rebase you branch against current `master`.

## Submitting changes

* Push your changes to your fork of nixpkgs.
* Create pull request:
  * Write the title in format `(pkg-name | service): improvement`.
    * If you update the pkg, write versions `from -> to`.
  * Write in comment if you have tested your patch. Do not rely much on `TravisCI`.
  * If you make an improvement, write about your motivation.
  * Notify maintainers of the package. For example add to the message: `cc @jagajaga @domenkozar`.

## Hotfixing pull requests

* Make the appropriate changes in you branch.
* Don't create additional commits, do
  * `git rebase -i`
  * `git push --force` to your branch.

## Commit policy

* Commits must be sufficiently tested before being merged, both the master and staging branches.
* Hydra builds for master and stagingshould not be used as testing platform, it's a build farm for changes that have been already tested.
* Master should only see non-breaking commits that do not cause mass rebuilds.
* Staging should only see non-breaking mass-rebuild commits. That means it's not to be used for testing, changes must have been well tested already. [Read policy here](http://comments.gmane.org/gmane.linux.distributions.nixos/13447).
* If staging is already in a broken state, please refrain from adding extra new breakages. Stabilize it for a few days, merge into master, then resume development on staging. [Keep an eye on the staging evaluations here](http://hydra.nixos.org/jobset/nixpkgs/staging#tabs-evaluations).
* When changing the bootloader installation process, extra care must be taken. Grub installations cannot be rolled back, hence changes may break people installation forever. For any non-trivial change to the bootloader please file a PR asking for review, especially from @edolstra.

