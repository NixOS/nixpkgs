#!/usr/bin/env python3

from elftools.common.exceptions import ELFError
from elftools.elf.dynamic import DynamicSection
from elftools.elf.elffile import ELFFile
from elftools.elf.enums import ENUM_E_TYPE, ENUM_EI_OSABI
from collections import defaultdict
from contextlib import contextmanager

import argparse
import os
import pprint
import subprocess
import sys

'''
Algorithm
=========

- for each SOFile in (recursive) dirs
  - for each missing lib (that is not yet found in its RPATH)
    - Look it up in
      - The global, provided, search path
      - The _recursive_ RPATH of included libraries
    - Check binary compatibility
    - Add it to the extra RPATH
  - Write the completed RPATH to the SOFile (and trim it !)

API
===

Take two argument collections:
    - A list of .../lib/ dirs to augment RPATHS
    - A set of paths (recursively) containing the SOFiles to patch
A `recursive` flag

Purpose
=======

- Autodetect dependencies, instead of manually patching each binary
- Restrict RPATHs to the minimum needed paths
- Detect missing dependencies
- Keep everything simple by bundling a lot of common dependencies by default

A major concern is that it may be more efficient to just patch RPATH to
a fixed value. Provided that such a value can be easily forged and validated.
'''

@contextmanager
def openELF(path):
    stream = open(path, "rb")
    try:
        elf = ELFFile(stream)
        elf.filename = path
        yield elf
    finally:
        stream.close()

def isExecutable(elf):
    # For dynamically linked ELF files it would be enough to check just for the
    # INTERP section. However, we won't catch statically linked executables as
    # they only have an ELF type of EXEC but no INTERP.
    #
    # So what we do here is just check whether *either* the ELF type is EXEC
    # *or* there is an INTERP section. This also catches position-independent
    # executables, as they typically have an INTERP section but their ELF type
    # is DYN.
    return elf.header["e_type"] == 'ET_EXEC' or elf.get_section_by_name(".interp")

def getDepsFromElfBinary(elf):
    #if section := elf.get_section_by_name('.dynamic')
    #    yield from enumerate_needed(section);
    # does not always work ! (why ??)

    for section in elf.iter_sections():
        if isinstance(section, DynamicSection):
            if section.name != ".dynamic":
                print("Hu hoo: found you >{}<".format(section.name))
            for tag in section.iter_tags('DT_NEEDED'):
                yield tag.needed
            # break ? There _should_ only be one. Not too sure anymore at this point.

def getRpathFromElfBinary(elf):
    if section := elf.get_section_by_name('.dynamic'):
        for tag in section.iter_tags('DT_RUNPATH'):
            return tag.runpath.split(':')

        for tag in section.iter_tags('DT_RPATH'):
            return tag.rpath.split(':')

    return []

def getBinArch(elf):
    return elf.get_machine_arch()

def getBinOsabi(elf):
    return elf.header["e_ident"]["EI_OSABI"]

# Tests whether two OS ABIs are compatible, taking into account the generally
# accepted compatibility of SVR4 ABI with other ABIs.
def areBinOsabisCompatible(wanted, got):
    if not wanted or not got:
        # One of the types couldn't be detected, so as a fallback we'll assume
        # they're compatible.
        return True

    # Generally speaking, the base ABI (0x00), which is represented by
    # readelf(1) as "UNIX - System V", indicates broad compatibility with other
    # ABIs.
    #
    # TODO: This isn't always true. For example, some OSes embed ABI
    # compatibility into SHT_NOTE sections like .note.tag and .note.ABI-tag.
    # It would be prudent to add these to the detection logic to produce better
    # ABI information.
    #print(wanted, got, ENUM_EI_OSABI)
    if wanted == 'ELFOSABI_SYSV':
        return True

    # Similarly here, we should be able to link against a superset of features,
    # so even if the target has another ABI, this should be fine.
    if got == 'ELFOSABI_SYSV':
        return True

    # Otherwise, we simply return whether the ABIs are identical.
    return wanted == got


cachedPaths = set()
sonameCache = defaultdict(list) # (soname, arch) -> [ (libdir, osabi) ]

def populateCache(initial, recurse = False):
    libDirs = list(initial)

    while libDirs:
        lib = libDirs.pop(0)

        if not lib or '$ORIGIN' in lib: continue
        if lib in cachedPaths: continue

        cachedPaths.add(lib)

        for (root, dirs, files) in os.walk(lib):
            used = False
            for file in files:
                if ".so" not in file:
                    continue

                try:
                    with openELF(os.path.join(root, file)) as elf:
                        osabi = getBinOsabi(elf)
                        arch = getBinArch(elf)

                        if rpath := getRpathFromElfBinary(elf):
                            libDirs += rpath
                        #print("Caching", file, arch, lib, osabi)

                        sonameCache[(file, arch)].append( (root, osabi) )
                        used = True
                except ELFError:
                    pass
            if used:
                print("found .so libs in", root)

            if not recurse:
                break;


def findDependency(soname, arch, osabi):
    for lib, libabi in sonameCache[(soname, arch)]:
        if areBinOsabisCompatible(osabi, libabi):
            return lib
    return None

