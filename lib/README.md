# Nixpkgs lib

This directory contains the implementation, documentation and tests for the Nixpkgs `lib` library.

## Overview

The evaluation entry point for `lib` is [`default.nix`](default.nix).
This file evaluates to an attribute set containing two separate kinds of attributes:
- Sub-libraries:
  Attribute sets grouping together similar functionality.
  Each sub-library is defined in a separate file usually matching its attribute name.

  Example: `lib.lists` is a sub-library containing list-related functionality such as `lib.lists.take` and `lib.lists.imap0`.
  These are defined in the file [`lists.nix`](lists.nix).

- Aliases:
  Attributes that point to an attribute of the same name in some sub-library.

  Example: `lib.take` is an alias for `lib.lists.take`.

Most files in this directory are definitions of sub-libraries, but there are a few others:
- [`minver.nix`](minver.nix): A string of the minimum version of Nix that is required to evaluate Nixpkgs.
- [`tests`](tests): Tests, see [Running tests](#running-tests)
  - [`release.nix`](tests/release.nix): A derivation aggregating all tests
  - [`misc.nix`](tests/misc.nix): Evaluation unit tests for most sub-libraries
  - `*.sh`: Bash scripts that run tests for specific sub-libraries
  - All other files in this directory exist to support the tests
- [`systems`](systems): The `lib.systems` sub-library, structured into a directory instead of a file due to its complexity
- [`path`](path): The `lib.path` sub-library, which includes tests as well as a document describing the design goals of `lib.path`
- All other files in this directory are sub-libraries

### Module system

The [module system](https://nixos.org/manual/nixpkgs/#module-system) spans multiple sub-libraries:
- [`modules.nix`](modules.nix): `lib.modules` for the core functions and anything not relating to option definitions
- [`options.nix`](options.nix): `lib.options` for anything relating to option definitions
- [`types.nix`](types.nix): `lib.types` for module system types

## PR Guidelines

Follow these guidelines for proposing a change to the interface of `lib`.

### Provide a Motivation

Clearly describe why the change is necessary and its use cases.

Make sure that the change benefits the user more than the added mental effort of looking it up and keeping track of its definition.
If the same can reasonably be done with the existing interface,
consider just updating the documentation with more examples and links.
This is also known as the [Fairbairn Threshold](https://wiki.haskell.org/Fairbairn_threshold).

Through this principle we avoid the human cost of duplicated functionality in an overly large library.

### Make one PR for each change

Don't have multiple changes in one PR, instead split it up into multiple ones.

This keeps the conversation focused and has a higher chance of getting merged.

### Name the interface appropriately

When introducing new names to the interface, such as new function, or new function attributes,
make sure to name it appropriately.

Names should be self-explanatory and consistent with the rest of `lib`.
If there's no obvious best name, include the alternatives you considered.

### Write documentation

Update the [reference documentation](#reference-documentation) to reflect the change.

Be generous with links to related functionality.

### Write tests

Add good test coverage for the change, including:

- Tests for edge cases, such as empty values or lists.
- Tests for tricky inputs, such as a string with string context or a path that doesn't exist.
- Test all code paths, such as `if-then-else` branches and returned attributes.
- If the tests for the sub-library are written in bash,
  test messages of custom errors, such as `throw` or `abortMsg`,

  At the time this is only not necessary for sub-libraries tested with [`tests/misc.nix`](./tests/misc.nix).

See [running tests](#running-tests) for more details on the test suites.

### Write tidy code

Name variables well, even if they're internal.
The code should be as self-explanatory as possible.
Be generous with code comments when appropriate.

As a baseline, follow the [Nixpkgs code conventions](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#code-conventions).

### Write efficient code

Nix generally does not have free abstractions.
Be aware that seemingly straightforward changes can cause more allocations and a decrease in performance.
That said, don't optimise prematurely, especially in new code.

## Reference documentation

Reference documentation for library functions is written above each function as a multi-line comment.
These comments are processed using [nixdoc](https://github.com/nix-community/nixdoc) and [rendered in the Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/#chap-functions).
The nixdoc README describes the [comment format](https://github.com/nix-community/nixdoc#comment-format).

See [doc/README.md](../doc/README.md) for how to build the manual.

## Running tests

All library tests can be run by building the derivation in [`tests/release.nix`](tests/release.nix):

```bash
nix-build tests/release.nix
```

Some commands for quicker iteration over parts of the test suite are also available:

```bash
# Run all evaluation unit tests in tests/misc.nix
# if the resulting list is empty, all tests passed
nix-instantiate --eval --strict tests/misc.nix

# Run the module system tests
tests/modules.sh

# Run the lib.sources tests
tests/sources.sh

# Run the lib.filesystem tests
tests/filesystem.sh

# Run the lib.path property tests
path/tests/prop.sh

# Run the lib.fileset tests
fileset/tests.sh
```

## Commit conventions

- Make sure you read about the [commit conventions](../CONTRIBUTING.md#commit-conventions) common to Nixpkgs as a whole.

- Format the commit messages in the following way:

  ```
  lib.(section): (init | add additional argument | refactor | etc)

  (Motivation for change. Additional information.)
  ```

  Examples:

  * lib.getExe': check arguments
  * lib.fileset: Add an additional argument in the design docs

    Closes #264537

