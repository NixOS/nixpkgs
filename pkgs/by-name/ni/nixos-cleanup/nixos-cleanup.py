#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import argparse
import os
import pwd
import re
import shutil
import subprocess
import sys
from pathlib import Path

VERSION = "0.1.0"

BOLD = "\033[1m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
RED = "\033[31m"
DIM = "\033[2m"
RESET = "\033[0m"

SYSTEM_PROFILE = "/nix/var/nix/profiles/system"


def human(n):
    for unit in ("B", "K", "M", "G", "T"):
        if abs(n) < 1024:
            return f"{n:.1f}{unit}"
        n /= 1024
    return f"{n:.1f}P"


def log(msg):
    print(f"{DIM}[*]{RESET} {msg}", file=sys.stderr)


def ok(msg):
    print(f"{GREEN}[+]{RESET} {msg}", file=sys.stderr)


def warn(msg):
    print(f"{YELLOW}[!]{RESET} {msg}", file=sys.stderr)


def err(msg):
    print(f"{RED}[x]{RESET} {msg}", file=sys.stderr)


class Ctx:
    def __init__(self, dry_run, verbose, user, home):
        self.dry_run = dry_run
        self.verbose = verbose
        self.user = user
        self.home = Path(home)


class Task:
    def __init__(self, name, fn):
        self.name = name
        self.fn = fn


def run(cmd, ctx, check=True):
    joined = " ".join(cmd) if isinstance(cmd, list) else cmd
    if ctx.dry_run:
        log(f"would run: {joined}")
        return "", 0
    if ctx.verbose:
        log(f"running: {joined}")
    proc = subprocess.run(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
    )
    out = proc.stdout or ""
    if proc.returncode != 0 and check:
        warn(f"command failed ({proc.returncode}): {joined}\n{out.strip()}")
    return out, proc.returncode


def query(cmd):
    proc = subprocess.run(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
    )
    return proc.stdout or ""


def dir_size(path):
    if not Path(path).exists():
        return 0
    out, _ = run(["du", "-sb", "--", str(path)], Ctx(dry_run=False, verbose=False, user="", home=""), check=False)
    if not out:
        return 0
    try:
        return int(out.split()[0])
    except (IndexError, ValueError):
        return 0


def free_bytes_on_root():
    out, _ = run(["df", "-B1", "--output=avail", "/"], Ctx(dry_run=False, verbose=False, user="", home=""), check=False)
    for line in out.splitlines()[1:]:
        if line.strip():
            try:
                return int(line.strip())
            except ValueError:
                pass
    return 0


def find_old_files(root, days):
    cmd = ["find", str(root), "-xdev", "-type", "f", "-mtime", f"+{days}"]
    out, _ = run(cmd, Ctx(dry_run=False, verbose=False, user="", home=""), check=False)
    return [l for l in out.splitlines() if l.strip()]


def parse_freed(text):
    m = re.search(r"(\d+) bytes? freed", text)
    if m:
        return int(m.group(1))
    m = re.search(r"freed ([\d.]+)\s*([KMGTP]?)", text)
    if m:
        mult = {"": 1, "K": 1024, "M": 1024**2, "G": 1024**3, "T": 1024**4}
        return int(float(m.group(1)) * mult[m.group(2)])
    return 0


def delete_nix_generations(profile, keep, ctx):
    total_kept = keep
    spec = f"+{max(total_kept, 1)}"
    gen_out = query(["nix-env", "--list-generations", "-p", profile])
    if not gen_out.strip():
        log(f"profile {profile} has no generations")
        return 0
    lines = [l for l in gen_out.splitlines() if l.strip()]
    old = max(len(lines) - total_kept, 0)
    if old <= 0:
        log(f"profile {profile}: {len(lines)} generations, keeping {total_kept}, nothing to delete")
        return 0
    log(f"profile {profile}: {len(lines)} generations -> keeping {total_kept} (deleting {old})")
    run(["nix-env", "-p", profile, "--delete-generations", spec], ctx)
    return 0


def gc_store(ctx):
    out, _ = run(["nix-store", "--gc"], ctx)
    return parse_freed(out) if not ctx.dry_run else 0


def optimise_store(ctx):
    out, _ = run(["nix-store", "--optimise"], ctx)
    return parse_freed(out) if not ctx.dry_run else 0


