# Emacs Lisp {#sec-emacs-lisp}

Since at least version 24, Emacs has a native package manager, `package.el`. Since its inception, many Elisp packages were created by Emacs community at large, as well as package repositories.

<!--
TODO: add a chapter about melpaBuild and the general Elisp Nix framework
-->

## Bulk Update {#sec-emacs-lisp-packages-bulk-update}

The chief Elisp package repositories are:

- [GNU ELPA](https://elpa.gnu.org/),
- [NonGNU ELPA](https://elpa.nongnu.org/), and
- [MELPA](https://melpa.org/).

Nixpkgs provides a comprehensive infrastucture that leverages the contents of these Elisp repositories as Nix packages. Here we will the bulk-updating automation tooling.

Inside the `pkgs/applications/editors/emacs/elisp-packages` subdirectory we find the following scripts:

- `update-package-sets`

  This script updates the package sets passed to it as arguments.

  It accepts multiple arguments.

  The only acceptable arguments are: `elpa`, `elpa-devel`, `nongnu`, `nongnu-devel`.

  When an argument is not recognized, the whole function bails out with an error message.

- `update-melpa`

  This script updates `recipes-archive-melpa.json`, a JSON file that describes the MELPA package set.

  It ignores the arguments.

- `update-from-overlay`

  This script downloads all the packagesets from overlay, then tests and commits them.

  It ignores the arguments.
