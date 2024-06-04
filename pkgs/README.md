# Contributing to Nixpkgs packages

This document is for people wanting to contribute specifically to the package collection in Nixpkgs.
See the [CONTRIBUTING.md](../CONTRIBUTING.md) document for more general information.

## Overview

- [`top-level`](./top-level): Entrypoints, package set aggregations
  - [`impure.nix`](./top-level/impure.nix), [`default.nix`](./top-level/default.nix), [`config.nix`](./top-level/config.nix): Definitions for the evaluation entry point of `import <nixpkgs>`
  - [`stage.nix`](./top-level/stage.nix), [`all-packages.nix`](./top-level/all-packages.nix), [`by-name-overlay.nix`](./top-level/by-name-overlay.nix), [`splice.nix`](./top-level/splice.nix): Definitions for the top-level attribute set made available through `import <nixpkgs> {…}`
  - `*-packages.nix`, [`linux-kernels.nix`](./top-level/linux-kernels.nix), [`unixtools.nix`](./top-level/unixtools.nix): Aggregations of nested package sets defined in `development`
  - [`aliases.nix`](./top-level/aliases.nix), [`python-aliases.nix`](./top-level/python-aliases.nix): Aliases for package definitions that have been renamed or removed
  - `release*.nix`, [`make-tarball.nix`](./top-level/make-tarball.nix), [`packages-config.nix`](./top-level/packages-config.nix), [`metrics.nix`](./top-level/metrics.nix), [`nixpkgs-basic-release-checks.nix`](./top-level/nixpkgs-basic-release-checks.nix): Entry-points and utilities used by Hydra for continuous integration
- [`development`](./development)
  - `*-modules`, `*-packages`, `*-pkgs`: Package definitions for nested package sets
  - All other directories loosely categorise top-level package definitions, see [category hierarchy][categories]
