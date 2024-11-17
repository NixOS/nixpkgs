# Emacs Lisp {#emacs-lisp}

Since at least version 24, Emacs has a native package manager, `package.el`.
Since its inception, many Elisp packages were created by Emacs community at large, as well as Elisp package repositories.

<!--
Note: add a sun chapter about melpaBuild
-->

### Bulk Update {#sec-emacs-elisp-packages-bulk-update}

The chief Elisp package repositories are [GNU ELPA](https://elpa.gnu.org/), [NonGNU ELPA](https://elpa.nongnu.org/), and [MELPA](https://melpa.org/).

Nixpkgs provides a comprehensive infrastucture that leverages the contents of these Elisp repositories as Nix packages. This chapter  describes the bulk-updating automation tooling.

Inside the `emacs` directory lives the `elisp-packages` subdirectory.
Inside it we provide the following scripts:

- `update-scripts_library.sh`

  This file serves as a library, containing useful functions to deal with bulk updates.
  It can be `source`'d in both interactive and batch environments.

  This library provides the following functions:

  - `download_packageset`

    This function downloads from [`nix-community` Emacs Overlay](https://github.com/nix-community/emacs-overlay) the corresponding files.

    It accepts one argument.
    This argument can assume one of the following values:
    `elpa`, `elpa-devel`,  `melpa`, `melpa-stable`, `nongnu`, `nongnu-devel`.

  - `test_packageset`

    This function runs a simple test that instantiates the corresponding package set.

    It accepts one argument.
    This argument can assume one of the following values:
    `elpa`, `elpa-devel`,  `melpa`, `melpa-stable`, `nongnu`, `nongnu-devel`.

  - `commit_packageset`

    This function commits the corresponding package set to the Nixpkgs repository, writing a one-line descriptive commit message.

    It accepts two arguments.

    The first argument can assume one of the following values: `elpa`,
    `elpa-devel`, `melpa`, `melpa-stable`, `nongnu`, `nongnu-devel`.
    The second argument is an optional free-form string used verbatim, describing the origin of the change being committed.
    Its default value is `interactive session`.

- `update-package-sets`

  This script updates the package sets passed to it as arguments.

  It accepts multiple arguments.
  Each argument can assume one of the following values:
  `elpa`, `elpa-devel`, `nongnu`, `nongnu-devel`.

- `update-melpa`

  This script updates `recipes-archive-melpa.json`, a JSON file that describes the MELPA package set.

  It accepts no arguments.

- `update-from-overlay`

  This script downloads all the packagesets from overlay, then tests and commits them.

  It accepts no arguments.
- `update-scripts_library.sh`

  This file serves as a library, containing useful functions to deal with bulk updates.
  It can be `source`'d in both interactive and batch environments.

  This library provides the following functions:

  - `download_packageset`

    This function downloads from [`nix-community` Emacs Overlay](https://github.com/nix-community/emacs-overlay) the corresponding files.

    It accepts one argument.
    This argument can assume one of the following values:
    `elpa`, `elpa-devel`,  `melpa`, `melpa-stable`, `nongnu`, `nongnu-devel`.

  - `test_packageset`

    This function runs a simple test that instantiates the corresponding package set.

    It accepts one argument.
    This argument can assume one of the following values:
    `elpa`, `elpa-devel`,  `melpa`, `melpa-stable`, `nongnu`, `nongnu-devel`.

  - `commit_packageset`

    This function commits the corresponding package set to the Nixpkgs repository, writing a one-line descriptive commit message.

    It accepts two arguments.

    The first argument can assume one of the following values: `elpa`,
    `elpa-devel`, `melpa`, `melpa-stable`, `nongnu`, `nongnu-devel`.
    The second argument is an optional free-form string used verbatim, describing the origin of the change being committed.
    Its default value is `interactive session`.

- `update-package-sets`

  This script updates the package sets passed to it as arguments.

  It accepts multiple arguments.
  Each argument can assume one of the following values:
  `elpa`, `elpa-devel`, `nongnu`, `nongnu-devel`.

- `update-melpa`

  This script updates `recipes-archive-melpa.json`, a JSON file that describes the MELPA package set.

  It accepts no arguments.

- `update-from-overlay`

  This script downloads all the packagesets from overlay, then tests and commits them.

  It accepts no arguments.
