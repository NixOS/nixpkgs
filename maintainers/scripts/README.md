# Maintainer scripts

This folder contains various executable scripts for nixpkgs maintainers,
and supporting data or nixlang files as needed.
These scripts generally aren't a stable interface and may changed or be removed.

What follows is a (very incomplete) overview of available scripts.


## Metadata

### `get-maintainer.sh`

`get-maintainer.sh [selector] value` returns a JSON object describing
a given nixpkgs maintainer, equivalent to `lib.maintainers.${x} // { handle = x; }`.

This allows looking up a maintainer's attrset (including GitHub and Matrix
handles, email address etc.) based on any of their handles, more correctly and
robustly than text search through `maintainers-list.nix`.

The maintainer is designated by a `selector` which must be one of:
- `handle` (default): the maintainer's attribute name in `lib.maintainers`;
- `email`, `name`, `github`, `githubId`, `matrix`, `name`:
  attributes of the maintainer's object, matched exactly;
  see [`maintainer-list.nix`] for the fields' definition.

[`maintainer-list.nix`]: ../maintainer-list.nix
