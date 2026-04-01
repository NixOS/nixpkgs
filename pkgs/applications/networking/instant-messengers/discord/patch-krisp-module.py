#!/usr/bin/env python3
"""Post-process Discord's Krisp module for use from Nix builds."""

import sys
from pathlib import Path

import lief


INIT_CALL = "KrispModule._initialize(initializationParams);"
INIT_GUARD = "process.env.NIXPKGS_KRISP_INITIALIZED"
INIT_PATCH = f"""if ({INIT_GUARD} !== "1") {{
    {INIT_CALL}
    {INIT_GUARD} = "1";
}}"""

# KrispInitializeExternal returns 0 on success. The module is initialized from
# index.js above, so the Linux external init hook can report success without
# running the native initializer a second time.
LINUX_EXTERNAL_INIT_PATCH = b"\x31\xc0\xc3"  # xor eax, eax; ret


def patch_index(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    if INIT_GUARD in text:
        return
    if INIT_CALL not in text:
        raise RuntimeError(f"could not find Krisp initialize call in {path}")
    path.write_text(text.replace(INIT_CALL, INIT_PATCH), encoding="utf-8")


def patch_linux_external_init(path: Path) -> None:
    elf = lief.parse(str(path))
    symbol = elf.get_dynamic_symbol("KrispInitializeExternal")
    if symbol is None:
        raise RuntimeError("could not find KrispInitializeExternal")
    offset = elf.virtual_address_to_offset(symbol.value)
    data = bytearray(path.read_bytes())
    end = offset + len(LINUX_EXTERNAL_INIT_PATCH)
    if end > len(data):
        raise RuntimeError("KrispInitializeExternal patch is outside the binary")
    data[offset:end] = LINUX_EXTERNAL_INIT_PATCH
    path.write_bytes(data)


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(f"Usage: {sys.argv[0]} <module-dir> <linux|darwin>")

    module_dir = Path(sys.argv[1])
    platform = sys.argv[2]
    patch_index(module_dir / "index.js")

    if platform == "linux":
        patch_linux_external_init(module_dir / "discord_krisp.node")
    elif platform != "darwin":
        raise SystemExit(f"unsupported platform: {platform}")


if __name__ == "__main__":
    main()
