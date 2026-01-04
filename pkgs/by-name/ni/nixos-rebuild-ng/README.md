# nixos-rebuild-ng

`nixos-rebuild-ng` is a command-line tool that builds and switches your NixOS
system to a new configuration based on your `configuration.nix` and related Nix
files.

## Development

Run:

```console
nix-build -A nixos-rebuild-ng -A nixos-rebuild-ng.tests.linters
```

The command above will build, run the unit tests and linters, and also check if
the code is formatted. However, sometimes it's more convenient to run just a few
tests to debug, in this case you can run:

```console
nix-shell -A nixos-rebuild-ng.devShell
```

The command above should automatically put you inside `src` directory, and you
can run:

```console
# run program
python -m nixos_rebuild
# run tests
pytest
# check types
mypy .
# fix lint issues
ruff check --fix .
# format code
ruff format .
```
