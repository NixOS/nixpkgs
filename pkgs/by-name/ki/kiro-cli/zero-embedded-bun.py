#!/usr/bin/env python3
"""
Zero out the embedded bun ELF inside kiro-cli-chat in-place.

kiro-cli-chat embeds:
  [...]
  [bun ELF bytes]                (binary data, 100MB+)
  [bun.sha256 hex string]        (64 ASCII chars, the expected hash)
  [tui.js bytes]
  [tui.js.sha256 hex string]
  [...]

The runtime extraction logic verifies the on-disk bun.sha256 against the
embedded hash, but does NOT verify the bun bytes themselves. Combined with
a wrapper that pre-creates ~/.local/share/kiro-cli/bun -> ${bun}/bin/bun
and writes the embedded bun.sha256, the embedded bun bytes are never
extracted to disk and are dead weight inside kiro-cli-chat. We zero them
out so they compress to nothing in the binary cache.

Usage:
  zero-embedded-bun.py <kiro-cli-chat> <extracted_bun> <bun.sha256_file>

The bun.sha256 string is unique inside kiro-cli-chat, so we use it as a
locator: bun_end = position of sha string, bun_start = bun_end - bun_size.
"""
import sys


def main() -> int:
    if len(sys.argv) != 4:
        sys.stderr.write(
            f"usage: {sys.argv[0]} <chat_binary> <extracted_bun> <bun_sha_file>\n"
        )
        return 2

    chat_path, bun_path, sha_path = sys.argv[1:4]

    with open(bun_path, "rb") as f:
        bun_bytes = f.read()
    with open(sha_path, "rb") as f:
        sha_str = f.read().rstrip(b"\n")

    if len(sha_str) != 64 or not all(c in b"0123456789abcdef" for c in sha_str):
        sys.stderr.write(f"unexpected sha format: {sha_str!r}\n")
        return 1

    with open(chat_path, "rb") as f:
        data = f.read()

    positions = []
    pos = -1
    while True:
        pos = data.find(sha_str, pos + 1)
        if pos < 0:
            break
        positions.append(pos)
    if len(positions) != 1:
        sys.stderr.write(
            f"expected exactly one occurrence of {sha_str.decode()} "
            f"in {chat_path}, found {len(positions)}: "
            f"{[hex(p) for p in positions]}\n"
        )
        return 1

    sha_pos = positions[0]
    bun_start = sha_pos - len(bun_bytes)
    if bun_start < 0:
        sys.stderr.write(
            f"computed bun_start {bun_start:#x} is negative\n"
        )
        return 1

    actual = data[bun_start:sha_pos]
    if actual != bun_bytes:
        sys.stderr.write(
            f"bytes at offset {bun_start:#x} do not match extracted bun\n"
        )
        return 1

    sys.stdout.write(
        f"zeroing {len(bun_bytes):,} bytes of embedded bun "
        f"at offset {bun_start:#x} in {chat_path}\n"
    )
    with open(chat_path, "r+b") as f:
        f.seek(bun_start)
        f.write(b"\x00" * len(bun_bytes))
    return 0


if __name__ == "__main__":
    sys.exit(main())
