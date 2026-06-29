# Default review strategy (`nixpkgs-review`)

Use this file **only** when no user instruction overrides review **and** no skill named `nixpkgs-review` is installed.

Canonical mentions: [`CONTRIBUTING.md`](../../../../CONTRIBUTING.md) (PR template / Things done section), [Mic92/nixpkgs-review usage](https://github.com/Mic92/nixpkgs-review#usage).

Run from the **nixpkgs git checkout** (not a random subdirectory outside the tree). Prefer a full clone; shallow clones can break merges (upstream README).

## Commands

| Situation | Command |
|-----------|---------|
| Uncommitted changes | `nix-shell -p nixpkgs-review --run "nixpkgs-review wip"` |
| Staged only | `nix-shell -p nixpkgs-review --run "nixpkgs-review wip --staged"` |
| Local commit(s) | `nix-shell -p nixpkgs-review --run "nixpkgs-review rev HEAD"` |
| GitHub PR by number or URL | `nix run nixpkgs#nixpkgs-review -- pr <N-or-URL>` |
| Post markdown result on PR (reviewer) | `nixpkgs-review pr <N> --post-result` (optional `--no-logs`) |
| Non-interactive / agent | add `--no-shell` where supported; see Mic92 README for current flags |

Flake-style equivalents of the shell form are fine, e.g. `nix run nixpkgs#nixpkgs-review -- wip`.

## After a successful build

- Exercise relevant binaries (often `./result/bin/` or paths from the review environment).
- Run applicable package tests (`passthru.tests`) and NixOS tests if the change warrants it — see PR template links and `pkgs/README.md` § Package tests.
- Record **only** platforms you actually built on in Things done.
- Do **not** claim `nixpkgs-review` in the PR unless you ran it (or the active custom skill’s equivalent).

## Flags and advanced behavior

Do not invent flags. Open [Mic92/nixpkgs-review](https://github.com/Mic92/nixpkgs-review#usage) for `--systems`, package filters, `--post-result`, tokens, etc.

Optional tools (`nom`, `glow`, `delta`, remote builders) are **not** required by this default strategy. Put personal stacks in a **`nixpkgs-review`** skill.
