---
name: Build failure
about: Create a report to help us improve
title: ''
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
