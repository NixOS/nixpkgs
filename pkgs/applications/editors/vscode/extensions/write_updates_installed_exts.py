# I am not putting a nix-shell shebang here because I can't be bothered to figure out how to put a Python package into it

from json import loads
from sys import stderr
from regex import MULTILINE, subn
import fileinput

if __name__ == "__main__":
    with open("./default.nix", "r") as file:
        contents = file.read()

    for line in fileinput.input(encoding="utf-8"):
        match loads(line):
            case {"name": name, "publisher": publisher, "version": version, "hash": hash}:
                pass  # only for assignment
            case _:
                raise RuntimeError

        pattern = fr"""(?<="?{publisher}"?\."?{name}"?\s*=\s*buildVscodeMarketplaceExtension\s*{{\s*mktplcRef\s*=\s*){{[^{{}}]*}}(?=;)"""

        replacement = f"""{{
          publisher = "{publisher}";
          name = "{name}";
          version = "{version}";
          hash = "{hash}";
        }}"""  # indentation here is somewhat important!

        contents, subcount = subn(pattern, replacement, contents, MULTILINE)

        assert subcount <= 1
        if subcount == 0:
            print(f"failed to find match for {line}", file=stderr)

    with open("./default.nix", "w") as file:
        file.write(contents)