- [`build-support`](./build-support): [Builders](https://nixos.org/manual/nixpkgs/stable/#part-builders)
  - `fetch*`: [Fetchers](https://nixos.org/manual/nixpkgs/stable/#chap-pkgs-fetchers)
- [`stdenv`](./stdenv): [Standard environment](https://nixos.org/manual/nixpkgs/stable/#part-stdenv)
- [`pkgs-lib`](./pkgs-lib): Definitions for utilities that need packages but are not needed for packages
- [`test`](./test): Tests not directly associated with any specific packages
- [`by-name`](./by-name): Top-level packages organised by name ([docs](./by-name/README.md))
- All other directories loosely categorise top-level packages definitions, see [category hierarchy][categories]

## Quick Start to Adding a Package

We welcome new contributors of new packages to Nixpkgs, arguably the greatest software database known. However, each new package comes with a cost for the maintainers, Continuous Integration, caching servers and users downloading Nixpkgs.

Before adding a new package, please consider the following questions:

* Is the package ready for general use? We don't want to include projects that are too immature or are going to be abandoned immediately. In case of doubt, check with upstream.
* Does the project have a clear license statement? Remember that software is unfree by default (all rights reserved), and merely providing access to the source code does not imply its redistribution. In case of doubt, ask upstream.
* How realistic is it that it will be used by other people? It's good that nixpkgs caters to various niches, but if it's a niche of 5 people it's probably too small.
* Are you willing to maintain the package? You should care enough about the package to be willing to keep it up and running for at least one complete Nixpkgs' release life-cycle.

If any of these questions' answer is no, then you should probably not add the package.

This is section describes a general framework of understanding and exceptions might apply.

Luckily it's pretty easy to maintain your own package set with Nix, which can then be added to the [Nix User Repository](https://github.com/nix-community/nur) project.

---

Now that this is out of the way. To add a package to Nixpkgs:

1. Checkout the Nixpkgs source tree:

   ```ShellSession
   $ git clone https://github.com/NixOS/nixpkgs
   $ cd nixpkgs
   ```

2. Create a package directory `pkgs/by-name/so/some-package` where `some-package` is the package name and `so` is the lowercased 2-letter prefix of the package name:

   ```ShellSession
   $ mkdir -p pkgs/by-name/so/some-package
   ```

   For more detailed information, see [here](./by-name/README.md).

3. Create a `package.nix` file in the package directory, containing a Nix expression — a piece of code that describes how to build the package. In this case, it should be a _function_ that is called with the package dependencies as arguments, and returns a build of the package in the Nix store.

   ```ShellSession
   $ emacs pkgs/by-name/so/some-package/package.nix
   $ git add pkgs/by-name/so/some-package/package.nix
   ```

   If the package is written in a language other than C, you should use [the corresponding language framework](https://nixos.org/manual/nixpkgs/stable/#chap-language-support).

   You can have a look at the existing Nix expressions under `pkgs/` to see how it’s done, some of which are also using the [category hierarchy](#category-hierarchy).
   Here are some good ones:

   - GNU Hello: [`pkgs/by-name/he/hello/package.nix`](./by-name/he/hello/package.nix). Trivial package, which specifies some `meta` attributes which is good practice.

   - GNU cpio: [`pkgs/tools/archivers/cpio/default.nix`](tools/archivers/cpio/default.nix). Also a simple package. The generic builder in `stdenv` does everything for you. It has no dependencies beyond `stdenv`.

   - GNU Multiple Precision arithmetic library (GMP): [`pkgs/development/libraries/gmp/5.1.x.nix`](development/libraries/gmp/5.1.x.nix). Also done by the generic builder, but has a dependency on `m4`.

   - Pan, a GTK-based newsreader: [`pkgs/applications/networking/newsreaders/pan/default.nix`](applications/networking/newsreaders/pan/default.nix). Has an optional dependency on `gtkspell`, which is only built if `spellCheck` is `true`.

   - Apache HTTPD: [`pkgs/servers/http/apache-httpd/2.4.nix`](servers/http/apache-httpd/2.4.nix). A bunch of optional features, variable substitutions in the configure flags, a post-install hook, and miscellaneous hackery.

   - buildMozillaMach: [`pkgs/applications/networking/browser/firefox/common.nix`](applications/networking/browsers/firefox/common.nix). A reusable build function for Firefox, Thunderbird and Librewolf.

   - JDiskReport, a Java utility: [`pkgs/tools/misc/jdiskreport/default.nix`](tools/misc/jdiskreport/default.nix). Nixpkgs doesn’t have a decent `stdenv` for Java yet so this is pretty ad-hoc.

   - XML::Simple, a Perl module: [`pkgs/top-level/perl-packages.nix`](top-level/perl-packages.nix) (search for the `XMLSimple` attribute). Most Perl modules are so simple to build that they are defined directly in `perl-packages.nix`; no need to make a separate file for them.

   - Adobe Reader: [`pkgs/applications/misc/adobe-reader/default.nix`](applications/misc/adobe-reader/default.nix). Shows how binary-only packages can be supported. In particular the [builder](applications/misc/adobe-reader/builder.sh) uses `patchelf` to set the RUNPATH and ELF interpreter of the executables so that the right libraries are found at runtime.

   Some notes:

   - Add yourself as the maintainer of the package.

   - All other [`meta`](https://nixos.org/manual/nixpkgs/stable/#chap-meta) attributes are optional, but it’s still a good idea to provide at least the `description`, `homepage` and [`license`](https://nixos.org/manual/nixpkgs/stable/#sec-meta-license).

   - The exact syntax and semantics of the Nix expression language, including the built-in functions, are [Nix language reference](https://nixos.org/manual/nix/stable/language/).

5. To test whether the package builds, run the following command from the root of the nixpkgs source tree:

   ```ShellSession
   $ nix-build -A some-package
   ```

   where `some-package` should be the package name. You may want to add the flag `-K` to keep the temporary build directory in case something fails. If the build succeeds, a symlink `./result` to the package in the Nix store is created.

6. If you want to install the package into your profile (optional), do

   ```ShellSession
   $ nix-env -f . -iA libfoo
   ```

7. Optionally commit the new package and open a pull request [to nixpkgs](https://github.com/NixOS/nixpkgs/pulls), or use [the Patches category](https://discourse.nixos.org/t/about-the-patches-category/477) on Discourse for sending a patch without a GitHub account.

## Commit conventions

- Make sure you read about the [commit conventions](../CONTRIBUTING.md#commit-conventions) common to Nixpkgs as a whole.

- Format the commit messages in the following way:

  ```
  (pkg-name): (from -> to | init at version | refactor | etc)

  (Motivation for change. Link to release notes. Additional information.)
  ```

  Examples:

  * nginx: init at 2.0.1
  * firefox: 54.0.1 -> 55.0

    https://www.mozilla.org/en-US/firefox/55.0/releasenotes/

## Category Hierarchy
[categories]: #category-hierarchy

Most top-level packages are organised in a loosely-categorised directory hierarchy in this directory.
See the [overview](#overview) for which directories are part of this.

This category hierarchy is partially deprecated and will be migrated away over time.
The new `pkgs/by-name` directory ([docs](./by-name/README.md)) should be preferred instead.
The category hierarchy may still be used for packages that should be imported using an alternate `callPackage`, such as `python3Packages.callPackage` or `libsForQt5.callPackage`.

If that is the case for a new package, here are some rules for picking the right category.
Many packages fall under several categories; what matters is the _primary_ purpose of a package.
For example, the `libxml2` package builds both a library and some tools; but it’s a library foremost, so it goes under `pkgs/development/libraries`.

<details>
<summary>Categories</summary>

**If it’s used to support _software development_:**

- **If it’s a _library_ used by other packages:**

  - `development/libraries` (e.g. `libxml2`)

- **If it’s a _compiler_:**

  - `development/compilers` (e.g. `gcc`)

- **If it’s an _interpreter_:**

  - `development/interpreters` (e.g. `guile`)

- **If it’s a (set of) development _tool(s)_:**

  - **If it’s a _parser generator_ (including lexers):**

    - `development/tools/parsing` (e.g. `bison`, `flex`)

  - **If it’s a _build manager_:**

    - `development/tools/build-managers` (e.g. `gnumake`)

  - **If it’s a _language server_:**

    - `development/tools/language-servers` (e.g. `ccls` or `nil`)

  - **Else:**

    - `development/tools/misc` (e.g. `binutils`)

- **Else:**

  - `development/misc`

**If it’s a (set of) _tool(s)_:**

(A tool is a relatively small program, especially one intended to be used non-interactively.)

- **If it’s for _networking_:**

  - `tools/networking` (e.g. `wget`)

- **If it’s for _text processing_:**

  - `tools/text` (e.g. `diffutils`)

- **If it’s a _system utility_, i.e., something related or essential to the operation of a system:**

  - `tools/system` (e.g. `cron`)

- **If it’s an _archiver_ (which may include a compression function):**

  - `tools/archivers` (e.g. `zip`, `tar`)

- **If it’s a _compression_ program:**

  - `tools/compression` (e.g. `gzip`, `bzip2`)

- **If it’s a _security_-related program:**

  - `tools/security` (e.g. `nmap`, `gnupg`)

- **Else:**

  - `tools/misc`

**If it’s a _shell_:**

- `shells` (e.g. `bash`)

**If it’s a _server_:**

- **If it’s a web server:**

  - `servers/http` (e.g. `apache-httpd`)

- **If it’s an implementation of the X Windowing System:**

  - `servers/x11` (e.g. `xorg` — this includes the client libraries and programs)

- **Else:**

  - `servers/misc`

**If it’s a _desktop environment_:**

- `desktops` (e.g. `kde`, `gnome`, `enlightenment`)

**If it’s a _window manager_:**

- `applications/window-managers` (e.g. `awesome`, `stumpwm`)

**If it’s an _application_:**

A (typically large) program with a distinct user interface, primarily used interactively.

- **If it’s a _version management system_:**

  - `applications/version-management` (e.g. `subversion`)

- **If it’s a _terminal emulator_:**

  - `applications/terminal-emulators` (e.g. `alacritty` or `rxvt` or `termite`)

- **If it’s a _file manager_:**

  - `applications/file-managers` (e.g. `mc` or `ranger` or `pcmanfm`)

- **If it’s for _video playback / editing_:**

  - `applications/video` (e.g. `vlc`)

- **If it’s for _graphics viewing / editing_:**

  - `applications/graphics` (e.g. `gimp`)

- **If it’s for _networking_:**

  - **If it’s a _mailreader_:**

    - `applications/networking/mailreaders` (e.g. `thunderbird`)

  - **If it’s a _newsreader_:**

    - `applications/networking/newsreaders` (e.g. `pan`)

  - **If it’s a _web browser_:**

    - `applications/networking/browsers` (e.g. `firefox`)

  - **Else:**

    - `applications/networking/misc`

- **Else:**

  - `applications/misc`

**If it’s _data_ (i.e., does not have a straight-forward executable semantics):**

- **If it’s a _font_:**

  - `data/fonts`

- **If it’s an _icon theme_:**

  - `data/icons`

- **If it’s related to _SGML/XML processing_:**

  - **If it’s an _XML DTD_:**

    - `data/sgml+xml/schemas/xml-dtd` (e.g. `docbook`)

  - **If it’s an _XSLT stylesheet_:**

    (Okay, these are executable...)

    - `data/sgml+xml/stylesheets/xslt` (e.g. `docbook-xsl`)

- **If it’s a _theme_ for a _desktop environment_, a _window manager_ or a _display manager_:**

  - `data/themes`

**If it’s a _game_:**

- `games`

**Else:**

- `misc`

</details>

# Conventions

## Package naming

The key words _must_, _must not_, _required_, _shall_, _shall not_, _should_, _should not_, _recommended_, _may_, and _optional_ in this section are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119). Only _emphasized_ words are to be interpreted in this way.

In Nixpkgs, there are generally three different names associated with a package:

- The `pname` attribute of the derivation. This is what most users see, in particular when using `nix-env`.

- The variable name used for the instantiated package in `all-packages.nix`, and when passing it as a dependency to other functions. Typically this is called the _package attribute name_. This is what Nix expression authors see. It can also be used when installing using `nix-env -iA`.

- The filename for (the directory containing) the Nix expression.

Most of the time, these are the same. For instance, the package `e2fsprogs` has a `pname` attribute `"e2fsprogs"`, is bound to the variable name `e2fsprogs` in `all-packages.nix`, and the Nix expression is in `pkgs/os-specific/linux/e2fsprogs/default.nix`.

There are a few naming guidelines:

- The `pname` attribute _should_ be identical to the upstream package name.

- The `pname` and the `version` attribute _must not_ contain uppercase letters — e.g., `"mplayer"` instead of `"MPlayer"`.

- The `version` attribute _must_ start with a digit e.g., `"0.3.1rc2"`.

- If a package is a commit from a repository without a version assigned, then the `version` attribute _should_ be the latest upstream version preceding that commit, followed by `-unstable-` and the date of the (fetched) commit. The date _must_ be in `"YYYY-MM-DD"` format.

Example: Given a project had its latest releases `2.2` in November 2021, and `3.0` in January 2022, a commit authored on March 15, 2022 for an upcoming bugfix release `2.2.1` would have `version = "2.2-unstable-2022-03-15"`.

- If a project has no suitable preceding releases - e.g., no versions at all, or an incompatible versioning / tagging schema - then the latest upstream version in the above schema should be `0`.

Example: Given a project that has no tags / released versions at all, or applies versionless tags like `latest` or `YYYY-MM-DD-Build`, a commit authored on March 15, 2022 would have `version = "0-unstable-2022-03-15"`.

- Dashes in the package `pname` _should_ be preserved in new variable names, rather than converted to underscores or camel cased — e.g., `http-parser` instead of `http_parser` or `httpParser`. The hyphenated style is preferred in all three package names.

- If there are multiple versions of a package, this _should_ be reflected in the variable names in `all-packages.nix`, e.g. `json-c_0_9` and `json-c_0_11`. If there is an obvious “default” version, make an attribute like `json-c = json-c_0_9;`. See also [versioning][versioning].

## Versioning
[versioning]: #versioning

Because every version of a package in Nixpkgs creates a potential maintenance burden, old versions of a package should not be kept unless there is a good reason to do so. For instance, Nixpkgs contains several versions of GCC because other packages don’t build with the latest version of GCC. Other examples are having both the latest stable and latest pre-release version of a package, or to keep several major releases of an application that differ significantly in functionality.

If there is only one version of a package, its Nix expression should be named `e2fsprogs/default.nix`. If there are multiple versions, this should be reflected in the filename, e.g. `e2fsprogs/1.41.8.nix` and `e2fsprogs/1.41.9.nix`. The version in the filename should leave out unnecessary detail. For instance, if we keep the latest Firefox 2.0.x and 3.5.x versions in Nixpkgs, they should be named `firefox/2.0.nix` and `firefox/3.5.nix`, respectively (which, at a given point, might contain versions `2.0.0.20` and `3.5.4`). If a version requires many auxiliary files, you can use a subdirectory for each version, e.g. `firefox/2.0/default.nix` and `firefox/3.5/default.nix`.

All versions of a package _must_ be included in `all-packages.nix` to make sure that they evaluate correctly.

## Meta attributes

* `meta.description` must:
  * Be short, just one sentence.
  * Be capitalized.
  * Not start with the package name.
    * More generally, it should not refer to the package name.
  * Not end with a period (or any punctuation for that matter).
  * Provide factual information.
    * Avoid subjective language.
* `meta.license` must be set and match the upstream license.
  * If there is no upstream license, `meta.license` should default to `lib.licenses.unfree`.
  * If in doubt, try to contact the upstream developers for clarification.
* `meta.mainProgram` must be set to the name of the executable which facilitates the primary function or purpose of the package, if there is such an executable in `$bin/bin/` (or `$out/bin/`, if there is no `"bin"` output).
  * Packages that only have a single executable in the applicable directory above should set `meta.mainProgram`. For example, the package `ripgrep` only has a single executable `rg` under `$out/bin/`, so `ripgrep.meta.mainProgram` is set to `"rg"`.
  * Packages like `polkit_gnome` that have no executables in the applicable directory should not set `meta.mainProgram`.
  * Packages like `e2fsprogs` that have multiple executables, none of which can be considered the main program, should not set `meta.mainProgram`.
  * Packages which are not primarily used for a single executable do not need to set `meta.mainProgram`.
  * Always prefer using a hardcoded string (don't use `pname`, for example).
  * When in doubt, ask for reviewer input.
* `meta.maintainers` must be set for new packages.

See the Nixpkgs manual for more details on [standard meta-attributes](https://nixos.org/nixpkgs/manual/#sec-standard-meta-attributes).

## Import From Derivation

[Import From Derivation](https://nixos.org/manual/nix/unstable/language/import-from-derivation) (IFD) is disallowed in Nixpkgs for performance reasons:
[Hydra](https://github.com/NixOS/hydra) evaluates the entire package set, and sequential builds during evaluation would increase evaluation times to become impractical.

Import From Derivation can be worked around in some cases by committing generated intermediate files to version control and reading those instead.

## Sources

Always fetch source files using [Nixpkgs fetchers](https://nixos.org/manual/nixpkgs/unstable/#chap-pkgs-fetchers).
Use reproducible sources with a high degree of availability.
Prefer protocols that support proxies.

A list of schemes for `mirror://` URLs can be found in [`pkgs/build-support/fetchurl/mirrors.nix`](build-support/fetchurl/mirrors.nix), and is supported by [`fetchurl`](https://nixos.org/manual/nixpkgs/unstable/#fetchurl).
Other fetchers which end up relying on `fetchurl` may also support mirroring.

The preferred source hash type is `sha256`.

Examples going from bad to best practices:

- Bad: Uses `git://` which won't be proxied.

  ```nix
  {
    src = fetchgit {
      url = "git://github.com/NixOS/nix.git";
      rev = "1f795f9f44607cc5bec70d1300150bfefcef2aae";
      hash = "sha256-7D4m+saJjbSFP5hOwpQq2FGR2rr+psQMTcyb1ZvtXsQ=";
    };
  }
  ```

- Better: This is ok, but an archive fetch will still be faster.

  ```nix
  {
    src = fetchgit {
      url = "https://github.com/NixOS/nix.git";
      rev = "1f795f9f44607cc5bec70d1300150bfefcef2aae";
      hash = "sha256-7D4m+saJjbSFP5hOwpQq2FGR2rr+psQMTcyb1ZvtXsQ=";
    };
  }
  ```

- Best: Fetches a snapshot archive for the given revision.

  ```nix
  {
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "1f795f9f44607cc5bec70d1300150bfefcef2aae";
      hash = "sha256-7D4m+saJjbSFP5hOwpQq2FGR2rr+psQMTcyb1ZvtXsQ=";
    };
  }
  ```

> [!Note]
> When fetching from GitHub, always reference revisions by their full commit hash.
> GitHub shares commit hashes among all forks and returns `404 Not Found` when a short commit hash is ambiguous.
> It already happened in Nixpkgs for short, 6-character commit hashes.
>
> Pushing large amounts of auto generated commits into forks is a practical vector for a denial-of-service attack, and was already [demonstrated against GitHub Actions Beta](https://blog.teddykatz.com/2019/11/12/github-actions-dos.html).

## Patches

Sometimes, changes are needed to the source to allow building a derivation in nixpkgs, or to get earlier access to an upstream fix or improvement.
When using the `patches` parameter to `mkDerivation`, make sure the patch name clearly describes the reason for the patch, or add a comment.

Patches already merged upstream or published elsewhere should be retrieved using `fetchpatch`.

```nix
{
  patches = [
    (fetchpatch {
      name = "fix-check-for-using-shared-freetype-lib.patch";
      url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=8f5d285";
      hash = "sha256-uRcxaCjd+WAuGrXOmGfFeu79cUILwkRdBu48mwcBE7g=";
    })
  ];
}
```

Otherwise, you can add a `.patch` file to the `nixpkgs` repository.
In the interest of keeping our maintenance burden and the size of nixpkgs to a minimum, only do this for patches that are unique to `nixpkgs` or that have been proposed upstream but are not merged yet, cannot be easily fetched or have a high chance to disappear in the future due to unstable or unreliable URLs.
The latter avoids link rot when the upstream abandons, squashes or rebases their change, in which case the commit may get garbage-collected.

If a patch is available online but does not cleanly apply, it can be modified in some fixed ways by using additional optional arguments for `fetchpatch`. Check [the `fetchpatch` reference](https://nixos.org/manual/nixpkgs/unstable/#fetchpatch) for details.

```nix
{
  patches = [ ./0001-changes.patch ];
}
```

If you do need to do create this sort of patch file, one way to do so is with git:

1. Move to the root directory of the source code you're patching.

    ```ShellSession
    $ cd the/program/source
    ```

2. If a git repository is not already present, create one and stage all of the source files.

    ```ShellSession
    $ git init
    $ git add .
    ```

3. Edit some files to make whatever changes need to be included in the patch.

4. Use git to create a diff, and pipe the output to a patch file:

    ```ShellSession
    $ git diff -a > nixpkgs/pkgs/the/package/0001-changes.patch
    ```

## Deprecating/removing packages

There is currently no policy when to remove a package.

Before removing a package, one should try to find a new maintainer or fix smaller issues first.

### Steps to remove a package from Nixpkgs

We use jbidwatcher as an example for a discontinued project here.

1. Have Nixpkgs checked out locally and up to date.
1. Create a new branch for your change, e.g. `git checkout -b jbidwatcher`
1. Remove the actual package including its directory, e.g. `git rm -rf pkgs/applications/misc/jbidwatcher`
1. Remove the package from the list of all packages (`pkgs/top-level/all-packages.nix`).
1. Add an alias for the package name in `pkgs/top-level/aliases.nix` (There is also `pkgs/applications/editors/vim/plugins/aliases.nix`. Package sets typically do not have aliases, so we can't add them there.)

    For example in this case:

    ```nix
    {
      jbidwatcher = throw "jbidwatcher was discontinued in march 2021"; # added 2021-03-15
    }
    ```

    The throw message should explain in short why the package was removed for users that still have it installed.

1. Test if the changes introduced any issues by running `nix-env -qaP -f . --show-trace`. It should show the list of packages without errors.
1. Commit the changes. Explain again why the package was removed. If it was declared discontinued upstream, add a link to the source.

    ```ShellSession
    $ git add pkgs/applications/misc/jbidwatcher/default.nix pkgs/top-level/all-packages.nix pkgs/top-level/aliases.nix
    $ git commit
    ```

    Example commit message:

    ```
    jbidwatcher: remove

    project was discontinued in march 2021. the program does not work anymore because ebay changed the login.

    https://web.archive.org/web/20210315205723/http://www.jbidwatcher.com/
    ```

1. Push changes to your GitHub fork with `git push`
1. Create a pull request against Nixpkgs. Mention the package maintainer.

This is how the pull request looks like in this case: [https://github.com/NixOS/nixpkgs/pull/116470](https://github.com/NixOS/nixpkgs/pull/116470)

## Package tests

To run the main types of tests locally:

- Run package-internal tests with `nix-build --attr pkgs.PACKAGE.passthru.tests`
- Run [NixOS tests](https://nixos.org/manual/nixos/unstable/#sec-nixos-tests) with `nix-build --attr nixosTests.NAME`, where `NAME` is the name of the test listed in `nixos/tests/all-tests.nix`
- Run [global package tests](https://nixos.org/manual/nixpkgs/unstable/#sec-package-tests) with `nix-build --attr tests.PACKAGE`, where `PACKAGE` is the name of the test listed in `pkgs/test/default.nix`
- See `lib/tests/NAME.nix` for instructions on running specific library tests

Tests are important to ensure quality and make reviews and automatic updates easy.

The following types of tests exists:

* [NixOS **module tests**](https://nixos.org/manual/nixos/stable/#sec-nixos-tests), which spawn one or more NixOS VMs. They exercise both NixOS modules and the packaged programs used within them. For example, a NixOS module test can start a web server VM running the `nginx` module, and a client VM running `curl` or a graphical `firefox`, and test that they can talk to each other and display the correct content.
* Nix **package tests** are a lightweight alternative to NixOS module tests. They should be used to create simple integration tests for packages, but cannot test NixOS services, and some programs with graphical user interfaces may also be difficult to test with them.
* The **`checkPhase` of a package**, which should execute the unit tests that are included in the source code of a package.

Here in the nixpkgs manual we describe mostly _package tests_; for _module tests_ head over to the corresponding [section in the NixOS manual](https://nixos.org/manual/nixos/stable/#sec-nixos-tests).

### Writing inline package tests

For very simple tests, they can be written inline:

```nix
{ /* ... , */ yq-go }:

buildGoModule rec {
  # …

  passthru.tests = {
    simple = runCommand "${pname}-test" {} ''
      echo "test: 1" | ${yq-go}/bin/yq eval -j > $out
      [ "$(cat $out | tr -d $'\n ')" = '{"test":1}' ]
    '';
  };
}
```

### Writing larger package tests
[larger-package-tests]: #writing-larger-package-tests

This is an example using the `phoronix-test-suite` package with the current best practices.

Add the tests in `passthru.tests` to the package definition like this:

```nix
{ stdenv, lib, fetchurl, callPackage }:

stdenv.mkDerivation {
  # …

  passthru.tests = {
    simple-execution = callPackage ./tests.nix { };
  };

  meta = { /* … */ };
}
```

Create `tests.nix` in the package directory:

```nix
{ runCommand, phoronix-test-suite }:

let
  inherit (phoronix-test-suite) pname version;
in

runCommand "${pname}-tests" { meta.timeout = 60; }
  ''
    # automatic initial setup to prevent interactive questions
    ${phoronix-test-suite}/bin/phoronix-test-suite enterprise-setup >/dev/null
    # get version of installed program and compare with package version
    if [[ `${phoronix-test-suite}/bin/phoronix-test-suite version` != *"${version}"*  ]]; then
      echo "Error: program version does not match package version"
      exit 1
    fi
    # run dummy command
    ${phoronix-test-suite}/bin/phoronix-test-suite dummy_module.dummy-command >/dev/null
    # needed for Nix to register the command as successful
    touch $out
  ''
```

### Running package tests

You can run these tests with:

```ShellSession
$ cd path/to/nixpkgs
$ nix-build -A phoronix-test-suite.tests
```

### Examples of package tests

Here are examples of package tests:

- [Jasmin compile test](development/compilers/jasmin/test-assemble-hello-world/default.nix)
- [Lobster compile test](development/compilers/lobster/test-can-run-hello-world.nix)
- [Spacy annotation test](development/python-modules/spacy/annotation-test/default.nix)
- [Libtorch test](development/libraries/science/math/libtorch/test/default.nix)
- [Multiple tests for nanopb](development/libraries/nanopb/default.nix)

### Linking NixOS module tests to a package

Like [package tests][larger-package-tests] as shown above, [NixOS module tests](https://nixos.org/manual/nixos/stable/#sec-nixos-tests) can also be linked to a package, so that the tests can be easily run when changing the related package.

For example, assuming we're packaging `nginx`, we can link its module test via `passthru.tests`:

```nix
{ stdenv, lib, nixosTests }:

stdenv.mkDerivation {
  # ...

  passthru.tests = {
    nginx = nixosTests.nginx;
  };

  # ...
}
```

## Reviewing contributions

### Package updates

A package update is the most trivial and common type of pull request. These pull requests mainly consist of updating the version part of the package name and the source hash.

It can happen that non-trivial updates include patches or more complex changes.

Reviewing process:

- Ensure that the package versioning [fits the guidelines](#versioning).
- Ensure that the commit text [fits the guidelines](../CONTRIBUTING.md#commit-conventions).
- Ensure that the package maintainers are notified.
  - [CODEOWNERS](https://help.github.com/articles/about-codeowners) will make GitHub notify users based on the submitted changes, but it can happen that it misses some of the package maintainers.
- Ensure that the meta field information [fits the guidelines](#meta-attributes) and is correct:
  - License can change with version updates, so it should be checked to match the upstream license.
  - If the package has no maintainer, a maintainer must be set. This can be the update submitter or a community member that accepts to take maintainership of the package.
- Ensure that the code contains no typos.
- Build the package locally.
  - Pull requests are often targeted to the master or staging branch, and building the pull request locally when it is submitted can trigger many source builds.
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
- Run every binary.

Sample template for a package update review is provided below.

```markdown
##### Reviewed points

- [ ] package name fits guidelines
- [ ] package version fits guidelines
- [ ] package builds on ARCHITECTURE
- [ ] executables tested on ARCHITECTURE
- [ ] all depending packages build
- [ ] patches have a comment describing either the upstream URL or a reason why the patch wasn't upstreamed
- [ ] patches that are remotely available are fetched rather than vendored

##### Possible improvements

##### Comments
```

### New packages

New packages are a common type of pull requests. These pull requests consists in adding a new nix-expression for a package.

Review process:

- Ensure that all file paths [fit the guidelines](../CONTRIBUTING.md#file-naming-and-organisation).
- Ensure that the package name and version [fits the guidelines](#package-naming).
- Ensure that the package versioning [fits the guidelines](#versioning).
- Ensure that the commit text [fits the guidelines](../CONTRIBUTING.md#commit-conventions).
- Ensure that the meta fields [fits the guidelines](#meta-attributes) and contain the correct information:
  - License must match the upstream license.
  - Platforms should be set (or the package will not get binary substitutes).
  - Maintainers must be set. This can be the package submitter or a community member that accepts taking up maintainership of the package.
  - The `meta.mainProgram` must be set if a main executable exists.
- Report detected typos.
- Ensure the package source:
  - Uses `mirror://` URLs when available.
  - Uses the most appropriate functions (e.g. packages from GitHub should use `fetchFromGitHub`).
- Build the package locally.
- Run every binary.

Sample template for a new package review is provided below.

```markdown
##### Reviewed points

- [ ] package path fits guidelines
- [ ] package name fits guidelines
- [ ] package version fits guidelines
- [ ] package builds on ARCHITECTURE
- [ ] executables tested on ARCHITECTURE
- [ ] `meta.description` is set and fits guidelines
- [ ] `meta.license` fits upstream license
- [ ] `meta.platforms` is set
- [ ] `meta.maintainers` is set
- [ ] `meta.mainProgram` is set, if applicable.
- [ ] build time only dependencies are declared in `nativeBuildInputs`
- [ ] source is fetched using the appropriate function
- [ ] the list of `phases` is not overridden
- [ ] when a phase (like `installPhase`) is overridden it starts with `runHook preInstall` and ends with `runHook postInstall`.
- [ ] patches have a comment describing either the upstream URL or a reason why the patch wasn't upstreamed
- [ ] patches that are remotely available are fetched rather than vendored

##### Possible improvements

##### Comments
```

## Security

### Submitting security fixes
[security-fixes]: #submitting-security-fixes

Security fixes are submitted in the same way as other changes and thus the same guidelines apply.

- If a new version fixing the vulnerability has been released, update the package;
- If the security fix comes in the form of a patch and a CVE is available, then add the patch to the Nixpkgs tree, and apply it to the package.
  The name of the patch should be the CVE identifier, so e.g. `CVE-2019-13636.patch`; If a patch is fetched the name needs to be set as well, e.g.:

  ```nix
  (fetchpatch {
    name = "CVE-2019-11068.patch";
    url = "https://gitlab.gnome.org/GNOME/libxslt/commit/e03553605b45c88f0b4b2980adfbbb8f6fca2fd6.patch";
    hash = "sha256-SEKe/8HcW0UBHCfPTTOnpRlzmV2nQPPeL6HOMxBZd14=";
  })
  ```

If a security fix applies to both master and a stable release then, similar to regular changes, they are preferably delivered via master first and cherry-picked to the release branch.

Critical security fixes may by-pass the staging branches and be delivered directly to release branches such as `master` and `release-*`.

### Vulnerability Roundup

#### Issues

Vulnerable packages in Nixpkgs are managed using issues.
Currently opened ones can be found using the following:

[github.com/NixOS/nixpkgs/issues?q=is:issue+is:open+"Vulnerability+roundup"](https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+%22Vulnerability+roundup%22)

Each issue correspond to a vulnerable version of a package; As a consequence:

- One issue can contain several CVEs;
- One CVE can be shared across several issues;
- A single package can be concerned by several issues.


A "Vulnerability roundup" issue usually respects the following format:

```txt
<link to relevant package search on search.nix.gsc.io>, <link to relevant files in Nixpkgs on GitHub>

<list of related CVEs, their CVSS score, and the impacted NixOS version>

<list of the scanned Nixpkgs versions>

<list of relevant contributors>
```

Note that there can be an extra comment containing links to previously reported (and still open) issues for the same package.


#### Triaging and Fixing

**Note**: An issue can be a "false positive" (i.e. automatically opened, but without the package it refers to being actually vulnerable).
If you find such a "false positive", comment on the issue an explanation of why it falls into this category, linking as much information as the necessary to help maintainers double check.

If you are investigating a "true positive":

- Find the earliest patched version or a code patch in the CVE details;
- Is the issue already patched (version up-to-date or patch applied manually) in Nixpkgs's `master` branch?
  - **No**:
    - [Submit a security fix][security-fixes];
    - Once the fix is merged into `master`, [submit the change to the vulnerable release branch(es)](../CONTRIBUTING.md#how-to-backport-pull-requests);
  - **Yes**: [Backport the change to the vulnerable release branch(es)](../CONTRIBUTING.md#how-to-backport-pull-requests).
- When the patch has made it into all the relevant branches (`master`, and the vulnerable releases), close the relevant issue(s).
