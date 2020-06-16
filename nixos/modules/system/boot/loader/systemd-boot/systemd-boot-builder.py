#! @python3@/bin/python3 -B
import argparse
from dataclasses import dataclass
import shutil
import os
import sys
import errno
import subprocess
import glob
import tempfile
import errno
import warnings
import ctypes
libc = ctypes.CDLL("libc.so.6")
import re
import datetime
import glob
import os.path

from typing import Optional

# TODO: Explain file entry paths and default ordering issues associated with boot counting

BOOT_ENTRY = """title NixOS{profile}
version Generation {generation} {description}
linux {kernel}
initrd {initrd}
options {kernel_params}
"""


@dataclass
class BootEntry:
    profile: Optional[str]
    generation: int
    orig_path: Optional[str] = None
    bootcounters: Optional[str] = None
    is_default: bool = False

    @property
    def path(self) -> str:
        return "@efiSysMountPoint@/loader/entries/nixos%s-generation%s-%d%s.conf" % (
            "-" + self.profile if self.profile else "",
            "-default" if self.is_default else "",
            self.generation,
            "+" + self.bootcounters if self.bootcounters else ""
        )


    def write(self, machine_id):
        kernel = copy_from_profile(self.profile, self.generation, "kernel")
        initrd = copy_from_profile(self.profile, self.generation, "initrd")
        try:
            append_initrd_secrets = profile_path(self.profile, self.generation, "append-initrd-secrets")
            subprocess.check_call([append_initrd_secrets, "@efiSysMountPoint@%s" % (initrd)])
        except FileNotFoundError:
            pass

        generation_dir = os.readlink(system_dir(self.profile, self.generation))
        tmp_path = self.path + ".tmp"
        kernel_params = "systemConfig=%s init=%s/init " % (generation_dir, generation_dir)

        with open("%s/kernel-params" % (generation_dir)) as params_file:
            kernel_params = kernel_params + params_file.read()
        with open(tmp_path, 'w') as f:
            f.write(BOOT_ENTRY.format(profile=" [" + self.profile + "]" if self.profile else "",
                    generation=self.generation,
                    kernel=kernel,
                    initrd=initrd,
                    kernel_params=kernel_params,
                    description=describe_generation(generation_dir)))

            if machine_id is not None:
                f.write("machine-id %s\n" % machine_id)
        os.rename(tmp_path, self.path)

        # Remove original file if we didn't replace it
        if (self.orig_path is not None) and (self.path != self.orig_path):
            os.unlink(self.orig_path)


def copy_if_not_exists(source, dest):
    if not os.path.exists(dest):
        shutil.copyfile(source, dest)

def system_dir(profile, generation):
    if profile:
        return "/nix/var/nix/profiles/system-profiles/%s-%d-link" % (profile, generation)
    else:
        return "/nix/var/nix/profiles/system-%d-link" % (generation)

# The boot loader entry for memtest86.
#
# TODO: This is hard-coded to use the 64-bit EFI app, but it could probably
# be updated to use the 32-bit EFI app on 32-bit systems.  The 32-bit EFI
# app filename is BOOTIA32.efi.
MEMTEST_BOOT_ENTRY = """title MemTest86
efi /efi/memtest86/BOOTX64.efi
"""

def write_loader_conf(profile):
    with open("@efiSysMountPoint@/loader/loader.conf.tmp", 'w') as f:
        if "@timeout@" != "":
            f.write("timeout @timeout@\n")
        if profile:
            f.write("default nixos-%s-generation-*\n" % profile)
        else:
            f.write("default nixos-generation-*\n")
        if not @editor@:
            f.write("editor 0\n");
        f.write("console-mode @consoleMode@\n");
    os.rename("@efiSysMountPoint@/loader/loader.conf.tmp", "@efiSysMountPoint@/loader/loader.conf")

def profile_path(profile, generation, name):
    return os.readlink("%s/%s" % (system_dir(profile, generation), name))

