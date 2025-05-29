#!/usr/bin/env python3

import argparse
import os
import pprint
import subprocess
import sys
import json
from fnmatch import fnmatch
from collections import defaultdict
from contextlib import contextmanager
from dataclasses import dataclass
from itertools import chain
from pathlib import Path, PurePath
from typing import DefaultDict, Generator, Iterator, Optional

from elftools.common.exceptions import ELFError  # type: ignore
from elftools.elf.dynamic import DynamicSection  # type: ignore
from elftools.elf.sections import NoteSection  # type: ignore
from elftools.elf.elffile import ELFFile  # type: ignore
from elftools.elf.enums import ENUM_E_TYPE, ENUM_EI_OSABI  # type: ignore


DEFAULT_BINTOOLS = "@defaultBintools@"


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

def is_separate_debug_object(elf: ELFFile) -> bool:
    # objects created by separateDebugInfo = true have all the section headers
    # of the unstripped objects but those that normal `strip` would have kept
    # are NOBITS
    text_section = elf.get_section_by_name(".text")
    return elf.has_dwarf_info() and bool(text_section) and text_section.header['sh_type'] == "SHT_NOBITS"


def get_dependencies(elf: ELFFile) -> list[list[Path]]:
    dependencies = []
    # This convoluted code is here on purpose. For some reason, using
    # elf.get_section_by_name(".dynamic") does not always return an
    # instance of DynamicSection, but that is required to call iter_tags
    for section in elf.iter_sections():
        if isinstance(section, DynamicSection):
            for tag in section.iter_tags('DT_NEEDED'):
                dependencies.append([Path(tag.needed)])
            break # There is only one dynamic section

    return dependencies


def get_dlopen_dependencies(elf: ELFFile) -> list[list[Path]]:
    """
    Extracts dependencies from the `.note.dlopen` section.
    This is a FreeDesktop standard to annotate binaries with libraries that it may `dlopen`.
    See https://systemd.io/ELF_DLOPEN_METADATA/
    """
    dependencies = []
    for section in elf.iter_sections():
        if not isinstance(section, NoteSection) or section.name != ".note.dlopen":
            continue
        for note in section.iter_notes():
            if note["n_type"] != 0x407C0C0A or note["n_name"] != "FDO":
                continue
            note_desc = note["n_desc"]
            text = note_desc.decode("utf-8").rstrip("\0")
            j = json.loads(text)
            for d in j:
                dependencies.append([Path(soname) for soname in d["soname"]])
    return dependencies


def get_rpath(elf: ELFFile) -> list[str]:
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
    if path.is_dir():
        return path.rglob(pattern) if recursive else path.glob(pattern)
    else:
        # path.glob won't return anything if the path is not a directory.
        # We extend that behavior by matching the file name against the pattern.
        # This allows to pass single files instead of dirs to auto_patchelf,
        # for greater control on the files to consider.
        return [path] if path.match(pattern) else []


cached_paths: set[Path] = set()
soname_cache: DefaultDict[tuple[str, str], list[tuple[Path, str]]] = defaultdict(list)


def populate_cache(initial: list[Path], recursive: bool =False) -> None:
    lib_dirs = list(initial)

    while lib_dirs:
        lib_dir = lib_dirs.pop(0)

        if lib_dir in cached_paths:
            continue

        cached_paths.add(lib_dir)

        for path in glob(lib_dir, "*.so*", recursive):
            if not path.is_file():
                continue

            # As an optimisation, resolve the symlinks here, as the target is unique
            # XXX: (layus, 2022-07-25) is this really an optimisation in all cases ?
            # It could make the rpath bigger or break the fragile precedence of $out.
            resolved = path.resolve()
            # Do not use resolved paths when names do not match
            if resolved.name != path.name:
                resolved = path

            try:
                with open_elf(path) as elf:
                    if is_separate_debug_object(elf):
                        print(f"skipping {path} because it looks like a separate debug object")
                        continue

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


