#!/usr/bin/env python3

import argparse
import os
import pprint
import subprocess
import sys
from collections import defaultdict
from contextlib import contextmanager
from dataclasses import dataclass
from itertools import chain
from pathlib import Path, PurePath
from typing import DefaultDict, Iterator, List, Optional, Set, Tuple

from elftools.common.exceptions import ELFError  # type: ignore
from elftools.elf.dynamic import DynamicSection  # type: ignore
from elftools.elf.elffile import ELFFile  # type: ignore
from elftools.elf.enums import ENUM_E_TYPE, ENUM_EI_OSABI  # type: ignore


@contextmanager
def open_elf(path: Path) -> Iterator[ELFFile]:
    with path.open('rb') as stream:
        yield ELFFile(stream)


def is_static_executable(elf: ELFFile) -> bool:
    # Statically linked executables have an ELF type of EXEC but no INTERP.
    return (elf.header["e_type"] == 'ET_EXEC'
            and not elf.get_section_by_name(".interp"))


def is_dynamic_executable(elf: ELFFile) -> bool:
    # We do not require an ELF type of EXEC. This also catches
    # position-independent executables, as they typically have an INTERP
    # section but their ELF type is DYN.
    return bool(elf.get_section_by_name(".interp"))


def get_dependencies(elf: ELFFile) -> List[str]:
    dependencies = []
    # This convoluted code is here on purpose. For some reason, using
    # elf.get_section_by_name(".dynamic") does not always return an
    # instance of DynamicSection, but that is required to call iter_tags
    for section in elf.iter_sections():
        if isinstance(section, DynamicSection):
            for tag in section.iter_tags('DT_NEEDED'):
                dependencies.append(tag.needed)
            break # There is only one dynamic section

    return dependencies


def get_rpath(elf: ELFFile) -> List[str]:
    # This convoluted code is here on purpose. For some reason, using
    # elf.get_section_by_name(".dynamic") does not always return an
    # instance of DynamicSection, but that is required to call iter_tags
    for section in elf.iter_sections():
        if isinstance(section, DynamicSection):
            for tag in section.iter_tags('DT_RUNPATH'):
                return tag.runpath.split(':')

            for tag in section.iter_tags('DT_RPATH'):
                return tag.rpath.split(':')

            break # There is only one dynamic section

    return []


def get_arch(elf: ELFFile) -> str:
    return elf.get_machine_arch()


def get_osabi(elf: ELFFile) -> str:
    return elf.header["e_ident"]["EI_OSABI"]


def osabi_are_compatible(wanted: str, got: str) -> bool:
    """
    Tests whether two OS ABIs are compatible, taking into account the
    generally accepted compatibility of SVR4 ABI with other ABIs.
    """
    if not wanted or not got:
        # One of the types couldn't be detected, so as a fallback we'll
        # assume they're compatible.
        return True

    # Generally speaking, the base ABI (0x00), which is represented by
    # readelf(1) as "UNIX - System V", indicates broad compatibility
    # with other ABIs.
    #
    # TODO: This isn't always true. For example, some OSes embed ABI
    # compatibility into SHT_NOTE sections like .note.tag and
    # .note.ABI-tag.  It would be prudent to add these to the detection
    # logic to produce better ABI information.
    if wanted == 'ELFOSABI_SYSV':
        return True

    # Similarly here, we should be able to link against a superset of
    # features, so even if the target has another ABI, this should be
    # fine.
    if got == 'ELFOSABI_SYSV':
        return True

    # Otherwise, we simply return whether the ABIs are identical.
    return wanted == got


def glob(path: Path, pattern: str, recursive: bool) -> Iterator[Path]:
    return path.rglob(pattern) if recursive else path.glob(pattern)


cached_paths: Set[Path] = set()
soname_cache: DefaultDict[Tuple[str, str], List[Tuple[Path, str]]] = defaultdict(list)


def populate_cache(initial: List[Path], recursive: bool =False) -> None:
    lib_dirs = list(initial)

    while lib_dirs:
        lib_dir = lib_dirs.pop(0)

        if lib_dir in cached_paths:
            continue

        cached_paths.add(lib_dir)

        for path in glob(lib_dir, "*.so*", recursive):
            if not path.is_file():
                continue

            resolved = path.resolve()
            try:
                with open_elf(path) as elf:
                    osabi = get_osabi(elf)
                    arch = get_arch(elf)
                    rpath = [Path(p) for p in get_rpath(elf)
                                     if p and '$ORIGIN' not in p]
                    lib_dirs += rpath
                    soname_cache[(path.name, arch)].append((resolved.parent, osabi))

            except ELFError:
                # Not an ELF file in the right format
                pass


def find_dependency(soname: str, soarch: str, soabi: str) -> Optional[Path]:
    for lib, libabi in soname_cache[(soname, soarch)]:
        if osabi_are_compatible(soabi, libabi):
            return lib
    return None


@dataclass
class Dependency:
    file: Path              # The file that contains the dependency
    name: Path              # The name of the dependency
    found: bool = False     # Whether it was found somewhere


