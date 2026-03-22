import os
import shutil
import subprocess
from collections import deque


ardour_lib = os.environ["ardourLib"]
bundled_dir = os.environ["bundledLibDir"]
out_root = os.environ["out"]


def is_macho(path: str) -> bool:
    try:
        output = subprocess.check_output(["file", "-b", path], text=True)
    except subprocess.CalledProcessError:
        return False
    return "Mach-O" in output


def macho_deps(path: str) -> list[str]:
    output = subprocess.check_output(["otool", "-L", path], text=True)
    deps: list[str] = []
    for line in output.splitlines()[1:]:
        line = line.strip()
        if not line:
            continue
        deps.append(line.split(" ", 1)[0])
    return deps


def should_bundle(dep: str) -> bool:
    return (
        dep.startswith("/nix/store/")
        and not dep.startswith(out_root + "/")
        and not dep.startswith("/System/Library/")
        and not dep.startswith("/usr/lib/")
    )


queue = deque()
seen: set[str] = set()

for root, _, files in os.walk(ardour_lib):
    for name in files:
        path = os.path.join(root, name)
        if is_macho(path):
            queue.append(path)

while queue:
    path = queue.popleft()
    if path in seen:
        continue
    seen.add(path)
    if not is_macho(path):
        continue

    for dep in macho_deps(path):
        if not should_bundle(dep):
            continue

        target = os.path.join(bundled_dir, os.path.basename(dep))
        if not os.path.exists(target):
            shutil.copy2(dep, target)
            os.chmod(target, os.stat(target).st_mode | 0o200)
            queue.append(target)
