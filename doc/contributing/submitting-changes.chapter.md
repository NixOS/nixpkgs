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
      - `nix-env -i pkg-name -f <path to your local nixpkgs folder>`
    - add pkg
      - Make sure it’s in `pkgs/top-level/all-packages.nix`
      - `nix-env -i pkg-name -f <path to your local nixpkgs folder>`
    - _If you don’t want to install pkg in you profile_.
      - `nix-build -A pkg-attribute-name <path to your local nixpkgs folder>/default.nix` and check results in the folder `result`. It will appear in the same directory where you did `nix-build`.
    - If you did `nix-env -i pkg-name` you can do `nix-env -e pkg-name` to uninstall it from your system.

  - NixOS and its modules:
    - You can add new module to your NixOS configuration file (usually it’s `/etc/nixos/configuration.nix`). And do `sudo nixos-rebuild test -I nixpkgs=<path to your local nixpkgs folder> --fast`.

- If you have commits `pkg-name: oh, forgot to insert whitespace`: squash commits in this case. Use `git rebase -i`.

- [Rebase](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) your branch against current `master`.

## Submitting changes {#submitting-changes-submitting-changes}

- Push your changes to your fork of nixpkgs.
- Create the pull request
- Follow [the contribution guidelines](https://github.com/NixOS/nixpkgs/blob/master/.github/CONTRIBUTING.md#submitting-changes).

## Submitting security fixes {#submitting-changes-submitting-security-fixes}

Security fixes are submitted in the same way as other changes and thus the same guidelines apply.

If the security fix comes in the form of a patch and a CVE is available, then the name of the patch should be the CVE identifier, so e.g. `CVE-2019-13636.patch` in the case of a patch that is included in the Nixpkgs tree. If a patch is fetched the name needs to be set as well, e.g.:

```nix
(fetchpatch {
  name = "CVE-2019-11068.patch";
  url = "https://gitlab.gnome.org/GNOME/libxslt/commit/e03553605b45c88f0b4b2980adfbbb8f6fca2fd6.patch";
  sha256 = "0pkpb4837km15zgg6h57bncp66d5lwrlvkr73h0lanywq7zrwhj8";
})
```

If a security fix applies to both master and a stable release then, similar to regular changes, they are preferably delivered via master first and cherry-picked to the release branch.

Critical security fixes may by-pass the staging branches and be delivered directly to release branches such as `master` and `release-*`.

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

Packages with automated tests are much more likely to be merged in a timely fashion because it doesn’t require as much manual testing by the maintainer to verify the functionality of the package. If there are existing tests for the package, they should be run to verify your changes do not break the tests. Tests only apply to packages with NixOS modules defined and can only be run on Linux. For more details on writing and running tests, see the [section in the NixOS manual](https://nixos.org/nixos/manual/index.html#sec-nixos-tests).

### Tested compilation of all pkgs that depend on this change using `nixpkgs-review` {#submitting-changes-tested-compilation}

If you are updating a package’s version, you can use nixpkgs-review to make sure all packages that depend on the updated package still compile correctly. The `nixpkgs-review` utility can look for and build all dependencies either based on uncommited changes with the `wip` option or specifying a github pull request number.

review changes from pull request number 12345:

```ShellSession
nix run nixpkgs.nixpkgs-review -c nixpkgs-review pr 12345
```

review uncommitted changes:

```ShellSession
nix run nixpkgs.nixpkgs-review -c nixpkgs-review wip
```

review changes from last commit:

```ShellSession
nix run nixpkgs.nixpkgs-review -c nixpkgs-review rev HEAD
```

### Tested execution of all binary files (usually in `./result/bin/`) {#submitting-changes-tested-execution}

It’s important to test any executables generated by a build when you change or create a package in nixpkgs. This can be done by looking in `./result/bin` and running any files in there, or at a minimum, the main executable for the package. For example, if you make a change to texlive, you probably would only check the binaries associated with the change you made rather than testing all of them.

### Meets Nixpkgs contribution standards {#submitting-changes-contribution-standards}

The last checkbox is fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/.github/CONTRIBUTING.md). The contributing document has detailed information on standards the Nix community has for commit messages, reviews, licensing of contributions you make to the project, etc\... Everyone should read and understand the standards the community has for contributing before submitting a pull request.

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

    master -> "staging-next" -> staging [color="#5F5EE8"] [label="every six hours/any time"] [fontcolor="#5F5EE8"]
}
```

### Master branch {#submitting-changes-master-branch}

The `master` branch is the main development branch. It should only see non-breaking commits that do not cause mass rebuilds.

### Staging branch {#submitting-changes-staging-branch}

The `staging` branch is a development branch where mass-rebuilds go. It should only see non-breaking mass-rebuild commits. That means it is not to be used for testing, and changes must have been well tested already. If the branch is already in a broken state, please refrain from adding extra new breakages.

### Staging-next branch {#submitting-changes-staging-next-branch}

The `staging-next` branch is for stabilizing mass-rebuilds submitted to the `staging` branch prior to merging them into `master`. Mass-rebuilds should go via the `staging` branch. It should only see non-breaking commits that are fixing issues blocking it from being merged into the `master ` branch.

If the branch is already in a broken state, please refrain from adding extra new breakages. Stabilize it for a few days and then merge into master.

### Stable release branches {#submitting-changes-stable-release-branches}

For cherry-picking a commit to a stable release branch (“backporting”), use `git cherry-pick -x <original commit>` so that the original commit id is included in the commit.

Add a reason for the backport by using `git cherry-pick -xe <original commit>` instead when it is not obvious from the original commit message. It is not needed when it's a minor version update that includes security and bug fixes but don't add new features or when the commit fixes an otherwise broken package.

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
