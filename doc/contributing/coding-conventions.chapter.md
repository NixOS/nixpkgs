# Coding conventions {#chap-conventions}

## Syntax {#sec-syntax}

- Use 2 spaces of indentation per indentation level in Nix expressions, 4 spaces in shell scripts.

- Do not use tab characters, i.e. configure your editor to use soft tabs. For instance, use `(setq-default indent-tabs-mode nil)` in Emacs. Everybody has different tab settings so it’s asking for trouble.

- Use `lowerCamelCase` for variable names, not `UpperCamelCase`. Note, this rule does not apply to package attribute names, which instead follow the rules in [](#sec-package-naming).

- Function calls with attribute set arguments are written as

  ```nix
  foo {
    arg = ...;
  }
  ```

  not

  ```nix
  foo
  {
    arg = ...;
  }
  ```

  Also fine is

  ```nix
  foo { arg = ...; }
  ```

  if it's a short call.

- In attribute sets or lists that span multiple lines, the attribute names or list elements should be aligned:

  ```nix
  # A long list.
  list = [
    elem1
    elem2
    elem3
  ];

  # A long attribute set.
  attrs = {
    attr1 = short_expr;
    attr2 =
      if true then big_expr else big_expr;
  };

  # Combined
  listOfAttrs = [
    {
      attr1 = 3;
      attr2 = "fff";
    }
    {
      attr1 = 5;
      attr2 = "ggg";
    }
  ];
  ```

- Short lists or attribute sets can be written on one line:

  ```nix
  # A short list.
  list = [ elem1 elem2 elem3 ];

  # A short set.
  attrs = { x = 1280; y = 1024; };
  ```

- Breaking in the middle of a function argument can give hard-to-read code, like

  ```nix
  someFunction { x = 1280;
    y = 1024; } otherArg
    yetAnotherArg
  ```

  (especially if the argument is very large, spanning multiple lines).

  Better:

  ```nix
  someFunction
    { x = 1280; y = 1024; }
    otherArg
    yetAnotherArg
  ```

  or

  ```nix
  let res = { x = 1280; y = 1024; };
  in someFunction res otherArg yetAnotherArg
  ```

- The bodies of functions, asserts, and withs are not indented to prevent a lot of superfluous indentation levels, i.e.

  ```nix
  { arg1, arg2 }:
  assert system == "i686-linux";
  stdenv.mkDerivation { ...
  ```

  not

  ```nix
  { arg1, arg2 }:
    assert system == "i686-linux";
      stdenv.mkDerivation { ...
  ```

- Function formal arguments are written as:

  ```nix
  { arg1, arg2, arg3 }:
  ```

  but if they don't fit on one line they're written as:

  ```nix
  { arg1, arg2, arg3
  , arg4, ...
  , # Some comment...
    argN
  }:
  ```

- Functions should list their expected arguments as precisely as possible. That is, write

  ```nix
  { stdenv, fetchurl, perl }: ...
  ```

  instead of

  ```nix
  args: with args; ...
  ```

  or

  ```nix
  { stdenv, fetchurl, perl, ... }: ...
  ```

  For functions that are truly generic in the number of arguments (such as wrappers around `mkDerivation`) that have some required arguments, you should write them using an `@`-pattern:

  ```nix
  { stdenv, doCoverageAnalysis ? false, ... } @ args:

  stdenv.mkDerivation (args // {
    ... if doCoverageAnalysis then "bla" else "" ...
  })
  ```

  instead of

  ```nix
  args:

  args.stdenv.mkDerivation (args // {
    ... if args ? doCoverageAnalysis && args.doCoverageAnalysis then "bla" else "" ...
  })
  ```

- Unnecessary string conversions should be avoided. Do

  ```nix
  rev = version;
  ```

  instead of

  ```nix
  rev = "${version}";
  ```

- Building lists conditionally _should_ be done with `lib.optional(s)` instead of using `if cond then [ ... ] else null` or `if cond then [ ... ] else [ ]`.

  ```nix
  buildInputs = lib.optional stdenv.isDarwin iconv;
  ```

  instead of

  ```nix
  buildInputs = if stdenv.isDarwin then [ iconv ] else null;
  ```

  As an exception, an explicit conditional expression with null can be used when fixing a important bug without triggering a mass rebuild.
  If this is done a follow up pull request _should_ be created to change the code to `lib.optional(s)`.

- Arguments should be listed in the order they are used, with the exception of `lib`, which always goes first.

## Package naming {#sec-package-naming}

The key words _must_, _must not_, _required_, _shall_, _shall not_, _should_, _should not_, _recommended_, _may_, and _optional_ in this section are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119). Only _emphasized_ words are to be interpreted in this way.

