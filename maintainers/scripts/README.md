# Maintainer scripts

This folder contains various executable scripts for nixpkgs maintainers,
and supporting data or nixlang files as needed.
These scripts generally aren't a stable interface and may changed or be removed.

What follows is a (very incomplete) overview of available scripts.


## Metadata

### `check-by-name.sh`

An alias for `pkgs/test/check-by-name/run-local.sh`, see [documentation](../../pkgs/test/check-by-name/README.md).

### `get-maintainer.sh`

`get-maintainer.sh [selector] value` returns a JSON object describing
a given nixpkgs maintainer, equivalent to `lib.maintainers.${x} // { handle = x; }`.

This allows looking up a maintainer's attrset (including GitHub and Matrix
handles, email address etc.) based on any of their handles, more correctly and
robustly than text search through `maintainers-list.nix`.

```
❯ ./get-maintainer.sh nicoo
{
  "email": "nicoo@debian.org",
  "github": "nbraud",
  "githubId": 1155801,
  "keys": [
    {
      "fingerprint": "E44E 9EA5 4B8E 256A FB73 49D3 EC9D 3708 72BC 7A8C"
    }
  ],
  "name": "nicoo",
  "handle": "nicoo"
}

❯ ./get-maintainer.sh name 'Silvan Mosberger'
{
  "email": "contact@infinisil.com",
  "github": "infinisil",
  "githubId": 20525370,
  "keys": [
    {
      "fingerprint": "6C2B 55D4 4E04 8266 6B7D  DA1A 422E 9EDA E015 7170"
    }
  ],
  "matrix": "@infinisil:matrix.org",
  "name": "Silvan Mosberger",
  "handle": "infinisil"
}
```

The maintainer is designated by a `selector` which must be one of:
- `handle` (default): the maintainer's attribute name in `lib.maintainers`;
- `email`, `name`, `github`, `githubId`, `matrix`, `name`:
  attributes of the maintainer's object, matched exactly;
  see [`maintainer-list.nix`] for the fields' definition.

[`maintainer-list.nix`]: ../maintainer-list.nix
