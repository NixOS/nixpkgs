# Render nixdoc's manifest-mode export JSON V1 into markdown sections.

from typing import Any, NamedTuple

_SCHEMA_VERSION = 1


class NixdocExportError(Exception):
    pass

class Source(NamedTuple):
    file: str
    line: int


class Group(NamedTuple):
    id: str
    description: str


class Entry(NamedTuple):
    id: str
    attr_path: str
    groups: list[str]
    description: str
    source: Source


class Export(NamedTuple):
    groups: list[Group]
    entries: list[Entry]


def _require(obj: dict[str, Any], key: str, ctx: str) -> Any:
    try:
        return obj[key]
    except (KeyError, TypeError) as e:
        raise NixdocExportError(f"{ctx}: missing required field {key!r}") from e


def _parse_group(raw: dict[str, Any]) -> Group:
    group_id = _require(raw, "id", "group")
    return Group(id=group_id, description=(raw.get("description") or "").strip())


def _parse_entry(raw: dict[str, Any]) -> Entry:
    entry_id = _require(raw, "id", "entry")
    ctx = f"entry {entry_id!r}"
    source = _require(raw, "source", ctx)
    return Entry(
        id=entry_id,
        attr_path=_require(raw, "attrPath", ctx),
        groups=_require(raw, "groups", ctx),
        description=_require(raw, "description", ctx),
        source=Source(file=_require(source, "file", ctx), line=_require(source, "line", ctx)),
    )


def parse_export(data: dict[str, Any]) -> Export:
    schema = data.get("schemaVersion") if isinstance(data, dict) else None
    if schema != _SCHEMA_VERSION:
        raise NixdocExportError(
            f"unsupported nixdoc export schemaVersion {schema!r}; "
            f"this renderer supports version {_SCHEMA_VERSION}"
        )
    return Export(
        groups=[_parse_group(g) for g in _require(data, "groups", "export")],
        entries=[_parse_entry(e) for e in _require(data, "entries", "export")],
    )


def _trim_leading_whitespace(line: str, max_count: int) -> str:
    count = 0
    i = 0
    for ch in line:
        if ch.isspace() and count < max_count:
            count += 1
            i += 1
        else:
            break
    return line[i:]


def _get_fence(line: str, allow_info: bool) -> tuple[int, str] | None:
    if not line:
        return None
    first = line[0]
    if first not in ('`', '~'):
        return None
    count = 1
    for ch in line[1:]:
        if ch == first:
            count += 1
        else:
            if not allow_info and ch != '\n':
                return None
            return (count, first)
    return (count, first)


def _handle_heading(line: str, levels: int) -> str:
    hashes = 0
    for ch in line:
        if ch == '#':
            hashes += 1
        else:
            break
    rest = line[hashes:]
    new_hashes = min(hashes + levels, 6)
    return f"{'#' * new_hashes}{rest}"


def shift_headings(text: str, levels: int) -> str:
    result: list[str] = []
    curr_fence: tuple[int, str] | None = None
    for raw_line in text.splitlines(keepends=True):
        line = _trim_leading_whitespace(raw_line, 3)
        if line.startswith("```") or line.startswith("~~~"):
            if curr_fence is None:
                curr_fence = _get_fence(line, True)
            else:
                end = _get_fence(line, False)
                if end is not None:
                    start_count, start_char = curr_fence
                    end_count, end_char = end
                    if start_char == end_char and start_count <= end_count:
                        curr_fence = None

        if curr_fence is None and line.startswith('#'):
            result.append(_handle_heading(line, levels))
        else:
            result.append(raw_line)
    return "".join(result)


def _located_at(source: Source, revision: str) -> str:
    url = f"https://github.com/NixOS/nixpkgs/blob/{revision}/{source.file}#L{source.line}"
    return f"Located at [{source.file}:{source.line}]({url}) in `<nixpkgs>`."


def render_group(group: Group, entries: list[Entry], revision: str) -> str:
    parts = [f"# {group.id} {{#sec-functions-library-{group.id}}}\n"]
    if group.description:
        parts.append(shift_headings(group.description, 1) + "\n")

    for entry in entries:
        parts.append(f"## `{entry.attr_path}` {{#function-library-{entry.id}}}\n")
        body = shift_headings(entry.description.strip(), 2)
        if body:
            parts.append(body + "\n")
        parts.append(_located_at(entry.source, revision) + "\n")

    return "\n".join(parts)


def render_sections(data: dict[str, Any], revision: str) -> list[tuple[str, str]]:
    export = parse_export(data)
    by_group: dict[str, list[Entry]] = {group.id: [] for group in export.groups}
    for entry in export.entries:
        for group_id in entry.groups:
            if group_id in by_group:
                by_group[group_id].append(entry)
    return [
        (group.id, render_group(group, by_group[group.id], revision))
        for group in export.groups
    ]
