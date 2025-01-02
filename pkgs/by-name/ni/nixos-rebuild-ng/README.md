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

If you want to use `nixos-rebuild-ng` without replacing `nixos-rebuild`, add to
your NixOS configuration:

```nix
{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.nixos-rebuild-ng ];
}
```

And use `nixos-rebuild-ng` instead of `nixos-rebuild`.

If you want to completely replace `nixos-rebuild` with `nixos-rebuild-ng`, add
to your NixOS configuration:

```nix
{ ... }:
{
  system.rebuild.enableNg = true;
}
```

This will set `config.system.build.nixos-rebuild` to `nixos-rebuild-ng`, so
all tools that expect it in that location should work.

## Development

Run:

```console
nix-build -A nixos-rebuild-ng -A nixos-rebuild-ng.tests.linters
```

The command above will build, run the unit tests and linters, and also check if
the code is formatted. However, sometimes is more convenient to run just a few
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

## Breaking changes

While `nixos-rebuild-ng` tries to be as much of a clone of the original as
possible, there are still some breaking changes that were done in other to
improve the user experience. If they break your workflow in some way that is
not possible to fix, please open an issue and we can discuss a solution.

- For `--build-host` and `--target-host`, `nixos-rebuild-ng` does not allocate
  a pseudo-TTY via SSH (e.g.: `ssh -t`) anymore. The reason for this is because
  pseudo-TTY breaks some expectations from SSH, like it mangles stdout and
  stderr, and can
  [break terminal output](https://github.com/NixOS/nixpkgs/issues/336967) in
  some situations.
  The issue is that `sudo` needs a TTY to ask for password, otherwise it will
  fail. The solution for this is a new flag, `--ask-sudo-password`, that when
  used with `--target-host` (`--build-host` doesn't need `sudo`), will ask for
  the `sudo` password for the target host using Python's
  [getpass](https://docs.python.org/3/library/getpass.html) and forward it to
  every `sudo` request. Keep in mind that there is no check, so if you type
  your password wrong, it will fail during activation (this can be improved
  though)
- When `--build-host` and `--target-host` is used together, we will use `nix
  copy` (or 2 `nix-copy-closure` if you're using Nix <2.18) instead of SSH'ing
  to build host and using `nix-copy-closure --to target-host`. The reason for
  this is documented in PR
  [#364698](https://github.com/NixOS/nixpkgs/pull/364698). If you do need the
  previous behavior, you can simulate it using `ssh build-host --
  nixos-rebuild-ng switch --target-host target-host`. If that is not the case,
  please open an issue
- We do some additional validation of flags, like exiting with an error when
  `--build-host` or `--target-host` is used with `repl`, since the user could
  assume that the `repl` would be run remotely while it always run the local
  machine. `nixos-rebuild` silently ignored those flags, so this
  [may cause some issues](https://github.com/NixOS/nixpkgs/pull/363922) for
  wrappers

## Caveats

- Bugs in the profile manipulation can cause corruption of your profile that
  may be difficult to fix, so right now I only recommend using
  `nixos-rebuild-ng` if you are testing in a VM or in a filesystem with
  snapshots like btrfs or ZFS. Those bugs are unlikely to be unfixable but the
  errors can be difficult to understand. If you want to go anyway,
  `nix-collect-garbage -d` and `nix store repair` are your friends

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
