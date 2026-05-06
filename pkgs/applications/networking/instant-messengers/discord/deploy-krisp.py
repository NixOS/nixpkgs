#!@pythonInterpreter@
"""Deploy pre-patched Krisp module to Discord's user-data directory."""

import hashlib
import json
import os
import shutil
import sys
from pathlib import Path
from shutil import COPY_BUFSIZE
from threading import Event, Lock

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer

KRISP_STORE = Path("@krispPath@")
VERSION = "@discordVersion@"
CONFIG_DIR = "@configDirName@"

# Marker file written alongside the deployed krisp to track which nix store
# path it came from. On case-insensitive filesystems (macOS APFS) another
# Discord install can silently overwrite our files, so a content hash alone
# isn't enough
MARKER = ".nix-krisp-source"
PARENT_CHECK_INTERVAL = 1


def modules_dir() -> Path:
    if sys.platform == "darwin":
        base = Path.home() / "Library" / "Application Support"
        return base / CONFIG_DIR.replace(" ", "") / VERSION / "modules"
    home = Path(os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config")
    return home / CONFIG_DIR / VERSION / "modules"


def _file_hash(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(COPY_BUFSIZE), b""):
            h.update(chunk)
    return h.hexdigest()


KRISP_HASH = _file_hash(KRISP_STORE / "discord_krisp.node")


# True if the deployed krisp is missing, damaged, or came from a different
# nix store path. A hash mismatch means another Discord install (or the user)
# overwrote our files, so the caller redeploys from KRISP_STORE
def needs_deploy(dest: Path, verify_node: bool = True) -> bool:
    node = dest / "discord_krisp.node"
    marker = dest / MARKER
    if not node.exists() or not marker.exists():
        return True
    try:
        stored_hash = marker.read_text().strip()
    except OSError:
        return True
    if stored_hash != KRISP_HASH:
        return True
    if not verify_node:
        try:
            return node.stat().st_mtime_ns > marker.stat().st_mtime_ns
        except OSError:
            return True
    return verify_node and _file_hash(node) != KRISP_HASH


def deploy(dest: Path, quiet: bool = False, verify_node: bool = True) -> None:
    if not needs_deploy(dest, verify_node):
        if not quiet:
            print("[Nix] Krisp already deployed")
        return
    if not quiet:
        print("[Nix] Deploying pre-patched Krisp module")
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.is_symlink():
        dest.unlink()
    elif dest.exists():
        # Fix read-only permissions inherited from the nix store before removing
        for p in dest.rglob("*"):
            p.chmod(0o755 if p.is_dir() else 0o644)
        dest.chmod(0o755)
        shutil.rmtree(dest)
    shutil.copytree(KRISP_STORE, dest)
    dest.chmod(0o755)
    for p in dest.rglob("*"):
        p.chmod(0o755 if p.is_dir() or p.suffix == ".node" else 0o644)
    # Write marker with hash of the deployed binary so we can detect overwrites
    node = dest / "discord_krisp.node"
    (dest / MARKER).write_text(KRISP_HASH + "\n")


def register(manifest: Path, create: bool) -> None:
    if not manifest.exists() and not create:
        return
    try:
        data = json.loads(manifest.read_text()) if manifest.exists() else {}
    except (json.JSONDecodeError, OSError):
        data = {}
    if data.get("discord_krisp", {}).get("installedVersion") != 1:
        data["discord_krisp"] = {"installedVersion": 1}
        manifest.write_text(json.dumps(data, indent=2))


def remove_incomplete_manifest(mdir: Path, manifest: Path) -> None:
    """Recover profiles touched by older deploy scripts.

    If installed.json contains only krisp, Discord thinks bootstrap completed
    and then fails to require discord_desktop_core. Remove that incomplete
    manifest so Discord can bootstrap its normal modules.
    """
    if not manifest.exists() or (mdir / "discord_desktop_core").exists():
        return
    try:
        data = json.loads(manifest.read_text())
    except (json.JSONDecodeError, OSError):
        return
    if set(data) == {"discord_krisp"}:
        manifest.unlink()


def process_alive(pid: int) -> bool:
    try:
        os.kill(pid, 0)
    except OSError:
        return False
    return True


def watch(parent_pid: int, dest: Path, manifest: Path) -> None:
    stopped = Event()
    lock = Lock()

    def repair() -> None:
        with lock:
            deploy(dest, quiet=True, verify_node=False)
            register(manifest, create=False)

    class Handler(FileSystemEventHandler):
        def on_any_event(self, event) -> None:
            repair()

    observer = Observer()
    observer.schedule(Handler(), str(dest.parent), recursive=True)
    observer.start()
    try:
        repair()
        while process_alive(parent_pid):
            stopped.wait(PARENT_CHECK_INTERVAL)
    finally:
        observer.stop()
        observer.join()


def start_watcher(dest: Path, manifest: Path) -> None:
    if not hasattr(os, "fork"):
        return
    parent_pid = os.getppid()
    if os.fork() != 0:
        return
    try:
        os.setsid()
        with open(os.devnull, "w") as devnull:
            os.dup2(devnull.fileno(), 1)
            os.dup2(devnull.fileno(), 2)
        watch(parent_pid, dest, manifest)
    finally:
        os._exit(0)


def main() -> None:
    mdir = modules_dir()
    dest = mdir / "discord_krisp"
    manifest = mdir / "installed.json"

    remove_incomplete_manifest(mdir, manifest)
    if not needs_deploy(dest):
        print("[Nix] Krisp already deployed")
    else:
        deploy(dest)

    # Do not create installed.json on fresh legacy installs: Discord needs a
    # missing manifest to bootstrap discord_desktop_core and friends. A short
    # watcher repairs krisp if the module updater overwrites it during launch,
    # then registers it once the real manifest exists.
    register(manifest, create=False)
    start_watcher(dest, manifest)


if __name__ == "__main__":
    main()
