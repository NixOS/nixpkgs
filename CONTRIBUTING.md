# Contributing to Nixpkgs

This document is for people wanting to contribute to the implementation of Nixpkgs.
This involves interacting with implementation changes that are proposed using [GitHub](https://github.com/) [pull requests](https://docs.github.com/pull-requests) to the [Nixpkgs](https://github.com/nixos/nixpkgs/) repository (which you're in right now).

As such, a GitHub account is required, which you can sign up for [here](https://github.com/signup).
Additionally this document assumes that you already know how to use GitHub and Git.
If that's not the case, we recommend learning about it first [here](https://docs.github.com/en/get-started/quickstart/hello-world).

## Overview

This file contains general contributing information, but individual parts also have more specific information to them in their respective `README.md` files, linked here:
- [`lib`](./lib): Sources and documentation of the [library functions](https://nixos.org/manual/nixpkgs/stable/#chap-functions)
- [`maintainers`](./maintainers): Nixpkgs maintainer and team listings, maintainer scripts
- [`pkgs`](./pkgs): Package and [builder](https://nixos.org/manual/nixpkgs/stable/#part-builders) definitions
- [`doc`](./doc): Sources and infrastructure for the [Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/)
- [`nixos`](./nixos): Implementation of [NixOS](https://nixos.org/manual/nixos/stable/)

## How to propose a change

This section describes in some detail how changes can be made and proposed with pull requests.

> **Note**
> Be aware that contributing implies licensing those contributions under the terms of [COPYING](./COPYING), an MIT-like license.

0. Set up a local version of Nixpkgs to work with using GitHub and Git
   1. [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo#forking-a-repository) the [Nixpkgs repository](https://github.com/nixos/nixpkgs/).
   1. [Clone the forked repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo#cloning-your-forked-repository) into a local `nixpkgs` directory.
   1. [Configure the upstream Nixpkgs repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo#configuring-git-to-sync-your-fork-with-the-upstream-repository).

1. Create and switch to a new Git branch, ideally such that:
   - The name of the branch hints at the change you'd like to implement, e.g. `update-hello`.
   - The base of the branch includes the most recent changes on the `master` branch.
     > **Note**
     > Depending on the change you may want to use a different branch, see <!-- TODO link to branch section -->

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

2. Make the desired changes in the local Nixpkgs repository using an editor of your choice.
   Make sure to:
   - Adhere to both the [general code conventions](#code-conventions), and the code conventions specific to the part you're making changes to.
     See the [overview section](#overview) for more specific information.
   - Test the changes.
     See the [overview section](#overview) for more specific information.
   - If necessary, document the change.
     See the [overview section](#overview) for more specific information.

3. Commit your changes using `git commit`.
   Make sure to adhere to the [commit conventions](#commit-conventions).

   Repeat the steps 2 and 3 as many times as necessary.
   Advance to the next step if all the commits (viewable with `git log`) make sense together.

4. Push your commits to your fork of Nixpkgs.
   ```
   git push --set-upstream origin HEAD
   ```

   The above command will output a link that allows you to directly quickly do the next step:
   ```
   remote: Create a pull request for 'update-hello' on GitHub by visiting:
   remote:      https://github.com/myUser/nixpkgs/pull/new/update-hello
   ```

5. [Create a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request#creating-the-pull-request) from the new branch in your Nixpkgs fork to the upstream Nixpkgs repository.
   Generally you should use `master` as the pull requests base branch.
   See <!-- TODO branch section link --> for when a different branch should be used instead.
   Make sure to go through the [pull request template](#pull-request-template) in the pre-filled default description.

6. Respond to review comments, potential CI failures and potential merge conflicts by updating the pull request.
   Always keep the pull request in a mergeable state.

   To add new commits, repeat steps 2-3 and push the result using
   ```
   git push
   ```

   To change existing commits you will have to [rewrite Git history](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History).
   Useful Git commands that can help a lot with this are `git commit --patch --amend` and `git rebase --interactive`.
   With a rewritten history you need to force-push the commits using
   ```
   git push --force-with-lease
   ```

   In case of merge conflicts you will also have to [rebasing the branch](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) on top of current `master`.
   Sometimes this can be done [on GitHub directly](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/keeping-your-pull-request-in-sync-with-the-base-branch#updating-your-pull-request-branch), but if not you will have to rebase locally using
   ```
   git fetch upstream
   git rebase upstream/master
   git push --force-with-lease
   ```

## (Flow of changes) | Commit policy {#submitting-changes-commit-policy}

Most contributions are based on and merged into these branches:

* `master` is the main branch where all small contributions go
* `staging` is branched from master, changes that have a big impact on
  Hydra builds go to this branch
* `staging-next` is branched from staging and only fixes to stabilize
  and security fixes with a big impact on Hydra builds should be
  contributed to this branch. This branch is merged into master when
  deemed of sufficiently high quality

- Commits must be sufficiently tested before being merged, both for the master and staging branches.
- Hydra builds for master and staging should not be used as testing platform, it’s a build farm for changes that have been already tested.
- When changing the bootloader installation process, extra care must be taken. Grub installations cannot be rolled back, hence changes may break people’s installations forever. For any non-trivial change to the bootloader please file a PR asking for review, especially from \@edolstra.

### Branches {#submitting-changes-branches}

The `nixpkgs` repository has three major branches:
- `master`
- `staging`
- `staging-next`

The most important distinction between them is that `staging`
(colored red in the diagram below) can receive commits which cause
a mass-rebuild (for example, anything that changes the `drvPath` of
`stdenv`).  The other two branches `staging-next` and `master`
(colored green in the diagram below) can *not* receive commits which
cause a mass-rebuild.

Arcs between the branches show possible merges into these branches,
either from other branches or from independently submitted PRs.  The
colors of these edges likewise show whether or not they could
trigger a mass rebuild (red) or must not trigger a mass rebuild
(green).

Hydra runs automatic builds for the green branches.

Notice that the automatic merges are all green arrows.  This is by
design.  Any merge which might cause a mass rebuild on a branch
which has automatic builds (`staging-next`, `master`) will be a
manual merge to make sure it is good use of compute power.

Nixpkgs has two branches so that there is one branch (`staging`)
which accepts mass-rebuilding commits, and one fast-rebuilding
branch which accepts independent PRs (`master`).  The `staging-next`
branch allows the Hydra operators to batch groups of commits to
`staging` to be built.  By keeping the `staging-next` branch
separate from `staging`, this batching does not block
developers from merging changes into `staging`.

```{.graphviz caption="Staging workflow"}
digraph {
    master [color="green" fontcolor=green]
    "staging-next" [color="green" fontcolor=green]
    staging [color="red" fontcolor=red]

    "small changes" [fontcolor=green shape=none]
    "small changes" -> master [color=green]

    "mass-rebuilds and other large changes" [fontcolor=red shape=none]
    "mass-rebuilds and other large changes" -> staging [color=red]

    "critical security fixes" [fontcolor=green shape=none]
    "critical security fixes" -> master [color=green]

    "staging fixes which do not cause staging to mass-rebuild" [fontcolor=green shape=none]
    "staging fixes which do not cause staging to mass-rebuild" -> "staging-next" [color=green]

    "staging-next" -> master [color="red"] [label="manual merge"] [fontcolor="red"]
    "staging" -> "staging-next" [color="red"] [label="manual merge"] [fontcolor="red"]

    master -> "staging-next" [color="green"] [label="automatic merge (GitHub Action)"] [fontcolor="green"]
    "staging-next" -> staging [color="green"] [label="automatic merge (GitHub Action)"] [fontcolor="green"]
}
```

[This GitHub Action](https://github.com/NixOS/nixpkgs/blob/master/.github/workflows/periodic-merge-6h.yml) brings changes from `master` to `staging-next` and from `staging-next` to `staging` every 6 hours; these are the green arrows in the diagram above.  The red arrows in the diagram above are done manually and much less frequently.  You can get an idea of how often these merges occur by looking at the git history.


#### Master branch {#submitting-changes-master-branch}

The `master` branch is the main development branch. It should only see non-breaking commits that do not cause mass rebuilds.

#### Staging branch {#submitting-changes-staging-branch}

The `staging` branch is a development branch where mass-rebuilds go. Mass rebuilds are commits that cause rebuilds for many packages, like more than 500 (or perhaps, if it's 'light' packages, 1000). It should only see non-breaking mass-rebuild commits. That means it is not to be used for testing, and changes must have been well tested already. If the branch is already in a broken state, please refrain from adding extra new breakages.

During the process of a releasing a new NixOS version, this branch or the release-critical packages can be restricted to non-breaking changes.

#### Staging-next branch {#submitting-changes-staging-next-branch}

The `staging-next` branch is for stabilizing mass-rebuilds submitted to the `staging` branch prior to merging them into `master`. Mass-rebuilds must go via the `staging` branch. It must only see non-breaking commits that are fixing issues blocking it from being merged into the `master` branch.

If the branch is already in a broken state, please refrain from adding extra new breakages. Stabilize it for a few days and then merge into master.

During the process of a releasing a new NixOS version, this branch or the release-critical packages can be restricted to non-breaking changes.

#### Stable release branches {#submitting-changes-stable-release-branches}

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

#### Rebasing between branches (i.e. from master to staging)

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

##### Something went wrong and a lot of people were pinged

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

### Backporting changes

Follow these steps to backport a change into a release branch in compliance with the [commit policy](https://nixos.org/nixpkgs/manual/#submitting-changes-stable-release-branches).

You can add a label such as `backport release-23.05` to a PR, so that merging it will
automatically create a backport (via [a GitHub Action](.github/workflows/backport.yml)).
This also works for pull requests that have already been merged, and might take a couple of minutes to trigger.

You can also create the backport manually:

1. Take note of the commits in which the change was introduced into `master` branch.
2. Check out the target _release branch_, e.g. `release-23.05`. Do not use a _channel branch_ like `nixos-23.05` or `nixpkgs-23.05-darwin`.
3. Create a branch for your change, e.g. `git checkout -b backport`.
4. When the reason to backport is not obvious from the original commit message, use `git cherry-pick -xe <original commit>` and add a reason. Otherwise use `git cherry-pick -x <original commit>`. That's fine for minor version updates that only include security and bug fixes, commits that fixes an otherwise broken package or similar. Please also ensure the commits exists on the master branch; in the case of squashed or rebased merges, the commit hash will change and the new commits can be found in the merge message at the bottom of the master pull request.
5. Push to GitHub and open a backport pull request. Make sure to select the release branch (e.g. `release-23.05`) as the target branch of the pull request, and link to the pull request in which the original change was committed to `master`. The pull request title should be the commit title with the release version as prefix, e.g. `[23.05]`.
6. When the backport pull request is merged and you have the necessary privileges you can also replace the label `9.needs: port to stable` with `8.has: port to stable` on the original pull request. This way maintainers can keep track of missing backports easier.

#### Criteria for Backporting changes

Anything that does not cause user or downstream dependency regressions can be backported. This includes:
- New Packages / Modules
- Security / Patch updates
- Version updates which include new functionality (but no breaking changes)
- Services which require a client to be up-to-date regardless. (E.g. `spotify`, `steam`, or `discord`)
- Security critical applications (E.g. `firefox`)

### Hotfixing pull requests {#submitting-changes-hotfixing-pull-requests}

- Make the appropriate changes in you branch.
- Don’t create additional commits, do
  - `git rebase -i`
  - `git push --force` to your branch.

## Reviewing contributions {#chap-reviewing-contributions}

::: {.warning}
The following section is a draft, and the policy for reviewing is still being discussed in issues such as [#11166](https://github.com/NixOS/nixpkgs/issues/11166) and [#20836](https://github.com/NixOS/nixpkgs/issues/20836).
:::

The Nixpkgs project receives a fairly high number of contributions via GitHub pull requests. Reviewing and approving these is an important task and a way to contribute to the project.

The high change rate of Nixpkgs makes any pull request that remains open for too long subject to conflicts that will require extra work from the submitter or the merger. Reviewing pull requests in a timely manner and being responsive to the comments is the key to avoid this issue. GitHub provides sort filters that can be used to see the [most recently](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+sort%3Aupdated-desc) and the [least recently](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+sort%3Aupdated-asc) updated pull requests. We highly encourage looking at [this list of ready to merge, unreviewed pull requests](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+review%3Anone+status%3Asuccess+-label%3A%222.status%3A+work-in-progress%22+no%3Aproject+no%3Aassignee+no%3Amilestone).

When reviewing a pull request, please always be nice and polite. Controversial changes can lead to controversial opinions, but it is important to respect every community member and their work.

GitHub provides reactions as a simple and quick way to provide feedback to pull requests or any comments. The thumb-down reaction should be used with care and if possible accompanied with some explanation so the submitter has directions to improve their contribution.

Pull request reviews should include a list of what has been reviewed in a comment, so other reviewers and mergers can know the state of the review.

All the review template samples provided in this section are generic and meant as examples. Their usage is optional and the reviewer is free to adapt them to their liking.

### Other submissions {#reviewing-contributions-other-submissions}

Other type of submissions requires different reviewing steps.

If you consider having enough knowledge and experience in a topic and would like to be a long-term reviewer for related submissions, please contact the current reviewers for that topic. They will give you information about the reviewing process. The main reviewers for a topic can be hard to find as there is no list, but checking past pull requests to see who reviewed or git-blaming the code to see who committed to that topic can give some hints.

Container system, boot system and library changes are some examples of the pull requests fitting this category.

## (Merging a pull request) | Merging pull requests {#reviewing-contributions--merging-pull-requests}

The *Nixpkgs committers* are people who have been given
permission to merge.

It is possible for community members that have enough knowledge and experience on a special topic to contribute by merging pull requests.

In case the PR is stuck waiting for the original author to apply a trivial
change (a typo, capitalisation change, etc.) and the author allowed the members
to modify the PR, consider applying it yourself. (or commit the existing review
suggestion) You should pay extra attention to make sure the addition doesn't go
against the idea of the original PR and would not be opposed by the author.

<!--
The following paragraphs about how to deal with unactive contributors is just a proposition and should be modified to what the community agrees to be the right policy.

Please note that contributors with commit rights unactive for more than three months will have their commit rights revoked.
-->

Please see the discussion in [GitHub nixpkgs issue #50105](https://github.com/NixOS/nixpkgs/issues/50105) for information on how to proceed to be granted this level of access.

In a case a contributor definitively leaves the Nix community, they should create an issue or post on [Discourse](https://discourse.nixos.org) with references of packages and modules they maintain so the maintainership can be taken over by other contributors.


## Code conventions

### Release notes

If you removed pkgs or made some major NixOS changes, write about it in the release notes for the next stable release. For example `nixos/doc/manual/release-notes/rl-2003.xml`.

### File naming and organisation {#sec-organisation}

Names of files and directories should be in lowercase, with dashes between words — not in camel case. For instance, it should be `all-packages.nix`, not `allPackages.nix` or `AllPackages.nix`.

### Syntax {#sec-syntax}

- Use 2 spaces of indentation per indentation level in Nix expressions, 4 spaces in shell scripts.

- Do not use tab characters, i.e. configure your editor to use soft tabs. For instance, use `(setq-default indent-tabs-mode nil)` in Emacs. Everybody has different tab settings so it’s asking for trouble.

- Use `lowerCamelCase` for variable names, not `UpperCamelCase`. Note, this rule does not apply to package attribute names, which instead follow the rules in [](#sec-package-naming).

- Function calls with attribute set arguments are written as

  ```nix
  foo {
    arg = ...;
  }
  ```

  not

  ```nix
  foo
  {
    arg = ...;
  }
  ```

  Also fine is

  ```nix
  foo { arg = ...; }
  ```

  if it's a short call.

- In attribute sets or lists that span multiple lines, the attribute names or list elements should be aligned:

  ```nix
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
  ```

- Short lists or attribute sets can be written on one line:

  ```nix
  # A short list.
  list = [ elem1 elem2 elem3 ];

  # A short set.
  attrs = { x = 1280; y = 1024; };
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
  stdenv.mkDerivation { ...
  ```

  not

  ```nix
  { arg1, arg2 }:
    assert system == "i686-linux";
      stdenv.mkDerivation { ...
  ```

- Function formal arguments are written as:

  ```nix
  { arg1, arg2, arg3 }:
  ```

  but if they don't fit on one line they're written as:

  ```nix
  { arg1, arg2, arg3
  , arg4, ...
  , # Some comment...
    argN
  }:
  ```

- Functions should list their expected arguments as precisely as possible. That is, write

  ```nix
  { stdenv, fetchurl, perl }: ...
  ```

  instead of

  ```nix
  args: with args; ...
  ```

  or

  ```nix
  { stdenv, fetchurl, perl, ... }: ...
  ```

  For functions that are truly generic in the number of arguments (such as wrappers around `mkDerivation`) that have some required arguments, you should write them using an `@`-pattern:

  ```nix
  { stdenv, doCoverageAnalysis ? false, ... } @ args:

  stdenv.mkDerivation (args // {
    ... if doCoverageAnalysis then "bla" else "" ...
  })
  ```

  instead of

  ```nix
  args:

  args.stdenv.mkDerivation (args // {
    ... if args ? doCoverageAnalysis && args.doCoverageAnalysis then "bla" else "" ...
  })
  ```

- Unnecessary string conversions should be avoided. Do

  ```nix
  rev = version;
  ```

  instead of

  ```nix
  rev = "${version}";
  ```

- Building lists conditionally _should_ be done with `lib.optional(s)` instead of using `if cond then [ ... ] else null` or `if cond then [ ... ] else [ ]`.

  ```nix
  buildInputs = lib.optional stdenv.isDarwin iconv;
  ```

  instead of

  ```nix
  buildInputs = if stdenv.isDarwin then [ iconv ] else null;
  ```

  As an exception, an explicit conditional expression with null can be used when fixing a important bug without triggering a mass rebuild.
  If this is done a follow up pull request _should_ be created to change the code to `lib.optional(s)`.

- Arguments should be listed in the order they are used, with the exception of `lib`, which always goes first.

## Commit conventions

- Create a commit for each logical unit.

- Check for unnecessary whitespace with `git diff --check` before committing.

- If you have commits `pkg-name: oh, forgot to insert whitespace`: squash commits in this case. Use `git rebase -i`.

- Format the commit messages in the following way:

  ```
  (pkg-name | nixos/<module>): (from -> to | init at version | refactor | etc)

  (Motivation for change. Link to release notes. Additional information.)
  ```

  For consistency, there should not be a period at the end of the commit message's summary line (the first line of the commit message).

  Examples:

  * nginx: init at 2.0.1
  * firefox: 54.0.1 -> 55.0

    https://www.mozilla.org/en-US/firefox/55.0/releasenotes/
  * nixos/hydra: add bazBaz option

    Dual baz behavior is needed to do foo.
  * nixos/nginx: refactor config generation

    The old config generation system used impure shell scripts and could break in specific circumstances (see #1234).

### Writing good commit messages

In addition to writing properly formatted commit messages, it's important to include relevant information so other developers can later understand *why* a change was made. While this information usually can be found by digging code, mailing list/Discourse archives, pull request discussions or upstream changes, it may require a lot of work.

Package version upgrades usually allow for simpler commit messages, including attribute name, old and new version, as well as a reference to the relevant release notes/changelog. Every once in a while a package upgrade requires more extensive changes, and that subsequently warrants a more verbose message.

Pull requests should not be squash merged in order to keep complete commit messages and GPG signatures intact and must not be when the change doesn't make sense as a single commit.

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
