#! @python3@/bin/python3 -B
import argparse
import ctypes
import datetime
import errno
import glob
import os
import os.path
import re
import shutil
import subprocess
import sys
import warnings
import json
from typing import NamedTuple, Dict, List, Type, Generator, Iterable
from dataclasses import dataclass
from pathlib import Path


@dataclass
class BootSpec:
    init: str
    initrd: str
    kernel: str
    kernelParams: List[str]
    label: str
    system: str
    toplevel: str
    specialisations: Dict[str, "BootSpec"]
    initrdSecrets: str | None = None

@dataclass
class Entry:
    profile: str | None
    generation_number: int
    specialisation: str | None

    @classmethod
    def from_path(cls: Type["Entry"], path: Path) -> "Entry":
        filename = path.name
        # Matching nixos-$profile-generation-*.conf
        rex_profile = re.compile(r"^nixos-(.*)-generation-.*\.conf$")
        # Matching nixos*-generation-$number*.conf
        rex_generation = re.compile(r"^nixos.*-generation-([0-9]+).*\.conf$")
        # Matching nixos*-generation-$number-specialisation-$specialisation_name*.conf
        rex_specialisation = re.compile(r"^nixos.*-generation-([0-9]+)-specialisation-([a-zA-Z0-9]+).*\.conf$")
        profile = rex_profile.sub(r"\1", filename) if rex_profile.match(filename) else None
        specialisation = rex_specialisation.sub(r"\2", filename) if rex_specialisation.match(filename) else None
        try:
            generation_number = int(rex_generation.sub(r"\1", filename))
        except ValueError:
            raise
        return cls(profile, generation_number, specialisation)


BOOT_ENTRY = """title {title}
version Generation {generation} {description}
linux {kernel}
initrd {initrd}
options {kernel_params}
machine-id {machine_id}
sort-key {sort_key}
"""

@dataclass
class DiskEntry():
    entry: Entry
    default: bool
    counters: str | None
    title: str
    description: str
    kernel: str
    initrd: str
    kernel_params: str
    machine_id: str

    @classmethod
    def from_path(cls: Type["DiskEntry"], path: Path) -> "DiskEntry":
        entry = Entry.from_path(path)
        with open(path, 'r') as f:
            data = f.read().splitlines()
            if '' in data:
                data.remove('')
            entry_map = dict(l.split(' ', 1) for l in data)
            assert "title" in entry_map
            assert "version" in entry_map
            version_splitted = entry_map["version"].split(" ", 2)
            assert version_splitted[0] == "Generation"
            assert version_splitted[1].isdigit()
            assert "linux" in entry_map
            assert "initrd" in entry_map
            assert "options" in entry_map
            assert "machine-id" in entry_map
            assert "sort-key" in entry_map
            filename = path.name
            # Matching nixos*-generation-*$counters.conf
            rex_counters = re.compile(r"^nixos.*-generation-.*(\+\d(-\d)?)\.conf$")
            counters = rex_counters.sub(r"\1", filename) if rex_counters.match(filename) else None
            disk_entry = cls(
                    entry=entry,
                    default=(entry_map["sort-key"] == "default"),
                    counters=counters,
                    title=entry_map["title"],
                    description=entry_map["version"],
                    kernel=entry_map["linux"],
                    initrd=entry_map["initrd"],
                    kernel_params=entry_map["options"],
                    machine_id=entry_map["machine-id"])
            return disk_entry

    def write(self) -> None:
        tmp_path = self.path.with_suffix(".tmp")
        with tmp_path.open('w') as f:
            # We use "sort-key" to sort the default generation first.
            # The "default" string is sorted before "non-default" (alphabetically)
            f.write(BOOT_ENTRY.format(title=self.title,
                          generation=self.entry.generation_number,
                          kernel=self.kernel,
                          initrd=self.initrd,
                          kernel_params=self.kernel_params,
                          machine_id=self.machine_id,
                          description=self.description,
                          sort_key="default" if self.default else "non-default"))
            f.flush()
            os.fsync(f.fileno())
        tmp_path.rename(self.path)


    @property
    def path(self) -> Path:
        pieces = [
            "nixos",
            self.entry.profile or None,
            "generation",
            str(self.entry.generation_number),
            f"specialisation-{self.entry.specialisation}" if self.entry.specialisation else None,
        ]
        prefix = "-".join(p for p in pieces if p)
        return Path(f"@efiSysMountPoint@/loader/entries/{prefix}{self.counters if self.counters else ''}.conf")

