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
from typing import NamedTuple, Any, Type
from dataclasses import dataclass
from pathlib import Path

# These values will be replaced with actual values during the package build
EFI_SYS_MOUNT_POINT = "@efiSysMountPoint@"
BOOT_MOUNT_POINT = "@bootMountPoint@"
LOADER_CONF = f"{EFI_SYS_MOUNT_POINT}/loader/loader.conf"  # Always stored on the ESP
NIXOS_DIR = "@nixosDir@"
TIMEOUT = "@timeout@"
EDITOR = "@editor@" == "1" # noqa: PLR0133
CONSOLE_MODE = "@consoleMode@"
BOOTSPEC_TOOLS = "@bootspecTools@"
DISTRO_NAME = "@distroName@"
NIX = "@nix@"
SYSTEMD = "@systemd@"
CONFIGURATION_LIMIT = int("@configurationLimit@")
CAN_TOUCH_EFI_VARIABLES = "@canTouchEfiVariables@"
GRACEFUL = "@graceful@"
COPY_EXTRA_FILES = "@copyExtraFiles@"
CHECK_MOUNTPOINTS = "@checkMountpoints@"
BOOT_COUNTING_TRIES = "@bootCountingTries@"
BOOT_COUNTING = "@bootCounting@" == "True"

@dataclass
class BootSpec:
    init: str
    initrd: str
    kernel: str
    kernelParams: list[str]  # noqa: N815
    label: str
    system: str
    toplevel: str
    specialisations: dict[str, "BootSpec"]
    sortKey: str  # noqa: N815
    initrdSecrets: str | None = None  # noqa: N815

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

@dataclass
class DiskEntry:
    entry: Entry
    default: bool
    counters: str | None
    title: str | None
    description: str | None
    kernel: str
    initrd: str
    kernel_params: str | None
    machine_id: str | None
    sort_key: str

    @classmethod
    def from_path(cls: Type["DiskEntry"], path: Path) -> "DiskEntry":
        entry = Entry.from_path(path)
        data = path.read_text().splitlines()
        if '' in data:
            data.remove('')
        entry_map = dict(lines.split(' ', 1) for lines in data)
        assert "linux" in entry_map
        assert "initrd" in entry_map
        filename = path.name
        # Matching nixos*-generation-*$counters.conf
        rex_counters = re.compile(r"^nixos.*-generation-.*(\+\d(-\d)?)\.conf$")
        counters = rex_counters.sub(r"\1", filename) if rex_counters.match(filename) else None
        disk_entry = cls(
            entry=entry,
            default=(entry_map.get("sort-key") == "default"),
            counters=counters,
            title=entry_map.get("title"),
            description=entry_map.get("version"),
            kernel=entry_map["linux"],
            initrd=entry_map["initrd"],
            kernel_params=entry_map.get("options"),
            machine_id=entry_map.get("machine-id"),
            sort_key=entry_map.get("sort_key", "nixos"))
        return disk_entry

    def write(self, sorted_first: str) -> None:
        # Compute a sort-key sorted before sorted_first
        # This will compute something like: nixos -> nixor-default to make sure we come before other nixos entries,
        # while allowing users users can pre-pend their own entries before.
        default_sort_key = sorted_first[:-1] + chr(ord(sorted_first[-1])-1) + "-default"
        tmp_path = self.path.with_suffix(".tmp")
        with tmp_path.open('w') as f:
            # We use "sort-key" to sort the default generation first.
            # The "default" string is sorted before "non-default" (alphabetically)
            boot_entry = [
                f"title {self.title}" if self.title is not None else None,
                f"version {self.description}" if self.description is not None else None,
                f"linux {self.kernel}",
                f"initrd  {self.initrd}",
                f"options {self.kernel_params}" if self.kernel_params is not None else None,
                f"machine-id {self.machine_id}" if self.machine_id is not None else None,
                f"sort-key {default_sort_key if self.default else self.sort_key}"
            ]

            f.write("\n".join(filter(None, boot_entry)))
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
        return Path(f"{BOOT_MOUNT_POINT}/loader/entries/{prefix}{self.counters if self.counters else ''}.conf")

libc = ctypes.CDLL("libc.so.6")

FILE = None | int

