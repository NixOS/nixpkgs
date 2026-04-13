---
name: rebase-nixpkgs
description: Rebase the plan-ai nixpkgs fork onto upstream master, resolve conflicts preserving local patches, then build and fix every package listed in xzar.sh. Use when the user asks to rebase nixpkgs, update the plan-ai fork, or refresh against upstream.
---

# rebase-nixpkgs

Do the steps below **in order** and **do not skip** any. If a step fails, fix it before moving to the next.

## 1. Rebase onto upstream master

See `PLANAI.md` for the canonical instructions. In short:

```bash
git fetch upstream -p # or if upstream doesn't exist use origin
git fetch planai -p
git checkout plan-ai            # already on it normally
git rebase upstream/master # or if upstream doesn't exist use origin
```

Do **not** force-push at the end of this skill — leave that to the user unless they explicitly ask. If you do push, use `--force-with-lease`, never `--force`.

## 2. Resolve conflicts

Guiding principle: **our patches stay, upstream packages stay otherwise unchanged.**

For each conflict:

1. `git log --oneline <file>` on the plan-ai side (commits not in `origin/master`) to see what *we* changed and why. `git show <our-commit> -- <file>` to inspect.
2. If the conflict is in a file we have **not** intentionally modified (i.e. no plan-ai commit touches it meaningfully), take upstream verbatim (`git checkout --theirs <file>`) — we don't want to drag along stale package edits.
3. If we *do* have a real change there (a patch, a version pin, a `postPatch`, an added file under `pkgs/by-name/...` that we own, etc.), reapply our change on top of the upstream version. Re-read our commit to understand intent; don't just blindly accept "ours".
4. Never delete one of our additions just because upstream renamed/moved a neighbouring file — find the new location and put our change there.
5. After fixing each file: `git add <file>`, then `git rebase --continue`. Repeat until the rebase finishes.

Recent plan-ai commits to be aware of (check `git log mkg-patch..plan-ai` for the live list — these change): openclaw, kanbn, nexa, mcporter, ollama flavours, nix.

## 3. Range-diff review

Before building, sanity-check the rebase by comparing the old and new plan-ai branch:

```bash
git range-diff upstream/master planai/plan-ai plan-ai # or if upstream doesn't exist use origin
```

Read every entry. For each commit you should see either `=` (identical), `!` with only trivial context shifts, or a clearly explained change matching a conflict you resolved. Anything else — unexpected hunks, dropped commits, content you don't recognise — is a red flag: stop, investigate, and fix the rebase before continuing.

Then **show the full range-diff output to the user** and call out anything non-trivial in your own words. Do not proceed to building until you've surfaced this.

## 4. Update packages to latest versions

Before building, check each package for available updates and bump them to the latest release. Read `xzar.sh` to derive the package list (same as the build step).

For each package, do the following:

### 4.1 Determine the upstream source

Read the package's nix expression and find its `fetchFromGitHub` (or equivalent) call. Extract the `owner` and `repo`.

**Skip** packages that:
- Use a **fork** as their source (e.g. `owner = "mkg20001"`) — these are pinned intentionally.
- Use `fetchurl` with a non-GitHub URL as their primary source — no easy way to detect latest.
- Use a git `rev` (commit hash) instead of a `tag` — these are snapshot pins.

### 4.2 Find the latest release version

Use the `gh` CLI to find the latest release tag:

```bash
gh release view --repo <owner>/<repo> --json tagName -q '.tagName'
```

If the repo doesn't use GitHub Releases (the above errors), fall back to the latest tag:

```bash
gh api repos/<owner>/<repo>/tags --jq '.[0].name'
```