def auto_patchelf_file(path: Path, runtime_deps: list[Path], append_rpaths: list[Path] = [], keep_libc: bool = False, extra_args: list[str] = []) -> list[Dependency]:
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

            file_dependencies = get_dependencies(elf) + get_dlopen_dependencies(elf)

    except ELFError:
        return []

    # these platforms are packaged in nixpkgs with ld.so in a separate derivation
    # than libc.so and friends. keep_libc is mandatory.
    keep_libc |= file_osabi in ('ELFOSABI_FREEBSD', 'ELFOSABI_OPENBSD')

    rpath = []
    if file_is_dynamic_executable:
        print("setting interpreter of", path)
        subprocess.run(
                ["patchelf", "--set-interpreter", interpreter_path.as_posix(), path.as_posix()] + extra_args,
                check=True)
        rpath += runtime_deps

    print("searching for dependencies of", path)
    dependencies = []
    # Be sure to get the output of all missing dependencies instead of
    # failing at the first one, because it's more useful when working
    # on a new package where you don't yet know the dependencies.
    for dep in file_dependencies:
        was_found = False
        for candidate in dep:

            # This loop determines which candidate for a given
            # dependency can be found, and how. There may be multiple
            # candidates for a dep because of '.note.dlopen'
            # dependencies.
            #
            # 1. If a candidate is an absolute path, it is already a
            #    valid dependency if that path exists, and nothing needs
            #    to be done. It should be an error if that path does not exist.
            # 2. If a candidate is found within libc, it should be dropped
            #    and resolved automatically by the dynamic linker, unless
            #    keep_libc is enabled.
            # 3. If a candidate is found in our library dependencies, that
            #    dependency should be added to rpath.
            # 4. If all of the above fail, libc dependencies should still be
            #    considered found. This is in contrast to step 2, because
            #    enabling keep_libc should allow libc to be found in step 3
            #    if possible to preserve its presence in rpath.
            #
            # These conditions are checked in this order, because #2
            # and #3 may both be true. In that case, we still want to
            # add the dependency to rpath, as the original binary
            # presumably had it and this should be preserved.

            is_libc = (libc_lib / candidate).is_file()

            if candidate.is_absolute() and candidate.is_file():
                was_found = True
                break
            elif is_libc and not keep_libc:
                was_found = True
                break
            elif found_dependency := find_dependency(candidate.name, file_arch, file_osabi):
                rpath.append(found_dependency)
                dependencies.append(Dependency(path, candidate, found=True))
                print(f"    {candidate} -> found: {found_dependency}")
                was_found = True
                break
            elif is_libc and keep_libc:
                was_found = True
                break

        if not was_found:
            dep_name = dep[0] if len(dep) == 1 else f"any({', '.join(map(str, dep))})"
            dependencies.append(Dependency(path, dep_name, found=False))
            print(f"    {dep_name} -> not found!")

    rpath.extend(append_rpaths)

    # Dedup the rpath
    rpath_str = ":".join(dict.fromkeys(map(Path.as_posix, rpath)))

    if rpath:
        print("setting RPATH to:", rpath_str)
        subprocess.run(
                ["patchelf", "--set-rpath", rpath_str, path.as_posix()] + extra_args,
                check=True)

    return dependencies


