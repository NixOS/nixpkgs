from typing import Iterable

import subprocess
from pathlib import Path

from jetbrains_nix_updater.config import UpdaterConfig


def run_command(cmd: list[str], **kwargs) -> str:
    result = subprocess.run(cmd, capture_output=True, check=True, text=True, **kwargs)
    return result.stdout.strip()


def convert_hash_to_sri(base32: str) -> str:
    return run_command(["nix-hash", "--to-sri", "--type", "sha256", base32])


def ensure_is_list(x):
    if type(x) is not list:
        return [x]
    return x


def one_or_more(x):
    return x if isinstance(x, list) else [x]


def replace_blocks(
    config: UpdaterConfig, file: Path, blocks: Iterable[tuple[str, str]]
):
    """
    Replace placeholder blocks in a nix file.

    The blocks must be enclosed  in the `file` with lines
    `# update-script-start: XXX` and `# update-script-end: XXX`,
    where these lines must only contain that string and optionally any
    number of leading and trailing whitespaces. `XXX` in this example is the
    identifier of the block.

    The lines between these markers are replaced with the content of the block.
    The content is stripped of trailin and leading lines containing only whitespaces first.

    The file is formatted with `nixfmt` after saving.
    """
    with open(file, "r") as f:
        lines = f.readlines()

    for name, block in blocks:
        old_lines = lines
        lines = []
        have_found_start = False
        have_found_end = False
        for line in old_lines:
            if not have_found_start and line.lstrip().startswith(
                f"# update-script-start: {name}"
            ):
                have_found_start = True
                lines.append(line)
            elif have_found_start and line.lstrip().startswith(
                f"# update-script-end: {name}"
            ):
                for replacement_line in block.splitlines(True):
                    if replacement_line.rstrip("\n") == "":
                        # Skip empty lines in replacement
                        continue
                    lines.append(replacement_line)
                have_found_end = True
                lines.append(line)
            elif not have_found_start or have_found_end:
                lines.append(line)
        if not have_found_start or not have_found_end:
            raise Exception(
                f"Either start or end marker for `{name}` block missing in `{file}`"
            )

    with open(file, "w") as f:
        f.writelines(lines)

    run_command(
        ["nix-shell", "--run", f"treefmt --no-cache {file.absolute()}"],
        cwd=config.nixpkgs_root,
    )
