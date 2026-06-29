---
name: nixpkgs
description: >
  AI entrypoint for NixOS/nixpkgs in this checkout: route to live contributor
  docs, enforce non-negotiable guidelines (Automation/AI policy, Assisted-by,
  PR Things done honesty), reduce reviewer noise, and verify with
  nixpkgs-review (use nixpkgs-review skill if present, else default wip/rev/pr).
  Use for package bumps/fixes/inits, hashes, branches, commits, draft PRs,
  CI follow-up, modules, maintainers—not unattended mass AI spam.
---

# nixpkgs (agent entrypoint)

Nixpkgs is **high-scrutiny** for AI output. Unattended or low-quality LLM PRs are **reviewer noise** and may violate the [Automation/AI policy](../../../CONTRIBUTING.md#automationai-policy). This skill is **not** a copy of the docs: it routes you to **where to look** and states **non‑negotiables** so contributions stay small, disclosed, verified, and mergeable.

**On conflict: live in-tree docs win.** Fix the skill later; do not invent policy.

## Always / Ask / Never

### Always

- Optimize for **reviewer trust**: human-in-the-loop understanding, minimal scope, honest claims.
- Open the **live file** for the topic (see [references/docs-map.md](references/docs-map.md)); do not guess guidelines.
- Package commits: subject format from [`pkgs/README.md` § Commit conventions](../../../pkgs/README.md#commit-conventions) — **open it**.
- LLM-influenced commits: accountable human review + trailer  
  `Assisted-by: <tool> (<primary model name and version>)`  
  Full rules: [`CONTRIBUTING.md` § Automation/AI policy](../../../CONTRIBUTING.md#automationai-policy).  
  `Co-authored-by` **alone does not satisfy** the policy. Disclose AI in PR body / review comments separately when those are AI-assisted.
- PR [Things done](../../../.github/PULL_REQUEST_TEMPLATE.md): check **only** what was actually done (platforms, `nixpkgs-review`, binaries, tests, AI policy).
- New top-level packages: prefer [`pkgs/by-name`](../../../pkgs/by-name/README.md) (see [`pkgs/README.md`](../../../pkgs/README.md)).
- Package-affecting changes: run the **active review strategy** (below) for real—not checkbox fiction. Prefer real `nixpkgs-review` runs over waiting on remote CI alone.
- Match nearby expressions; for language lock hashes (`cargoHash`, `vendorHash`, `npmDepsHash`, …) update the attr the expression **already uses**. Open `doc/languages-frameworks/<lang>.section.md` when unsure.

### Ask first

- Branch target unclear (`staging`, `staging-nixos`, `release-*`) — open [`CONTRIBUTING.md` § Branch conventions](../../../CONTRIBUTING.md#branch-conventions) with the user if rebuild impact is uncertain. Large CI `rebuild` labels ⇒ read that section before targeting `master`.
- New packages that may fail the “should this be in nixpkgs?” gates in [`pkgs/README.md`](../../../pkgs/README.md) (Quick Start).
- Force-push / history rewrite on branches others may use.
- **Worktree** or extra clone — **opt-in only** (user asked, or the optional `nixpkgs-review` skill requires it).
- Scope expansion / drive-by refactors (noise).

### Never

- Tick PR template boxes without evidence (including review and AI policy).
- Submit unreviewed LLM output for inclusion (“vibe coding”) — [AI policy](../../../CONTRIBUTING.md#automationai-policy).
- Skip or **fake** review while claiming it was done — use the real active strategy.
- Short ambiguous GitHub `rev`s in fetchers when docs require full commit hashes — [`pkgs/README.md` § Sources](../../../pkgs/README.md#sources).
- Invent policy; contradict in-tree docs.
- Sprawl: multi-topic PRs, unsolicited cleanups, agent “helpfulness” that increases review burden.

## Where to look

**MANDATORY when unsure of procedure or policy:** read [references/docs-map.md](references/docs-map.md), then open the **live** path listed there. Do **not** load a skill reference that restates CONTRIBUTING—there isn’t one; only the map and the default review card.

| Task class | Start here (then docs-map for more) |
|------------|-------------------------------------|
| Any contrib / PR process | [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) |
| Package edit / init / tests / sources | [`pkgs/README.md`](../../../pkgs/README.md), [`pkgs/by-name/README.md`](../../../pkgs/by-name/README.md) |
| PR checkboxes | [`.github/PULL_REQUEST_TEMPLATE.md`](../../../.github/PULL_REQUEST_TEMPLATE.md) |
| AI / automation disclosure | [`CONTRIBUTING.md` § Automation/AI policy](../../../CONTRIBUTING.md#automationai-policy) |
| Branch / staging / mass rebuild | [`CONTRIBUTING.md` § Branch conventions](../../../CONTRIBUTING.md#branch-conventions) |
| NixOS modules / tests | [`nixos/README.md`](../../../nixos/README.md), NixOS manual tests section (linked from PR template) |
| `lib` | [`lib/README.md`](../../../lib/README.md) |
| Manual / `doc` | [`doc/README.md`](../../../doc/README.md) |
| Maintainers list | [`maintainers/README.md`](../../../maintainers/README.md) |
| Language-specific build | `doc/languages-frameworks/<lang>.section.md` |
| `nixpkgs-review` flags / behavior | [Mic92/nixpkgs-review](https://github.com/Mic92/nixpkgs-review#usage) (also linked from CONTRIBUTING / PR template) |

**Landmine (one line):** PR **title** `WIP:` / `[WIP]` affects automatic package builds; **draft** status alone does not — see [`pkgs/README.md` § Commit conventions](../../../pkgs/README.md#commit-conventions).

## Review strategy

Resolve **once** per task; follow **one** procedure wholly (do not invent a hybrid):

1. **User said how to review** in this session → that instruction wins for this run.
2. Else if a skill named **`nixpkgs-review`** is installed (user or project, e.g. `~/.agents/skills/nixpkgs-review/SKILL.md` or `.agents/skills/nixpkgs-review/SKILL.md`) → **read that skill completely** and use it as the full review procedure (nonstandard setups belong there).
3. Else → **default strategy**: open [references/review-default.md](references/review-default.md) and run those commands from the nixpkgs checkout.

To customize review long-term, add a **`nixpkgs-review`** skill; otherwise defaults apply. See [references/nixpkgs-review-skill.example.md](references/nixpkgs-review-skill.example.md) (example only—do not load unless creating that skill).

After builds: exercise relevant binaries (often under `./result/bin/`), run applicable `passthru.tests` / NixOS tests; claim only platforms you used. Checkbox meaning → PR template + CONTRIBUTING PR template section.

## Worktree (opt-in)

Default: edit and build in the **current** checkout.

Only if the user asks (e.g. “work on this in a worktree”) or the active `nixpkgs-review` skill requires it: `git fetch` the base, `git worktree add <path> <base>`, work there with the **same** guidelines. Do not create worktrees proactively.

## Phase checklist (router)

1. **Classify** — bump / init / fix / module / lib / docs / review-only PR.  
2. **Open docs-map** rows for that class; read live files.  
3. **Branch** — [`CONTRIBUTING.md` § Branch conventions](../../../CONTRIBUTING.md#branch-conventions) (no skill-side staging/Hydra tutorial).  
4. **Edit** — nearest similar package + area README / language doc.  
5. **Build / hashes** — expression + [`pkgs/README.md` § Sources](../../../pkgs/README.md#sources); language section if needed.  
6. **Verify** — active review strategy (above); binaries/tests per PR template.  
7. **Commit / PR** — commit conventions (area README + CONTRIBUTING); AI trailer if applicable; honest Things done; push and open PR per CONTRIBUTING “How to create pull requests”.  
8. **CI / feedback** — ofborg and format (`nix fmt` / `treefmt` per [CONTRIBUTING code conventions](../../../CONTRIBUTING.md#code-conventions)); rebase/update per CONTRIBUTING PR section (`--force-with-lease` when rewriting).  
9. **Worktree** — only if requested; then continue from step 3 in that tree.

## Do not

- Rehost or paraphrase multi-page policy into new skill files.  
- Skip real verification; use **local builds + the active `nixpkgs-review` strategy** (custom skill or default card).  
- Load obsolete personal playbooks from older skill versions—this skill is the entrypoint.
