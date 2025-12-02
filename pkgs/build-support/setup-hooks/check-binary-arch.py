#!/usr/bin/env python3
"""
Verify that ELF binaries match the expected host platform architecture.

This tool compiles an empty object file to determine the expected e_machine
value, then checks all ELF files in the specified paths to ensure they match.
"""

import argparse
import os
import struct
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

# Global debug flag
DEBUG = False


def debug(msg: str) -> None:
    """Print debug message if debug mode is enabled."""
    if DEBUG:
        print(f"[DEBUG] {msg}", file=sys.stderr)

# ELF magic bytes
ELF_MAGIC = b"\x7fELF"

# e_machine field offset and size in ELF header
E_MACHINE_OFFSET = 18
E_MACHINE_SIZE = 2

# Mapping from e_machine values to human-readable architecture names
# See: https://refspecs.linuxfoundation.org/elf/gabi4+/ch4.eheader.html
E_MACHINE_NAMES: dict[int, str] = {
    3: "i386",
    8: "mips",
    20: "powerpc",
    21: "powerpc64",
    40: "arm",
    43: "sparc",
    62: "x86_64",
    183: "aarch64",
    243: "riscv",
}


def get_arch_name(e_machine: int) -> str:
    """Get human-readable architecture name for e_machine value."""
    return E_MACHINE_NAMES.get(e_machine, f"unknown({e_machine})")


def is_elf(path: Path) -> bool:
    """Check if file starts with ELF magic bytes."""
    try:
        with open(path, "rb") as f:
            magic = f.read(4)
            result = magic == ELF_MAGIC
            debug(f"is_elf({path}): magic={magic.hex()}, is_elf={result}")
            return result
    except (OSError, IOError) as e:
        debug(f"is_elf({path}): error reading file: {e}")
        return False


def get_e_machine(path: Path) -> int | None:
    """Read e_machine field (2 bytes at offset 18) from ELF header."""
    try:
        with open(path, "rb") as f:
            f.seek(E_MACHINE_OFFSET)
            data = f.read(E_MACHINE_SIZE)
            if len(data) != E_MACHINE_SIZE:
                debug(f"get_e_machine({path}): insufficient data read")
                return None
            # e_machine is a 16-bit little-endian value
            e_machine = struct.unpack("<H", data)[0]
            debug(f"get_e_machine({path}): e_machine={e_machine} ({get_arch_name(e_machine)})")
            return e_machine
    except (OSError, IOError) as e:
        debug(f"get_e_machine({path}): error reading file: {e}")
        return None


def get_expected_e_machine(cc: str) -> int:
    """Compile an empty object file and extract its e_machine value."""
    debug(f"get_expected_e_machine: using compiler {cc}")
    with tempfile.TemporaryDirectory() as tmpdir:
        obj_path = Path(tmpdir) / "ref.o"
        debug(f"get_expected_e_machine: compiling reference object to {obj_path}")
        try:
            # Compile empty C file to object
            subprocess.run(
                [cc, "-c", "-x", "c", "-", "-o", str(obj_path)],
                input=b"",
                capture_output=True,
                check=True,
            )
        except subprocess.CalledProcessError as e:
            print(
                "check-binary-arch: ERROR: Failed to compile reference object",
                file=sys.stderr,
            )
            print(f"  Command: {cc} -c -x c - -o {obj_path}", file=sys.stderr)
            print(f"  stderr: {e.stderr.decode()}", file=sys.stderr)
            sys.exit(1)
        except FileNotFoundError:
            print(f"check-binary-arch: ERROR: Compiler not found: {cc}", file=sys.stderr)
            sys.exit(1)

        e_machine = get_e_machine(obj_path)
        if e_machine is None:
            print(
                "check-binary-arch: ERROR: Failed to read e_machine from reference object",
                file=sys.stderr,
            )
            sys.exit(1)

        debug(f"get_expected_e_machine: expected e_machine={e_machine} ({get_arch_name(e_machine)})")
        return e_machine


