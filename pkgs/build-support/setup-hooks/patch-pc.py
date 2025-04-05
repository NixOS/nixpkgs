# Replaces dependencies in pc files with their absolute paths
#
# Usage: python patch-pc.py /path/to/pkgconf libfoo.pc
# The tool writes patched .pc file to the stdout

from subprocess import run
import sys
import re

LINE_SEP = re.compile(r"(?<!\\)\n")

pkgconf_bin = sys.argv[1]
pc_file = sys.argv[2]


def run_pkgconf(*args: str) -> str:
    result = run([pkgconf_bin, *args], capture_output=True, check=True)
    return result.stdout.decode().rstrip()


def get_path(name: str) -> str:
    return run_pkgconf("--path", name)


def list_requires(file: str, private: bool) -> list[str]:
    return run_pkgconf(
        f"--print-requires{"-private" if private else ""}", file
    ).splitlines()


def transform_dep_spec(dep_spec: str) -> str:
    def escape(s: str) -> str:
        return s.replace("#", "\\#")

    [name, *version_spec] = dep_spec.split(" ")
    return " ".join(escape(s) for s in [get_path(name), *version_spec])


def print_requires(file: str, private: bool):
    requires = (transform_dep_spec(dep) for dep in list_requires(file, private))
    print(f"Requires{".private" if private else ""}:", ", ".join(requires))


with open(pc_file, "r") as f:
    for line in LINE_SEP.split(f.read()):
        if line.lstrip().startswith("Requires:"):
            print_requires(pc_file, private=False)
        elif line.lstrip().startswith("Requires.private:"):
            print_requires(pc_file, private=True)
        else:
            print(line)