def run(cmd: list[str], stdout: FILE = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, check=True, text=True, stdout=stdout)

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
    with open(f"{EFI_SYS_MOUNT_POINT}/loader/loader.conf.tmp", 'w') as f:
        if TIMEOUT != "":
            f.write(f"timeout {TIMEOUT}\n")
        if profile:
            f.write("default nixos-%s-generation-*\n" % profile)
        else:
            f.write("default nixos-generation-*\n")
        if not EDITOR:
            f.write("editor 0\n")
        f.write(f"console-mode {CONSOLE_MODE}\n")
        f.flush()
        os.fsync(f.fileno())
    os.rename(f"{LOADER_CONF}.tmp", LOADER_CONF)

def scan_entries() -> list[DiskEntry]:
    """
    Scan all entries in $ESP/loader/entries/*
    Does not support Type 2 entries as we do not support them for now.
    Returns a generator of Entry.
    """
    entries = []
    for path in Path(f"{EFI_SYS_MOUNT_POINT}/loader/entries/").glob("nixos*-generation-[1-9]*.conf"):
        try:
            entries.append(DiskEntry.from_path(path))
        except ValueError:
            continue
    return entries

def get_bootspec(profile: str | None, generation: int) -> BootSpec:
    system_directory = system_dir(profile, generation, None)
    boot_json_path = os.path.realpath("%s/%s" % (system_directory, "boot.json"))
    if os.path.isfile(boot_json_path):
        boot_json_f = open(boot_json_path, 'r')
        bootspec_json = json.load(boot_json_f)
    else:
        boot_json_str = run(
            [
                f"{BOOTSPEC_TOOLS}/bin/synthesize",
                "--version",
                "1",
                system_directory,
                "/dev/stdout",
            ],
            stdout=subprocess.PIPE,
        ).stdout
        bootspec_json = json.loads(boot_json_str)
    return bootspec_from_json(bootspec_json)

def bootspec_from_json(bootspec_json: dict[str, Any]) -> BootSpec:
    specialisations = bootspec_json['org.nixos.specialisation.v1']
    specialisations = {k: bootspec_from_json(v) for k, v in specialisations.items()}
    systemdBootExtension = bootspec_json.get('org.nixos.systemd-boot', {})
    sortKey = systemdBootExtension.get('sortKey', 'nixos')
    return BootSpec(
        **bootspec_json['org.nixos.bootspec.v1'],
        specialisations=specialisations,
        sortKey=sortKey
    )


def copy_from_file(file: str, dry_run: bool = False) -> str:
    store_file_path = os.path.realpath(file)
    suffix = os.path.basename(store_file_path)
    store_dir = os.path.basename(os.path.dirname(store_file_path))
    efi_file_path = f"{NIXOS_DIR}/{store_dir}-{suffix}.efi"
    if not dry_run:
        copy_if_not_exists(store_file_path, f"{BOOT_MOUNT_POINT}{efi_file_path}")
    return efi_file_path

def write_entry(profile: str | None,
                generation: int,
                specialisation: str | None,
                machine_id: str,
                bootspec: BootSpec,
                entries: list[DiskEntry],
                sorted_first: str,
                current: bool) -> None:
    if specialisation:
        bootspec = bootspec.specialisations[specialisation]
    kernel = copy_from_file(bootspec.kernel)
    initrd = copy_from_file(bootspec.initrd)

    title = "{name}{profile}{specialisation}".format(
        name=DISTRO_NAME,
        profile=" [" + profile + "]" if profile else "",
        specialisation=" (%s)" % specialisation if specialisation else "")

    try:
        if bootspec.initrdSecrets is not None:
            run([bootspec.initrdSecrets, f"{BOOT_MOUNT_POINT}%s" % (initrd)])
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
    counters = f"+{BOOT_COUNTING_TRIES}" if BOOT_COUNTING else ""
    entry = Entry(profile, generation, specialisation)
    # We check if the entry we are writing is already on disk
    # and we update its "default entry" status
    for entry_on_disk in entries:
        if entry == entry_on_disk.entry:
            entry_on_disk.default = current
            entry_on_disk.write(sorted_first)
            return

    DiskEntry(
        entry=entry,
        title=title,
        kernel=kernel,
        initrd=initrd,
        counters=counters,
        kernel_params=kernel_params,
        machine_id=machine_id,
        description=f"Generation {generation} {bootspec.label}, built on {build_date}",
        sort_key=bootspec.sortKey,
        default=current
    ).write(sorted_first)

def get_generations(profile: str | None = None) -> list[SystemIdentifier]:
    gen_list = run(
        [
            f"{NIX}/bin/nix-env",
            "--list-generations",
            "-p",
            "/nix/var/nix/profiles/%s"
            % ("system-profiles/" + profile if profile else "system"),
        ],
        stdout=subprocess.PIPE,
    ).stdout
    gen_lines = gen_list.split("\n")
    gen_lines.pop()

    configurationLimit = CONFIGURATION_LIMIT
    configurations = [
        SystemIdentifier(
            profile=profile,
            generation=int(line.split()[0]),
            specialisation=None
        )
        for line in gen_lines
    ]
    return configurations[-configurationLimit:]


