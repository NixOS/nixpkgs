# Nixpkgs Maintainers

Unlike other packaging ecosystems, the maintainer doesn't have exclusive
control over the packages and modules they maintain. This more fluid approach
is one reason why we scale to so many packages.

## Definition and role of the maintainer

The main responsibility of a maintainer is to keep the packages they maintain
in a functioning state, and keep up with updates. In order to do that, they
are empowered to make decisions over the packages they maintain.

That being said, the maintainer is not alone proposing changes to the
packages. Anybody (both bots and humans) can send PRs to bump or tweak the
package.

We also allow other non-maintainer committers to merge changes to the package,
provided enough time and priority has been given to the maintainer.

For most packages, we expect committers to wait at least a week before merging
changes not endorsed by a package maintainer (which may be themselves). This should leave enough time
for the maintainers to provide feedback.

For critical packages, this convention needs to be negotiated with the
maintainer. A critical package is one that causes mass-rebuild, or where an
author is listed in the [`CODEOWNERS`](../.github/CODEOWNERS) file.

In case of critical security updates, the [security team](https://nixos.org/community/teams/security) might override these
heuristics in order to get the fixes in as fast as possible.

In case of conflict, the maintainer takes priority and is allowed to revert
the changes. This can happen for example if the maintainer was on holiday.

### How to become a maintainer

We encourage people who care about a package to assign themselves as a
maintainer. Commit access to the Nixpkgs repository is not required for that.

In order to do so, add yourself to the
[`maintainer-list.nix`](./maintainer-list.nix), and then to the desired
package's `meta.maintainers` list, and send a PR with the changes.

### How to lose maintainer status

Maintainers who have become inactive on a given package can be removed. This
helps us keep an accurate view of the state of maintenance in Nixpkgs.

The inactivity measure is currently not strictly enforced. We would typically
look at it if we notice that the author hasn't reacted to package-related
notifications for more than 3 months.

Removing the maintainer happens by making a PR on the package, adding that
person as a reviewer, and then waiting a week for a reaction.

The maintainer is welcome to come back at any time.

### Tools for maintainers

When a pull request is made against a package, OfBorg will notify the
appropriate maintainer(s).

## Reviewing contributions

### Individual maintainer list

When adding users to [`maintainer-list.nix`](./maintainer-list.nix), the following
checks should be performed:

- If the user has specified a GPG key, verify that the commit is
  signed by their key.

  For example, with an entry as follows:

  ```nix
    SomeMaintainer = {
      name = "Some Maintainer";
      email = "some.maintainer@example.com";
      github = "some-maintainer";
      githubId = 1234567890;
      keys = [{
        fingerprint = "21E5 9F74 B993 9CAE 09E1  156A C894 8ADE 4250 5525";
      }];
    };
  ```

  First, import the users key into `gpg` based on their `lib.maintainers` entry:
  - If they [added the GPG to their GitHub account](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account),
    you can fetch it directly from GitHub based on their username:
    ```
    gpg --fetch-keys https://github.com/some-maintainer.gpg
    ```
  - If the user uploaded their key to a key server,
    you can search for it by the fingerprint:
    ```
    gpg --recv-keys 21E59F74B9939CAE09E1156AC8948ADE42505525
    ```
  - If the key is available using [WKD](https://wiki.gnupg.org/WKD),
    you can request it using their email:
    ```
    gpg --locate-key some.maintainer@example.com
    ```

  If successful, it should look like this:
  ```
  gpg: key C8948ADE42505525: public key "Some Maintainer <some.maintainer@example.com>" imported
  gpg: Total number processed: 1
  gpg:               imported: 1
  ```

  Then check that the commits signature is valid and matches the key:

  ```
  git log -1 --show-signature
  ```
  ```
  commit 5c67405e028f747b92664fe467b3b31bd3ec4110
  gpg: Signature made Fri 19 Apr 2024 07:16:32 AM CEST
  gpg:                using EDDSA key 21E59F74B9939CAE09E1156AC8948ADE42505525
  gpg: Good signature from "Some Maintainer <some.maintainer@example.com>" [unknown]
  Primary key fingerprint: 21E5 9F74 B993 9CAE 09E1  156A C894 8ADE 4250 5525
  Author: Some Maintainer <some.maintainer@example.com>
  Date:   Fri Apr 19 07:16:22 2024 +0200

      maintainers: add SomeMaintainer
  ```

  Note the `Good signature` and that the `Primary key fingerprint` matches the one from the maintainer entry.

  Alternatively if the user added the GPG to their GitHub account, GitHub also [verifies the signature](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification):

  ![](https://docs.github.com/assets/cb-17614/mw-1440/images/help/commits/verified-commit.webp)

  However, GitHub does not display the user's full key fingerprint,
  and should therefore not be used for validating the key matches.

  If the commit is not signed or it is signed by a different user, ask
  them to either recommit using that key or to remove their key
  information.

- If the user has specified a `github` account name, ensure they have
  also specified a `githubId` and verify the two match.

  Maintainer entries that include a `github` field must also include
  their `githubId`. People can and do change their GitHub name
  frequently, and the ID is used as the official and stable identity
  of the maintainer.

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

  First, make sure that the listed GitHub handle matches the author of
  the commit.

  Then, visit the URL `https://api.github.com/users/ghost` and
  validate that the `id` field matches the provided `githubId`.

### Maintainer teams

Feel free to create a new maintainer team in [`team-list.nix`](./team-list.nix)
when a group is collectively responsible for a collection of packages.
Use taste and personal judgement when deciding if a team is warranted.

Teams are allowed to define their own rules about membership.

For example, some teams will represent a business or other group which
wants to carefully track its members. Other teams may be very open about
who can join, and allow anybody to participate.

When reviewing changes to a team, read the team's scope and the context
around the member list for indications about the team's membership
policy.

In any case, request reviews from the existing team members. If the team
lists no specific membership policy, feel free to merge changes to the
team after giving the existing members a few days to respond.

*Important:* If a team says it is a closed group, do not merge additions
to the team without an approval by at least one existing member.


# Maintainer scripts

Various utility scripts, which are mainly useful for nixpkgs maintainers,
are available under `./scripts/`.  See its [README](./scripts/README.md)
for further information.
