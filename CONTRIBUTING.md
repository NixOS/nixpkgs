# How to contribute

## Opening issues

* Make sure you have a [GitHub account](https://github.com/signup/free)
* Submit a ticket for your issue, assuming one does not already exist.
  * Clearly describe the issue including steps to reproduce when it is a bug.

## Making patches

* Read [Manual (How to write packages for Nix)](https://nixos.org/nixpkgs/manual/)
* Fork the repository on GitHub.
* Create a branch for your future fix.
  * You can make branch from a commit of your local `nixos-version`. That will help you to avoid additional local compilations. Because you will recieve some packages from cache server.
    * For example: `nixos-version` returns `15.05.git.0998212 (Dingo)`. So you can do:

        ```bash
        git checkout 0998212
        git checkout -b 'fix/pkg-name-update'
        ```
  * Please avoid working directly on the `master` branch.
* Make commits of logical units. 
  * If you removed pkgs, made some major changes etc., write about them in `nixos/doc/manual/release-notes/rl-unstable.xml`.
* Check for unnecessary whitespace with `git diff --check` before committing.
* Format the commit in a following way:

        ```
        (pkg-name | service-name): (update from -> to | init at version | refactor | etc)

        Additional information.
        ```
  * Examples:
    * `foo-pkg: init at 2.0.1`
    * `bar-pkg: update 3.0 -> 3.1.1`
    * `lala-service: add bazBaz option`
    * `tata-service: refactor config generation`
* Test your changes. If you work with 
  * nixpkgs
    * update pkg -> 
      * `nix-env -i pkg-name -f <path to your local nixpkgs folder>`
    * add pkg -> 
      * Make sure it's in `pkgs/top-level/all-packages.nix`
      * `nix-env -i pkg-name -f <path to your local nixpkgs folder>`
    * _If you don't want to install pkg in you profile_. 
      * `nix-build -A pkg-attribute-name <path to your local nixpkgs folder>/default.nix` and check results in the folder `result`. It will appear in the same directory where you did `nix-build`.
    * If you did `nix-env -i pkg-name` you can do `nix-env -e pkg-name` to uninstall it from your system.
  * nixos and its modules
    * You can add new module to you `nixos-configuration file` (usually it's `/etc/nixos/configuration.nix`.  
    And do `sudo nixos-rebuild test -I nixpkgs=<path to your local nixpkgs folder> --fast`
* If you have commits `pkg-name: oh, forgot to insert whitespace`: squash commits in this case. Use `git rebase -i`.
* Rebase you branch against current `master`.

## Submitting changes

* Push your changes to your fork of nixpkgs.
* Create pull request.
  * Write the title in format `(pkg-name | service): improvement`
    * If you update the pkg, write versions `from -> to`
  * Write in comment if you have tested your patch. Do not rely much on `TravisCI`.
  * If you make an improvement, write why is it good.
  * Notify maintainers of the package. For example add to the message: `cc @jagajaga @domenkozar`

## Hotfixing pull requests

* Make the appropriate changes in you branch.
* Don't create additional commits.
  * `git rebase`
  * `git push --force` to your branch.
