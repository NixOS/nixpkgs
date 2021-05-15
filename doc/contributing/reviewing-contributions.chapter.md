# Reviewing contributions {#chap-reviewing-contributions}

::: warning
The following section is a draft, and the policy for reviewing is still being discussed in issues such as [#11166](https://github.com/NixOS/nixpkgs/issues/11166) and [#20836](https://github.com/NixOS/nixpkgs/issues/20836).
:::

The Nixpkgs project receives a fairly high number of contributions via GitHub pull requests. Reviewing and approving these is an important task and a way to contribute to the project.

The high change rate of Nixpkgs makes any pull request that remains open for too long subject to conflicts that will require extra work from the submitter or the merger. Reviewing pull requests in a timely manner and being responsive to the comments is the key to avoid this issue. GitHub provides sort filters that can be used to see the [most recently](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+sort%3Aupdated-desc) and the [least recently](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+sort%3Aupdated-asc) updated pull requests. We highly encourage looking at [this list of ready to merge, unreviewed pull requests](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+review%3Anone+status%3Asuccess+-label%3A%222.status%3A+work-in-progress%22+no%3Aproject+no%3Aassignee+no%3Amilestone).

When reviewing a pull request, please always be nice and polite. Controversial changes can lead to controversial opinions, but it is important to respect every community member and their work.

GitHub provides reactions as a simple and quick way to provide feedback to pull requests or any comments. The thumb-down reaction should be used with care and if possible accompanied with some explanation so the submitter has directions to improve their contribution.

pull request reviews should include a list of what has been reviewed in a comment, so other reviewers and mergers can know the state of the review.

All the review template samples provided in this section are generic and meant as examples. Their usage is optional and the reviewer is free to adapt them to their liking.

## Package updates {#reviewing-contributions-package-updates}

A package update is the most trivial and common type of pull request. These pull requests mainly consist of updating the version part of the package name and the source hash.

It can happen that non-trivial updates include patches or more complex changes.

Reviewing process:

- Ensure that the package versioning fits the guidelines.
- Ensure that the commit text fits the guidelines.
- Ensure that the package maintainers are notified.
  - [CODEOWNERS](https://help.github.com/articles/about-codeowners) will make GitHub notify users based on the submitted changes, but it can happen that it misses some of the package maintainers.
- Ensure that the meta field information is correct.
  - License can change with version updates, so it should be checked to match the upstream license.
  - If the package has no maintainer, a maintainer must be set. This can be the update submitter or a community member that accepts to take maintainership of the package.
- Ensure that the code contains no typos.
- Building the package locally.
  - pull requests are often targeted to the master or staging branch, and building the pull request locally when it is submitted can trigger many source builds.
  - It is possible to rebase the changes on nixos-unstable or nixpkgs-unstable for easier review by running the following commands from a nixpkgs clone.
    ```ShellSession
    $ git fetch origin nixos-unstable
    $ git fetch origin pull/PRNUMBER/head
    $ git rebase --onto nixos-unstable BASEBRANCH FETCH_HEAD
    ```
    - The first command fetches the nixos-unstable branch.
    - The second command fetches the pull request changes, `PRNUMBER` is the number at the end of the pull request title and `BASEBRANCH` the base branch of the pull request.
    - The third command rebases the pull request changes to the nixos-unstable branch.
  - The [nixpkgs-review](https://github.com/Mic92/nixpkgs-review) tool can be used to review a pull request content in a single command. `PRNUMBER` should be replaced by the number at the end of the pull request title. You can also provide the full github pull request url.
    ```ShellSession
    $ nix-shell -p nixpkgs-review --run "nixpkgs-review pr PRNUMBER"
    ```
- Running every binary.

Sample template for a package update review is provided below.

```markdown
##### Reviewed points

- [ ] package name fits guidelines
- [ ] package version fits guidelines
- [ ] package build on ARCHITECTURE
- [ ] executables tested on ARCHITECTURE
- [ ] all depending packages build

##### Possible improvements

##### Comments
```

## New packages {#reviewing-contributions-new-packages}

New packages are a common type of pull requests. These pull requests consists in adding a new nix-expression for a package.

Review process:

- Ensure that the package versioning fits the guidelines.
- Ensure that the commit name fits the guidelines.
- Ensure that the meta fields contain correct information.
  - License must match the upstream license.
  - Platforms should be set (or the package will not get binary substitutes).
  - Maintainers must be set. This can be the package submitter or a community member that accepts taking up maintainership of the package.
- Report detected typos.
- Ensure the package source:
  - Uses mirror URLs when available.
  - Uses the most appropriate functions (e.g. packages from GitHub should use `fetchFromGitHub`).
- Building the package locally.
- Running every binary.

Sample template for a new package review is provided below.

```markdown
##### Reviewed points

- [ ] package path fits guidelines
- [ ] package name fits guidelines
- [ ] package version fits guidelines
- [ ] package build on ARCHITECTURE
- [ ] executables tested on ARCHITECTURE
- [ ] `meta.description` is set and fits guidelines
- [ ] `meta.license` fits upstream license
- [ ] `meta.platforms` is set
- [ ] `meta.maintainers` is set
- [ ] build time only dependencies are declared in `nativeBuildInputs`
- [ ] source is fetched using the appropriate function
- [ ] phases are respected
- [ ] patches that are remotely available are fetched with `fetchpatch`

##### Possible improvements

##### Comments
```

## Module updates {#reviewing-contributions-module-updates}

Module updates are submissions changing modules in some ways. These often contains changes to the options or introduce new options.

Reviewing process:

- Ensure that the module maintainers are notified.
  - [CODEOWNERS](https://help.github.com/articles/about-codeowners/) will make GitHub notify users based on the submitted changes, but it can happen that it misses some of the package maintainers.
- Ensure that the module tests, if any, are succeeding.
- Ensure that the introduced options are correct.
  - Type should be appropriate (string related types differs in their merging capabilities, `optionSet` and `string` types are deprecated).
  - Description, default and example should be provided.
- Ensure that option changes are backward compatible.
  - `mkRenamedOptionModule` and `mkAliasOptionModule` functions provide way to make option changes backward compatible.
- Ensure that removed options are declared with `mkRemovedOptionModule`
- Ensure that changes that are not backward compatible are mentioned in release notes.
- Ensure that documentations affected by the change is updated.

Sample template for a module update review is provided below.

```markdown
##### Reviewed points

- [ ] changes are backward compatible
- [ ] removed options are declared with `mkRemovedOptionModule`
- [ ] changes that are not backward compatible are documented in release notes
- [ ] module tests succeed on ARCHITECTURE
- [ ] options types are appropriate
- [ ] options description is set
- [ ] options example is provided
- [ ] documentation affected by the changes is updated

##### Possible improvements

##### Comments
```

## New modules {#reviewing-contributions-new-modules}

New modules submissions introduce a new module to NixOS.

Reviewing process:

- Ensure that the module tests, if any, are succeeding.
- Ensure that the introduced options are correct.
  - Type should be appropriate (string related types differs in their merging capabilities, `optionSet` and `string` types are deprecated).
  - Description, default and example should be provided.
- Ensure that module `meta` field is present
  - Maintainers should be declared in `meta.maintainers`.
  - Module documentation should be declared with `meta.doc`.
- Ensure that the module respect other modules functionality.
  - For example, enabling a module should not open firewall ports by default.

Sample template for a new module review is provided below.

```markdown
##### Reviewed points

- [ ] module path fits the guidelines
- [ ] module tests succeed on ARCHITECTURE
- [ ] options have appropriate types
- [ ] options have default
- [ ] options have example
- [ ] options have descriptions
- [ ] No unneeded package is added to environment.systemPackages
- [ ] meta.maintainers is set
- [ ] module documentation is declared in meta.doc

##### Possible improvements

##### Comments
```

## Other submissions {#reviewing-contributions-other-submissions}

Other type of submissions requires different reviewing steps.

If you consider having enough knowledge and experience in a topic and would like to be a long-term reviewer for related submissions, please contact the current reviewers for that topic. They will give you information about the reviewing process. The main reviewers for a topic can be hard to find as there is no list, but checking past pull requests to see who reviewed or git-blaming the code to see who committed to that topic can give some hints.

Container system, boot system and library changes are some examples of the pull requests fitting this category.

## Merging pull requests {#reviewing-contributions--merging-pull-requests}

It is possible for community members that have enough knowledge and experience on a special topic to contribute by merging pull requests.

<!--
The following paragraphs about how to deal with unactive contributors is just a proposition and should be modified to what the community agrees to be the right policy.

Please note that contributors with commit rights unactive for more than three months will have their commit rights revoked.
-->

Please see the discussion in [GitHub nixpkgs issue #50105](https://github.com/NixOS/nixpkgs/issues/50105) for information on how to proceed to be granted this level of access.

In a case a contributor definitively leaves the Nix community, they should create an issue or post on [Discourse](https://discourse.nixos.org) with references of packages and modules they maintain so the maintainership can be taken over by other contributors.
