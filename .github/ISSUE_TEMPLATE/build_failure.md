---
name: Build failure
about: Create a report to help us improve
title: 'Build failure: PACKAGENAME'
labels: '0.kind: build failure'
assignees: ''

---

### Steps To Reproduce

Steps to reproduce the behavior:
1. build *X*

### Build log

```
log here if short otherwise a link to a gist
```

### Additional context

Add any other context about the problem here.

### Notify maintainers

<!--
Please @ people who are in the `meta.maintainers` list of the offending package or module.
If in doubt, check `git blame` for whoever last touched something.
-->

### Metadata

Please run `nix-shell -p nix-info --run "nix-info -m"` and paste the result.

```console
[user@system:~]$ nix-shell -p nix-info --run "nix-info -m"
output here
```

---

Add a :+1: [reaction] to [issues you find important].

[reaction]: https://github.blog/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/
[issues you find important]: https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc
