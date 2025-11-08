"""Copy Noto Color Emoji PNGs into an extracted Signal ASAR archive.

Signal loads small Apple emoji PNGs directly from
`node_modules/emoji-datasource-apple/img/apple/64`, and downloads and
caches large Apple emoji WebP files in `.proto` bundles on the fly. The
latter are not a copyright concern for the Nixpkgs cache, but would
result in inconsistent presentation between small and large emoji.

We skip the complexity and buy some additional privacy by replacing the
`emoji://jumbo?emoji=` URL prefix with a `file://` path to the copied
PNGs inside the ASAR archive, and linking the `node_modules` PNG paths
directly to them.
"""

import json
import shutil
import sys
from pathlib import Path


def emoji_to_noto_name(emoji: str) -> str:
    r"""Return the Noto emoji name of an emoji.

    Noto emoji names are underscore‐separated Unicode scalar values,
    represented in lowercase big‐endian hex padded to at least four
    digits. Any U+FE0F variant selectors are omitted.

    >>> emoji_to_noto_name("😶‍🌫️")
    '1f636_200d_1f32b'
    >>> emoji_to_noto_name("\U0001f636\u200d\U0001f32b\ufe0f")
    '1f636_200d_1f32b'
    """
    return "_".join(
        f"{ord(scalar_value):04x}"
        for scalar_value in emoji
        if scalar_value != "\ufe0f"
    )


def _main() -> None:
    noto_png_path, asar_root = (Path(arg) for arg in sys.argv[1:])
    asar_root = asar_root.absolute()

    out_path = asar_root / "images" / "nixpkgs-emoji"
    out_path.mkdir(parents=True)

    jumbomoji_json_path = asar_root / "build" / "jumbomoji.json"
    with jumbomoji_json_path.open() as jumbomoji_json_file:
        jumbomoji_packs = json.load(jumbomoji_json_file)

    for signal_emoji_names in jumbomoji_packs.values():
        for signal_emoji_name in signal_emoji_names:

            try:
                shutil.copy(
                    noto_png_path / f"emoji_u{emoji_to_noto_name(signal_emoji_name)}.png",
                    out_path / signal_emoji_name,
                )
            except FileNotFoundError:
                print(
                    f"Missing Noto emoji: {signal_emoji_name}",
                    file=sys.stderr,
                )
                continue

    print(out_path.relative_to(asar_root))


if __name__ == "__main__":
    _main()
