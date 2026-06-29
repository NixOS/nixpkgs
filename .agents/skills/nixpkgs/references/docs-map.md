# Docs map (open live files — do not treat this table as policy text)

Paths are relative to the **nixpkgs repository root**. Read the target when the topic applies. Prefer the file over memory.

| Topic | Open |
|-------|------|
| Contributing overview, PR how-to, rebase, backport, review/merge culture | `CONTRIBUTING.md` |
| Pull request template / Things done checkboxes | `.github/PULL_REQUEST_TEMPLATE.md` |
| Branch choice (`master`, `staging`, `staging-nixos`, `release-*`), mass rebuilds | `CONTRIBUTING.md` → Branch conventions |
| Staging workflow / Hydra batching (only if you need merge-flow context) | `CONTRIBUTING.md` → Staging |
| Commit conventions (repo-wide) | `CONTRIBUTING.md` → Commit conventions |
| Code conventions, formatting (`nix fmt` / `treefmt`), editorconfig | `CONTRIBUTING.md` → Code conventions |
| Automation / AI policy (`Assisted-by`, accountability, exemptions) | `CONTRIBUTING.md` → Automation/AI policy |
| Packages: layout, init gates, naming, versioning, meta | `pkgs/README.md` |
| Package commit subject (`attr: old -> new`, `init at`, CI build prefixes) | `pkgs/README.md` → Commit conventions |
| Sources, hashes, GitHub full `rev`, patches | `pkgs/README.md` → Sources (and Patches) |
| Package tests, `passthru.tests`, linking NixOS tests | `pkgs/README.md` → Package tests |
| Automatic updates / `passthru.updateScript` | `pkgs/README.md` → Automatic package updates |
| Reviewing package PRs (human reviewer notes) | `pkgs/README.md` → Reviewing contributions |
| `pkgs/by-name` layout and rules | `pkgs/by-name/README.md` |
| Language / framework builders | `doc/languages-frameworks/<lang>.section.md` |
| Fetchers (manual) | Nixpkgs manual § fetchers (from `pkgs/README.md` Sources links) |
| NixOS modules and tests in-tree | `nixos/README.md`; tests also linked from PR template |
| `lib` contributions | `lib/README.md` |
| Nixpkgs manual / `doc` | `doc/README.md` |
| Maintainers list, becoming a maintainer | `maintainers/README.md` |
| ofborg behavior | https://github.com/NixOS/ofborg#readme (linked from CONTRIBUTING) |
| `nixpkgs-review` usage and flags | https://github.com/Mic92/nixpkgs-review#usage — also `CONTRIBUTING.md` PR template section; default commands in [review-default.md](review-default.md) |
| Custom review setups (optional agent skill) | User/project skill named `nixpkgs-review` |

## Task → first opens

| Task | Open first |
|------|------------|
| Version bump / package fix | Package expression; `pkgs/README.md` (Sources, commit conventions); then review strategy |
| New package | `pkgs/README.md` Quick Start + gates; `pkgs/by-name/README.md`; similar packages |
| Mass-rebuild / stdenv / widely used dep | `CONTRIBUTING.md` Branch conventions **before** large commits to `master` |
| NixOS module | `nixos/README.md`; related module tests |
| `lib` change | `lib/README.md` |
| Docs-only | `doc/README.md` |
| Add maintainer entry | `maintainers/README.md` (separate commit message convention in CONTRIBUTING) |
| Backport | `CONTRIBUTING.md` → How to backport pull requests |
| Review someone else’s PR | `CONTRIBUTING.md` → How to review; optional `nixpkgs-review` skill or [review-default.md](review-default.md) `pr` |
