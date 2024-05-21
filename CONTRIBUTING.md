# Contributing to Nixpkgs

This document is for people wanting to contribute to the implementation of Nixpkgs.
This involves interacting with implementation changes that are proposed using [GitHub](https://github.com/) [pull requests](https://docs.github.com/pull-requests) to the [Nixpkgs](https://github.com/nixos/nixpkgs/) repository (which you're in right now).

As such, a GitHub account is recommended, which you can sign up for [here](https://github.com/signup).
See [here](https://discourse.nixos.org/t/about-the-patches-category/477) for how to contribute without a GitHub account.

Additionally this document assumes that you already know how to use GitHub and Git.
If that's not the case, we recommend learning about it first [here](https://docs.github.com/en/get-started/quickstart/hello-world).

## Overview
[overview]: #overview

This file contains general contributing information, but individual parts also have more specific information to them in their respective `README.md` files, linked here:
- [`lib`](./lib/README.md): Sources and documentation of the [library functions](https://nixos.org/manual/nixpkgs/stable/#chap-functions)
- [`maintainers`](./maintainers/README.md): Nixpkgs maintainer and team listings, maintainer scripts
- [`pkgs`](./pkgs/README.md): Package and [builder](https://nixos.org/manual/nixpkgs/stable/#part-builders) definitions
- [`doc`](./doc/README.md): Sources and infrastructure for the [Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/)
- [`nixos`](./nixos/README.md): Implementation of [NixOS](https://nixos.org/manual/nixos/stable/)

# How to's

## How to create pull requests
[pr-create]: #how-to-create-pull-requests

This section describes in some detail how changes can be made and proposed with pull requests.

> [!Note]
> Be aware that contributing implies licensing those contributions under the terms of [COPYING](./COPYING), an MIT-like license.

0. Set up a local version of Nixpkgs to work with using GitHub and Git
   1. [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo#forking-a-repository) the [Nixpkgs repository](https://github.com/nixos/nixpkgs/).
   1. [Clone the forked repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo#cloning-your-forked-repository) into a local `nixpkgs` directory.
   1. [Configure the upstream Nixpkgs repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo#configuring-git-to-sync-your-fork-with-the-upstream-repository).

1. Figure out the branch that should be used for this change by going through [this section][branch].
   If in doubt use `master`, that's where most changes should go.
   This can be changed later by [rebasing][rebase].

2. Create and switch to a new Git branch, ideally such that:
   - The name of the branch hints at the change you'd like to implement, e.g. `update-hello`.
   - The base of the branch includes the most recent changes on the base branch from step 1, we'll assume `master` here.

   ```bash
   # Make sure you have the latest changes from upstream Nixpkgs
   git fetch upstream

   # Create and switch to a new branch based off the master branch in Nixpkgs
   git switch --create update-hello upstream/master
   ```

   To avoid having to download and build potentially many derivations, at the expense of using a potentially outdated version, you can base the branch off a specific [Git commit](https://www.git-scm.com/docs/gitglossary#def_commit) instead:
   - The commit of the latest `nixpkgs-unstable` channel, available [here](https://channels.nixos.org/nixpkgs-unstable/git-revision).
   - The commit of a local Nixpkgs downloaded using [nix-channel](https://nixos.org/manual/nix/stable/command-ref/nix-channel), available using `nix-instantiate --eval --expr '(import <nixpkgs/lib>).trivial.revisionWithDefault null'`
   - If you're using NixOS, the commit of your NixOS installation, available with `nixos-version --revision`.

   Once you have an appropriate commit you can use it instead of `upstream/master` in the above command:
   ```bash
   git switch --create update-hello <the desired base commit>
   ```

3. Make the desired changes in the local Nixpkgs repository using an editor of your choice.
   Make sure to:
   - Adhere to both the [general code conventions][code-conventions], and the code conventions specific to the part you're making changes to.
     See the [overview section][overview] for more specific information.
   - Test the changes.
     See the [overview section][overview] for more specific information.
   - If necessary, document the change.
     See the [overview section][overview] for more specific information.

4. Commit your changes using `git commit`.
   Make sure to adhere to the [commit conventions](#commit-conventions).

   Repeat the steps 3-4 as many times as necessary.
   Advance to the next step if all the commits (viewable with `git log`) make sense together.

5. Push your commits to your fork of Nixpkgs.
   ```
   git push --set-upstream origin HEAD
   ```

   The above command will output a link that allows you to directly quickly do the next step:
   ```
   remote: Create a pull request for 'update-hello' on GitHub by visiting:
   remote:      https://github.com/myUser/nixpkgs/pull/new/update-hello
   ```

6. [Create a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request#creating-the-pull-request) from the new branch in your Nixpkgs fork to the upstream Nixpkgs repository.
   Use the branch from step 2 as the pull requests base branch.
   Go through the [pull request template](#pull-request-template) in the pre-filled default description.

7. Respond to review comments, potential CI failures and potential merge conflicts by updating the pull request.
   Always keep the pull request in a mergeable state.

   The custom [OfBorg](https://github.com/NixOS/ofborg) CI system will perform various checks to help ensure code quality, whose results you can see at the bottom of the pull request.
   See [the OfBorg Readme](https://github.com/NixOS/ofborg#readme) for more details.

   - To add new commits, repeat steps 3-4 and push the result using
     ```
     git push
     ```

   - To change existing commits you will have to [rewrite Git history](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History).
     Useful Git commands that can help a lot with this are `git commit --patch --amend` and `git rebase --interactive`.
     With a rewritten history you need to force-push the commits using
     ```
     git push --force-with-lease
     ```

   - In case of merge conflicts you will also have to [rebase the branch](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) on top of current `master`.
     Sometimes this can be done [on GitHub directly](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/keeping-your-pull-request-in-sync-with-the-base-branch#updating-your-pull-request-branch), but if not you will have to rebase locally using
     ```
     git fetch upstream
     git rebase upstream/master
     git push --force-with-lease
     ```

   - If you need to change the base branch of the pull request, you can do so by [rebasing][rebase].

8. If your pull request is merged and [acceptable for releases][release-acceptable] you may [backport][pr-backport] the pull request.

### Pull request template
[pr-template]: #pull-request-template

The pull request template helps determine what steps have been made for a contribution so far, and will help guide maintainers on the status of a change. The motivation section of the PR should include any extra details the title does not address and link any existing issues related to the pull request.

When a PR is created, it will be pre-populated with some checkboxes detailed below:

#### Tested using sandboxing

When sandbox builds are enabled, Nix will set up an isolated environment for each build process.
It is used to remove further hidden dependencies set by the build environment to improve reproducibility.
This includes access to the network during the build outside of `fetch*` functions and files outside the Nix store.
Depending on the operating system, access to other resources is blocked as well (e.g., inter-process communication is isolated on Linux); see [sandbox](https://nixos.org/manual/nix/stable/command-ref/conf-file#conf-sandbox) in the Nix manual for details.

In pull requests for [nixpkgs](https://github.com/NixOS/nixpkgs/) people are asked to test builds with sandboxing enabled (see `Tested using sandboxing` in the pull request template) because in [Hydra](https://nixos.org/hydra/) sandboxing is also used.

If you are on Linux, sandboxing is enabled by default.
On other platforms, sandboxing is disabled by default due to a small performance hit on each build.

Please enable sandboxing **before** building the package by adding the following to: `/etc/nix/nix.conf`:

  ```ini
  sandbox = true
  ```

#### Built on platform(s)

Many Nix packages are designed to run on multiple platforms. As such, it’s important to let the maintainer know which platforms your changes have been tested on. It’s not always practical to test a change on all platforms, and is not required for a pull request to be merged. Only check the systems you tested the build on in this section.

#### Tested via one or more NixOS test(s) if existing and applicable for the change (look inside nixos/tests)

Packages with automated tests are much more likely to be merged in a timely fashion because it doesn’t require as much manual testing by the maintainer to verify the functionality of the package. If there are existing tests for the package, they should be run to verify your changes do not break the tests. Tests can only be run on Linux. For more details on writing and running tests, see the [section in the NixOS manual](https://nixos.org/nixos/manual/index.html#sec-nixos-tests).

#### Tested compilation of all pkgs that depend on this change using `nixpkgs-review`

If you are modifying a package, you can use `nixpkgs-review` to make sure all packages that depend on the updated package still compile correctly. The `nixpkgs-review` utility can look for and build all dependencies either based on uncommitted changes with the `wip` option or specifying a GitHub pull request number.

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

#### Tested execution of all binary files (usually in `./result/bin/`)

It’s important to test any executables generated by a build when you change or create a package in nixpkgs. This can be done by looking in `./result/bin` and running any files in there, or at a minimum, the main executable for the package. For example, if you make a change to texlive, you probably would only check the binaries associated with the change you made rather than testing all of them.

#### Meets Nixpkgs contribution standards

The last checkbox is about whether it fits the guidelines in this `CONTRIBUTING.md` file. This document has detailed information on standards the Nix community has for commit messages, reviews, licensing of contributions you make to the project, etc... Everyone should read and understand the standards the community has for contributing before submitting a pull request.

### Rebasing between branches (i.e. from master to staging)
[rebase]: #rebasing-between-branches-ie-from-master-to-staging

From time to time, changes between branches must be rebased, for example, if the
number of new rebuilds they would cause is too large for the target branch. When
rebasing, care must be taken to include only the intended changes, otherwise
many CODEOWNERS will be inadvertently requested for review. To achieve this,
rebasing should not be performed directly on the target branch, but on the merge
base between the current and target branch. As an additional precautionary measure,
you should temporarily mark the PR as draft for the duration of the operation.
This reduces the probability of mass-pinging people. (OfBorg might still
request a couple of persons for reviews though.)

In the following example, we assume that the current branch, called `feature`,
is based on `master`, and we rebase it onto the merge base between
`master` and `staging` so that the PR can eventually be retargeted to
`staging` without causing a mess. The example uses `upstream` as the remote for `NixOS/nixpkgs.git`
while `origin` is the remote you are pushing to.


```console
# Rebase your commits onto the common merge base
git rebase --onto upstream/staging... upstream/master
# Force push your changes
git push origin feature --force-with-lease
```

The syntax `upstream/staging...` is equivalent to `upstream/staging...HEAD` and
stands for the merge base between `upstream/staging` and `HEAD` (hence between
`upstream/staging` and `upstream/master`).

Then change the base branch in the GitHub PR using the *Edit* button in the upper
right corner, and switch from `master` to `staging`. *After* the PR has been
retargeted it might be necessary to do a final rebase onto the target branch, to
resolve any outstanding merge conflicts.

```console
# Rebase onto target branch
git rebase upstream/staging
# Review and fixup possible conflicts
git status
# Force push your changes
git push origin feature --force-with-lease
```

#### Something went wrong and a lot of people were pinged

It happens. Remember to be kind, especially to new contributors.
There is no way back, so the pull request should be closed and locked
(if possible). The changes should be re-submitted in a new PR, in which the people
originally involved in the conversation need to manually be pinged again.
No further discussion should happen on the original PR, as a lot of people
are now subscribed to it.

The following message (or a version thereof) might be left when closing to
describe the situation, since closing and locking without any explanation
is kind of rude:

```markdown
It looks like you accidentally mass-pinged a bunch of people, which are now subscribed
and getting notifications for everything in this pull request. Unfortunately, they
cannot be automatically unsubscribed from the issue (removing review request does not
unsubscribe), therefore development cannot continue in this pull request anymore.

Please open a new pull request with your changes, link back to this one and ping the
people actually involved in here over there.

In order to avoid this in the future, there are instructions for how to properly
rebase between branches in our [contribution guidelines](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#rebasing-between-branches-ie-from-master-to-staging).
Setting your pull request to draft prior to rebasing is strongly recommended.
In draft status, you can preview the list of people that are about to be requested
for review, which allows you to sidestep this issue.
This is not a bulletproof method though, as OfBorg still does review requests even on draft PRs.
```

## How to backport pull requests
[pr-backport]: #how-to-backport-pull-requests

Once a pull request has been merged into `master`, a backport pull request to the corresponding `release-YY.MM` branch can be created either automatically or manually.

### Automatically backporting changes

> [!Note]
> You have to be a [Nixpkgs maintainer](./maintainers) to automatically create a backport pull request.

Add the [`backport release-YY.MM` label](https://github.com/NixOS/nixpkgs/labels?q=backport) to the pull request on the `master` branch.
This will cause [a GitHub Action](.github/workflows/backport.yml) to open a pull request to the `release-YY.MM` branch a few minutes later.
This can be done on both open or already merged pull requests.

### Manually backporting changes

To manually create a backport pull request, follow [the standard pull request process][pr-create], with these notable differences:

- Use `release-YY.MM` for the base branch, both for the local branch and the pull request.

> [!Warning]
> Do not use the `nixos-YY.MM` branch, that is a branch pointing to the tested release channel commit

- Instead of manually making and committing the changes, use [`git cherry-pick -x`](https://git-scm.com/docs/git-cherry-pick) for each commit from the pull request you'd like to backport.
  Either `git cherry-pick -x <commit>` when the reason for the backport is obvious (such as minor versions, fixes, etc.), otherwise use `git cherry-pick -xe <commit>` to add a reason for the backport to the commit message.
  Here is [an example](https://github.com/nixos/nixpkgs/commit/5688c39af5a6c5f3d646343443683da880eaefb8) of this.

> [!Warning]
> Ensure the commits exists on the master branch.
> In the case of squashed or rebased merges, the commit hash will change and the new commits can be found in the merge message at the bottom of the master pull request.

- In the pull request description, link to the original pull request to `master`.
  The pull request title should include `[YY.MM]` matching the release you're backporting to.

- When the backport pull request is merged and you have the necessary privileges you can also replace the label `9.needs: port to stable` with `8.has: port to stable` on the original pull request.
  This way maintainers can keep track of missing backports easier.

## How to review pull requests
[pr-review]: #how-to-review-pull-requests

> [!Warning]
> The following section is a draft, and the policy for reviewing is still being discussed in issues such as [#11166](https://github.com/NixOS/nixpkgs/issues/11166) and [#20836](https://github.com/NixOS/nixpkgs/issues/20836).

The Nixpkgs project receives a fairly high number of contributions via GitHub pull requests. Reviewing and approving these is an important task and a way to contribute to the project.

The high change rate of Nixpkgs makes any pull request that remains open for too long subject to conflicts that will require extra work from the submitter or the merger. Reviewing pull requests in a timely manner and being responsive to the comments is the key to avoid this issue. GitHub provides sort filters that can be used to see the [most recently](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+sort%3Aupdated-desc) and the [least recently](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+sort%3Aupdated-asc) updated pull requests. We highly encourage looking at [this list of ready to merge, unreviewed pull requests](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+review%3Anone+status%3Asuccess+-label%3A%222.status%3A+work-in-progress%22+no%3Aproject+no%3Aassignee+no%3Amilestone).

When reviewing a pull request, please always be nice and polite. Controversial changes can lead to controversial opinions, but it is important to respect every community member and their work.

GitHub provides reactions as a simple and quick way to provide feedback to pull requests or any comments. The thumb-down reaction should be used with care and if possible accompanied with some explanation so the submitter has directions to improve their contribution.

Pull request reviews should include a list of what has been reviewed in a comment, so other reviewers and mergers can know the state of the review.

All the review template samples provided in this section are generic and meant as examples. Their usage is optional and the reviewer is free to adapt them to their liking.

To get more information about how to review specific parts of Nixpkgs, refer to the documents linked to in the [overview section][overview].

If a pull request contains documentation changes that might require feedback from the documentation team, ping [@NixOS/documentation-team](https://github.com/orgs/nixos/teams/documentation-team) on the pull request.

If you consider having enough knowledge and experience in a topic and would like to be a long-term reviewer for related submissions, please contact the current reviewers for that topic. They will give you information about the reviewing process. The main reviewers for a topic can be hard to find as there is no list, but checking past pull requests to see who reviewed or git-blaming the code to see who committed to that topic can give some hints.

Container system, boot system and library changes are some examples of the pull requests fitting this category.

## How to merge pull requests
[pr-merge]: #how-to-merge-pull-requests

The *Nixpkgs committers* are people who have been given
permission to merge.

It is possible for community members that have enough knowledge and experience on a special topic to contribute by merging pull requests.

In case the PR is stuck waiting for the original author to apply a trivial
change (a typo, capitalisation change, etc.) and the author allowed the members
to modify the PR, consider applying it yourself (or commit the existing review
suggestion). You should pay extra attention to make sure the addition doesn't go
against the idea of the original PR and would not be opposed by the author.

<!--
The following paragraphs about how to deal with unactive contributors is just a proposition and should be modified to what the community agrees to be the right policy.

Please note that contributors with commit rights unactive for more than three months will have their commit rights revoked.
-->

Please see the discussion in [GitHub nixpkgs issue #50105](https://github.com/NixOS/nixpkgs/issues/50105) for information on how to proceed to be granted this level of access.

In a case a contributor definitively leaves the Nix community, they should create an issue or post on [Discourse](https://discourse.nixos.org) with references of packages and modules they maintain so the maintainership can be taken over by other contributors.

# Flow of merged pull requests

After a pull request is merged, it eventually makes it to the [official Hydra CI](https://hydra.nixos.org/).
Hydra regularly evaluates and builds Nixpkgs, updating [the official channels](https://channels.nixos.org/) when specific Hydra jobs succeeded.
See [Nix Channel Status](https://status.nixos.org/) for the current channels and their state.
Here's a brief overview of the main Git branches and what channels they're used for:

- `master`: The main branch, used for the unstable channels such as `nixpkgs-unstable`, `nixos-unstable` and `nixos-unstable-small`.
- `release-YY.MM` (e.g. `release-23.11`): The NixOS release branches, used for the stable channels such as `nixos-23.11`, `nixos-23.11-small` and `nixpkgs-23.11-darwin`.

When a channel is updated, a corresponding Git branch is also updated to point to the corresponding commit.
So e.g. the [`nixpkgs-unstable` branch](https://github.com/nixos/nixpkgs/tree/nixpkgs-unstable) corresponds to the Git commit from the [`nixpkgs-unstable` channel](https://channels.nixos.org/nixpkgs-unstable).

Nixpkgs in its entirety is tied to the NixOS release process, which is documented in the [NixOS Release Wiki](https://nixos.github.io/release-wiki/).

See [this section][branch] to know when to use the release branches.

## Staging
[staging]: #staging

The staging workflow exists to batch Hydra builds of many packages together.

It works by directing commits that cause [mass rebuilds][mass-rebuild] to a separate `staging` branch that isn't directly built by Hydra.
Regularly, the `staging` branch is _manually_ merged into a `staging-next` branch to be built by Hydra using the [`nixpkgs:staging-next` jobset](https://hydra.nixos.org/jobset/nixpkgs/staging-next).
The `staging-next` branch should then only receive direct commits in order to fix Hydra builds.
Once it is verified that there are no major regressions, it is merged into `master` using [a pull request](https://github.com/NixOS/nixpkgs/pulls?q=head%3Astaging-next).
This is done manually in order to ensure it's a good use of Hydra's computing resources.
By keeping the `staging-next` branch separate from `staging`, this batching does not block developers from merging changes into `staging`.

In order for the `staging` and `staging-next` branches to be up-to-date with the latest commits on `master`, there are regular _automated_ merges from `master` into `staging-next` and `staging`.
This is implemented using GitHub workflows [here](.github/workflows/periodic-merge-6h.yml) and [here](.github/workflows/periodic-merge-24h.yml).

> [!Note]
> Changes must be sufficiently tested before being merged into any branch.
> Hydra builds should not be used as testing platform.

Here is a Git history diagram showing the flow of commits between the three branches:
```mermaid
%%{init: {
    'theme': 'base',
    'themeVariables': {
        'gitInv0': '#ff0000',
        'gitInv1': '#ff0000',
        'git2': '#ff4444',
        'commitLabelFontSize': '15px'
    },
    'gitGraph': {
        'showCommitLabel':true,
        'mainBranchName': 'master',
        'rotateCommitLabel': true
    }
} }%%
gitGraph
    commit id:" "
    branch staging-next
    branch staging

    checkout master
    checkout staging
    checkout master
    commit id:"    "
    checkout staging-next
    merge master id:"automatic"
    checkout staging
    merge staging-next id:"automatic "

    checkout staging-next
    merge staging type:HIGHLIGHT id:"manual"
    commit id:"fixup"

    checkout master
    checkout staging
    checkout master
    commit id:"       "
    checkout staging-next
    merge master id:"automatic  "
    checkout staging
    merge staging-next id:"automatic   "

    checkout staging-next
    commit id:"fixup "
    checkout master
    merge staging-next type:HIGHLIGHT id:"manual (PR)"
```


Here's an overview of the different branches:

| branch | `master` | `staging-next` | `staging` |
| --- | --- | --- | --- |
| Used for development | ✔️ | ❌ | ✔️ |
| Built by Hydra | ✔️ | ✔️ | ❌ |
| [Mass rebuilds][mass-rebuild] | ❌ | ⚠️  Only to fix Hydra builds | ✔️ |
| Critical security fixes | ✔️ for non-mass-rebuilds | ✔️ for mass-rebuilds | ❌ |
| Automatically merged into | `staging-next` | `staging` | - |
| Manually merged into | - | `master` | `staging-next` |

The staging workflow is used for all main branches, `master` and `release-YY.MM`, with corresponding names:
- `master`/`release-YY.MM`
- `staging`/`staging-YY.MM`
- `staging-next`/`staging-next-YY.MM`

# Conventions

## Branch conventions
<!-- This section is relevant to both contributors and reviewers -->
[branch]: #branch-conventions

Most changes should go to the `master` branch, but sometimes other branches should be used instead.
Use the following decision process to figure out which one it should be:

Is the change [acceptable for releases][release-acceptable] and do you wish to have the change in the release?
- No: Use the `master` branch, do not backport the pull request.
- Yes: Can the change be implemented the same way on the `master` and release branches?
  For example, a packages major version might differ between the `master` and release branches, such that separate security patches are required.
  - Yes: Use the `master` branch and [backport the pull request](#how-to-backport-pull-requests).
  - No: Create separate pull requests to the `master` and `release-XX.YY` branches.

Furthermore, if the change causes a [mass rebuild][mass-rebuild], use the appropriate staging branch instead:
- Mass rebuilds to `master` should go to `staging` instead.
- Mass rebuilds to `release-XX.YY` should go to `staging-XX.YY` instead.

See [this section][staging] for more details about such changes propagate between the branches.

### Changes acceptable for releases
[release-acceptable]: #changes-acceptable-for-releases

Only changes to supported releases may be accepted.
The oldest supported release (`YYMM`) can be found using
```
nix-instantiate --eval -A lib.trivial.oldestSupportedRelease
```

The release branches should generally only receive backwards-compatible changes, both for the Nix expressions and derivations.
Here are some examples of backwards-compatible changes that are okay to backport:
- ✔️ New packages, modules and functions
- ✔️ Security fixes
- ✔️ Package version updates
  - ✔️ Patch versions with fixes
  - ✔️ Minor versions with new functionality, but no breaking changes

In addition, major package version updates with breaking changes are also acceptable for:
- ✔️ Services that would fail without up-to-date client software, such as `spotify`, `steam`, and `discord`
- ✔️ Security critical applications, such as `firefox` and `chromium`

### Changes causing mass rebuilds
[mass-rebuild]: #changes-causing-mass-rebuilds

Which changes cause mass rebuilds is not formally defined.
In order to help the decision, CI automatically assigns [`rebuild` labels](https://github.com/NixOS/nixpkgs/labels?q=rebuild) to pull requests based on the number of packages they cause rebuilds for.
As a rule of thumb, if the number of rebuilds is **over 500**, it can be considered a mass rebuild.
To get a sense for what changes are considered mass rebuilds, see [previously merged pull requests to the staging branches](https://github.com/NixOS/nixpkgs/issues?q=base%3Astaging+-base%3Astaging-next+is%3Amerged).

## Commit conventions
[commit-conventions]: #commit-conventions

- Create a commit for each logical unit.

- Check for unnecessary whitespace with `git diff --check` before committing.

- If you have commits `pkg-name: oh, forgot to insert whitespace`: squash commits in this case. Use `git rebase -i`.
  See [Squashing Commits](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History#_squashing) for additional information.

- For consistency, there should not be a period at the end of the commit message's summary line (the first line of the commit message).

- When adding yourself as maintainer in the same pull request, make a separate
  commit with the message `maintainers: add <handle>`.
  Add the commit before those making changes to the package or module.
  See [Nixpkgs Maintainers](./maintainers/README.md) for details.

- Make sure you read about any commit conventions specific to the area you're touching. See:
  - [Commit conventions](./pkgs/README.md#commit-conventions) for changes to `pkgs`.
  - [Commit conventions](./lib/README.md#commit-conventions) for changes to `lib`.
  - [Commit conventions](./nixos/README.md#commit-conventions) for changes to `nixos`.
  - [Commit conventions](./doc/README.md#commit-conventions) for changes to `doc`, the Nixpkgs manual.

### Writing good commit messages

In addition to writing properly formatted commit messages, it's important to include relevant information so other developers can later understand *why* a change was made. While this information usually can be found by digging code, mailing list/Discourse archives, pull request discussions or upstream changes, it may require a lot of work.

Package version upgrades usually allow for simpler commit messages, including attribute name, old and new version, as well as a reference to the relevant release notes/changelog. Every once in a while a package upgrade requires more extensive changes, and that subsequently warrants a more verbose message.

Pull requests should not be squash merged in order to keep complete commit messages and GPG signatures intact and must not be when the change doesn't make sense as a single commit.

## Code conventions
[code-conventions]: #code-conventions

### Release notes

If you removed packages or made some major NixOS changes, write about it in the release notes for the next stable release in [`nixos/doc/manual/release-notes`](./nixos/doc/manual/release-notes).

### File naming and organisation

Names of files and directories should be in lowercase, with dashes between words — not in camel case. For instance, it should be `all-packages.nix`, not `allPackages.nix` or `AllPackages.nix`.

### Syntax

- Use 2 spaces of indentation per indentation level in Nix expressions, 4 spaces in shell scripts.

- Do not use tab characters, i.e. configure your editor to use soft tabs. For instance, use `(setq-default indent-tabs-mode nil)` in Emacs. Everybody has different tab settings so it’s asking for trouble.

- Use `lowerCamelCase` for variable names, not `UpperCamelCase`. Note, this rule does not apply to package attribute names, which instead follow the rules in [package naming](./pkgs/README.md#package-naming).

- Function calls with attribute set arguments are written as

  ```nix
  foo {
    arg = <...>;
  }
  ```

  not

  ```nix
  foo
  {
    arg = <...>;
  }
  ```

  Also fine is

  ```nix
  foo { arg = <...>; }
  ```

  if it's a short call.

- In attribute sets or lists that span multiple lines, the attribute names or list elements should be aligned:

  ```nix
  {
    # A long list.
    list = [
      elem1
      elem2
      elem3
    ];

    # A long attribute set.
    attrs = {
      attr1 = short_expr;
      attr2 =
        if true then big_expr else big_expr;
    };

    # Combined
    listOfAttrs = [
      {
        attr1 = 3;
        attr2 = "fff";
      }
      {
        attr1 = 5;
        attr2 = "ggg";
      }
    ];
  }
  ```

- Short lists or attribute sets can be written on one line:

  ```nix
  {
    # A short list.
    list = [ elem1 elem2 elem3 ];

    # A short set.
    attrs = { x = 1280; y = 1024; };
  }
  ```

- Breaking in the middle of a function argument can give hard-to-read code, like

  ```nix
  someFunction { x = 1280;
    y = 1024; } otherArg
    yetAnotherArg
  ```

  (especially if the argument is very large, spanning multiple lines).

  Better:

  ```nix
  someFunction
    { x = 1280; y = 1024; }
    otherArg
    yetAnotherArg
  ```

  or

  ```nix
  let res = { x = 1280; y = 1024; };
  in someFunction res otherArg yetAnotherArg
  ```

- The bodies of functions, asserts, and withs are not indented to prevent a lot of superfluous indentation levels, i.e.

  ```nix
  { arg1, arg2 }:
  assert system == "i686-linux";
  stdenv.mkDerivation { /* ... */ }
  ```

  not

  ```nix
  { arg1, arg2 }:
    assert system == "i686-linux";
      stdenv.mkDerivation { /* ... */ }
  ```

- Function formal arguments are written as:

  ```nix
  { arg1, arg2, arg3 }: { /* ... */ }
  ```

  but if they don't fit on one line they're written as:

  ```nix
  { arg1, arg2, arg3
  , arg4
  # Some comment...
  ,  argN
  }: { }
  ```

- Functions should list their expected arguments as precisely as possible. That is, write

  ```nix
  { stdenv, fetchurl, perl }: <...>
  ```

  instead of

  ```nix
  args: with args; <...>
  ```

  or

  ```nix
  { stdenv, fetchurl, perl, ... }: <...>
  ```

  For functions that are truly generic in the number of arguments (such as wrappers around `mkDerivation`) that have some required arguments, you should write them using an `@`-pattern:

  ```nix
  { stdenv, doCoverageAnalysis ? false, ... } @ args:

  stdenv.mkDerivation (args // {
    foo = if doCoverageAnalysis then "bla" else "";
  })
  ```

  instead of

  ```nix
  args:

  args.stdenv.mkDerivation (args // {
    foo = if args ? doCoverageAnalysis && args.doCoverageAnalysis then "bla" else "";
  })
  ```

- Unnecessary string conversions should be avoided. Do

  ```nix
  {
    rev = version;
  }
  ```

  instead of

  ```nix
  {
    rev = "${version}";
  }
  ```

- Building lists conditionally _should_ be done with `lib.optional(s)` instead of using `if cond then [ ... ] else null` or `if cond then [ ... ] else [ ]`.

  ```nix
  {
    buildInputs = lib.optional stdenv.isDarwin iconv;
  }
  ```

  instead of

  ```nix
  {
    buildInputs = if stdenv.isDarwin then [ iconv ] else null;
  }
  ```

  As an exception, an explicit conditional expression with null can be used when fixing a important bug without triggering a mass rebuild.
  If this is done a follow up pull request _should_ be created to change the code to `lib.optional(s)`.
