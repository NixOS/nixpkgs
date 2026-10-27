#!/usr/bin/env python3
"""Extract the API registry embedded in an official lark-cli release binary.

lark-cli embeds its registry of Lark Open Platform APIs
(internal/registry/meta_data.json) into the binary at build time:
build.sh runs scripts/fetch_meta.py and internal/registry/loader_embedded.go
pulls the file in via go:embed. scripts/fetch_meta.py stores the document
with json.dump(..., indent=2), so the registry exists verbatim in the
binary's read-only data section as a pretty-printed JSON object.

This script locates that object without anchoring on any particular key
order: the key order of the embedded registry is whatever the API endpoint
used on the day upstream built the release (releases 1.0.58 and 1.0.88
already differ), so it enumerates every pretty-printed top-level object in
the binary and keeps the only one that parses as JSON with a non-empty
"services" list. Extraction uses a brace-matching scan that is string- and
escape-aware. The binary is never executed, so the linux-amd64 release
artifact works as the source on every platform.

If upstream changes how the registry is embedded, extraction fails loudly
instead of silently producing stale data.
"""

import json
import sys


def candidates(data: bytes):
    # json.dump(..., indent=2) indents nested objects deeper, so a newline
    # followed by exactly two spaces can only occur at the top level of a
    # pretty-printed document: every such '{' is a candidate, and inner
    # objects of the registry itself never match. Raw newlines cannot occur
    # inside JSON strings, so string literals produce no false candidates
    # either. The registry's own key order is whatever the endpoint used
    # when upstream built the release; do not anchor on any specific key.
    marker = b'{\n  "'
    start = 0
    while True:
        offset = data.find(marker, start)
        if offset < 0:
            return
        start = offset + 1
        yield offset


def extract_object(data: bytes, start: int) -> bytes | None:
    # Returns the bytes of the JSON object starting at `start`, or None when
    # the bytes do not form one. Bails out on NUL bytes and unbalanced
    # closes, which end non-JSON regions of the binary quickly.
    depth = 0
    in_string = False
    escaped = False
    for offset in range(start, len(data)):
        byte = data[offset]
        if byte == 0:
            return None
        if in_string:
            if escaped:
                escaped = False
            elif byte == 0x5C:  # backslash
                escaped = True
            elif byte == 0x22:  # double quote
                in_string = False
        elif byte == 0x22:
            in_string = True
        elif byte == 0x7B:  # '{'
            depth += 1
        elif byte == 0x7D:  # '}'
            depth -= 1
            if depth < 0:
                return None
            if depth == 0:
                return data[start : offset + 1]
    return None


def main() -> None:
    if len(sys.argv) != 3:
        sys.exit(f"usage: {sys.argv[0]} LARK_CLI_BINARY OUTPUT_JSON")

    binary_path, output_path = sys.argv[1], sys.argv[2]
    with open(binary_path, "rb") as fp:
        data = fp.read()

    registry = None
    for start in candidates(data):
        blob = extract_object(data, start)
        if blob is None:
            continue
        try:
            document = json.loads(blob)
        except ValueError:
            continue
        # The real registry is the only candidate with a non-empty service
        # list; embedded fallbacks look like {"version":"0.0.0","services":[]}.
        if isinstance(document.get("services"), list) and document["services"]:
            if registry is None or len(blob) > len(registry):
                registry = blob

    if registry is None:
        sys.exit("no embedded API registry found in binary")

    with open(output_path, "wb") as fp:
        fp.write(registry)


if __name__ == "__main__":
    main()
