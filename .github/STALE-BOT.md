# Stale bot information

- Thanks for your contribution!
- Our stale bot will never close an issue or PR.
- To remove the stale label, just leave a new comment.
- _How to find the right people to ping?_ &rarr; [`git blame`](https://git-scm.com/docs/git-blame) to the rescue! (or GitHub's history and blame buttons.)
- You can always ask for help on [our Discourse Forum](https://discourse.nixos.org/), [our Matrix room](https://matrix.to/#/#nix:nixos.org), or on the [#nixos IRC channel](https://web.libera.chat/#nixos).

## Suggestions for PRs

1. GitHub sometimes doesn't notify people who commented / reviewed a PR previously, when you (force) push commits. If you have addressed the reviews you can [officially ask for a review](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/requesting-a-pull-request-review) from those who commented to you or anyone else.
2. If it is unfinished but you plan to finish it, please mark it as a draft.
3. If you don't expect to work on it any time soon, closing it with a short comment may encourage someone else to pick up your work.
4. To get things rolling again, rebase the PR against the target branch and address valid comments.
5. If you need a review to move forward, ask in [the Discourse thread for PRs that need help](https://discourse.nixos.org/t/prs-in-distress/3604).
6. If all you need is a merge, check the git history to find and [request reviews](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/requesting-a-pull-request-review) from people who usually merge related contributions.

## Suggestions for issues

1. If it is resolved (either for you personally, or in general), please consider closing it.
2. If this might still be an issue, but you are not interested in promoting its resolution, please consider closing it while encouraging others to take over and reopen an issue if they care enough.
3. If you still have interest in resolving it, try to ping somebody who you believe might have an interest in the topic. Consider discussing the problem in [our Discourse Forum](https://discourse.nixos.org/).
4. As with all open source projects, your best option is to submit a Pull Request that addresses this issue. We :heart: this attitude!

**Memorandum on closing issues**

Don't be afraid to close an issue that holds valuable information. Closed issues stay in the system for people to search, read, cross-reference, or even reopen--nothing is lost! Closing obsolete issues is an important way to help maintainers focus their time and effort.

## Useful GitHub search queries

- [Open PRs with any stale-bot interaction](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+commenter%3Aapp%2Fstale+)
- [Open PRs with any stale-bot interaction and `2.status: stale`](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+commenter%3Aapp%2Fstale+label%3A%222.status%3A+stale%22)
- [Open PRs with any stale-bot interaction and NOT `2.status: stale`](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+commenter%3Aapp%2Fstale+-label%3A%222.status%3A+stale%22+)
- [Open Issues with any stale-bot interaction](https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+commenter%3Aapp%2Fstale+)
- [Open Issues with any stale-bot interaction and `2.status: stale`](https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+commenter%3Aapp%2Fstale+label%3A%222.status%3A+stale%22+)
- [Open Issues with any stale-bot interaction and NOT `2.status: stale`](https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+commenter%3Aapp%2Fstale+-label%3A%222.status%3A+stale%22+)