In Nixpkgs, there are generally three different names associated with a package:

- The `name` attribute of the derivation (excluding the version part). This is what most users see, in particular when using `nix-env`.

- The variable name used for the instantiated package in `all-packages.nix`, and when passing it as a dependency to other functions. Typically this is called the _package attribute name_. This is what Nix expression authors see. It can also be used when installing using `nix-env -iA`.

- The filename for (the directory containing) the Nix expression.

Most of the time, these are the same. For instance, the package `e2fsprogs` has a `name` attribute `"e2fsprogs-version"`, is bound to the variable name `e2fsprogs` in `all-packages.nix`, and the Nix expression is in `pkgs/os-specific/linux/e2fsprogs/default.nix`.

There are a few naming guidelines:

- The `pname` attribute _should_ be identical to the upstream package name.

- The `pname` and the `version` attribute _must not_ contain uppercase letters — e.g., `"mplayer" instead of `"MPlayer"`.

- The `version` attribute _must_ start with a digit e.g`"0.3.1rc2".

- If a package is not a release but a commit from a repository, then the `version` attribute _must_ be the date of that (fetched) commit. The date _must_ be in `"unstable-YYYY-MM-DD"` format.

- Dashes in the package `pname` _should_ be preserved in new variable names, rather than converted to underscores or camel cased — e.g., `http-parser` instead of `http_parser` or `httpParser`. The hyphenated style is preferred in all three package names.