def autoPatchelfFile(elf, runtimeDeps):
    fileArch = getBinArch(elf)
    fileOsabi = getBinOsabi(elf)
    rpath = []

    if interpreterArch != fileArch:
        # Our target architecture is different than this file's architecture, so skip it.
        print("skipping {} because its architecture ({}) differs from target ({})"
            .format(elf.filename, fileArch, interpreterArch))
        return
    elif not areBinOsabisCompatible(interpreterOsabi, fileOsabi):
        print("skipping {} because its OS ABI ({}) is not compatible with target ({})"
            .format(elf.filename, fileOsabi, interpreterOsabi))
        return

    if isExecutable(elf):
        print("setting interpreter of", elf.filename)
        subprocess.run(["patchelf", "--set-interpreter", interpreterPath, elf.filename], check = True)
        rpath += ["{}/lib".format(path) for path in runtimeDeps]

    print("searching for dependencies of", elf.filename)
    try:
        missing = getDepsFromElfBinary(elf)
    except ELFError:
        return

    # This ensures that we get the output of all missing dependencies instead
    # of failing at the first one, because it's more useful when working on a
    # new package where you don't yet know its dependencies.

    for dep in missing:
        if dep.is_absolute():
            # This is an absolute path. If it exists, just use it. Otherwise,
            # we probably want this to produce an error when checked (because
            # just updating the rpath won't satisfy it).
            if os.path.isfile(dep):
                continue
        elif os.path.isfile(os.path.join(libcLib, dep)):
            # This library exists in libc, and will be correctly resolved by
            # the linker.
            continue

        if foundDependency := findDependency(dep, fileArch, fileOsabi):
            rpath.append(foundDependency)
            print("    {} -> found: {}".format(dep, foundDependency))
        else:
            print("    {} -> not found!".format(dep))
            yield dep

    # dedup. Relies on dicts preserving insertion order. Python3.7+
    rpath = ":".join(dict.fromkeys(rpath))

    if rpath:
        print("setting RPATH to:", rpath)
        subprocess.run(["patchelf", "--set-rpath", rpath, elf.filename], check = True)


def walk(paths, recurse):
    for path in paths:
        for (dirpath, dirs, files) in os.walk(path):
            for file in files:
                fullPath = os.path.join(dirpath, file) # todo: normalize
                yield fullPath

            if not recurse:
                break


def autoPatchelf(pathsToPatch, libDirs, runtimeDeps, recurse = True, ignoreMissing = False):
    if not pathsToPatch:
        sys.exit("no paths to patch, stopping.")

    # Add all shared objects of the current output path to the cache,
    # before libDirs, so that they are chosen first in findDependency.
    populateCache(pathsToPatch, recurse);
    populateCache(libDirs);

    missingDeps = {}
    failed = False
    for path in walk(pathsToPatch, recurse):
        try:
            with openELF(path) as elf:
                missing = list(autoPatchelfFile(elf, runtimeDeps))
                if missing:
                    missingDeps[path] = missing
        except ELFError:
            pass

    # Print a summary of the missing dependencies at the end
    for path, deps in missingDeps.items():
        for dep in deps:
            print("autoPatchelfHook could not satisfy dependency {} wanted by {}".format(dep, path))

    if missingDeps and not ignoreMissing:
        sys.exit("""
            autoPatchelfHook failed to find all the required dependencies.
            Add the missing dependencies to the build inputs or set autoPatchelfIgnoreMissingDeps=true.
            """)

def main():

    parser = argparse.ArgumentParser(prog="autoPatchelf.py",
            description="""autoPatchelf tries as hard as possible to patch the provided\
                    binary files by looking for compatible libraries in the provided paths.
                    """)
    parser.add_argument( "--ignore-missing", dest="ignoreMissing", action="store_true",
        help="Do not fail when some dependencies are not found.")
    parser.add_argument( "--norecurse", dest="recurse", action="store_false",
        help="Patch only the provided paths, and ignore their children")
    parser.add_argument("--paths", nargs="*",
        help="Paths whose content needs to be patched.")
    parser.add_argument("--libs", nargs="*",
        help="Paths where libraries are searched for.")
    parser.add_argument("--runtimeDependencies", nargs="*",
        help="Paths whose 'lib' dir will be added unconditionally to the runtime path of executables.")

    args = parser.parse_args()
    print("automatically fixing dependencies for ELF files")
    pprint.pprint(vars(args))

    autoPatchelf(args.paths, args.libs, args.runtimeDependencies, args.recurse, args.ignoreMissing)

interpreterPath = None
interpreterOsabi = None
interpreterArch = None
libcLib = None

if __name__ == "__main__":
    with open(os.environ['NIX_BINTOOLS']+"/nix-support/dynamic-linker") as f:
        interpreterPath = f.read().strip()

    with open(os.environ['NIX_BINTOOLS']+"/nix-support/orig-libc") as f:
        libcLib = os.path.join(f.read().strip(), "/lib")

    with openELF(interpreterPath) as interpreter:
        interpreterOsabi = getBinOsabi(interpreter)
        interpreterArch = getBinArch(interpreter)

    if interpreterArch and interpreterOsabi and interpreterPath and libcLib:
        main()
    else:
        sys.exit("Failed to parse dynamic linker (ld) properties.")

