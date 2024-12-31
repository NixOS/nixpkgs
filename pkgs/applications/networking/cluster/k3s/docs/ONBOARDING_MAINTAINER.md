# Onboarding Maintainer

Anyone willing can become a maintainer, no pre-requisite knowledge is required. Willingness to learn is enough.

A K3s maintainer, maintains K3s's:

- [documentation](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/README.md)
- [issues](https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+k3s)
- [pull requests](https://github.com/NixOS/nixpkgs/pulls?q=is%3Aopen+is%3Apr+label%3A%226.topic%3A+k3s%22)
- [NixOS tests](https://github.com/NixOS/nixpkgs/tree/master/nixos/tests/k3s)
- [NixOS service module](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/cluster/k3s/default.nix)
- [update script](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/update-script.sh) (the process of updating)
- updates (the act of updating) and [r-ryantm bot logs](https://r.ryantm.com/log/k3s/)
- deprecations
- CVEs
- NixOS releases
- dependencies (runc, containerd, ipset)

Anything that is due, basically.

As a maintainer, feel free to improve anything and everything at your discretion. Meaning, at your pace and according to your capabilities and interests.

Only consensus is required to move forward any proposal. Consensus meaning the approval of others.

If you cause a regression (we've all been there), you are responsible for fixing it, but in case you can't fix it (it happens), feel free to ask for help. That's fine, just let us know.

To merge code, you need to be a committer, or use the merge-bot, but currently the merge-bot only works for packages located at `pkgs/by-name/`, which means, K3s still need to be migrated there before you can use merge-bot for merging. As a non-committer, once you have approved a PR you need to forward the request to a committer. For deciding which committer, give preference initially to K3s committers, but any committer can commit. A committer usually has a green approval in PRs.

K3s's committers currently are: superherointj, marcusramberg, Mic92.

@euank is often silent but still active and has always handled anything dreadful, internal parts of K3s/Kubernetes or architecture things, he initially packaged K3s for nixpkgs, think of him as a last resort, when we fail to accomplish a fix, he comes to rescue us from ourselves.

@mic92 stepped up when @superherointj stepped down a time ago, as Mic92 has a broad responsibility in nixpkgs (he is responsible for far too many things already, nixpkgs-reviews, sops-nix, release manager, bot-whatever), we avoid giving him chore work for `nixos-unstable`, only pick him as committer last. As Mic92 runs K3s in a `nixos-stable` setting, he might help in testing stable backports.

On how to handle requests, it's the usual basics, such as, when reviewing PRs, issues, be welcoming, helpful, provide hints whenever possible, try to move things forward, assume good will, ignore [as don't react to] any negativity [since it spirals badly], delay and sort any (severe) disagreement in private. Even on disagrements, be thankful to people for their dedicated time, no matter what happens. In essence, on any unfortunate event, **always put people over code**.

Dumbshit happens, we make mistakes, the CI, reviews, fellow maintainers are there to nudge us on a better direction, no need to over think interactions, if a problem happens, we'll handle it.

We should optimize for maintainers satisfaction, because it is maintainers that make the service great. The best kind of win we have is when someone new steps up for being a maintainer. This multiplies our capabilities of doing meaningful work and increases our knowledge pool.

Know that your participation matters most for us. And we thank you for stepping up. It's good to have you here!

We welcome you and wish you the best in this new journey!

K3s Maintainers
