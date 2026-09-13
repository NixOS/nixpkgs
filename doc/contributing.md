# Contributing {#part-contributing}

<!--
    Legacy anchors. The sections behind these IDs used to live in this manual and are
    now maintained next to the code they describe. The IDs are kept so that existing
    links keep resolving to the list below.
-->
<!-- moved to CONTRIBUTING.md -->
[]{#chap-conventions}
[]{#sec-syntax}
[]{#sec-organisation}
[]{#chap-submitting-changes}
[]{#submitting-changes-submitting-changes}
[]{#submitting-changes-pull-request-template}
[]{#submitting-changes-tested-with-sandbox}
[]{#submitting-changes-platform-diversity}
[]{#submitting-changes-nixos-tests}
[]{#submitting-changes-tested-compilation}
[]{#submitting-changes-tested-execution}
[]{#submitting-changes-contribution-standards}
[]{#submitting-changes-hotfixing-pull-requests}
[]{#submitting-changes-commit-policy}
[]{#submitting-changes-branches}
[]{#submitting-changes-master-branch}
[]{#submitting-changes-staging-branch}
[]{#submitting-changes-staging-next-branch}
[]{#submitting-changes-stable-release-branches}
[]{#submitting-changes-stable-release-branches-automatic-backports}
[]{#submitting-changes-stable-release-branches-manual-backports}
[]{#acceptable-backport-criteria}
[]{#chap-reviewing-contributions}
[]{#reviewing-contributions-other-submissions}
[]{#reviewing-contributions--merging-pull-requests}
[]{#part-development}

<!-- moved to pkgs/README.md -->
[]{#chap-quick-start}
[]{#sec-package-naming}
[]{#sec-versioning}
[]{#sec-sources}
[]{#sec-source-hashes}
[]{#sec-source-hashes-security}
[]{#sec-patches}
[]{#sec-package-tests}
[]{#ssec-inline-package-tests-writing}
[]{#ssec-package-tests-writing}
[]{#ssec-package-tests-running}
[]{#ssec-package-tests-examples}
[]{#ssec-nixos-tests-linking}
[]{#ssec-import-from-derivation}
[]{#submitting-changes-submitting-security-fixes}
[]{#submitting-changes-deprecating-packages}
[]{#steps-to-remove-a-package-from-nixpkgs}
[]{#chap-vulnerability-roundup}
[]{#vulnerability-roundup-issues}
[]{#vulnerability-roundup-triaging-and-fixing}
[]{#reviewing-contributions-package-updates}
[]{#reviewing-contributions-new-packages}

<!-- moved to nixos/README.md -->
[]{#reviewing-contributions-module-updates}
[]{#reviewing-contributions-new-modules}

<!-- moved to maintainers/README.md -->
[]{#reviewing-contributions-individual-maintainer-list}
[]{#reviewing-contributions-maintainer-teams}

<!-- moved to doc/README.md -->
[]{#chap-contributing}

Contribution documentation is kept next to the code it describes:

- [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md): coding conventions, file organisation, submitting changes, commit policy, branches and backports, reviewing contributions.
- [pkgs/README.md](https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md): adding and updating packages, package naming and versioning, source fetching and hashes, patches, package tests, deprecating packages, security fixes.
- [nixos/README.md](https://github.com/NixOS/nixpkgs/blob/master/nixos/README.md): NixOS modules and reviewing module changes.
- [maintainers/README.md](https://github.com/NixOS/nixpkgs/blob/master/maintainers/README.md): maintainer entries and maintainer teams.
- [doc/README.md](https://github.com/NixOS/nixpkgs/blob/master/doc/README.md): writing and building this manual.

## Opening issues {#sec-opening-issues}

- Make sure you have a [GitHub account](https://github.com/signup/free)
- Make sure there is no open issue on the topic
- [Submit a new issue](https://github.com/NixOS/nixpkgs/issues/new/choose) by choosing the kind of topic and filling out the template

<!-- In the future this section could also include more detailed information on the issue templates -->