libc = ctypes.CDLL("libc.so.6")

class SystemIdentifier(NamedTuple):
    profile: str | None
    generation: int
    specialisation: str | None


def copy_if_not_exists(source: str, dest: str) -> None:
    if not os.path.exists(dest):
        shutil.copyfile(source, dest)


def generation_dir(profile: str | None, generation: int) -> str:
    if profile:
        return "/nix/var/nix/profiles/system-profiles/%s-%d-link" % (profile, generation)
    else:
        return "/nix/var/nix/profiles/system-%d-link" % (generation)

def system_dir(profile: str | None, generation: int, specialisation: str | None) -> str:
    d = generation_dir(profile, generation)
    if specialisation:
        return os.path.join(d, "specialisation", specialisation)
    else:
        return d

def write_loader_conf(profile: str | None) -> None:
    with open("@efiSysMountPoint@/loader/loader.conf.tmp", 'w') as f:
        if "@timeout@" != "":
            f.write("timeout @timeout@\n")
        if profile:
            f.write("default nixos-%s-generation-*\n" % profile)
        else:
            f.write("default nixos-generation-*\n")
        if not @editor@:
            f.write("editor 0\n")
        f.write("console-mode @consoleMode@\n")
        f.flush()
        os.fsync(f.fileno())
    os.rename("@efiSysMountPoint@/loader/loader.conf.tmp", "@efiSysMountPoint@/loader/loader.conf")

def scan_entries() -> Generator[DiskEntry, None, None]:
    """
    Scan all entries in $ESP/loader/entries/*
    Does not support Type 2 entries as we do not support them for now.
    Returns a generator of Entry.
    """
    for path in Path("@efiSysMountPoint@/loader/entries/").glob("nixos*-generation-[1-9]*.conf"):
        try:
            yield DiskEntry.from_path(path)
        except ValueError:
            continue

def get_bootspec(profile: str | None, generation: int) -> BootSpec:
    system_directory = system_dir(profile, generation, None)
    boot_json_path = os.path.realpath("%s/%s" % (system_directory, "boot.json"))
    if os.path.isfile(boot_json_path):
        boot_json_f = open(boot_json_path, 'r')
        bootspec_json = json.load(boot_json_f)
    else:
        boot_json_str = subprocess.check_output([
        "@bootspecTools@/bin/synthesize",
        "--version",
        "1",
        system_directory,
        "/dev/stdout"],
        universal_newlines=True)
        bootspec_json = json.loads(boot_json_str)
    return bootspec_from_json(bootspec_json)

def bootspec_from_json(bootspec_json: Dict) -> BootSpec:
    specialisations = bootspec_json['org.nixos.specialisation.v1']
    specialisations = {k: bootspec_from_json(v) for k, v in specialisations.items()}
    return BootSpec(**bootspec_json['org.nixos.bootspec.v1'], specialisations=specialisations)


def copy_from_file(file: str, dry_run: bool = False) -> str:
    store_file_path = os.path.realpath(file)
    suffix = os.path.basename(store_file_path)
    store_dir = os.path.basename(os.path.dirname(store_file_path))
    efi_file_path = "/efi/nixos/%s-%s.efi" % (store_dir, suffix)
    if not dry_run:
        copy_if_not_exists(store_file_path, "@efiSysMountPoint@%s" % (efi_file_path))
    return efi_file_path

