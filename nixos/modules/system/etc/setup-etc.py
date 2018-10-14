import argparse
import os
import os.path
from pathlib import Path
from pwd import getpwnam
from grp import getgrnam
import shutil
import sys
from typing import List, Tuple, Set

STATIC = Path("/etc/static")
CLEAN_FILE = Path("/etc/.clean")

def warn(msg: str) -> None:
    print('warning:', msg, file=sys.stderr)

def atomic_symlink(source: Path, target: Path) -> None:
    tmp = Path("{target}.tmp".format(target=target))
    tmp.unlink()
    tmp.symlink_to(source)
    tmp.rename(target)

def atomic_symlink_or_warn(source: Path, target: Path) -> None:
    try:
        atomic_symlink(source, target)
    except IOError as exc:
        warn("error creating link '{target}': {exc}". \
             format(target=target, exc=exc))

def is_static(path: Path) -> bool:
    """
    Returns True if the argument points to the files in /etc/static. That means
    either argument is a symlink to a file in /etc/static or a directory with
    all children being static.
    """

    if path.is_symlink():
        target = path.resolve()
        res = os.path.commonprefix([target, STATIC]) == STATIC  # type: bool
        return res

    if path.is_dir():
        return all(is_static(ent) for ent in path.iterdir())

    return False

def cleanup() -> None:
    """
    Remove dangling symlinks that point to /etc/static.  These are
    configuration files that existed in a previous configuration but not
    in the current one.  For efficiency, don't look under /etc/nixos
    (where all the NixOS sources live).
    """
    for root, dirs, files in os.walk('/etc'):
        if root == '/etc':
            dirs.remove('nixos')

        for f in files:
            path = Path(root) / Path(f)
            if path.is_symlink():
                target = path.resolve()
                if os.path.commonprefix([target, STATIC]) == STATIC:
                    x = STATIC / path.relative_to('/etc')
                    if x.is_symlink():
                        print("removing obsolete symlink '{path}'".format(path=path),
                              file=sys.stderr)
                        path.unlink()

def link_statics(etc: Path) -> Tuple[Set[Path], Set[Path]]:
    """
    For every file in the etc tree, create a corresponding symlink in
    /etc to /etc/static.  The indirection through /etc/static is to make
    switching to a new configuration somewhat more atomic.
    """

    clean = open(CLEAN_FILE, 'a')
    created = set()
    copied = set()
    for root, dirs, files in os.walk(etc):
        for f in files:
            path = Path(root) / Path(f)
            if os.path.commonprefix([etc, path]) != etc:
                continue
            fn = path.relative_to(etc)
            target = Path("/etc") / f
            target.parent.mkdir(parents=True)
            created.add(fn)

            # Rename doesn't work if target is directory.
            if Path(f).is_symlink() and target.is_dir():
                if is_static(target):
                    try:
                        shutil.rmtree(target)
                    except IOError as exc:
                        warn("error trying to remove '{target}': {exc}". \
                             format(target=target, exc=exc))
                else:
                    warn("$target directory contains user files. Symlinking may fail.")

            meta_f = Path("{f}.mode".format(f=f))
            if meta_f.exists():
                mode = open(meta_f, 'r').read().strip()
                if mode == 'direct-symlink':
                    src = (STATIC / fn).resolve()
                    atomic_symlink_or_warn(src, target)
                else:
                    user = open("{f}.uid".format(f=f)).read().strip()
                    grp = open("{f}.gid".format(f=f)).read().strip()
                    uid = getpwnam(user).pw_uid
                    gid = getgrnam(grp).gr_gid

                    src = STATIC / fn
                    tmp = Path("{target}.tmp".format(target=target))
                    try:
                        shutil.copyfile(src, tmp)
                    except IOError as exc:
                        warn("error copying from '{src}' to '{tmp}': {exc}". \
                             format(src=src, tmp=tmp, exc=exc))

                    try:
                        os.chown(tmp, uid, gid)
                    except IOError as exc:
                        warn("error setting owner of '{tmp}': {exc}". \
                             format(tmp=tmp, exc=exc))

                    try:
                        os.chmod(tmp, int(mode, 8))
                    except IOError as exc:
                        warn("error setting mode of '{tmp}': {exc}". \
                             format(tmp=tmp, exc=exc))

                    try:
                        tmp.rename(target)
                    except IOError as exc:
                        warn("error renaming '{tmp}' to '{target}': {exc}". \
                             format(tmp=tmp, target=target, exc=exc))

                copied.add(fn)
                print(fn, file=clean)

            elif Path(f).is_symlink():
                atomic_symlink_or_warn(STATIC / fn, target)

    return (created, copied)

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('etc')
    args = parser.parse_args()
    etc = args.etc

    # Atomically update /etc/static to point at the etc files of the
    # current configuration.
    atomic_symlink(etc, STATIC)

    cleanup()

    # Use /etc/.clean to keep track of copied files.
    old_copied = []  # type: List[str]
    if CLEAN_FILE.is_file():
        old_copied += [ line.strip() for line in CLEAN_FILE.read_text().split('\n') ]

    created, copied = link_statics(etc)

    # Delete files that were copied in a previous version but not in the
    # current.
    for f in old_copied:
        if f not in created:
            fn = Path("/etc") / f
            print("removing obsolete file '{f}'...".format(f=f),
                  file=sys.stderr)
            fn.unlink()

    # Rewrite /etc/.clean
    CLEAN_FILE.write_text('\n'.join(str(p) for p in copied))

if __name__ == "__main__":
    main()
