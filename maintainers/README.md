# Nixpkgs Maintainers

Unlike other packaging ecosystems, the maintainer doesn't have exclusive control over the packages and modules they maintain.
This more fluid approach is one reason why we scale to so many packages.

## Definition and role of the maintainer

The main responsibility of a maintainer is to keep the packages they maintain in a functioning state, and keep up with updates.
In order to do that, they are empowered to make decisions over the packages they maintain.

That being said, the maintainer is not alone proposing changes to the packages.
Anybody (both bots and humans) can send PRs to bump or tweak the package.

We also allow other non-maintainer committers to merge changes to the package, provided enough time and priority has been given to the maintainer.

For most packages, we expect committers to wait at least a week before merging changes not endorsed by a package maintainer (which may be themselves).
This should leave enough time for the maintainers to provide feedback.

For critical packages, this convention needs to be negotiated with the maintainer.
A critical package is one that causes mass-rebuild, or where an author is listed in the [`OWNERS`](../ci/OWNERS) file.

In case of critical security updates, the [security team](https://nixos.org/community/teams/security) might override these heuristics in order to get the fixes in as fast as possible.

In case of conflict, the maintainer takes priority and is allowed to revert the changes.
This can happen for example if the maintainer was on holiday.

### How to become a maintainer

We encourage people who care about a package to assign themselves as a maintainer.
Commit access to the Nixpkgs repository is not required for that.

In order to do so, add yourself to the [`maintainer-list.nix`](./maintainer-list.nix), and then to the desired package's `meta.maintainers` list, and send a PR with the changes.

If you're adding yourself as a maintainer as part of another PR (in which you become a maintainer of a package, for example), make your change to
`maintainer-list.nix` in a separate commit titled `maintainers: add <name>`.

### How to lose maintainer status

Maintainers who have become inactive on a given package can be removed.
This helps us keep an accurate view of the state of maintenance in Nixpkgs.

The inactivity measure is currently not strictly enforced.
We would typically look at it if we notice that the author hasn't reacted to package-related notifications for more than 3 months.

Removing the maintainer happens by making a PR on the package, adding that person as a reviewer, and then waiting a week for a reaction.

The maintainer is welcome to come back at any time.

## Tools for maintainers

When a pull request is made against a package, nixpkgs CI will notify the appropriate maintainer(s) by trying to correlate the files the PR touches with the packages that need rebuilding.
This process is subject to error however, so we encourage PR authors to notify the appropriate people.

Maintainers can also invoke the [nixpkgs-merge-bot](https://github.com/nixos/nixpkgs-merge-bot) to merge pull requests targeting packages they are the maintainer of, which satisfy the current security [constraints](https://github.com/NixOS/nixpkgs-merge-bot/blob/main/README.md#constraints).
Examples: [#397273](https://github.com/NixOS/nixpkgs/pull/397273#issuecomment-2789382120) and [#377027](https://github.com/NixOS/nixpkgs/pull/377027#issuecomment-2614510869)

New maintainers will automatically get invited to join the [NixOS/nixpkgs-maintainers](https://github.com/orgs/NixOS/teams/nixpkgs-maintainers) GitHub team.
By joining, you will get some triaging rights in the nixpkgs repository, like the ability to close and reopen issues made by others, and managing labels.
However, the GitHub team invite is usually only sent by email, and is only valid for one week!
Should it expire, please ask for a re-invite in the [GitHub org owners help desk Matrix channel](https://matrix.to/#/#org_owners:nixos.org).

### Unofficial maintainer tooling

[zh.fail](https://zh.fail/failed/overview.html) tracks all package build failures on `master` grouped by maintainer.

[asymmetric/nixpkgs-update-notifier](https://github.com/asymmetric/nixpkgs-update-notifier) is a matrix bot that scrapes the [nixpkgs-update logs](https://nixpkgs-update-logs.nix-community.org/) and notifies you if nixpkgs-update/@r-ryantm fails to update any of the packages you've subscribed to.

[repology.org](https://repology.org) tracks and compares the versions of packages between various package repositories, letting you know what packages may be out of date or insecure.
You can view which packages a specific maintainer maintains and subscribe to updates with atom/rss.
Example: [repology.org/maintainer/pbsds](https://repology.org/maintainer/pbsds%40hotmail.com).

[nixpk.gs/pr-tracker](https://nixpk.gs/pr-tracker.html) and [nixpkgs-tracker.ocfox.me](https://nixpkgs-tracker.ocfox.me/) can visualize the release status of any nixpkgs pull request.

## Reviewing contributions

### Individual maintainer list

When adding users to [`maintainer-list.nix`](./maintainer-list.nix), the following checks should be performed:

- If the user has specified a GPG key, verify that the commit is signed by their key.

  First, validate that the commit adding the maintainer is signed by the key the maintainer listed.
  Check out the pull request and compare its signing key with the listed key in the commit.

  If the commit is not signed or it is signed by a different user, ask them to either recommit using that key or to remove their key information.

  Given a maintainer entry like this:

  ``` nix
  {
    example = {
      email = "user@example.com";
      name = "Example User";
      keys = [{
        fingerprint = "0000 0000 2A70 6423 0AED  3C11 F04F 7A19 AAA6 3AFE";
      }];
    };
  }
  ```

  First receive their key from a keyserver:

      $ gpg --recv-keys 0xF04F7A19AAA63AFE
      gpg: key 0xF04F7A19AAA63AFE: public key "Example <user@example.com>" imported
      gpg: Total number processed: 1
      gpg:               imported: 1

  Then check the commit is signed by that key:

      $ git log --show-signature
      commit b87862a4f7d32319b1de428adb6cdbdd3a960153
      gpg: Signature made Wed Mar 12 13:32:24 2003 +0000
      gpg:                using RSA key 000000002A7064230AED3C11F04F7A19AAA63AFE
      gpg: Good signature from "Example User <user@example.com>
      Author: Example User <user@example.com>
      Date:   Wed Mar 12 13:32:24 2003 +0000

          maintainers: adding example

  and validate that there is a `Good signature` and the printed key matches the user's submitted key.

  Note: GitHub's "Verified" label does not display the user's full key fingerprint, and should not be used for validating the key matches.

- If the user has specified a `github` account name, ensure they have also specified a `githubId` and verify the two match.

  Maintainer entries that include a `github` field must also include their `githubId`.
  People can and do change their GitHub name frequently, and the ID is used as the official and stable identity of the maintainer.

  Given a maintainer entry like this:

  ``` nix
  {
    example = {
      email = "user@example.com";
      name = "Example User";
      github = "ghost";
      githubId = 10137;
    };
  }
  ```

  First, make sure that the listed GitHub handle matches the author of the commit.

  Then, visit the URL `https://api.github.com/users/ghost` and validate that the `id` field matches the provided `githubId`.

### Maintainer teams

Feel free to create a new maintainer team in [`team-list.nix`](./team-list.nix) when a group is collectively responsible for a collection of packages.
Use taste and personal judgement when deciding if a team is warranted.

Teams are allowed to define their own rules about membership.

For example, some teams will represent a business or other group which wants to carefully track its members.
Other teams may be very open about who can join, and allow anybody to participate.

When reviewing changes to a team, read the team's scope and the context around the member list for indications about the team's membership policy.

In any case, request reviews from the existing team members.
If the team lists no specific membership policy, feel free to merge changes to the team after giving the existing members a few days to respond.

*Important:* If a team says it is a closed group, do not merge additions to the team without an approval by at least one existing member.


# Maintainer scripts

Various utility scripts, which are mainly useful for nixpkgs maintainers, are available under `./scripts/`.
See its [README](./scripts/README.md) for further information.

# nixpkgs-merge-bot

To streamline autoupdates, leverage the nixpkgs-merge-bot by commenting `@NixOS/nixpkgs-merge-bot merge` if the package resides in pkgs-by-name, the commenter is among the package maintainers, and the pull request author is @r-ryantm or a Nixpkgs committer.
The bot ensures that all ofborg checks, except for darwin, are successfully completed before merging the pull request.
Should the checks still be underway, the bot patiently waits for ofborg to finish before attempting the merge again.

# Guidelines for Committers

When merging pull requests, care must be taken to reduce impact to the `master` branch.
If a commit breaks evaluation, it will affect Ofborg evaluation results in other pull requests and block Hydra CI, thus introducing chaos to our workflow.

One approach to avoid merging such problematic changes is to wait for successful Ofborg evaluation.
Additionally, using tools like [nixpkgs-review](https://github.com/Mic92/nixpkgs-review) can help spot issues early, before Ofborg finishes evaluation.

## Breaking changes

In general breaking changes to `master` and `staging` branches are permitted, as long as they are documented in the release notes.
Though restrictions might apply towards the end of a NixOS release cycle, due to our feature freeze mechanism.
This is to avoid large-scale breakages shortly before and during a Zero Hydra Failures (ZHF) campaign.
These restrictions also intend to decrease the likelihood of a delayed NixOS release.
The feature freeze period is documented in the announcement of each release schedule.

> These are some example changes and if they are considered a breaking change during a freeze period:
>
> - `foo: 1.2.3 -> 1.2.4`:
>   Assuming this package follows semantic versioning and none of its dependent packages fail to build because of this change, it can be safely merged.
>   Otherwise, if it can be confirmed that there is no major change in its functionality or API, but only adding new features or fixing bugs, it can also be merged.
> - `unmaintained-software: drop`:
>   If this PR removes a leaf package or the removal doesn't otherwise break other packages, it can be merged.
> - `cool-tool: rename from fancy-tool`:
>   As long as this PR replaces all references to the old attribute name with the new name and adds an alias, it can be merged.
> - `libpopular: 4.3.2 -> 5.0.0`:
>   If this PR would trigger many rebuilds and/or target `staging`, it should probably be delayed until after the freeze-period is over.
>   Alternatively, if this PR is for a popular package and doesn't cause many rebuilds, it should also be delayed to reduce risk of breakage.
>   If a PR includes important changes, such as security fixes, it should be brought up to release managers.
> - `nixos/transmission: refactor`:
>   If this PR adjusts the type, default value or effect of options in the NixOS module, so that users must rewrite their configuration to keep the current behavior unchanged, it should not be merged, as we don't have enough time to collect user feedback and avoid possible breakage.
>   However, it should be accepted if the current behavior is considered broken and is fixed by the PR.
