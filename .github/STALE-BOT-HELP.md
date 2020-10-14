# Help! The stale-bot hit me.

- If you bother something being marked as stale, just leave a comment. No questions asked.
- _How to find the right people to ping?_ &rarr; [`git blame`](https://git-scm.com/docs/git-blame) to the rescue or GitHub's history button!
- As a regular subscriber, you are also invited to take initiative within due reason. Just make sure to coordinate with the author.
- Lastly, you can always ask for help at [our Discourse Forum](https://discourse.nixos.org/) or at [#nixos' IRC channel](https://webchat.freenode.net/#nixos).

## A few suggestions for PR authors

1. If it is unfinished work and you plan on finishing it some time in the future, please mark the PR as draft.
2. If you want to abandon this work for whatever reason, please consider closing this PR with a short comment. This might encourage somebody else to pick up your work.
3. If you want to get things rolling again, first make sure to rebase the PR and have all valid comments addressed.
4. Then, if you need a review to push things forward, [try this thread](https://discourse.nixos.org/t/prs-in-distress/3604).
5. If all you need is a merger, check out the git history to find and [request reviews](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/requesting-a-pull-request-review) from people who usually merge things in adjacent code.

## A few suggestions for issue authors

1. If this issue is no longer one (either for you, personally, or in general), please consider closing it.
2. If this might still be an issue, but you don't have a vested interest in promoting it's resolution, please consider closing it while encouraging others to take over and reopen an issue if they care enough.
3. If you still have interest in pushing this issue, try to ping somebody who you believe might have an interest in the topic. Consider exposing the problem in [our Discourse Forum](https://discourse.nixos.org/).
4. As in all open source projects, though, by far your best option is to submit a Pull Request that addresses this issue. We :heart: this attitude!

**Memorandum on Closing Issues**

- Closed issues are still around, and people actually _do_ occasionally search closed issues, so nothing at all is lost.
- They also can be reopened at any time, for example, once you've gained renewed interest in the issue.
- So, when in doubt, closing mostly helps real human beings to deal with the sheer complexity of the amount of open issues on this project.

## Useful GithHub Label Queries

- [Open PRs with any stale-bot interaction](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+commenter%3Aapp%2Fstale+)
- [Open PRs with any stale-bot interaction and `2.status: stale`](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+commenter%3Aapp%2Fstale+label%3A%222.status%3A+stale%22)
- [Open PRs with any stale-bot interaction and NOT `2.status: stale`](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+commenter%3Aapp%2Fstale+-label%3A%222.status%3A+stale%22+)
- [Open Issues with any stale-bot interaction](https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+commenter%3Aapp%2Fstale+)
- [Open Issues with any stale-bot interaction and `2.status: stale`](https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+commenter%3Aapp%2Fstale+label%3A%222.status%3A+stale%22+)
- [Open Issues with any stale-bot interaction and NOT `2.status: stale`](https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+commenter%3Aapp%2Fstale+-label%3A%222.status%3A+stale%22+)

---

<sub>In case this document is outdated, please help us update it with your drive-by contribution. Thanks!</sub>