def write_entry(profile: str | None, generation: int, specialisation: str | None,
                machine_id: str, bootspec: BootSpec, entries: Iterable[DiskEntry], current: bool) -> None:
    if specialisation:
        bootspec = bootspec.specialisations[specialisation]
    kernel = copy_from_file(bootspec.kernel)
    initrd = copy_from_file(bootspec.initrd)

    title = "@distroName@{profile}{specialisation}".format(
        profile=" [" + profile + "]" if profile else "",
        specialisation=" (%s)" % specialisation if specialisation else "")

    try:
        if bootspec.initrdSecrets is not None:
            subprocess.check_call([bootspec.initrdSecrets, "@efiSysMountPoint@%s" % (initrd)])
    except subprocess.CalledProcessError:
        if current:
            print("failed to create initrd secrets!", file=sys.stderr)
            sys.exit(1)
        else:
            print("warning: failed to create initrd secrets "
                  f'for "{title} - Configuration {generation}", an older generation', file=sys.stderr)
            print("note: this is normal after having removed "
                  "or renamed a file in `boot.initrd.secrets`", file=sys.stderr)
    kernel_params = "init=%s " % bootspec.init
    kernel_params = kernel_params + " ".join(bootspec.kernelParams)
    build_time = int(os.path.getctime(system_dir(profile, generation, specialisation)))
    build_date = datetime.datetime.fromtimestamp(build_time).strftime('%F')
    counters = "+@bootCountingTrials@" if @bootCounting@ else ""
    entry = Entry(profile, generation, specialisation)
    # We check if the entry we are writing is already on disk
    # and we update its "default entry" status
    for entry_on_disk in entries:
        if entry == entry_on_disk.entry:
            entry_on_disk.default = current
            entry_on_disk.write()
            return

    DiskEntry(
            entry=entry,
            title=title,
            kernel=kernel,
            initrd=initrd,
            counters=counters,
            kernel_params=kernel_params,
            machine_id=machine_id,
            description=f"{bootspec.label}, built on {build_date}",
            default=current).write()

def get_generations(profile: str | None = None) -> list[SystemIdentifier]:
    gen_list = subprocess.check_output([
        "@nix@/bin/nix-env",
        "--list-generations",
        "-p",
        "/nix/var/nix/profiles/%s" % ("system-profiles/" + profile if profile else "system"),
        "--option", "build-users-group", ""],
        universal_newlines=True)
    gen_lines = gen_list.split('\n')
    gen_lines.pop()

    configurationLimit = @configurationLimit@
    configurations = [
        SystemIdentifier(
            profile=profile,
            generation=int(line.split()[0]),
            specialisation=None
        )
        for line in gen_lines
    ]
    return configurations[-configurationLimit:]


def remove_old_entries(gens: list[SystemIdentifier], disk_entries: Iterable[DiskEntry]) -> None:
    known_paths = []
    for gen in gens:
        bootspec = get_bootspec(gen.profile, gen.generation)
        known_paths.append(copy_from_file(bootspec.kernel, True))
        known_paths.append(copy_from_file(bootspec.initrd, True))
    for disk_entry in disk_entries:
        if (disk_entry.entry.profile, disk_entry.entry.generation_number, None) not in gens:
            os.unlink(disk_entry.path)
    for path in glob.iglob("@efiSysMountPoint@/efi/nixos/*"):
        if path not in known_paths and not os.path.isdir(path):
            os.unlink(path)

def get_profiles() -> list[str]:
    if os.path.isdir("/nix/var/nix/profiles/system-profiles/"):
        return [x
            for x in os.listdir("/nix/var/nix/profiles/system-profiles/")
            if not x.endswith("-link")]
    else:
        return []

