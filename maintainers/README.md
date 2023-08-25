# Nixpkgs Maintainers

The *Nixpkgs maintainers* are people who have assigned themselves to
maintain specific individual packages. We encourage people who care
about a package to assign themselves as a maintainer. When a pull
request is made against a package, OfBorg will notify the appropriate
maintainer(s).

## Reviewing contributions

### Individual maintainer list

When adding users to [`maintainer-list.nix`](./maintainer-list.nix), the following
checks should be performed:

- If the user has specified a GPG key, verify that the commit is
  signed by their key.

  First, validate that the commit adding the maintainer is signed by
  the key the maintainer listed. Check out the pull request and
  compare its signing key with the listed key in the commit.

  If the commit is not signed or it is signed by a different user, ask
  them to either recommit using that key or to remove their key
  information.

  Given a maintainer entry like this:

  ``` nix
  {
    example = {
      email = "user@example.com";
      name = "Example User";
      keys = [{
        fingerprint = "0000 0000 2A70 6423 0AED  3C11 F04F 7A19 AAA6 3AFE";
      }];
    }
  };
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

  and validate that there is a `Good signature` and the printed key
  matches the user's submitted key.

  Note: GitHub's "Verified" label does not display the user's full key
  fingerprint, and should not be used for validating the key matches.

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
    }
  };
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
