#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages (ps: [ ps.unicorn ps.pyelftools ])" squashfsTools _7zz
import base64
import hashlib
import json
import plistlib
import re
import struct
import subprocess
import sys
import tempfile
import urllib.parse
import urllib.request
from pathlib import Path

from elftools.elf.elffile import ELFFile
from unicorn import UC_ARCH_ARM64, UC_ARCH_X86, UC_MODE_64, UC_MODE_ARM, Uc
from unicorn.arm64_const import UC_ARM64_REG_LR, UC_ARM64_REG_SP, UC_ARM64_REG_X8
from unicorn.x86_const import UC_X86_REG_RDI, UC_X86_REG_RSP

PACKAGE_FILE = Path(__file__).parent / "package.nix"
UPSTREAM_URL = "https://static.immersed.com/dl/"
UPSTREAM_FILES = {
    "x86_64-linux": "Immersed-x86_64.AppImage",
    "aarch64-linux": "Immersed-aarch64.AppImage",
    "aarch64-darwin": "Immersed.dmg",
}

APPIMAGE_BINARY = "usr/bin/Immersed"
MANGLED_GET_APP_VERSION = "_Z13GetAppVersionB5cxx11v"
MACOS_INFO_PLIST_PATTERN = "*/Immersed.app/Contents/Info.plist"

POINTER_SIZE = 8
STD_STRING_LAYOUT = struct.Struct("<QQ")
assert STD_STRING_LAYOUT.size == 2 * POINTER_SIZE

PAGE_SIZE = 0x1000
CODE_ADDRESS = 0x1000000
CODE_SIZE = PAGE_SIZE
DATA_ADDRESS = 0x2000000
DATA_SIZE = 16 * PAGE_SIZE
STRING_SLOT_ADDRESS = DATA_ADDRESS
STACK_TOP = DATA_ADDRESS + DATA_SIZE - PAGE_SIZE
RETURN_ADDRESS = 0x3000000

DOWNLOAD_CHUNK_SIZE = 1 << 20


def download(url, destination):
    digest = hashlib.sha256()
    with urllib.request.urlopen(url) as response, open(destination, "wb") as output:
        while chunk := response.read(DOWNLOAD_CHUNK_SIZE):
            digest.update(chunk)
            output.write(chunk)
    return "sha256-" + base64.b64encode(digest.digest()).decode()


def squashfs_offset(elf):
    return elf["e_shoff"] + elf["e_shentsize"] * elf["e_shnum"]


def symbol_machine_code(elf, name):
    symbol = elf.get_section_by_name(".symtab").get_symbol_by_name(name)[0]
    address = symbol["st_value"]
    for section in elf.iter_sections():
        if section["sh_addr"] <= address < section["sh_addr"] + section["sh_size"]:
            elf.stream.seek(section["sh_offset"] + address - section["sh_addr"])
            return elf.stream.read(symbol["st_size"])
    raise LookupError(f"{name} is not inside any section")


def new_emulator(machine):
    if machine == "EM_X86_64":
        emulator = Uc(UC_ARCH_X86, UC_MODE_64)
        emulator.mem_map(DATA_ADDRESS, DATA_SIZE)
        emulator.mem_write(STACK_TOP, struct.pack("<Q", RETURN_ADDRESS))
        emulator.reg_write(UC_X86_REG_RSP, STACK_TOP)
        emulator.reg_write(UC_X86_REG_RDI, STRING_SLOT_ADDRESS)
    elif machine == "EM_AARCH64":
        emulator = Uc(UC_ARCH_ARM64, UC_MODE_ARM)
        emulator.mem_map(DATA_ADDRESS, DATA_SIZE)
        emulator.reg_write(UC_ARM64_REG_SP, STACK_TOP)
        emulator.reg_write(UC_ARM64_REG_X8, STRING_SLOT_ADDRESS)
        emulator.reg_write(UC_ARM64_REG_LR, RETURN_ADDRESS)
    else:
        raise ValueError(f"unsupported machine: {machine}")
    return emulator


def run_returning_std_string(machine, code):
    assert len(code) <= CODE_SIZE
    emulator = new_emulator(machine)
    emulator.mem_map(CODE_ADDRESS, CODE_SIZE)
    emulator.mem_write(CODE_ADDRESS, code)
    emulator.emu_start(CODE_ADDRESS, RETURN_ADDRESS)
    data_pointer, length = STD_STRING_LAYOUT.unpack(
        emulator.mem_read(STRING_SLOT_ADDRESS, STD_STRING_LAYOUT.size)
    )
    return emulator.mem_read(data_pointer, length).decode()


def linux_version(appimage):
    with open(appimage, "rb") as stream:
        offset = squashfs_offset(ELFFile(stream))

    with tempfile.TemporaryDirectory() as workdir:
        subprocess.run(
            ["unsquashfs", "-q", "-o", str(offset), "-d", workdir, str(appimage), APPIMAGE_BINARY],
            check=True,
            stdout=subprocess.DEVNULL,
        )
        with open(Path(workdir) / APPIMAGE_BINARY, "rb") as stream:
            binary = ELFFile(stream)
            code = symbol_machine_code(binary, MANGLED_GET_APP_VERSION)
            return run_returning_std_string(binary["e_machine"], code)


def darwin_version(dmg):
    with tempfile.TemporaryDirectory() as workdir:
        subprocess.run(
            ["7zz", "e", "-y", f"-o{workdir}", str(dmg), MACOS_INFO_PLIST_PATTERN],
            check=True,
            stdout=subprocess.DEVNULL,
        )
        with open(Path(workdir) / "Info.plist", "rb") as stream:
            return plistlib.load(stream)["CFBundleShortVersionString"]


def wayback_snapshot_url(url):
    quoted = urllib.parse.quote(url, safe="")
    urllib.request.urlopen(f"https://web.archive.org/save/{url}").close()
    with urllib.request.urlopen(f"https://archive.org/wayback/available?url={quoted}") as response:
        snapshot = json.load(response)["archived_snapshots"]["closest"]["url"]
    return snapshot.replace("http://", "https://", 1)


def source_block(package, system):
    return re.search(rf"^    {re.escape(system)} = \{{\n.*?^    \}};\n", package, re.M | re.S)


def pinned_value(package, system, field):
    return re.search(rf'{field} = "(.*)";', source_block(package, system).group()).group(1)


def pin(package, system, **values):
    block = source_block(package, system)
    updated = block.group()
    for field, value in values.items():
        updated = re.sub(rf'{field} = ".*";', f'{field} = "{value}";', updated)
    return package[: block.start()] + updated + package[block.end() :]


def main():
    package = PACKAGE_FILE.read_text()

    for system, filename in UPSTREAM_FILES.items():
        upstream = UPSTREAM_URL + filename
        old_version = pinned_value(package, system, "version")

        with tempfile.TemporaryDirectory() as workdir:
            downloaded = Path(workdir) / filename
            hash = download(upstream, downloaded)

            if hash == pinned_value(package, system, "hash"):
                print(f"immersed ({system}) is up to date ({old_version})")
                continue

            version = (darwin_version if system.endswith("-darwin") else linux_version)(downloaded)

        if not re.fullmatch(r"\d+(\.\d+)+", version):
            sys.exit(f"failed to detect version for {system}")

        package = pin(package, system, version=version, url=wayback_snapshot_url(upstream), hash=hash)
        PACKAGE_FILE.write_text(package)
        print(f"immersed ({system}): {old_version} -> {version}")


if __name__ == "__main__":
    main()