def auto_patchelf_file(path: Path, runtime_deps: list[Path]) -> list[Dependency]:
    try:
        with open_elf(path) as elf:

            if is_static_executable(elf):
                # No point patching these
                print(f"skipping {path} because it is statically linked")
                return []

            if elf.num_segments() == 0:
                # no segment (e.g. object file)
                print(f"skipping {path} because it contains no segment")
                return []

            file_arch = get_arch(elf)
            if interpreter_arch != file_arch:
                # Our target architecture is different than this file's
                # architecture, so skip it.
                print(f"skipping {path} because its architecture ({file_arch})"
                      f" differs from target ({interpreter_arch})")
                return []

            file_osabi = get_osabi(elf)
            if not osabi_are_compatible(interpreter_osabi, file_osabi):
                print(f"skipping {path} because its OS ABI ({file_osabi}) is"
                      f" not compatible with target ({interpreter_osabi})")
                return []

            file_is_dynamic_executable = is_dynamic_executable(elf)

            file_dependencies = map(Path, get_dependencies(elf))

    except ELFError:
        return []

    rpath = []
    if file_is_dynamic_executable:
        print("setting interpreter of", path)
        subprocess.run(
                ["patchelf", "--set-interpreter", interpreter_path.as_posix(), path.as_posix()],
                check=True)
        rpath += runtime_deps

    print("searching for dependencies of", path)
    dependencies = []
    # Be sure to get the output of all missing dependencies instead of
    # failing at the first one, because it's more useful when working
    # on a new package where you don't yet know the dependencies.
    for dep in file_dependencies:
        if dep.is_absolute() and dep.is_file():
            # This is an absolute path. If it exists, just use it.
            # Otherwise, we probably want this to produce an error when
            # checked (because just updating the rpath won't satisfy
            # it).
            continue
        elif (libc_lib / dep).is_file():
            # This library exists in libc, and will be correctly
            # resolved by the linker.
            continue

        if found_dependency := find_dependency(dep.name, file_arch, file_osabi):
            rpath.append(found_dependency)
            dependencies.append(Dependency(path, dep, True))
            print(f"    {dep} -> found: {found_dependency}")
        else:
            dependencies.append(Dependency(path, dep, False))
            print(f"    {dep} -> not found!")

    # Dedup the rpath
    rpath_str = ":".join(dict.fromkeys(map(Path.as_posix, rpath)))

    if rpath:
        print("setting RPATH to:", rpath_str)
        subprocess.run(
                ["patchelf", "--set-rpath", rpath_str, path.as_posix()],
                check=True)

    return dependencies


def auto_patchelf(
        paths_to_patch: List[Path],
        lib_dirs: List[Path],
        runtime_deps: List[Path],
        recursive: bool =True,
        ignore_missing: List[str] = []) -> None:

    if not paths_to_patch:
        sys.exit("No paths to patch, stopping.")

    # Add all shared objects of the current output path to the cache,
    # before lib_dirs, so that they are chosen first in find_dependency.
    populate_cache(paths_to_patch, recursive)
    populate_cache(lib_dirs)

    dependencies = []
    for path in chain.from_iterable(glob(p, '*', recursive) for p in paths_to_patch):
        if not path.is_symlink() and path.is_file():
            dependencies += auto_patchelf_file(path, runtime_deps)

    missing = [dep for dep in dependencies if not dep.found]

    # Print a summary of the missing dependencies at the end
    print(f"auto-patchelf: {len(missing)} dependencies could not be satisfied")
    failure = False
    for dep in missing:
        if dep.name.name in ignore_missing or "*" in ignore_missing:
            print(f"warn: auto-patchelf ignoring missing {dep.name} wanted by {dep.file}")
        else:
            print(f"error: auto-patchelf could not satisfy dependency {dep.name} wanted by {dep.file}")
            failure = True

    if failure:
        sys.exit('auto-patchelf failed to find all the required dependencies.\n'
                 'Add the missing dependencies to --libs or use '
                 '`--ignore-missing="foo.so.1 bar.so etc.so"`.')


def main() -> None:
    parser = argparse.ArgumentParser(
        prog="auto-patchelf",
        description='auto-patchelf tries as hard as possible to patch the'
                    ' provided binary files by looking for compatible'
                    'libraries in the provided paths.')
    parser.add_argument(
        "--ignore-missing",
        nargs="*",
        type=str,
        help="Do not fail when some dependencies are not found.")
    parser.add_argument(
        "--no-recurse",
        dest="recursive",
        action="store_false",
        help="Patch only the provided paths, and ignore their children")
    parser.add_argument(
        "--paths", nargs="*", type=Path,
        help="Paths whose content needs to be patched.")
    parser.add_argument(
        "--libs", nargs="*", type=Path,
        help="Paths where libraries are searched for.")
    parser.add_argument(
        "--runtime-dependencies", nargs="*", type=Path,
        help="Paths to prepend to the runtime path of executable binaries.")

    print("automatically fixing dependencies for ELF files")
    args = parser.parse_args()
    pprint.pprint(vars(args))

    auto_patchelf(
        args.paths,
        args.libs,
        args.runtime_dependencies,
        args.recursive,
        args.ignore_missing)


interpreter_path: Path  = None # type: ignore
interpreter_osabi: str  = None # type: ignore
interpreter_arch: str   = None # type: ignore
libc_lib: Path          = None # type: ignore

if __name__ == "__main__":
    nix_support = Path(os.environ['NIX_BINTOOLS']) / 'nix-support'
    interpreter_path = Path((nix_support / 'dynamic-linker').read_text().strip())
    libc_lib = Path((nix_support / 'orig-libc').read_text().strip()) / 'lib'

    with open_elf(interpreter_path) as interpreter:
        interpreter_osabi = get_osabi(interpreter)
        interpreter_arch = get_arch(interpreter)

    if interpreter_arch and interpreter_osabi and interpreter_path and libc_lib:
        main()
    else:
        sys.exit("Failed to parse dynamic linker (ld) properties.")
