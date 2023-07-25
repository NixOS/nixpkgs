---
name: Bug report
about: Create a report to help us improve
title: ''
labels: '0.kind: bug'
assignees: ''

---

### Describe the bug
A clear and concise description of what the bug is.

### Steps To Reproduce
Steps to reproduce the behavior:
1. ...
2. ...
3. ...

### Expected behavior
A clear and concise description of what you expected to happen.

### Screenshots
If applicable, add screenshots to help explain your problem.

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