def clean_nix_drv_logs(ctx):
    drvs = Path("/nix/var/log/nix/drvs")
    if not drvs.is_dir():
        log("/nix/var/log/nix/drvs not present, skipping")
        return 0
    size = dir_size(drvs)
    if size == 0:
        log("no nix derivation logs to clean")
        return 0
    log(f"removing {human(size)} of nix derivation logs in {drvs}")
    if not ctx.dry_run:
        shutil.rmtree(drvs)
    return size if ctx.dry_run else size


def vacuum_journal(ctx, target):
    size = dir_size("/var/log/journal")
    if size == 0:
        log("/var/log/journal is empty, skipping vacuum")
        return 0
    target_bytes = int(target[:-1]) * {"K": 1024, "M": 1024**2, "G": 1024**3}.get(target[-1].upper(), 1)
    if ctx.dry_run:
        if size <= target_bytes:
            log(f"journal is {human(size)}, already under {target}; nothing to vacuum")
            return 0
        log(f"journal is {human(size)}, vacuuming to {target}")
        return size - target_bytes
    log(f"journal is {human(size)}, vacuuming to {target}")
    out, _ = run(["journalctl", "--vacuum-size", target], ctx)
    return parse_freed(out)


def clean_tmp(ctx, days):
    total = 0
    for root in ("/tmp", "/var/tmp"):
        if not Path(root).is_dir():
            continue
        files = find_old_files(root, days)
        if not files:
            log(f"{root}: no regular files older than {days} days")
            continue
        log(f"{root}: {len(files)} file(s) older than {days} days")
        if not ctx.dry_run:
            run(["find", root, "-xdev", "-type", "f", "-mtime", f"+{days}", "-delete"], ctx, check=False)
            run(["find", root, "-xdev", "-type", "d", "-empty", "-delete"], ctx, check=False)
    return total


def flatpak_unused(ctx, scope):
    args = ["flatpak", "uninstall", "--unused", "--noninteractive"]
    if scope == "user":
        args.append("--user")
    else:
        args.append("--system")
    out, _ = run(args, ctx, check=False)
    return 0


def empty_dir(path, ctx):
    p = Path(path)
    if not p.is_dir():
        return 0
    size = dir_size(p)
    log(f"emptying {p} ({human(size)})")
    if not ctx.dry_run:
        for child in p.iterdir():
            if child.is_dir() and not child.is_symlink():
                shutil.rmtree(child, ignore_errors=True)
            else:
                try:
                    child.unlink()
                except OSError:
                    pass
    return size if ctx.dry_run else size


