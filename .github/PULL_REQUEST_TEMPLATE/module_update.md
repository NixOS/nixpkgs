<!--
This project's monthly turnover might well be beyond 1500 PRs. Since we are community driven,
let's do tit for tat: submitters are kindly ask to pick an open pull request for review.

Start with packages updates. They are relatively simple.
Since you'll be required to do those very steps below, it'll be easy.

Marvin needs_reviewer: https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+label%3Aneeds_reviewer+
Marvin needs_merger:   https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+label%3Aneeds_merger+
Reviewing guidelines:  https://hydra.nixos.org/job/nixpkgs/trunk/manual/latest/download/1/nixpkgs/manual.html#chap-reviewing-contributions
-->

##### Motivation for this change


##### General review

- [ ] changes are backward compatible
- [ ] removed options are declared with `mkRemovedOptionModule`
- [ ] changes that are not backward compatible are documented in release notes
- [ ] module tests succeed on ARCHITECTURE
- [ ] options types are appropriate
- [ ] options description is set
- [ ] options example is provided
- [ ] fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/.github/CONTRIBUTING.md).

##### Package build
<!-- Tipp: pipe those commands through bash directly from your editor -->

```
uname -srm
---
lsb_release -a
```

<details>
<summary>Logs from <code>nixpkgs-review rev HEAD</code></summary>

```
nixpkgs-review rev HEAD

```
</details>

<!--
substitute this command by it's own output when run within the nipkgs-review shell
-->
cat ./report.md

<!--
substitute this command by it's own output when run within the nipkgs-review shell
and test "not ok" binaries manually
-->
for cmd in $(ls ./results/**/**/**); do if $($cmd --help > /dev/null); then echo "- [x] \`$cmd --help\`: ok"; else "- [ ] \`$cmd --help\`: not ok -- tested otherwise"; fi; done

##### Documentation (if aplicable)

- [ ] updated documentation
- [ ] introduced no ortographical errors

##### Possible improvements

##### Comments