- If there are multiple versions of a package, this _should_ be reflected in the variable names in `all-packages.nix`, e.g. `json-c_0_9` and `json-c_0_11`. If there is an obvious “default” version, make an attribute like `json-c = json-c_0_9;`. See also [](#sec-versioning)

## File naming and organisation {#sec-organisation}

Names of files and directories should be in lowercase, with dashes between words — not in camel case. For instance, it should be `all-packages.nix`, not `allPackages.nix` or `AllPackages.nix`.

### Hierarchy {#sec-hierarchy}

Each package should be stored in its own directory somewhere in the `pkgs/` tree, i.e. in `pkgs/category/subcategory/.../pkgname`. Below are some rules for picking the right category for a package. Many packages fall under several categories; what matters is the _primary_ purpose of a package. For example, the `libxml2` package builds both a library and some tools; but it’s a library foremost, so it goes under `pkgs/development/libraries`.

When in doubt, consider refactoring the `pkgs/` tree, e.g. creating new categories or splitting up an existing category.

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

### Versioning {#sec-versioning}

Because every version of a package in Nixpkgs creates a potential maintenance burden, old versions of a package should not be kept unless there is a good reason to do so. For instance, Nixpkgs contains several versions of GCC because other packages don’t build with the latest version of GCC. Other examples are having both the latest stable and latest pre-release version of a package, or to keep several major releases of an application that differ significantly in functionality.

If there is only one version of a package, its Nix expression should be named `e2fsprogs/default.nix`. If there are multiple versions, this should be reflected in the filename, e.g. `e2fsprogs/1.41.8.nix` and `e2fsprogs/1.41.9.nix`. The version in the filename should leave out unnecessary detail. For instance, if we keep the latest Firefox 2.0.x and 3.5.x versions in Nixpkgs, they should be named `firefox/2.0.nix` and `firefox/3.5.nix`, respectively (which, at a given point, might contain versions `2.0.0.20` and `3.5.4`). If a version requires many auxiliary files, you can use a subdirectory for each version, e.g. `firefox/2.0/default.nix` and `firefox/3.5/default.nix`.

All versions of a package _must_ be included in `all-packages.nix` to make sure that they evaluate correctly.

## Fetching Sources {#sec-sources}

There are multiple ways to fetch a package source in nixpkgs. The general guideline is that you should package reproducible sources with a high degree of availability. Right now there is only one fetcher which has mirroring support and that is `fetchurl`. Note that you should also prefer protocols which have a corresponding proxy environment variable.

You can find many source fetch helpers in `pkgs/build-support/fetch*`.

In the file `pkgs/top-level/all-packages.nix` you can find fetch helpers, these have names on the form `fetchFrom*`. The intention of these are to provide snapshot fetches but using the same api as some of the version controlled fetchers from `pkgs/build-support/`. As an example going from bad to good:

- Bad: Uses `git://` which won't be proxied.

  ```nix
  src = fetchgit {
    url = "git://github.com/NixOS/nix.git";
    rev = "1f795f9f44607cc5bec70d1300150bfefcef2aae";
    sha256 = "1cw5fszffl5pkpa6s6wjnkiv6lm5k618s32sp60kvmvpy7a2v9kg";
  }
  ```

- Better: This is ok, but an archive fetch will still be faster.

  ```nix
  src = fetchgit {
    url = "https://github.com/NixOS/nix.git";
    rev = "1f795f9f44607cc5bec70d1300150bfefcef2aae";
    sha256 = "1cw5fszffl5pkpa6s6wjnkiv6lm5k618s32sp60kvmvpy7a2v9kg";
  }
  ```

- Best: Fetches a snapshot archive and you get the rev you want.

  ```nix
  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nix";
    rev = "1f795f9f44607cc5bec70d1300150bfefcef2aae";
    sha256 = "1i2yxndxb6yc9l6c99pypbd92lfq5aac4klq7y2v93c9qvx2cgpc";
  }
  ```

When fetching from GitHub, commits must always be referenced by their full commit hash. This is because GitHub shares commit hashes among all forks and returns `404 Not Found` when a short commit hash is ambiguous. It already happens for some short, 6-character commit hashes in `nixpkgs`.
It is a practical vector for a denial-of-service attack by pushing large amounts of auto generated commits into forks and was already [demonstrated against GitHub Actions Beta](https://blog.teddykatz.com/2019/11/12/github-actions-dos.html).

Find the value to put as `sha256` by running `nix-shell -p nix-prefetch-github --run "nix-prefetch-github --rev 1f795f9f44607cc5bec70d1300150bfefcef2aae NixOS nix"`. 

## Obtaining source hash {#sec-source-hashes}

Preferred source hash type is sha256. There are several ways to get it.

1. Prefetch URL (with `nix-prefetch-XXX URL`, where `XXX` is one of `url`, `git`, `hg`, `cvs`, `bzr`, `svn`). Hash is printed to stdout.

2. Prefetch by package source (with `nix-prefetch-url '<nixpkgs>' -A PACKAGE.src`, where `PACKAGE` is package attribute name). Hash is printed to stdout.

    This works well when you've upgraded existing package version and want to find out new hash, but is useless if package can't be accessed by attribute or package has multiple sources (`.srcs`, architecture-dependent sources, etc).

3. Upstream provided hash: use it when upstream provides `sha256` or `sha512` (when upstream provides `md5`, don't use it, compute `sha256` instead).

    A little nuance is that `nix-prefetch-*` tools produce hash encoded with `base32`, but upstream usually provides hexadecimal (`base16`) encoding. Fetchers understand both formats. Nixpkgs does not standardize on any one format.

    You can convert between formats with nix-hash, for example:

    ```ShellSession
    $ nix-hash --type sha256 --to-base32 HASH
    ```

4. Extracting hash from local source tarball can be done with `sha256sum`. Use `nix-prefetch-url file:///path/to/tarball` if you want base32 hash.

5. Fake hash: set fake hash in package expression, perform build and extract correct hash from error Nix prints.

    For package updates it is enough to change one symbol to make hash fake. For new packages, you can use `lib.fakeSha256`, `lib.fakeSha512` or any other fake hash.

    This is last resort method when reconstructing source URL is non-trivial and `nix-prefetch-url -A` isn’t applicable (for example, [one of `kodi` dependencies](https://github.com/NixOS/nixpkgs/blob/d2ab091dd308b99e4912b805a5eb088dd536adb9/pkgs/applications/video/kodi/default.nix#L73)). The easiest way then would be replace hash with a fake one and rebuild. Nix build will fail and error message will contain desired hash.

::: {.warning}
This method has security problems. Check below for details.
:::

### Obtaining hashes securely {#sec-source-hashes-security}

Let's say Man-in-the-Middle (MITM) sits close to your network. Then instead of fetching source you can fetch malware, and instead of source hash you get hash of malware. Here are security considerations for this scenario:

- `http://` URLs are not secure to prefetch hash from;

- hashes from upstream (in method 3) should be obtained via secure protocol;

- `https://` URLs are secure in methods 1, 2, 3;

- `https://` URLs are not secure in method 5. When obtaining hashes with fake hash method, TLS checks are disabled. So refetch source hash from several different networks to exclude MITM scenario. Alternatively, use fake hash method to make Nix error, but instead of extracting hash from error, extract `https://` URL and prefetch it with method 1.

## Patches {#sec-patches}

Patches available online should be retrieved using `fetchpatch`.

```nix
patches = [
  (fetchpatch {
    name = "fix-check-for-using-shared-freetype-lib.patch";
    url = "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=8f5d285";
    sha256 = "1f0k043rng7f0rfl9hhb89qzvvksqmkrikmm38p61yfx51l325xr";
  })
];
```

Otherwise, you can add a `.patch` file to the `nixpkgs` repository. In the interest of keeping our maintenance burden to a minimum, only patches that are unique to `nixpkgs` should be added in this way.

If a patch is available online but does not cleanly apply, it can be modified in some fixed ways by using additional optional arguments for `fetchpatch`. Check [](#fetchpatch) for details.

```nix
patches = [ ./0001-changes.patch ];
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

## Package tests {#sec-package-tests}

Tests are important to ensure quality and make reviews and automatic updates easy.

The following types of tests exists:

* [NixOS **module tests**](https://nixos.org/manual/nixos/stable/#sec-nixos-tests), which spawn one or more NixOS VMs. They exercise both NixOS modules and the packaged programs used within them. For example, a NixOS module test can start a web server VM running the `nginx` module, and a client VM running `curl` or a graphical `firefox`, and test that they can talk to each other and display the correct content.
* Nix **package tests** are a lightweight alternative to NixOS module tests. They should be used to create simple integration tests for packages, but cannot test NixOS services, and some programs with graphical user interfaces may also be difficult to test with them.
* The **`checkPhase` of a package**, which should execute the unit tests that are included in the source code of a package.

Here in the nixpkgs manual we describe mostly _package tests_; for _module tests_ head over to the corresponding [section in the NixOS manual](https://nixos.org/manual/nixos/stable/#sec-nixos-tests).

### Writing inline package tests {#ssec-inline-package-tests-writing}

For very simple tests, they can be written inline:

```nix
{ …, yq-go }:

buildGoModule rec {
  …

  passthru.tests = {
    simple = runCommand "${pname}-test" {} ''
      echo "test: 1" | ${yq-go}/bin/yq eval -j > $out
      [ "$(cat $out | tr -d $'\n ')" = '{"test":1}' ]
    '';
  };
}
```

### Writing larger package tests {#ssec-package-tests-writing}

This is an example using the `phoronix-test-suite` package with the current best practices.

Add the tests in `passthru.tests` to the package definition like this:

```nix
{ stdenv, lib, fetchurl, callPackage }:

stdenv.mkDerivation {
  …

  passthru.tests = {
    simple-execution = callPackage ./tests.nix { };
  };

  meta = { … };
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

### Running package tests {#ssec-package-tests-running}

You can run these tests with:

```ShellSession
$ cd path/to/nixpkgs
$ nix-build -A phoronix-test-suite.tests
```

### Examples of package tests {#ssec-package-tests-examples}

Here are examples of package tests:

- [Jasmin compile test](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/compilers/jasmin/test-assemble-hello-world/default.nix)
- [Lobster compile test](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/compilers/lobster/test-can-run-hello-world.nix)
- [Spacy annotation test](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/python-modules/spacy/annotation-test/default.nix)
- [Libtorch test](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/science/math/libtorch/test/default.nix)
- [Multiple tests for nanopb](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/nanopb/default.nix)

### Linking NixOS module tests to a package {#ssec-nixos-tests-linking}

Like [package tests](#ssec-package-tests-writing) as shown above, [NixOS module tests](https://nixos.org/manual/nixos/stable/#sec-nixos-tests) can also be linked to a package, so that the tests can be easily run when changing the related package.

For example, assuming we're packaging `nginx`, we can link its module test via `passthru.tests`:

```nix
{ stdenv, lib, nixosTests }:

stdenv.mkDerivation {
  ...

  passthru.tests = {
    nginx = nixosTests.nginx;
  };

  ...
}
```
