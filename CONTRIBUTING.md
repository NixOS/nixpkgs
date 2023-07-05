# How to contribute

Note: contributing implies licensing those contributions
under the terms of [COPYING](COPYING), which is an MIT-like license.

## Opening issues

* Make sure you have a [GitHub account](https://github.com/signup/free)
* Make sure there is no open issue on the topic
* [Submit a new issue](https://github.com/NixOS/nixpkgs/issues/new/choose) by choosing the kind of topic and fill out the template

## Submitting changes

Read the ["Submitting changes"](https://nixos.org/nixpkgs/manual/#chap-submitting-changes) section of the nixpkgs manual. It explains how to write, test, and iterate on your change, and which branch to base your pull request against.

Below is a short excerpt of some points in there:

* Format the commit messages in the following way:

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

* `meta.description` should:
  * Be short, just one sentence.
  * Be capitalized.
  * Not start with the package name.
    * More generally, it should not refer to the package name.
  * Not end with a period (or any punctuation for that matter).
  * Aim to inform while avoiding subjective language.
* `meta.license` must be set and fit the upstream license.
  * If there is no upstream license, `meta.license` should default to `lib.licenses.unfree`.
  * If in doubt, try to contact the upstream developers for clarification.
* `meta.maintainers` must be set.

See the nixpkgs manual for more details on [standard meta-attributes](https://nixos.org/nixpkgs/manual/#sec-standard-meta-attributes).

## Writing good commit messages

In addition to writing properly formatted commit messages, it's important to include relevant information so other developers can later understand *why* a change was made. While this information usually can be found by digging code, mailing list/Discourse archives, pull request discussions or upstream changes, it may require a lot of work.

Package version upgrades usually allow for simpler commit messages, including attribute name, old and new version, as well as a reference to the relevant release notes/changelog. Every once in a while a package upgrade requires more extensive changes, and that subsequently warrants a more verbose message.

Pull requests should not be squash merged in order to keep complete commit messages and GPG signatures intact and must not be when the change doesn't make sense as a single commit.
This means that, when addressing review comments in order to keep the pull request in an always mergeable status, you will sometimes need to rewrite your branch's history and then force-push it with `git push --force-with-lease`.
Useful git commands that can help a lot with this are `git commit --patch --amend` and `git rebase --interactive`. For more details consult the git man pages or online resources like [git-rebase.io](https://git-rebase.io/) or [The Pro Git Book](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History).

## Testing changes

To run the main types of tests locally:

- Run package-internal tests with `nix-build --attr pkgs.PACKAGE.passthru.tests`
- Run [NixOS tests](https://nixos.org/manual/nixos/unstable/#sec-nixos-tests) with `nix-build --attr nixosTest.NAME`, where `NAME` is the name of the test listed in `nixos/tests/all-tests.nix`
- Run [global package tests](https://nixos.org/manual/nixpkgs/unstable/#sec-package-tests) with `nix-build --attr tests.PACKAGE`, where `PACKAGE` is the name of the test listed in `pkgs/test/default.nix`
- See `lib/tests/NAME.nix` for instructions on running specific library tests

## Rebasing between branches (i.e. from master to staging)

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

### Something went wrong and a lot of people were pinged

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

## Backporting changes

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

## Criteria for Backporting changes

Anything that does not cause user or downstream dependency regressions can be backported. This includes:
- New Packages / Modules
- Security / Patch updates
- Version updates which include new functionality (but no breaking changes)
- Services which require a client to be up-to-date regardless. (E.g. `spotify`, `steam`, or `discord`)
- Security critical applications (E.g. `firefox`)

## Reviewing contributions

See the nixpkgs manual for more details on how to [Review contributions](https://nixos.org/nixpkgs/manual/#chap-reviewing-contributions).