def copy_from_profile(profile, generation, name, dry_run=False):
    store_file_path = profile_path(profile, generation, name)
    suffix = os.path.basename(store_file_path)
    store_dir = os.path.basename(os.path.dirname(store_file_path))
    efi_file_path = "/efi/nixos/%s-%s.efi" % (store_dir, suffix)
    if not dry_run:
        copy_if_not_exists(store_file_path, "@efiSysMountPoint@%s" % (efi_file_path))
    return efi_file_path

def describe_generation(generation_dir):
    try:
        with open("%s/nixos-version" % generation_dir) as f:
            nixos_version = f.read()
    except IOError:
        nixos_version = "Unknown"

    kernel_dir = os.path.dirname(os.path.realpath("%s/kernel" % generation_dir))
    module_dir = glob.glob("%s/lib/modules/*" % kernel_dir)[0]
    kernel_version = os.path.basename(module_dir)

    build_time = int(os.path.getctime(generation_dir))
    build_date = datetime.datetime.fromtimestamp(build_time).strftime('%F')

    description = "NixOS {}, Linux Kernel {}, Built on {}".format(
        nixos_version, kernel_version, build_date
    )

    return description

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as e:
        if e.errno != errno.EEXIST or not os.path.isdir(path):
            raise

def get_generations(profile=None):
    gen_list = subprocess.check_output([
        "@nix@/bin/nix-env",
        "--list-generations",
        "-p",
        "/nix/var/nix/profiles/%s" % ("system-profiles/" + profile if profile else "system"),
        "--option", "build-users-group", ""],
        universal_newlines=True)
    gen_lines = gen_list.split('\n')
    gen_lines.pop()

    configurationLimit = int("@configurationLimit@")
    return [ (profile, int(line.split()[0])) for line in gen_lines ][-configurationLimit:]

def remove_old_entries(entries, gens):
    remaining_entries = []
    for entry in entries:
        if (entry.profile, entry.generation) in gens:
            remaining_entries.append(entry)
        else:
            os.unlink(entry.orig_path)

    known_paths = []
    for gen in gens:
        known_paths.append(copy_from_profile(*gen, "kernel", True))
        known_paths.append(copy_from_profile(*gen, "initrd", True))
    for path in glob.iglob("@efiSysMountPoint@/efi/nixos/*"):
        if not path in known_paths and not os.path.isdir(path):
            os.unlink(path)

    return remaining_entries

def append_new_entries(entries, gens):
    _entries = [ (e.profile, e.generation) for e in entries ]
    for profile, generation in gens:
        if (profile, generation) not in _entries:
            entry = BootEntry(profile, generation)
            # Set the default number of tries
            if @countersEnable@:
                entry.bootcounters = "@countersTries@"
            entries.append(entry)
    return entries

def get_profiles():
    if os.path.isdir("/nix/var/nix/profiles/system-profiles/"):
        return [x
            for x in os.listdir("/nix/var/nix/profiles/system-profiles/")
            if not x.endswith("-link")]
    else:
        return []

def get_entries():
    entries = []
    for path in glob.iglob("@efiSysMountPoint@/loader/entries/nixos*-generation-*.conf"):
        m = re.match("^@efiSysMountPoint@/loader/entries/nixos-?(.*)?-generation(-default)?-(\d+)\+?(.*)?\.conf$", path)
        if m is None:
            continue

        profile, _, generation, bootcounters = m.groups()
        if not profile:
            profile = None
        if not bootcounters:
            bootcounters = None
        generation = int(generation)

        entries.append(BootEntry(profile, generation, path, bootcounters))
    return entries