def remove_old_entries(gens: list[SystemIdentifier], disk_entries: list[DiskEntry]) -> None:
    known_paths = []
    for gen in gens:
        bootspec = get_bootspec(gen.profile, gen.generation)
        known_paths.append(copy_from_file(bootspec.kernel, True))
        known_paths.append(copy_from_file(bootspec.initrd, True))
    for disk_entry in disk_entries:
        if (disk_entry.entry.profile, disk_entry.entry.generation_number, None) not in gens:
            os.unlink(disk_entry.path)
    for path in glob.iglob(f"{EFI_SYS_MOUNT_POINT}/efi/nixos/*"):
        if path not in known_paths and not os.path.isdir(path):
            os.unlink(path)

def cleanup_esp() -> None:
    for path in glob.iglob(f"{EFI_SYS_MOUNT_POINT}/loader/entries/nixos*"):
        os.unlink(path)
    if os.path.isdir(f"{EFI_SYS_MOUNT_POINT}/{NIXOS_DIR}"):
        shutil.rmtree(f"{EFI_SYS_MOUNT_POINT}/{NIXOS_DIR}")


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
            machine_id = machine_file.readlines()[0].strip()
    except IOError as e:
        if e.errno != errno.ENOENT:
            raise
        # Since systemd version 232 a machine ID is required and it might not
        # be there on newly installed systems, so let's generate one so that
        # bootctl can find it and we can also pass it to write_entry() later.
        cmd = [f"{SYSTEMD}/bin/systemd-machine-id-setup", "--print"]
        machine_id = run(cmd, stdout=subprocess.PIPE).stdout.rstrip()

    if os.getenv("NIXOS_INSTALL_GRUB") == "1":
        warnings.warn("NIXOS_INSTALL_GRUB env var deprecated, use NIXOS_INSTALL_BOOTLOADER", DeprecationWarning)
        os.environ["NIXOS_INSTALL_BOOTLOADER"] = "1"

    # flags to pass to bootctl install/update
    bootctl_flags = []

    if BOOT_MOUNT_POINT != EFI_SYS_MOUNT_POINT:
        bootctl_flags.append(f"--boot-path={BOOT_MOUNT_POINT}")

    if CAN_TOUCH_EFI_VARIABLES != "1":
        bootctl_flags.append("--no-variables")

    if GRACEFUL == "1":
        bootctl_flags.append("--graceful")

    if os.getenv("NIXOS_INSTALL_BOOTLOADER") == "1":
        # bootctl uses fopen() with modes "wxe" and fails if the file exists.
        if os.path.exists(LOADER_CONF):
            os.unlink(LOADER_CONF)

        run(
            [f"{SYSTEMD}/bin/bootctl", f"--esp-path={EFI_SYS_MOUNT_POINT}"]
            + bootctl_flags
            + ["install"]
        )
    else:
        # Update bootloader to latest if needed
        available_out = run(
            [f"{SYSTEMD}/bin/bootctl", "--version"], stdout=subprocess.PIPE
        ).stdout.split()[2]
        installed_out = run(
            [f"{SYSTEMD}/bin/bootctl", f"--esp-path={EFI_SYS_MOUNT_POINT}", "status"],
            stdout=subprocess.PIPE,
        ).stdout

        # See status_binaries() in systemd bootctl.c for code which generates this
        # Matches
        # Available Boot Loaders on ESP:
        #  ESP: /boot (/dev/disk/by-partuuid/9b39b4c4-c48b-4ebf-bfea-a56b2395b7e0)
        # File: └─/EFI/systemd/systemd-bootx64.efi (systemd-boot 255.2)
        # But also:
        # Available Boot Loaders on ESP:
        #  ESP: /boot (/dev/disk/by-partuuid/9b39b4c4-c48b-4ebf-bfea-a56b2395b7e0)
        # File: ├─/EFI/systemd/HashTool.efi
        #       └─/EFI/systemd/systemd-bootx64.efi (systemd-boot 255.2)
        installed_match = re.search(r"^\W+.*/EFI/(?:BOOT|systemd)/.*\.efi \(systemd-boot ([\d.]+[^)]*)\)$",
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
            run(
                [f"{SYSTEMD}/bin/bootctl", f"--esp-path={EFI_SYS_MOUNT_POINT}"]
                + bootctl_flags
                + ["update"]
            )

    os.makedirs(f"{BOOT_MOUNT_POINT}/{NIXOS_DIR}", exist_ok=True)
    os.makedirs(f"{BOOT_MOUNT_POINT}/loader/entries", exist_ok=True)

    gens = get_generations()
    for profile in get_profiles():
        gens += get_generations(profile)
    entries = scan_entries()
    remove_old_entries(gens, entries)
    # Compute the sort-key that will be sorted first.
    sorted_first = ""
    for gen in gens:
        try:
            bootspec = get_bootspec(gen.profile, gen.generation)
            if bootspec.sortKey < sorted_first or sorted_first == "":
                sorted_first = bootspec.sortKey
        except OSError as e:
            # See https://github.com/NixOS/nixpkgs/issues/114552
            if e.errno == errno.EINVAL:
                profile = f"profile '{gen.profile}'" if gen.profile else "default profile"
                print("ignoring {} in the list of boot entries because of the following error:\n{}".format(profile, e), file=sys.stderr)
            else:
                raise e

    for gen in gens:
        try:
            bootspec = get_bootspec(gen.profile, gen.generation)
            is_default = os.path.dirname(bootspec.init) == args.default_config
            write_entry(*gen, machine_id, bootspec, entries, sorted_first, current=is_default)
            for specialisation in bootspec.specialisations.keys():
                write_entry(gen.profile, gen.generation, specialisation, machine_id, bootspec, entries, sorted_first, current=(is_default and bootspec.specialisations[specialisation].sortKey == bootspec.sortKey))
            if is_default:
                write_loader_conf(gen.profile)
        except OSError as e:
            # See https://github.com/NixOS/nixpkgs/issues/114552
            if e.errno == errno.EINVAL:
                profile = f"profile '{gen.profile}'" if gen.profile else "default profile"
                print("ignoring {} in the list of boot entries because of the following error:\n{}".format(profile, e), file=sys.stderr)
            else:
                raise e

    if BOOT_MOUNT_POINT != EFI_SYS_MOUNT_POINT:
        # Cleanup any entries in ESP if xbootldrMountPoint is set.
        # If the user later unsets xbootldrMountPoint, entries in XBOOTLDR will not be cleaned up
        # automatically, as we don't have information about the mount point anymore.
        cleanup_esp()

    for root, _, files in os.walk(f"{BOOT_MOUNT_POINT}/{NIXOS_DIR}/.extra-files", topdown=False):
        relative_root = root.removeprefix(f"{BOOT_MOUNT_POINT}/{NIXOS_DIR}/.extra-files").removeprefix("/")
        actual_root = os.path.join(f"{BOOT_MOUNT_POINT}", relative_root)

        for file in files:
            actual_file = os.path.join(actual_root, file)

            if os.path.exists(actual_file):
                os.unlink(actual_file)
            os.unlink(os.path.join(root, file))

        if not len(os.listdir(actual_root)):
            os.rmdir(actual_root)
        os.rmdir(root)

    os.makedirs(f"{BOOT_MOUNT_POINT}/{NIXOS_DIR}/.extra-files", exist_ok=True)

    run([COPY_EXTRA_FILES])


def main() -> None:
    parser = argparse.ArgumentParser(description=f"Update {DISTRO_NAME}-related systemd-boot files")
    parser.add_argument('default_config', metavar='DEFAULT-CONFIG', help=f"The default {DISTRO_NAME} config to boot")
    args = parser.parse_args()

    run([CHECK_MOUNTPOINTS])

    try:
        install_bootloader(args)
    finally:
        # Since fat32 provides little recovery facilities after a crash,
        # it can leave the system in an unbootable state, when a crash/outage
        # happens shortly after an update. To decrease the likelihood of this
        # event sync the efi filesystem after each update.
        rc = libc.syncfs(os.open(f"{BOOT_MOUNT_POINT}", os.O_RDONLY))
        if rc != 0:
            print(f"could not sync {BOOT_MOUNT_POINT}: {os.strerror(rc)}", file=sys.stderr)

        if BOOT_MOUNT_POINT != EFI_SYS_MOUNT_POINT:
            rc = libc.syncfs(os.open(EFI_SYS_MOUNT_POINT, os.O_RDONLY))
            if rc != 0:
                print(f"could not sync {EFI_SYS_MOUNT_POINT}: {os.strerror(rc)}", file=sys.stderr)


if __name__ == '__main__':
    main()
