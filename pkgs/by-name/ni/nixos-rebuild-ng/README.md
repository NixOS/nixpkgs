# nixos-rebuild-ng

Work-in-Progress rewrite of
[`nixos-rebuild`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh).

## Why the rewrite?

The current state of `nixos-rebuild` is dare: it is one of the most critical
piece of code we have in NixOS, but it has tons of issues:
- The code is written in Bash, and while this by itself is not necessary bad,
  it means that it is difficult to do refactorings due to the lack of tooling
  for the language
- The code itself is a hacky mess. Changing even one line of code can cause
  issues that affects dozens of people
- Lack of proper testing (we do have some integration tests, but no unit tests
  and coverage is probably pitiful)
- The code predates some of the improvements `nix` had over the years, e.g.: it
  builds Flakes inside a temporary directory and read the resulting symlink
  since the code seems to predate `--print-out-paths` flag

Given all of those above, improvements in the `nixos-rebuild` are difficult to
do. A full rewrite is probably the easier way to improve the situation since
this can be done in a separate package that will not break anyone. So this is
an attempt of the rewrite.

## Why Python?

- It is the language of choice for many critical things inside `nixpkgs`, like
  the `NixOSTest` and `systemd-boot-builder.py` activation scripts
- It is a language with great tooling, e.g.: `mypy` for type checking, `ruff`
  for linting, `pytest` for unit testing
- It is a scripting language that fits well with the scope of this project
- Python's standard library is great and it means we will need a low number of
  external dependencies for this project. For example, `nixos-rebuild`
  currently depends in `jq` for JSON parsing, while Python has `json` in
  standard library

## Do's and Don'ts

- Do: be as much of a drop-in replacement as possible
- Do: fix obvious bugs
- Do: improvements that are non-breaking
- Don't: change logic in breaking ways even if this would be an improvement

## How to use

```nix
{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.nixos-rebuild-ng ];
}
```

And use `nixos-rebuild-ng` instead of `nixos-rebuild`.

## Development

Run:

```console
nix-build -A nixos-rebuild-ng.tests.ci
```

The command above will run the unit tests and linters, and also check if the
code is formatted. However, sometimes is more convenient to run just a few
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

## Current caveats

- For now we will install it in `nixos-rebuild-ng` path by default, to avoid
  conflicting with the current `nixos-rebuild`. This means you can keep both in
  your system at the same time, but it also means that a few things like bash
  completion are broken right now (since it looks at `nixos-rebuild` binary)
- Bugs in the profile manipulation can cause corruption of your profile that
  may be difficult to fix, so right now I only recommend using
  `nixos-rebuild-ng` if you are testing in a VM or in a filesystem with
  snapshots like btrfs or ZFS. Those bugs are unlikely to be unfixable but the
  errors can be difficult to understand. If you want to go anyway,
  `nix-collect-garbage -d` and `nix store repair` are your friends

## TODO

- [x] Remote host/builders (via SSH)
- [x] Improve nix arguments handling (e.g.: `nixFlags` vs `copyFlags` in the
  old `nixos-rebuild`)
- [x] `_NIXOS_REBUILD_REEXEC`
- [ ] Port `nixos-rebuild.passthru.tests`
- [ ] Change module system to allow easier opt-in, like
  `system.switch.enableNg` for `switch-to-configuration-ng`
- [x] Improve documentation
- [x] `nixos-rebuild repl`
- [x] Generate tab completion via [`shtab`](https://docs.iterative.ai/shtab/)
- [x] Reduce build closure

## TODON'T

- Reimplement `systemd-run` logic: will be moved to the new
  [`apply`](https://github.com/NixOS/nixpkgs/pull/344407) script
- Nix bootstrap: it is only used for non-Flake paths and it is basically
  useless nowadays. It was created at a time when Nix was changing frequently
  and there was a need to bootstrap a new version of Nix before evaluating the
  configuration (otherwise the new Nixpkgs version may have code that is only
  compatible with a newer version of Nix). Nixpkgs now has a policy to be
  compatible with Nix 2.3, and even if this is bumped as long we don't do
  drastic minimum version changes this should not be an issue. Also, the daemon
  itself always run with the previous version since even we can replace Nix in
  `PATH` (so Nix client), but we can't replace the daemon without switching to
  a new version.
