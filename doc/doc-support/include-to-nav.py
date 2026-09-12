import json
import re
import sys
from pathlib import Path
from typing import TypedDict

# Coupled to where this file lives!
# Needed to resolve the relative includes file paths
DOC_ROOT = Path(__file__).resolve().parent.parent

ROOT_FILE = DOC_ROOT / "manual.md.in"

INCLUDE_RE = re.compile(r"^```\{=include=\}(?P<rest>.*)$")
FENCE_RE = re.compile(r"^(```|~~~)")
HEADING_RE = re.compile(r"^(#{1,6})\s+(.*?)\s*(?:\{#([^}]+)\})?\s*$")


class TokenIncludeBlock:
    """Represents a complete include block like:

    ```{=include=} sections
    special/buildenv.section.md
    ```

    As

    typ = "sections"
    files = [ "special/buildenv.section.md" ]

    """
    kind = "include"

    def __repr__(self):
        # For debugging
        return f"```{{=include=}} {self.typ}\n" "\n".join(self.files) + "\n```"

    def __init__(self, typ, args, files, start, end):
        self.typ: str = typ
        self.args: list[str] = args
        self.files: list[str] = files
        self.start: int = start
        self.end: int = end

    def is_option_block(self) -> bool:
        # option blocks have some special syntax which is part of another migration
        # 8 coccurrences, seperate migration
        return self.typ == "options"

    def into_file(self) -> bool:
        # into-file is trivial after the nav migration
        # 2 coccurrences, can be migrated by hand
        return any("html:into-file=" in arg for arg in self.args)

    def keep(self) -> bool:
        # Keep the include blocks that require seperate migration
        return self.is_option_block() or self.into_file()

class TokenHeading:
    kind = "heading"

    def __init__(self, level, title, anchor):
        self.level: int = level
        self.title: str = title
        self.anchor: str = anchor


def tokenize(src: str) -> list[TokenIncludeBlock|TokenHeading]:
    """Finds all Includes and Headings"""
    lines = src.splitlines()
    items = []
    fenced = False
    i = 0
    while i < len(lines):
        line = lines[i]
        m = INCLUDE_RE.match(line)
        if m and not fenced:
            typ, *args = m.group("rest").split()
            end = i + 1
            while end < len(lines) and not lines[end].startswith("```"):
                end += 1
            if end == len(lines):
                sys.exit(f"unterminated include block at line {i + 1}")
            files = [f.strip() for f in lines[i + 1 : end] if f.strip()]
            items.append(TokenIncludeBlock(typ, args, files, i, end))
            i = end + 1
            continue
        if FENCE_RE.match(line):
            fenced = not fenced
            i += 1
            continue
        if not fenced:
            m = HEADING_RE.match(line)
            if m:
                items.append(TokenHeading(len(m.group(1)), m.group(2), m.group(3)))
        i += 1
    return items


def read_source(source: Path) ->  None | tuple[str, Path]:
    """Read a return [content,Path]

    library.md is called .md.in; provided at build time via nixdoc

    So the filename might differ
    """
    if source.exists():
        return source.read_text(), source

    in_file = Path(str(source) + ".in")
    if in_file.exists():
        return in_file.read_text(), in_file
    return None

# Make sure we process every file only once
visited = set()

# Map from filename -> line_nrs
# These lines will be deleted from the file
rewrites: dict[str, tuple[int,int]] = {}

group_ids: set[str] = set()

class Green(TypedDict):
    label: str
    id: str
    children: list["Green"]
    file: str | None

def convert_md_in(md_in: Path) -> Green:
    """Build up items for the nav.json as we recurse.
    Collecting line-areas and group_ids
    """
    if md_in in visited:
        sys.exit(f"{md_in}: reached twice")

    visited.add(md_in)

    res = read_source(md_in)

    rel_file = md_in.relative_to(DOC_ROOT).as_posix()
    if not res:
        return {"file": rel_file}

    text, actual = res
    token: list[TokenHeading|TokenIncludeBlock] = tokenize(text)

    # Collect a list of actual files to be processed
    # Recurse for files
    # Do not recurse for "options", "into-file"
    all_file_includes: list[TokenIncludeBlock] = [it for it in token if it.kind == "include" and not (it.is_option_block() or it.into_file())]
    children = [convert_md_in((md_in.parent / f).resolve()) for b in all_file_includes for f in b.files]

    # Lines to rewrite
    include_blocks_to_rewrite: list[TokenIncludeBlock] = [it for it in all_file_includes if not it.keep()]
    rewrites[actual] = [(b.start, b.end) for b in include_blocks_to_rewrite]

    if not children:
        return {"file": rel_file}

    title = next((it for it in token if it.kind == "heading" and it.level == 1), None)
    if title is None:
        sys.exit(f"{md_in}: no level-1 heading to label its group")
    if not title.anchor:
        sys.exit(f"{md_in}: level-1 heading has no id")
    if title.anchor in group_ids:
        sys.exit(f"{md_in}: duplicate group id {title.anchor}")
    group_ids.add(title.anchor)

    return Green({
        "label": title.title.replace("`", ""),
        "id": title.anchor,
        "children": [{"file": rel_file}] + children,
    })


def remove_includes(path: Path, drop_lines: tuple[int,int]):
    if not drop_lines:
        return

    lines = path.read_text().splitlines()
    for start, end in sorted(drop_lines, reverse=True):
        del lines[start : end + 1]
        if 0 < start < len(lines) and not lines[start - 1].strip() and not lines[start].strip():
            del lines[start]
    while lines and not lines[-1].strip():
        lines.pop()
    path.write_text("\n".join(lines) + "\n")


def main():
    nav = DOC_ROOT / "nav.json"
    if json.loads(nav.read_text())["items"]:
        sys.exit("nav.json already has items; This tool can only run once")

    root = convert_md_in(ROOT_FILE)
    items = root["children"][1:]

    nav.write_text(json.dumps({"open": [], "items": items}, indent=2) + "\n")
    for path, lines in rewrites.items():
        remove_includes(path, lines)


if __name__ == "__main__":
    main()
