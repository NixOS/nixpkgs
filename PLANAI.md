# Plan AI nixpkgs setup

## Clone & configure remotes

```bash
# Clone upstream nixpkgs as origin
git clone git@github.com:NixOS/nixpkgs.git
cd nixpkgs

# Add plan-ai remote
git remote add planai git@git.plan.ai:plan-ai/nixpkgs

# Fetch everything
git fetch --all
```

## Switch to the plan-ai branch

```bash
git checkout -b plan-ai planai/plan-ai
```

## Rebase onto upstream master

```bash
# Fetch latest upstream
git fetch origin

# Rebase plan-ai on top of origin/master
git rebase origin/master
```

Resolve any conflicts as they come up, then `git rebase --continue`.

## Force push the rebased branch

```bash
git push planai plan-ai --force-with-lease
```

Use `--force-with-lease` instead of `--force` to avoid overwriting changes pushed by someone else since your last fetch.
