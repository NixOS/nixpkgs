# Submitting changes {#chap-submitting-changes}

## Making patches {#submitting-changes-making-patches}

- Read [Manual (How to write packages for Nix)](https://nixos.org/nixpkgs/manual/).

- Fork [the Nixpkgs repository](https://github.com/nixos/nixpkgs/) on GitHub.

- Create a branch for your future fix.

  - You can make branch from a commit of your local `nixos-version`. That will help you to avoid additional local compilations. Because you will receive packages from binary cache. For example

    ```ShellSession
    $ nixos-version --hash
    0998212
    $ git checkout 0998212
    $ git checkout -b 'fix/pkg-name-update'
    ```

  - Please avoid working directly on the `master` branch.

- Make commits of logical units.

- If you removed pkgs or made some major NixOS changes, write about it in the release notes for the next stable release. For example `nixos/doc/manual/release-notes/rl-2003.xml`.

- Check for unnecessary whitespace with `git diff --check` before committing.

- Format the commit in a following way:

  ```
  (pkg-name | nixos/<module>): (from -> to | init at version | refactor | etc)
  Additional information.
  ```

  - Examples:
    - `nginx: init at 2.0.1`
    - `firefox: 54.0.1 -> 55.0`
    - `nixos/hydra: add bazBaz option`
    - `nixos/nginx: refactor config generation`

- Test your changes. If you work with

  - nixpkgs:

    - update pkg
      - `nix-env -iA pkg-attribute-name -f <path to your local nixpkgs folder>`
    - add pkg
      - Make sure it’s in `pkgs/top-level/all-packages.nix`
      - `nix-env -iA pkg-attribute-name -f <path to your local nixpkgs folder>`
    - _If you don’t want to install pkg in you profile_.
      - `nix-build -A pkg-attribute-name <path to your local nixpkgs folder>` and check results in the folder `result`. It will appear in the same directory where you did `nix-build`.
    - If you installed your package with `nix-env`, you can run `nix-env -e pkg-name` where `pkg-name` is as reported by `nix-env -q` to uninstall it from your system.

  - NixOS and its modules:
    - You can add new module to your NixOS configuration file (usually it’s `/etc/nixos/configuration.nix`). And do `sudo nixos-rebuild test -I nixpkgs=<path to your local nixpkgs folder> --fast`.

- If you have commits `pkg-name: oh, forgot to insert whitespace`: squash commits in this case. Use `git rebase -i`.

- [Rebase](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) your branch against current `master`.

## Submitting changes {#submitting-changes-submitting-changes}

- Push your changes to your fork of nixpkgs.
- Create the pull request
- Follow [the contribution guidelines](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#submitting-changes).

## Submitting security fixes {#submitting-changes-submitting-security-fixes}

Security fixes are submitted in the same way as other changes and thus the same guidelines apply.

- If a new version fixing the vulnerability has been released, update the package;
- If the security fix comes in the form of a patch and a CVE is available, then add the patch to the Nixpkgs tree, and apply it to the package.
  The name of the patch should be the CVE identifier, so e.g. `CVE-2019-13636.patch`; If a patch is fetched the name needs to be set as well, e.g.:

  ```nix
  (fetchpatch {
    name = "CVE-2019-11068.patch";
    url = "https://gitlab.gnome.org/GNOME/libxslt/commit/e03553605b45c88f0b4b2980adfbbb8f6fca2fd6.patch";
    hash = "sha256-SEKe/8HcW0UBHCfPTTOnpRlzmV2nQPPeL6HOMxBZd14=";
  })
  ```

If a security fix applies to both master and a stable release then, similar to regular changes, they are preferably delivered via master first and cherry-picked to the release branch.

Critical security fixes may by-pass the staging branches and be delivered directly to release branches such as `master` and `release-*`.

## Deprecating/removing packages {#submitting-changes-deprecating-packages}

There is currently no policy when to remove a package.

Before removing a package, one should try to find a new maintainer or fix smaller issues first.

### Steps to remove a package from Nixpkgs {#steps-to-remove-a-package-from-nixpkgs}

We use jbidwatcher as an example for a discontinued project here.

1. Have Nixpkgs checked out locally and up to date.
1. Create a new branch for your change, e.g. `git checkout -b jbidwatcher`
1. Remove the actual package including its directory, e.g. `git rm -rf pkgs/applications/misc/jbidwatcher`
1. Remove the package from the list of all packages (`pkgs/top-level/all-packages.nix`).
1. Add an alias for the package name in `pkgs/top-level/aliases.nix` (There is also `pkgs/applications/editors/vim/plugins/aliases.nix`. Package sets typically do not have aliases, so we can't add them there.)

    For example in this case:

    ```
    jbidwatcher = throw "jbidwatcher was discontinued in march 2021"; # added 2021-03-15
    ```

    The throw message should explain in short why the package was removed for users that still have it installed.

1. Test if the changes introduced any issues by running `nix-env -qaP -f . --show-trace`. It should show the list of packages without errors.
1. Commit the changes. Explain again why the package was removed. If it was declared discontinued upstream, add a link to the source.

    ```ShellSession
    $ git add pkgs/applications/misc/jbidwatcher/default.nix pkgs/top-level/all-packages.nix pkgs/top-level/aliases.nix
    $ git commit
    ```

    Example commit message:

    ```
    jbidwatcher: remove

    project was discontinued in march 2021. the program does not work anymore because ebay changed the login.

    https://web.archive.org/web/20210315205723/http://www.jbidwatcher.com/
    ```

1. Push changes to your GitHub fork with `git push`
1. Create a pull request against Nixpkgs. Mention the package maintainer.

This is how the pull request looks like in this case: [https://github.com/NixOS/nixpkgs/pull/116470](https://github.com/NixOS/nixpkgs/pull/116470)

## Pull Request Template {#submitting-changes-pull-request-template}

The pull request template helps determine what steps have been made for a contribution so far, and will help guide maintainers on the status of a change. The motivation section of the PR should include any extra details the title does not address and link any existing issues related to the pull request.

When a PR is created, it will be pre-populated with some checkboxes detailed below:

### Tested using sandboxing {#submitting-changes-tested-with-sandbox}

When sandbox builds are enabled, Nix will setup an isolated environment for each build process. It is used to remove further hidden dependencies set by the build environment to improve reproducibility. This includes access to the network during the build outside of `fetch*` functions and files outside the Nix store. Depending on the operating system access to other resources are blocked as well (ex. inter process communication is isolated on Linux); see [sandbox](https://nixos.org/nix/manual/#conf-sandbox) in Nix manual for details.

Sandboxing is not enabled by default in Nix due to a small performance hit on each build. In pull requests for [nixpkgs](https://github.com/NixOS/nixpkgs/) people are asked to test builds with sandboxing enabled (see `Tested using sandboxing` in the pull request template) because in<https://nixos.org/hydra/> sandboxing is also used.

Depending if you use NixOS or other platforms you can use one of the following methods to enable sandboxing **before** building the package:

- **Globally enable sandboxing on NixOS**: add the following to `configuration.nix`

  ```nix
  nix.useSandbox = true;
  ```

- **Globally enable sandboxing on non-NixOS platforms**: add the following to: `/etc/nix/nix.conf`

  ```ini
  sandbox = true
  ```

### Built on platform(s) {#submitting-changes-platform-diversity}

Many Nix packages are designed to run on multiple platforms. As such, it’s important to let the maintainer know which platforms your changes have been tested on. It’s not always practical to test a change on all platforms, and is not required for a pull request to be merged. Only check the systems you tested the build on in this section.

### Tested via one or more NixOS test(s) if existing and applicable for the change (look inside nixos/tests) {#submitting-changes-nixos-tests}

Packages with automated tests are much more likely to be merged in a timely fashion because it doesn’t require as much manual testing by the maintainer to verify the functionality of the package. If there are existing tests for the package, they should be run to verify your changes do not break the tests. Tests can only be run on Linux. For more details on writing and running tests, see the [section in the NixOS manual](https://nixos.org/nixos/manual/index.html#sec-nixos-tests).

### Tested compilation of all pkgs that depend on this change using `nixpkgs-review` {#submitting-changes-tested-compilation}

If you are updating a package’s version, you can use `nixpkgs-review` to make sure all packages that depend on the updated package still compile correctly. The `nixpkgs-review` utility can look for and build all dependencies either based on uncommitted changes with the `wip` option or specifying a GitHub pull request number.

Review changes from pull request number 12345:

```ShellSession
nix-shell -p nixpkgs-review --run "nixpkgs-review pr 12345"
```

Alternatively, with flakes (and analogously for the other commands below):

```ShellSession
nix run nixpkgs#nixpkgs-review -- pr 12345
```

Review uncommitted changes:

```ShellSession
nix-shell -p nixpkgs-review --run "nixpkgs-review wip"
```

Review changes from last commit:

```ShellSession
nix-shell -p nixpkgs-review --run "nixpkgs-review rev HEAD"
```

### Tested execution of all binary files (usually in `./result/bin/`) {#submitting-changes-tested-execution}

It’s important to test any executables generated by a build when you change or create a package in nixpkgs. This can be done by looking in `./result/bin` and running any files in there, or at a minimum, the main executable for the package. For example, if you make a change to texlive, you probably would only check the binaries associated with the change you made rather than testing all of them.

### Meets Nixpkgs contribution standards {#submitting-changes-contribution-standards}

The last checkbox is fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md). The contributing document has detailed information on standards the Nix community has for commit messages, reviews, licensing of contributions you make to the project, etc... Everyone should read and understand the standards the community has for contributing before submitting a pull request.

## Hotfixing pull requests {#submitting-changes-hotfixing-pull-requests}

- Make the appropriate changes in you branch.
- Don’t create additional commits, do
  - `git rebase -i`
  - `git push --force` to your branch.

## Commit policy {#submitting-changes-commit-policy}

- Commits must be sufficiently tested before being merged, both for the master and staging branches.
- Hydra builds for master and staging should not be used as testing platform, it’s a build farm for changes that have been already tested.
- When changing the bootloader installation process, extra care must be taken. Grub installations cannot be rolled back, hence changes may break people’s installations forever. For any non-trivial change to the bootloader please file a PR asking for review, especially from \@edolstra.

```{.graphviz caption="Staging workflow"}
digraph {
    "small changes" [shape=none]
    "mass-rebuilds and other large changes" [shape=none]
    "critical security fixes" [shape=none]
    "broken staging-next fixes" [shape=none]

    "small changes" -> master
    "mass-rebuilds and other large changes" -> staging
    "critical security fixes" -> master
    "broken staging-next fixes" -> "staging-next"

    "staging-next" -> master [color="#E85EB0"] [label="stabilization ends"] [fontcolor="#E85EB0"]
    "staging" -> "staging-next" [color="#E85EB0"] [label="stabilization starts"] [fontcolor="#E85EB0"]

    master -> "staging-next" -> staging [color="#5F5EE8"] [label="every six hours (GitHub Action)"] [fontcolor="#5F5EE8"]
}
```

[This GitHub Action](https://github.com/NixOS/nixpkgs/blob/master/.github/workflows/periodic-merge-6h.yml) brings changes from `master` to `staging-next` and from `staging-next` to `staging` every 6 hours; these are the blue arrows in the diagram above.  The purple arrows in the diagram above are done manually and much less frequently.  You can get an idea of how often these merges occur by looking at the git history.


### Master branch {#submitting-changes-master-branch}

The `master` branch is the main development branch. It should only see non-breaking commits that do not cause mass rebuilds.

### Staging branch {#submitting-changes-staging-branch}

The `staging` branch is a development branch where mass-rebuilds go. Mass rebuilds are commits that cause rebuilds for many packages, like more than 500 (or perhaps, if it's 'light' packages, 1000). It should only see non-breaking mass-rebuild commits. That means it is not to be used for testing, and changes must have been well tested already. If the branch is already in a broken state, please refrain from adding extra new breakages.

During the process of a releasing a new NixOS version, this branch or the release-critical packages can be restricted to non-breaking changes.

### Staging-next branch {#submitting-changes-staging-next-branch}

The `staging-next` branch is for stabilizing mass-rebuilds submitted to the `staging` branch prior to merging them into `master`. Mass-rebuilds must go via the `staging` branch. It must only see non-breaking commits that are fixing issues blocking it from being merged into the `master` branch.

If the branch is already in a broken state, please refrain from adding extra new breakages. Stabilize it for a few days and then merge into master.

During the process of a releasing a new NixOS version, this branch or the release-critical packages can be restricted to non-breaking changes.

### Stable release branches {#submitting-changes-stable-release-branches}

The same staging workflow applies to stable release branches, but the main branch is called `release-*` instead of `master`.

Example branch names: `release-21.11`, `staging-21.11`, `staging-next-21.11`.

Most changes added to the stable release branches are cherry-picked (“backported”) from the `master` and staging branches.

#### Automatically backporting a Pull Request {#submitting-changes-stable-release-branches-automatic-backports}

Assign label `backport <branch>` (e.g. `backport release-21.11`) to the PR and a backport PR is automatically created after the PR is merged.

#### Manually backporting changes {#submitting-changes-stable-release-branches-manual-backports}

Cherry-pick changes via `git cherry-pick -x <original commit>` so that the original commit id is included in the commit message.

Add a reason for the backport when it is not obvious from the original commit message. You can do this by cherry picking with `git cherry-pick -xe <original commit>`, which allows editing the commit message. This is not needed for minor version updates that include security and bug fixes but don't add new features or when the commit fixes an otherwise broken package.

Here is an example of a cherry-picked commit message with good reason description:

```
zfs: Keep trying root import until it works

Works around #11003.

(cherry picked from commit 98b213a11041af39b39473906b595290e2a4e2f9)

Reason: several people cannot boot with ZFS on NVMe
```

Other examples of reasons are:

- Previously the build would fail due to, e.g., `getaddrinfo` not being defined
- The previous download links were all broken
- Crash when starting on some X11 systems

#### Acceptable backport criteria {#acceptable-backport-criteria}

The stable branch does have some changes which cannot be backported. Most notable are breaking changes. The desire is to have stable users be uninterrupted when updating packages.

However, many changes are able to be backported, including:
- New Packages / Modules
- Security / Patch updates
- Version updates which include new functionality (but no breaking changes)
- Services which require a client to be up-to-date regardless. (E.g. `spotify`, `steam`, or `discord`)
- Security critical applications (E.g. `firefox`)