Strip the leading `v` prefix if the nix expression's `version` field doesn't include one (most don't).

### 4.3 Compare versions

If the latest version equals the current `version` in the nix expression, skip — nothing to do.

### 4.4 Check for existing upgrade PRs on NixOS/nixpkgs

Before doing the upgrade ourselves, search for an existing open PR on the upstream `NixOS/nixpkgs` repo that already upgrades this package to the target version. Use the GitHub API:

```bash
gh pr list --repo NixOS/nixpkgs --state open --search "<pkg-name>: <new-version>" --limit 5 --json number,title,url
```

Also try broader searches if the exact query returns nothing:

```bash
gh pr list --repo NixOS/nixpkgs --state open --search "<pkg-name>: <old-version>" --limit 5 --json number,title,url
gh pr list --repo NixOS/nixpkgs --state open --search "<pkg-name> update" --limit 5 --json number,title,url
```

Look at the returned PR titles. If a PR clearly upgrades the package to the version we want (or a newer one):

1. **Pull the PR as a patch** using GitHub's `.patch` URL:
   ```bash
   curl -sL "https://github.com/NixOS/nixpkgs/pull/<number>.patch" -o /tmp/<pkg-name>-upgrade.patch
   ```
2. **Inspect the patch** to make sure it only touches files relevant to this package and looks reasonable. Read through it — don't blindly apply.
3. **Apply the patch:**
   ```bash
   git apply --3way /tmp/<pkg-name>-upgrade.patch
   ```
   If it doesn't apply cleanly (due to our fork divergence), resolve conflicts manually, guided by the patch's intent.
4. **Build the package** and verify the binary works:
   ```bash
   NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_INSECURE=1 nix-build -A <attr> --out-link /tmp/result-<pkg-name>
   /tmp/result-<pkg-name>/bin/<binary> --help   # or --version, whichever is appropriate
   ```
   If the build fails due to hash mismatches or patch conflicts, fix them as described in later steps. If the binary doesn't run or crashes, treat it as a build failure.
5. **Commit** with the same format as 4.8, but add a note referencing the upstream PR:
   ```
   <pkg-name>: <previous version> -> <new version>

   Based on NixOS/nixpkgs#<number>
   ```
6. **Skip** the remaining sub-steps (4.5–4.8) for this package and move on to the next.

If no suitable PR exists, proceed with the manual upgrade below.

### 4.5 Update the version and source hash

1. Edit the `version` field in the nix expression to the new version.
2. Invalidate the source hash by setting it to an empty string (`hash = "";`).
3. Attempt a build:
   ```bash
   NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_INSECURE=1 nix-build -A <attr> --out-link /tmp/result-<pkg-name> 2>&1
   ```
4. The build will fail with a hash mismatch. Extract the `got:` hash from the error output and set it as the new `hash`.

### 4.6 Update dependency hashes (vendorHash, pnpmDepsHash, etc.)

After fixing the source hash, the build may fail again because of stale dependency hashes. For each dependency hash field (`vendorHash`, `pnpmDepsHash`, `pnpmDeps`, or similar):

1. Set the hash to an empty string (`""`).
2. Re-run the build.
3. Extract the correct hash from the `got:` line in the error output and update the field.

Repeat until the build either **succeeds** or fails for a reason unrelated to hash mismatches (e.g. compilation error). If a compilation error occurs on the version bump, **revert the update for that package** — do not leave it broken — and note it in the final report so the user can investigate manually.

Once the build succeeds, verify the binary actually works:

```bash
/tmp/result-<pkg-name>/bin/<binary> --help   # or --version, whichever is appropriate
```

If the binary doesn't run or crashes, treat it as a build failure — investigate and fix, or revert the update.

### 4.7 Handle patches that no longer apply

A version bump may cause existing patches to fail. If so, follow the same patch-rebasing procedure described in the build-fix section below (step 5). Rebase the patch onto the new source, update it, and rebuild.

### 4.8 Commit the update

After each **individual** package is successfully updated and builds, commit with:

```
<pkg-name>: <previous version> -> <new version>
```

For example: `ollama: 0.20.3 -> 0.21.0`

Use the raw package name from `xzar.sh` (e.g. `openclaw`, `ollama`, `nexa`). For packages with multiple flavours (like ollama-cpu, ollama-rocm, etc.), they share one version — commit once as the base name (e.g. `ollama`).

Do **not** batch multiple package updates into a single commit — one commit per package.

### 4.9 Push update to a per-package branch

After committing a package update, push the commit to a dedicated branch on the `mkg20001/nixpkgs` fork so it can be used for upstream PRs or independent testing.

1. Record the commit hash of the update you just made:
   ```bash
   UPDATE_COMMIT=$(git rev-parse HEAD)
   ```
2. Create a git worktree based on `upstream/master` (or `origin/master` if upstream doesn't exist):
   ```bash
   git worktree add /tmp/wt-<pkg-name> upstream/master
   ```
3. In the worktree, create a branch named `<pkg-name>-<new-version>` and cherry-pick the commit:
   ```bash
   cd /tmp/wt-<pkg-name>
   git checkout -b <pkg-name>-<new-version>
   git cherry-pick $UPDATE_COMMIT
   ```
   If the cherry-pick has conflicts, resolve them — the intent is to land the same change cleanly on top of upstream master.
4. Amend the cherry-picked commit to set the correct author:
   ```bash
   git commit --amend --author="Maciej Krüger <mkg20001@gmail.com>" --no-edit
   ```
5. Push the branch:
   ```bash
   git push git@github.com:mkg20001/nixpkgs.git <pkg-name>-<new-version>
   ```
   If the branch already exists on the remote (from a previous run), force-push with `--force-with-lease`.
6. Return to the main tree but **keep the worktree** — do **not** remove it:
   ```bash
   cd /root/nixpkgs
   ```

Use the raw package name and new version for the branch name (e.g. `ollama-0.21.0`, `openclaw-2026.5.0`).

Skip this step for packages that were **not** updated (i.e. already at latest version).

## 5. Build every package in xzar.sh

Read `xzar.sh` and extract the list of attribute names passed to `nix-build -A`. As of writing that includes:

- `openclaw`
- `ollama-cpu`, and on Linux also `ollama-rocm`, `ollama-cuda`, `ollama-vulkan`
- `nix`
- `mcporter`
- `nexa`

(Re-derive the list from the script each run — don't hardcode it; the user updates `xzar.sh`.)

For each attribute, build with `--out-link` and then verify the binary runs:

```bash
NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_INSECURE=1 nix-build -A <attr> --out-link /tmp/result-<attr>
/tmp/result-<attr>/bin/<binary> --help   # or --version, whichever is appropriate
```

You do **not** need to `xzar upload`; just build and verify. Build sequentially so failures are easy to attribute. Do not stop at the first failure — record it, fix it, then continue. Every package must end green and its binary must run.

### Fixing build errors

Common failure modes and how to handle them:

- **Patch no longer applies** (`patch: **** malformed patch` / `Hunk #N FAILED`). This is the main reason this skill exists. To rebase the patch:
  1. Find the `src` of the failing derivation. Easiest way:
     ```bash
     nix-store --realise $(nix-instantiate -A <attr>.src)
     ```
     This prints the unpacked-source store path. (For fetchFromGitHub etc. you may need `nix-build -A <attr>.src` instead — whichever yields the source tree.)
  2. Copy that source out somewhere writable, `git init` it if helpful, apply the existing patch with `patch -p1 --merge` or `git apply --3way` to get conflict markers.
  3. Resolve, regenerate the patch with `diff -ruN orig new > new.patch` (or `git diff`), and replace the patch file in the nixpkgs tree.
  4. Rebuild.
- **Hash mismatch** after a version bump pulled in by upstream: update the `hash =` / `sha256 =` field with the value Nix reports as `got:`.
- **Upstream removed an attribute we depend on**: search for the new name in nixpkgs (`Grep`), update our reference.
- **Compilation/linker errors from a new toolchain**: prefer the smallest possible fix that keeps our patch's intent. If the upstream package builds fine and only *our* patch breaks it, the patch is what to fix.

Do not "fix" a build by deleting our patch or reverting our commit — that defeats the purpose of the fork. If a patch is genuinely obsolete (upstream merged it), confirm by reading upstream, then remove the patch and note it in the commit message.

## 6. Run NixOS tests

After all packages build, run the NixOS integration tests for packages that have them. Check `nixos/tests/all-tests.nix` for test attributes that match the package names from `xzar.sh`.

For each matching test, run it:

```bash
NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_INSECURE=1 nix-build -A nixosTests.<test-name> --out-link /tmp/result-test-<test-name>
```

Known tests to look for (re-derive from `all-tests.nix` each run):
- `openclaw` — tests openclaw gateway + ollama with a pre-fetched qwen3 model
- `ollama` — tests ollama service
- `ollama-cuda`, `ollama-rocm`, `ollama-vulkan` — GPU-variant tests (Linux only)

If a test fails, investigate and fix the issue (module config, missing dependency, test script bug, etc.) before proceeding. Every test must pass.

## 7. Report

When all packages build, summarise to the user:
- which conflicts you resolved and how (one line each),
- which packages were updated to newer versions (old → new),
- which packages were skipped for version updates and why (e.g. fork pin, already latest, update broke build),
- which patches you had to rebase,
- any package whose fix was non-trivial,
- for each updated package: the worktree path (`/tmp/wt-<pkg-name>`), the branch name (`<pkg-name>-<version>`), and the remote it was pushed to (`git@github.com:mkg20001/nixpkgs`),
- which NixOS tests were run and their pass/fail status.

Then stop. Pushing and running `xzar.sh` for real is the user's call.
