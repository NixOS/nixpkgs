# Replaces dependencies in pc files with their absolute paths
#
# Usage: python patch-pc.py /path/to/pkgconf libfoo.pc
# The tool writes patched .pc file to the stdout

from subprocess import check_output
import sys
import re

# pkg-config stanzas can extend across lines. For example:
#
# Requires: thing1, \
#     thing2, \
#     thing3
# Cflags: blah
#
# https://github.com/pkgconf/pkgconf/blob/d81b4731d6efb33ad971a7936be449d705bb1ae9/tests/lib-sbom/meta_package.pc#L5
LINE_SEP = re.compile(r"(?<!\\)\n")

# Make it a template just to make
# sure we don't pick up something from the
# derivation environment
pkgconf_bin = "@PKG_CONFIG_BIN@"

def run_pkgconf(*args: str) -> str:
    result = check_output([pkgconf_bin, "--print-errors", *args], text=True)
    return result.rstrip()

# Use --path from pkgconf for now since pkgconf doesn't quite
# work the same as pkg-config with absolute paths. Later try
# using `--variable=pcfiledir` for backwards compat.
#
# Use --variable=pcfiledir to get the dir, then append the name and extension.
# This is backwards compatible with pkg-config
def get_path(name: str) -> str:
    return run_pkgconf("--path", name)


# Get the requires list. Notably this ignores items that
# are commented out
# https://github.com/pkgconf/pkgconf/blob/d81b4731d6efb33ad971a7936be449d705bb1ae9/tests/lib1/comments-in-fields.pc#L5
def list_requires(file: str, private: bool) -> list[str]:
    return run_pkgconf(
        f"--print-requires{'-private' if private else ''}", file
    ).splitlines()


def transform_dep_spec(dep_spec: str) -> str:
    # This does several things:
    #
    # 1. Split the module SPEC into module and version
    # 2. Get the absolute path to the module file
    # 3. Escape any '#' that may appear with \
    # https://github.com/pkgconf/pkgconf/issues/215#issuecomment-801324307
    # 4. Rejoins to module path + version spec
    def escape(s: str) -> str:
        return s.replace("#", "\\#")

    [name, *version_spec] = dep_spec.split(" ")
    return " ".join(escape(s) for s in [get_path(name), *version_spec])

# Takes in a requires line, and outputs a new line that is only
# absolute paths
def require_to_path(file: str, private: bool) -> str:
    requires = (transform_dep_spec(dep) for dep in list_requires(file, private))
    return "Requires" + (".private: " if private else ": ") + ", ".join(requires)

def main(pc_file: str):
    with open(pc_file, "r") as f:
        for line in LINE_SEP.split(f.read()):
            if line.lstrip().startswith("Requires:"):
                print(require_to_path(pc_file, False))
            elif line.lstrip().startswith("Requires.private:"):
                print(require_to_path(pc_file, True))
            elif line.lstrip().startswith("Requires.internal:"):
                print(require_to_path(pc_file, True))
            else:
                print(line)


if __name__ == "__main__":
    main(sys.argv[1])
