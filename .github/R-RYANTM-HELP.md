# Help! r-ryantm bumped one of my contributions.

_It's a good thing: r-ryantm is a bot that helps keeping [nixpkgs (one of) the most up-to-date repositories](https://repology.org/repositories/graphs)._


## Manual Cross-Check

- If you havn't submitted automated tests, yet, please take a moment and follow the bot's instructions on how to test.
- Once you've tested successfully, please report what you did as a simple
  [GitHub review](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/reviewing-proposed-changes-in-a-pull-request),
  similar to the text below.

```markdown
LGTM.

<!-- say briefly what you checked -->

- [x] built locally on `<my exotic unix>`
- [x] checked `./bin/<cmd> --help`
```

## Automated Cross-Check

- In the future, the r-ryantm _might_ gain the capability of auto-merging updates, if tests are available and they pass.
- So please consider adding automated tests to your packages.
- Those tests also free you from the need to do the Manual Cross-Check above.

TODO: put examples here for how to add:
- _The tests defined in passthru.tests , if any, passed_
- _0 of 0 passed binary check by having a zero exit code._
- _0 of 0 passed binary check by having the new version present in output._

_Note, that `nixpkgs-update` doesn’t do anything with [`updateWalker`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/upstream-updater/update-walker.txt)
nor does it currently interfere with [other update tooling](https://github.com/ryantm/nixpkgs-update/issues/12)._

## Useful GithHub Label Queries

- [Open PRs from r-ryantm](https://github.com/NixOS/nixpkgs/pulls/r-ryantm)
- [Open PRs NOT from r-ryantm](https://github.com/NixOS/nixpkgs/pulls?q=is%3Aopen+is%3Apr+-author%3Ar-ryantm+)

**Merging**

- Maintainers shall merge the PR at their best judgement, i.e. if it is ensured that nothing is broken.

---

<sub>In case this document is outdated, please help us update it with your drive-by contribution. Thanks!</sub>
