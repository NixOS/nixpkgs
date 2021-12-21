#!/usr/bin/env python3

from elftools.common.exceptions import ELFError
from elftools.elf.dynamic import DynamicSection
from elftools.elf.elffile import ELFFile
from elftools.elf.enums import ENUM_E_TYPE, ENUM_EI_OSABI
from collections import defaultdict
from contextlib import contextmanager
from typing import Tuple
from pathlib import Path, PurePath
from itertools import chain

import argparse
import os
import pprint
import subprocess
import sys


@contextmanager
def open_elf(path):
    with path.open('rb') as stream:
        yield ELFFile(stream)


def is_static_executable(elf):
    # Statically linked executables have an ELF type of EXEC but no INTERP.
    return (elf.header["e_type"] == 'ET_EXEC'
            and not elf.get_section_by_name(".interp"))


def is_dynamic_executable(elf):
    # We do not require an ELF type of EXEC. This also catches
    # position-independent executables, as they typically have an INTERP
    # section but their ELF type is DYN.
    return bool(elf.get_section_by_name(".interp"))


def get_dependencies(elf):
    # This convoluted code is here on purpose. For some reason, using
    # elf.get_section_by_name(".dynamic") does not always return an
    # instance of DynamicSection, but that is required to call iter_tags
    for section in elf.iter_sections():
        if isinstance(section, DynamicSection):
            for tag in section.iter_tags('DT_NEEDED'):
                yield tag.needed
            # There is only one dynamic section
            break


def get_rpath(elf):
    # This convoluted code is here on purpose. For some reason, using
    # elf.get_section_by_name(".dynamic") does not always return an
    # instance of DynamicSection, but that is required to call iter_tags
    for section in elf.iter_sections():
        if isinstance(section, DynamicSection):
            for tag in section.iter_tags('DT_RUNPATH'):
                return tag.runpath.split(':')

            for tag in section.iter_tags('DT_RPATH'):
                return tag.rpath.split(':')

            # There is only one dynamic section
            break

    return []


def get_arch(elf):
    return elf.get_machine_arch()


def get_osabi(elf):
    return elf.header["e_ident"]["EI_OSABI"]


# Tests whether two OS ABIs are compatible, taking into account the
# generally accepted compatibility of SVR4 ABI with other ABIs.
def osabi_are_compatible(wanted, got):
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


def glob(path, pattern, recursive):
    return path.rglob(pattern) if recursive else path.glob(pattern)


cached_paths = set()
soname_cache = defaultdict(list)


def populate_cache(initial, recursive=False):
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


def findDependency(soname, soarch, soabi):
    for lib, libabi in soname_cache[(soname, soarch)]:
        if osabi_are_compatible(soabi, libabi):
            return lib
    return None


patched_any = False
missingDeps = defaultdict(list)


def autoPatchelfFile(path, runtime_deps):
    try:
        with open_elf(path) as elf:

            if is_static_executable(elf):
                # No point patching these
                print(f"skipping {path} because it is statically linked")
                return

            if elf.num_segments() == 0:
                # no segment (e.g. object file)
                print(f"skipping {path} because it contains no segment")
                return

            file_arch = get_arch(elf)
            if interpreter_arch != file_arch:
                # Our target architecture is different than this file's
                # architecture, so skip it.
                print(f"skipping {path} because its architecture ({file_arch})"
                      f" differs from target ({interpreter_arch})")
                return

            file_osabi = get_osabi(elf)
            if osabi_are_compatible(interpreter_osabi, file_osabi):
                print(f"skipping {path} because its OS ABI ({file_osabi}) is"
                      f" not compatible with target ({interpreter_osabi})")
                return

            file_is_dynamic_executable = is_dynamic_executable(elf)

            print("searching for dependencies of", path)
            dependencies = map(Path, get_dependencies(elf))

    except ELFError:
        return

    rpath = []
    if file_is_dynamic_executable:
        print("setting interpreter of", path)
        subprocess.run(
                ["patchelf", "--set-interpreter", interpreter_path.as_posix(), path.as_posix()],
                check=True)
        rpath += runtime_deps

    # Be sure to get the output of all missing dependencies instead of
    # failing at the first one, because it's more useful when working
    # on a new package where you don't yet know the dependencies.
    for dep in dependencies:
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

        if foundDependency := findDependency(dep.name, file_arch, file_osabi):
            rpath.append(foundDependency)
            print(f"    {dep} -> found: {foundDependency}")
        else:
            missingDeps[path].append(dep)
            print(f"    {dep} -> not found!")

    # Dedup the rpath
    rpath = ":".join(dict.fromkeys(map(Path.as_posix, rpath)))

    if rpath:
        print("setting RPATH to:", rpath)
        subprocess.run(
                ["patchelf", "--set-rpath", rpath, path.as_posix()],
                check=True)
        patched_any = True


def autoPatchelf(
        pathsToPatch,
        libDirs,
        runtime_deps,
        recursive=True,
        ignoreMissing=False):

    if not pathsToPatch:
        sys.exit("No paths to patch, stopping.")

    # Add all shared objects of the current output path to the cache,
    # before libDirs, so that they are chosen first in findDependency.
    populate_cache(pathsToPatch, recursive)
    populate_cache(libDirs)

    missingDeps = {}
    for path in chain.from_iterable(glob(p, '*', recursive) for p in pathsToPatch):
        if not path.is_symlink() and path.is_file():
            autoPatchelfFile(path, runtime_deps)

    # Print a summary of the missing dependencies at the end
    for path, deps in missingDeps.items():
        for dep in deps:
            print(f"auto-patchelf could not satisfy dependency {dep} wanted by {path}")

    if missingDeps and not ignoreMissing:
        sys.exit('auto-patchelf failed to find all the required dependencies.\n'
                 'Add the missing dependencies to --libs or use --ignore-missing.')

    if not patched_any:
        print('auto-patchelf failed to find any file to patch.\n'
              'It may have been misconfigured, or you may not need it.')


def main():
    parser = argparse.ArgumentParser(
        prog="auto-patchelf",
        description='auto-patchelf tries as hard as possible to patch the'
                    ' provided binary files by looking for compatible'
                    'libraries in the provided paths.')
    parser.add_argument(
        "--ignore-missing",
        dest="ignoreMissing",
        action="store_true",
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

    autoPatchelf(
        args.paths,
        args.libs,
        args.runtime_dependencies,
        args.recursive,
        args.ignoreMissing)


interpreter_path = None
interpreter_osabi = None
interpreter_arch = None
libc_lib = None

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