def main():
    parser = argparse.ArgumentParser(description='Update NixOS-related systemd-boot files')
    parser.add_argument('default_config', metavar='DEFAULT-CONFIG', help='The default NixOS config to boot')
    args = parser.parse_args()

    try:
        with open("/etc/machine-id") as machine_file:
            machine_id = machine_file.readlines()[0]
    except IOError as e:
        if e.errno != errno.ENOENT:
            raise
        # Since systemd version 232 a machine ID is required and it might not
        # be there on newly installed systems, so let's generate one so that
        # bootctl can find it and we can also pass it to write_entry() later.
        cmd = ["@systemd@/bin/systemd-machine-id-setup", "--print"]
        machine_id = subprocess.check_output(cmd).rstrip()

    if os.getenv("NIXOS_INSTALL_GRUB") == "1":
        warnings.warn("NIXOS_INSTALL_GRUB env var deprecated, use NIXOS_INSTALL_BOOTLOADER", DeprecationWarning)
        os.environ["NIXOS_INSTALL_BOOTLOADER"] = "1"

    if os.getenv("NIXOS_INSTALL_BOOTLOADER") == "1":
        # bootctl uses fopen() with modes "wxe" and fails if the file exists.
        if os.path.exists("@efiSysMountPoint@/loader/loader.conf"):
            os.unlink("@efiSysMountPoint@/loader/loader.conf")

        if "@canTouchEfiVariables@" == "1":
            subprocess.check_call(["@systemd@/bin/bootctl", "--path=@efiSysMountPoint@", "install"])
        else:
            subprocess.check_call(["@systemd@/bin/bootctl", "--path=@efiSysMountPoint@", "--no-variables", "install"])
    else:
        # Update bootloader to latest if needed
        systemd_version = subprocess.check_output(["@systemd@/bin/bootctl", "--version"], universal_newlines=True).split()[1]
        # Ideally this should use check_output as well, but as a temporary
        # work-around for #97433 we ignore any errors.
        sdboot_status = subprocess.run(["@systemd@/bin/bootctl", "--path=@efiSysMountPoint@", "status"], universal_newlines=True, stdout=subprocess.PIPE).stdout

        # See status_binaries() in systemd bootctl.c for code which generates this
        m = re.search("^\W+File:.*/EFI/(BOOT|systemd)/.*\.efi \(systemd-boot (\d+)\)$",
                      sdboot_status, re.IGNORECASE | re.MULTILINE)
        if m is None:
            print("could not find any previously installed systemd-boot")
        else:
            sdboot_version = m.group(2)
            if systemd_version > sdboot_version:
                print("updating systemd-boot from %s to %s" % (sdboot_version, systemd_version))
                subprocess.check_call(["@systemd@/bin/bootctl", "--path=@efiSysMountPoint@", "update"])


    mkdir_p("@efiSysMountPoint@/efi/nixos")
    mkdir_p("@efiSysMountPoint@/loader/entries")

    gens = get_generations()
    for profile in get_profiles():
        gens += get_generations(profile)

    entries = get_entries()
    entries = remove_old_entries(entries, gens)
    entries = append_new_entries(entries, gens)

    for entry in entries:
        entry.is_default = os.readlink(system_dir(entry.profile, entry.generation)) == args.default_config
        entry.write(machine_id)
        if entry.is_default:
            write_loader_conf(entry.profile)

    memtest_entry_file = "@efiSysMountPoint@/loader/entries/memtest86.conf"
    if os.path.exists(memtest_entry_file):
        os.unlink(memtest_entry_file)
    shutil.rmtree("@efiSysMountPoint@/efi/memtest86", ignore_errors=True)
    if "@memtest86@" != "":
        mkdir_p("@efiSysMountPoint@/efi/memtest86")
        for path in glob.iglob("@memtest86@/*"):
            if os.path.isdir(path):
                shutil.copytree(path, os.path.join("@efiSysMountPoint@/efi/memtest86", os.path.basename(path)))
            else:
                shutil.copy(path, "@efiSysMountPoint@/efi/memtest86/")

        memtest_entry_file = "@efiSysMountPoint@/loader/entries/memtest86.conf"
        memtest_entry_file_tmp_path = "%s.tmp" % memtest_entry_file
        with open(memtest_entry_file_tmp_path, 'w') as f:
            f.write(MEMTEST_BOOT_ENTRY)
        os.rename(memtest_entry_file_tmp_path, memtest_entry_file)

    # Since fat32 provides little recovery facilities after a crash,
    # it can leave the system in an unbootable state, when a crash/outage
    # happens shortly after an update. To decrease the likelihood of this
    # event sync the efi filesystem after each update.
    rc = libc.syncfs(os.open("@efiSysMountPoint@", os.O_RDONLY))
    if rc != 0:
        print("could not sync @efiSysMountPoint@: {}".format(os.strerror(rc)), file=sys.stderr)

if __name__ == '__main__':
    main()