def parse_args():
    parser = argparse.ArgumentParser(
        description="Free up space on the NixOS root partition.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("--version", action="version", version=f"nixos-cleanup {VERSION}")
    parser.add_argument("-n", "--dry-run", action="store_true", default=True,
                        help="show what would be done without changing anything (default)")
    parser.add_argument("-y", "--yes", action="store_true",
                        help="actually perform the cleanup (disables dry-run)")
    parser.add_argument("-s", "--system", action="store_true",
                        help="run system-level cleanup (requires root)")
    parser.add_argument("-u", "--user", nargs="?", const=None, metavar="USER",
                        help="run user-level cleanup for USER (default: sudo caller or sole /home owner)")
    parser.add_argument("-v", "--verbose", action="store_true")
    parser.add_argument("--keep-system", type=int, default=2, metavar="N",
                        help="keep last N system generations")
    parser.add_argument("--keep-user", type=int, default=3, metavar="N",
                        help="keep last N user generations")
    parser.add_argument("--journal-size", default="200M", metavar="SIZE",
                        help="vacuum journal to this size")
    parser.add_argument("--older-than", type=int, default=7, metavar="DAYS",
                        help="delete /tmp and /var/tmp files older than this")
    parser.add_argument("--no-report", action="store_true",
                        help="skip the final disk-usage report")
    return parser.parse_args()


def resolve_user(args):
    if args.user is not None:
        return args.user
    if os.environ.get("SUDO_USER"):
        return os.environ["SUDO_USER"]
    homes = [p for p in Path("/home").iterdir() if p.is_dir()] if Path("/home").is_dir() else []
    if len(homes) == 1:
        return homes[0].name
    if os.geteuid() != 0:
        return pwd.getpwuid(os.geteuid()).pw_name
    warn("cannot determine target user (no SUDO_USER, multiple /home entries). Use --user USER")
    return None


def main():
    args = parse_args()
    dry_run = not args.yes
    ctx = Ctx(dry_run=dry_run, verbose=args.verbose, user="", home="")

    if os.geteuid() != 0:
        err("system-level cleanup needs root. Re-run with sudo.")
        sys.exit(1)

    tasks = []

    if args.system or not (args.system or args.user):
        tasks += [
            Task("system generations", lambda: delete_nix_generations(SYSTEM_PROFILE, args.keep_system, ctx)),
            Task("nix store garbage collection", lambda: gc_store(ctx)),
            Task("nix store optimisation", lambda: optimise_store(ctx)),
            Task("nix derivation logs", lambda: clean_nix_drv_logs(ctx)),
            Task(f"journal vacuum to {args.journal_size}", lambda: vacuum_journal(ctx, args.journal_size)),
            Task(f"/tmp and /var/tmp older than {args.older_than} days", lambda: clean_tmp(ctx, args.older_than)),
            Task("flatpak unused (system)", lambda: flatpak_unused(ctx, "system")),
        ]

    if args.user is not None or (not args.system):
        user = resolve_user(args)
        if user:
            user_ctx = Ctx(dry_run=dry_run, verbose=args.verbose, user=user, home=pwd.getpwnam(user).pw_dir)
            profile = f"/nix/var/nix/profiles/per-user/{user}/profile"
            tasks += [
                Task(f"user generations ({user})", lambda: delete_nix_generations(profile, args.keep_user, user_ctx)),
                Task(f"user caches ({user})", lambda: clean_user_caches(user_ctx)),
                Task(f"trash ({user})", lambda: empty_dir(user_ctx.home / ".local/share/Trash", user_ctx)),
                Task(f"flatpak unused (user, {user})", lambda: flatpak_unused(user_ctx, "user")),
            ]

    banner = "DRY RUN (no changes)" if dry_run else "PERFORMING CLEANUP"
    print(f"{BOLD}== {banner} =={RESET}", file=sys.stderr)

    before = free_bytes_on_root()
    total = 0
    for t in tasks:
        print(f"{BOLD}--- {t.name} ---{RESET}", file=sys.stderr)
        try:
            freed = t.fn() or 0
        except KeyboardInterrupt:
            warn("interrupted")
            break
        if freed:
            ok(f"{'would free' if dry_run else 'freed'} {human(freed)}")
            total += freed
    after = free_bytes_on_root()

    if dry_run:
        print(f"\n{DIM}Dry run finished: {human(total)} of directly-measurable space could be freed{RESET}", file=sys.stderr)
        print(f"{DIM}Actual nix-store gc / optimise savings will be reported on a real run.{RESET}", file=sys.stderr)
    else:
        print(f"\n{GREEN}Cleanup finished, freed {human(after - before)} on /{RESET}", file=sys.stderr)

    if not args.no_report:
        report()


def clean_user_caches(ctx):
    total = 0
    caches = [
        ".cache/pip", ".npm/_cacache", ".npm/_logs", ".cache/go-build",
        ".cache/cargo", ".cache/yarn", ".cache/pnpm", ".local/share/pnpm",
        ".cache/electron", ".cache/vivaldi", ".cache/chromium",
        ".cache/google-chrome", ".cache/mozilla", ".cache/thumbnails",
        ".cache/nix", ".cache/meson",
    ]
    for rel in caches:
        total += empty_dir(ctx.home / rel, ctx)
    for pattern in (".var/app/*/cache", ".var/app/*/config/*/Cache"):
        for p in sorted(ctx.home.glob(pattern)):
            total += empty_dir(p, ctx)
    return total


def report():
    print(f"\n{BOLD}== Largest space consumers on / =={RESET}", file=sys.stderr)
    for p in ("/nix/store", "/var", "/home"):
        if Path(p).exists():
            print(f"{DIM}{p}: {human(dir_size(p))}{RESET}", file=sys.stderr)
    out, _ = run(["du", "-xB1", "--max-depth=1", "/nix/store", "/var", "/home"],
                 Ctx(dry_run=False, verbose=False, user="", home=""), check=False)
    entries = []
    for line in out.splitlines():
        parts = line.split("\t")
        if len(parts) == 2 and parts[1].startswith(("/nix/store/", "/var/", "/home/")):
            try:
                entries.append((int(parts[0]), parts[1]))
            except ValueError:
                pass
    for size, path in sorted(entries, reverse=True)[:15]:
        print(f"  {human(size):>10}  {path}", file=sys.stderr)


if __name__ == "__main__":
    main()