def check_binary(path: Path, expected: int) -> tuple[Path, int | None] | None:
    """
    Check if a binary has the expected architecture.

    Returns (path, actual_e_machine) if mismatch, None if OK or not an ELF.
    Returns (path, None) if e_machine could not be read.
    """
    debug(f"check_binary: checking {path}")
    if not path.is_file() or path.is_symlink():
        debug(f"check_binary: {path} is not a regular file or is a symlink, skipping")
        return None

    if not is_elf(path):
        debug(f"check_binary: {path} is not an ELF file, skipping")
        return None

    actual = get_e_machine(path)
    if actual is None:
        debug(f"check_binary: {path} could not read e_machine")
        return (path, None)

    if actual != expected:
        debug(f"check_binary: {path} MISMATCH: got {actual}, expected {expected}")
        return (path, actual)

    debug(f"check_binary: {path} OK")
    return None


def find_binaries(paths: list[Path]) -> list[Path]:
    """Find all files in the given paths recursively."""
    debug(f"find_binaries: searching in {paths}")
    binaries = []
    for path in paths:
        if path.is_dir():
            debug(f"find_binaries: scanning directory {path} recursively")
            for entry in path.rglob("*"):
                if entry.is_file() and not entry.is_symlink():
                    debug(f"find_binaries: found file {entry}")
                    binaries.append(entry)
        elif path.is_file():
            debug(f"find_binaries: adding file {path}")
            binaries.append(path)
    debug(f"find_binaries: found {len(binaries)} files to check")
    return binaries


def main() -> None:
    global DEBUG

    parser = argparse.ArgumentParser(
        description="Verify ELF binaries match expected architecture"
    )
    parser.add_argument(
        "--cc",
        required=True,
        help="Path to the C compiler",
    )
    parser.add_argument(
        "--paths",
        nargs="+",
        required=True,
        type=Path,
        help="Directories or files to check",
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="Enable verbose debug logging",
    )

    args = parser.parse_args()

    # Enable debug mode via --debug flag or checkBinaryArchDebug env var
    DEBUG = args.debug or os.environ.get("checkBinaryArchDebug", "") != ""

    # Get number of parallel jobs from NIX_BUILD_CORES, defaulting to 1
    jobs = int(os.environ.get("NIX_BUILD_CORES", "1")) or 1

    if DEBUG:
        debug("Debug mode enabled")
        debug(f"Arguments: cc={args.cc}, paths={args.paths}, jobs={jobs}")

    # Get expected e_machine from compiler
    expected = get_expected_e_machine(args.cc)

    # Find all binaries to check
    binaries = find_binaries(args.paths)

    if not binaries:
        return

    # Check all binaries in parallel
    errors: list[tuple[Path, int | None]] = []
    with ThreadPoolExecutor(max_workers=jobs) as executor:
        futures = {
            executor.submit(check_binary, binary, expected): binary
            for binary in binaries
        }
        for future in as_completed(futures):
            result = future.result()
            if result:
                errors.append(result)

    if errors:
        expected_name = get_arch_name(expected)
        print(
            "check-binary-arch: ERROR: Binary architecture mismatch detected!",
            file=sys.stderr,
        )
        print(file=sys.stderr)
        print(
            f"Expected architecture: {expected_name} (e_machine={expected})",
            file=sys.stderr,
        )
        print(file=sys.stderr)
        print("Mismatched binaries:", file=sys.stderr)
        for path, actual in sorted(errors, key=lambda x: str(x[0])):
            print(f"  {path}", file=sys.stderr)
            if actual is None:
                print("    Error: could not read e_machine", file=sys.stderr)
            else:
                actual_name = get_arch_name(actual)
                print(
                    f"    Found:    {actual_name} (e_machine={actual})",
                    file=sys.stderr,
                )
                print(
                    f"    Expected: {expected_name} (e_machine={expected})",
                    file=sys.stderr,
                )
        print(file=sys.stderr)
        print(
            "This usually means the binary was built for a different platform.",
            file=sys.stderr,
        )
        print("Common causes:", file=sys.stderr)
        print("  - Prebuilt binary fetched for wrong architecture", file=sys.stderr)
        print("  - Cross-compilation misconfiguration", file=sys.stderr)
        print(file=sys.stderr)
        print("To disable this check, set: dontCheckBinaryArch = true;", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