def auto_patchelf(
        paths_to_patch: list[Path],
        lib_dirs: list[Path],
        runtime_deps: list[Path],
        recursive: bool = True,
        ignore_missing: list[str] = [],
        append_rpaths: list[Path] = [],
        keep_libc: bool = False,
        add_existing: bool = True,
        extra_args: list[str] = []) -> None:

    if not paths_to_patch:
        sys.exit("No paths to patch, stopping.")

    # Add all shared objects of the current output path to the cache,
    # before lib_dirs, so that they are chosen first in find_dependency.
    if add_existing:
        populate_cache(paths_to_patch, recursive)

    populate_cache(lib_dirs)

    dependencies = []
    for path in chain.from_iterable(glob(p, '*', recursive) for p in paths_to_patch):
        if not path.is_symlink() and path.is_file():
            dependencies += auto_patchelf_file(path, runtime_deps, append_rpaths, keep_libc, extra_args)

    missing = [dep for dep in dependencies if not dep.found]

    # Print a summary of the missing dependencies at the end
    print(f"auto-patchelf: {len(missing)} dependencies could not be satisfied")
    failure = False
    for dep in missing:
        for pattern in ignore_missing:
            if fnmatch(dep.name.name, pattern):
                print(f"warn: auto-patchelf ignoring missing {dep.name} wanted by {dep.file}")
                break
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
                    ' libraries in the provided paths.')
    parser.add_argument(
        "--ignore-missing",
        nargs="*",
        type=str,
        default=[],
        help="Do not fail when some dependencies are not found."
    )
    parser.add_argument(
        "--no-recurse",
        dest="recursive",
        action="store_false",
        help="Disable the recursive traversal of paths to patch."
    )
    parser.add_argument(
        "--paths",
        nargs="*",
        type=Path,
        required=True,
        help="Paths whose content needs to be patched."
             " Single files and directories are accepted."
             " Directories are traversed recursively by default."
    )
    parser.add_argument(
        "--libs",
        nargs="*",
        type=Path,
        default=[],
        help="Paths where libraries are searched for."
             " Single files and directories are accepted."
             " Directories are not searched recursively."
    )
    parser.add_argument(
        "--runtime-dependencies",
        nargs="*",
        type=Path,
        default=[],
        help="Paths to prepend to the runtime path of executable binaries."
             " Subject to deduplication, which may imply some reordering."
    )
    parser.add_argument(
        "--append-rpaths",
        nargs="*",
        type=Path,
        default=[],
        help="Paths to append to all runtime paths unconditionally",
    )
    parser.add_argument(
        "--keep-libc",
        dest="keep_libc",
        action="store_true",
        help="Attempt to search for and relink libc dependencies.",
    )
    parser.add_argument(
        "--ignore-existing",
        dest="add_existing",
        action="store_false",
        help="Do not add the existing rpaths of the patched files to the list of directories to search for dependencies.",
    )
    parser.add_argument(
        "--extra-args",
        # Undocumented Python argparse feature: consume all remaining arguments
        # as values for this one. This means this argument should always be passed
        # last.
        nargs="...",
        type=str,
        default=[],
        help="Extra arguments to pass to patchelf. This argument should always come last.",
    )

    print("automatically fixing dependencies for ELF files")
    args = parser.parse_args()
    pprint.pprint(vars(args))

    auto_patchelf(
        args.paths,
        args.libs,
        args.runtime_dependencies,
        args.recursive,
        args.ignore_missing,
        append_rpaths=args.append_rpaths,
        keep_libc=args.keep_libc,
        add_existing=args.add_existing,
        extra_args=args.extra_args)


interpreter_path: Path  = None # type: ignore
interpreter_osabi: str  = None # type: ignore
interpreter_arch: str   = None # type: ignore
libc_lib: Path          = None # type: ignore

if __name__ == "__main__":
    nix_support = Path(os.environ.get('NIX_BINTOOLS', DEFAULT_BINTOOLS)) / 'nix-support'
    interpreter_path = Path((nix_support / 'dynamic-linker').read_text().strip())
    libc_lib = Path((nix_support / 'orig-libc').read_text().strip()) / 'lib'

    with open_elf(interpreter_path) as interpreter:
        interpreter_osabi = get_osabi(interpreter)
        interpreter_arch = get_arch(interpreter)

    if interpreter_arch and interpreter_osabi and interpreter_path and libc_lib:
        main()
    else:
        sys.exit("Failed to parse dynamic linker (ld) properties.")