def install_bootloader(args: argparse.Namespace) -> None:
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
        machine_id = subprocess.run(
          cmd, text=True, check=True, stdout=subprocess.PIPE
        ).stdout.rstrip()

    if os.getenv("NIXOS_INSTALL_GRUB") == "1":
        warnings.warn("NIXOS_INSTALL_GRUB env var deprecated, use NIXOS_INSTALL_BOOTLOADER", DeprecationWarning)
        os.environ["NIXOS_INSTALL_BOOTLOADER"] = "1"

    # flags to pass to bootctl install/update
    bootctl_flags = []

    if "@canTouchEfiVariables@" != "1":
        bootctl_flags.append("--no-variables")

    if "@graceful@" == "1":
        bootctl_flags.append("--graceful")

    if os.getenv("NIXOS_INSTALL_BOOTLOADER") == "1":
        # bootctl uses fopen() with modes "wxe" and fails if the file exists.
        if os.path.exists("@efiSysMountPoint@/loader/loader.conf"):
            os.unlink("@efiSysMountPoint@/loader/loader.conf")

        subprocess.check_call(["@systemd@/bin/bootctl", "--esp-path=@efiSysMountPoint@"] + bootctl_flags + ["install"])
    else:
        # Update bootloader to latest if needed
        available_out = subprocess.check_output(["@systemd@/bin/bootctl", "--version"], universal_newlines=True).split()[2]
        installed_out = subprocess.check_output(["@systemd@/bin/bootctl", "--esp-path=@efiSysMountPoint@", "status"], universal_newlines=True)

        # See status_binaries() in systemd bootctl.c for code which generates this
        installed_match = re.search(r"^\W+File:.*/EFI/(?:BOOT|systemd)/.*\.efi \(systemd-boot ([\d.]+[^)]*)\)$",
                      installed_out, re.IGNORECASE | re.MULTILINE)

        available_match = re.search(r"^\((.*)\)$", available_out)

        if installed_match is None:
            raise Exception("could not find any previously installed systemd-boot")

        if available_match is None:
            raise Exception("could not determine systemd-boot version")

        installed_version = installed_match.group(1)
        available_version = available_match.group(1)

        if installed_version < available_version:
            print("updating systemd-boot from %s to %s" % (installed_version, available_version))
            subprocess.check_call(["@systemd@/bin/bootctl", "--esp-path=@efiSysMountPoint@"] + bootctl_flags + ["update"])

    os.makedirs("@efiSysMountPoint@/efi/nixos", exist_ok=True)
    os.makedirs("@efiSysMountPoint@/loader/entries", exist_ok=True)

    gens = get_generations()
    for profile in get_profiles():
        gens += get_generations(profile)
    entries = scan_entries()
    remove_old_entries(gens, entries)
    for gen in gens:
        try:
            bootspec = get_bootspec(gen.profile, gen.generation)
            is_default = os.path.dirname(bootspec.init) == args.default_config
            write_entry(*gen, machine_id, bootspec, entries, current=is_default)
            for specialisation in bootspec.specialisations.keys():
                write_entry(gen.profile, gen.generation, specialisation, machine_id, bootspec, entries, current=is_default)
            if is_default:
                write_loader_conf(gen.profile)
        except OSError as e:
            # See https://github.com/NixOS/nixpkgs/issues/114552
            if e.errno == errno.EINVAL:
                profile = f"profile '{gen.profile}'" if gen.profile else "default profile"
                print("ignoring {} in the list of boot entries because of the following error:\n{}".format(profile, e), file=sys.stderr)
            else:
                raise e

    for root, _, files in os.walk('@efiSysMountPoint@/efi/nixos/.extra-files', topdown=False):
        relative_root = root.removeprefix("@efiSysMountPoint@/efi/nixos/.extra-files").removeprefix("/")
        actual_root = os.path.join("@efiSysMountPoint@", relative_root)

        for file in files:
            actual_file = os.path.join(actual_root, file)

            if os.path.exists(actual_file):
                os.unlink(actual_file)
            os.unlink(os.path.join(root, file))

        if not len(os.listdir(actual_root)):
            os.rmdir(actual_root)
        os.rmdir(root)

    os.makedirs("@efiSysMountPoint@/efi/nixos/.extra-files", exist_ok=True)

    subprocess.check_call("@copyExtraFiles@")


def main() -> None:
    parser = argparse.ArgumentParser(description='Update @distroName@-related systemd-boot files')
    parser.add_argument('default_config', metavar='DEFAULT-CONFIG', help='The default @distroName@ config to boot')
    args = parser.parse_args()

    try:
        install_bootloader(args)
    finally:
        # Since fat32 provides little recovery facilities after a crash,
        # it can leave the system in an unbootable state, when a crash/outage
        # happens shortly after an update. To decrease the likelihood of this
        # event sync the efi filesystem after each update.
        rc = libc.syncfs(os.open("@efiSysMountPoint@", os.O_RDONLY))
        if rc != 0:
            print("could not sync @efiSysMountPoint@: {}".format(os.strerror(rc)), file=sys.stderr)


if __name__ == '__main__':
    main()
