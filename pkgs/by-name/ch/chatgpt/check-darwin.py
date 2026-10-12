"""Check the vendor bundle identity and version without modifying it."""

import plistlib
import sys
from pathlib import Path

bundle = Path(sys.argv[1])
with (bundle / "Contents/Info.plist").open("rb") as stream:
    metadata = plistlib.load(stream)
for field, expected in {
    "CFBundleIdentifier": "com.openai.codex",
    "CFBundleExecutable": "ChatGPT",
    "CFBundleShortVersionString": sys.argv[2],
}.items():
    if metadata.get(field) != expected:
        raise ValueError(
            f"Unexpected {field}: {metadata.get(field)!r}, expected {expected!r}"
        )
