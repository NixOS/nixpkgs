#! @python3@/bin/python3 -B
import argparse
import ctypes
import datetime
import errno
import os
import re
import shutil
import subprocess
import sys
import tempfile
import warnings
import json
import glob
from typing import NamedTuple, Any, Sequence, Type
from dataclasses import dataclass
from pathlib import Path

# These values will be replaced with actual values during the package build
EFI_SYS_MOUNT_POINT = Path("@efiSysMountPoint@")
BOOT_MOUNT_POINT = Path("@bootMountPoint@")
LOADER_CONF = EFI_SYS_MOUNT_POINT / "loader/loader.conf"  # Always stored on the ESP
NIXOS_DIR = Path(
    "@nixosDir@".strip("/")
)  # Path relative to the XBOOTLDR or ESP mount point
TIMEOUT = "@timeout@"
EDITOR = "@editor@" == "1"  # noqa: PLR0133
CONSOLE_MODE = "@consoleMode@"
BOOTSPEC_TOOLS = "@bootspecTools@"
DISTRO_NAME = "@distroName@"
NIX = "@nix@"
SYSTEMD = "@systemd@"
CONFIGURATION_LIMIT = int("@configurationLimit@")
REBOOT_FOR_BITLOCKER = bool("@rebootForBitlocker@")
CAN_TOUCH_EFI_VARIABLES = "@canTouchEfiVariables@"
GRACEFUL = "@graceful@"
COPY_EXTRA_FILES = "@copyExtraFiles@"
CHECK_MOUNTPOINTS = "@checkMountpoints@"
STORE_DIR = "@storeDir@"
BOOT_COUNTING_TRIES = "@bootCountingTries@"
BOOT_COUNTING = "@bootCounting@" == "True"


@dataclass
class BootSpec:
    init: Path
    initrd: Path
    kernel: Path
    kernelParams: list[str]  # noqa: N815
    label: str
    system: str
    toplevel: Path
    specialisations: dict[str, "BootSpec"]
    sortKey: str  # noqa: N815
    devicetree: Path | None = None  # noqa: N815
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
        rex_specialisation = re.compile(
            r"^nixos.*-generation-([0-9]+)-specialisation-([a-zA-Z0-9]+).*\.conf$"
        )
        profile = (
            rex_profile.sub(r"\1", filename) if rex_profile.match(filename) else None
        )
        specialisation = (
            rex_specialisation.sub(r"\2", filename)
            if rex_specialisation.match(filename)
            else None
        )
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
    kernel: Path
    initrd: Path
    devicetree: Path | None
    kernel_params: str | None
    machine_id: str | None
    sort_key: str

    @classmethod
    def from_path(cls: Type["DiskEntry"], path: Path) -> "DiskEntry":
        entry = Entry.from_path(path)
        data = path.read_text().splitlines()
        if "" in data:
            data.remove("")
        entry_map = dict(lines.split(" ", 1) for lines in data)
        assert "linux" in entry_map
        assert "initrd" in entry_map
        filename = path.name
        # Matching nixos*-generation-*$counters.conf
        rex_counters = re.compile(r"^nixos.*-generation-.*(\+\d(-\d)?)\.conf$")
        counters = (
            rex_counters.sub(r"\1", filename) if rex_counters.match(filename) else None
        )

        maybe_devicetree_path = entry_map.get("devicetree")
        disk_entry = cls(
            entry=entry,
            default=(entry_map.get("sort-key") == "default"),
            counters=counters,
            title=entry_map.get("title"),
            description=entry_map.get("version"),
            kernel=Path(entry_map["linux"]),
            initrd=Path(entry_map["initrd"]),
            devicetree=Path(maybe_devicetree_path) if maybe_devicetree_path else None,
            machine_id=entry_map.get("machine-id"),
            sort_key=entry_map.get("sort_key", "nixos"),
            kernel_params=entry_map.get("options"),
        )
        return disk_entry

    def write(self, sorted_first: str) -> None:
        # TODO
        # Compute a sort-key sorted before sorted_first
        # This will compute something like: nixos -> nixor-default to make sure we come before other nixos entries,
        # while allowing users users can pre-pend their own entries before.
        default_sort_key = (
            sorted_first[:-1] + chr(ord(sorted_first[-1]) - 1) + "-default"
        )
        tmp_path = self.path.with_suffix(".tmp")
        with tmp_path.open("w") as f:
            # We use "sort-key" to sort the default generation first.
            # The "default" string is sorted before "non-default" (alphabetically)
            boot_entry = [
                f"title {self.title}" if self.title is not None else None,
                f"version {self.description}" if self.description is not None else None,
                f"linux {self.kernel}",
                f"initrd  {self.initrd}",
                f"options {self.kernel_params}"
                if self.kernel_params is not None
                else None,
                f"machine-id {self.machine_id}"
                if self.machine_id is not None
                else None,
                f"devicetree {self.devicetree}"
                if self.devicetree is not None
                else None,
                f"sort-key {default_sort_key if self.default else self.sort_key}",
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
            f"specialisation-{self.entry.specialisation}"
            if self.entry.specialisation
            else None,
        ]
        prefix = "-".join(p for p in pieces if p)
        return Path(
            f"{BOOT_MOUNT_POINT}/loader/entries/{prefix}{self.counters if self.counters else ''}.conf"
        )


libc = ctypes.CDLL("libc.so.6")

FILE = None | int


def run(
    cmd: Sequence[str | Path], stdout: FILE = None
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, check=True, text=True, stdout=stdout)


class SystemIdentifier(NamedTuple):
    profile: str | None
    generation: int
    specialisation: str | None


def copy_if_not_exists(source: Path, dest: Path) -> None:
    if not dest.exists():
        tmpfd, tmppath = tempfile.mkstemp(dir=dest.parent, prefix=dest.name, suffix='.tmp.')
        shutil.copyfile(source, tmppath)
        os.fsync(tmpfd)
        shutil.move(tmppath, dest)


def generation_dir(profile: str | None, generation: int) -> Path:
    if profile:
        return Path(
            f"/nix/var/nix/profiles/system-profiles/{profile}-{generation}-link"
        )
    else:
        return Path(f"/nix/var/nix/profiles/system-{generation}-link")


def system_dir(
    profile: str | None, generation: int, specialisation: str | None
) -> Path:
    d = generation_dir(profile, generation)
    if specialisation:
        return d / "specialisation" / specialisation
    else:
        return d


def write_loader_conf(profile: str | None) -> None:
    tmp = LOADER_CONF.with_suffix(".tmp")
    with tmp.open("x") as f:
        f.write(f"timeout {TIMEOUT}\n")
        if profile:
            f.write("default nixos-%s-generation-*\n" % profile)
        else:
            f.write("default nixos-generation-*\n")
        if not EDITOR:
            f.write("editor 0\n")
        if REBOOT_FOR_BITLOCKER:
            f.write("reboot-for-bitlocker yes\n")
        f.write(f"console-mode {CONSOLE_MODE}\n")
        f.flush()
        os.fsync(f.fileno())
    os.rename(tmp, LOADER_CONF)


def scan_entries() -> list[DiskEntry]:
    """
    Scan all entries in $ESP/loader/entries/*
    Does not support Type 2 entries as we do not support them for now.
    Returns a generator of Entry.
    """
    entries = []
    for path in Path(f"{EFI_SYS_MOUNT_POINT}/loader/entries/").glob(
        "nixos*-generation-[1-9]*.conf"
    ):
        try:
            entries.append(DiskEntry.from_path(path))
        except ValueError:
            continue
    return entries


def get_bootspec(profile: str | None, generation: int) -> BootSpec:
    system_directory = system_dir(profile, generation, None)
    boot_json_path = (system_directory / "boot.json").resolve()
    if boot_json_path.is_file():
        with boot_json_path.open("r") as f:
            # check if json is well-formed, else throw error with filepath
            try:
                bootspec_json = json.load(f)
            except ValueError as e:
                print(
                    f"error: Malformed Json: {e}, in {boot_json_path}", file=sys.stderr
                )
                sys.exit(1)
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
    specialisations = bootspec_json["org.nixos.specialisation.v1"]
    specialisations = {k: bootspec_from_json(v) for k, v in specialisations.items()}
    systemdBootExtension = bootspec_json.get("org.nixos.systemd-boot", {})
    sortKey = systemdBootExtension.get("sortKey", "nixos")
    devicetree = systemdBootExtension.get("devicetree")

    if devicetree:
        devicetree = Path(devicetree)

    main_json = bootspec_json["org.nixos.bootspec.v1"]
    for attr in ("kernel", "initrd", "toplevel"):
        if attr in main_json:
            main_json[attr] = Path(main_json[attr])
    return BootSpec(
        **main_json,
        specialisations=specialisations,
        sortKey=sortKey,
        devicetree=devicetree,
    )


def copy_from_file(file: Path, dry_run: bool = False) -> Path:
    """
    Copy a file to the boot filesystem (XBOOTLDR if in use, otherwise ESP), basing the destination filename on the store path that's being copied from. Return the destination path, relative to the boot filesystem mountpoint.
    """
    store_file_path = file.resolve()
    suffix = store_file_path.name
    store_subdir = store_file_path.relative_to(STORE_DIR).parts[0]
    efi_file_path = NIXOS_DIR / (
        f"{suffix}.efi" if suffix == store_subdir else f"{store_subdir}-{suffix}.efi"
    )
    if not dry_run:
        copy_if_not_exists(store_file_path, BOOT_MOUNT_POINT / efi_file_path)
    return efi_file_path


def write_entry(
    profile: str | None,
    generation: int,
    specialisation: str | None,
    machine_id: str | None,
    bootspec: BootSpec,
    entries: list[DiskEntry],
    sorted_first: str,
    current: bool,
) -> None:
    if specialisation:
        bootspec = bootspec.specialisations[specialisation]
    kernel = copy_from_file(bootspec.kernel)
    initrd = copy_from_file(bootspec.initrd)
    devicetree = (
        copy_from_file(bootspec.devicetree) if bootspec.devicetree is not None else None
    )

    title = "{name}{profile}{specialisation}".format(
        name=DISTRO_NAME,
        profile=" [" + profile + "]" if profile else "",
        specialisation=" (%s)" % specialisation if specialisation else "",
    )

    try:
        if bootspec.initrdSecrets is not None:
            run([bootspec.initrdSecrets, BOOT_MOUNT_POINT / initrd])
    except subprocess.CalledProcessError:
        if current:
            print("failed to create initrd secrets!", file=sys.stderr)
            sys.exit(1)
        else:
            print(
                "warning: failed to create initrd secrets "
                f'for "{title} - Configuration {generation}", an older generation',
                file=sys.stderr,
            )
            print(
                "note: this is normal after having removed "
                "or renamed a file in `boot.initrd.secrets`",
                file=sys.stderr,
            )
    kernel_params = "init=%s " % bootspec.init

    kernel_params = kernel_params + " ".join(bootspec.kernelParams)
    build_time = int(system_dir(profile, generation, specialisation).stat().st_ctime)
    build_date = datetime.datetime.fromtimestamp(build_time).strftime("%F")

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
        devicetree=devicetree,
        counters=counters,
        kernel_params=kernel_params,
        machine_id=machine_id,
        description=f"Generation {generation} {bootspec.label}, built on {build_date}",
        sort_key=bootspec.sortKey,
        default=current,
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
            profile=profile, generation=int(line.split()[0]), specialisation=None
        )
        for line in gen_lines
    ]
    return configurations[-configurationLimit:]


def remove_old_entries(
    gens: list[SystemIdentifier], disk_entries: list[DiskEntry]
) -> None:
    known_paths = []
    for gen in gens:
        bootspec = get_bootspec(gen.profile, gen.generation)
        known_paths.append(copy_from_file(bootspec.kernel, True).name)
        known_paths.append(copy_from_file(bootspec.initrd, True).name)
        if bootspec.devicetree is not None:
            known_paths.append(copy_from_file(bootspec.devicetree, True).name)

    for disk_entry in disk_entries:
        if (
            disk_entry.entry.profile,
            disk_entry.entry.generation_number,
            None,
        ) not in gens:
            os.unlink(disk_entry.path)
    for path_name in glob.iglob(f"{EFI_SYS_MOUNT_POINT}/efi/nixos/*"):
        path = Path(path_name)
        if path.name not in known_paths and not path.is_dir():
            path.unlink()


def cleanup_esp() -> None:
    for path in (EFI_SYS_MOUNT_POINT / "loader/entries").glob("nixos*"):
        path.unlink()
    nixos_dir = EFI_SYS_MOUNT_POINT / NIXOS_DIR
    if nixos_dir.is_dir():
        shutil.rmtree(nixos_dir)


def get_profiles() -> list[str]:
    system_profiles = Path("/nix/var/nix/profiles/system-profiles/")
    if system_profiles.is_dir():
        return [
            x.name for x in system_profiles.iterdir() if not x.name.endswith("-link")
        ]
    else:
        return []


def install_bootloader(args: argparse.Namespace) -> None:
    try:
        with open("/etc/machine-id") as machine_file:
            machine_id = machine_file.readlines()[0].strip()
    except IOError as e:
        if e.errno != errno.ENOENT:
            raise
        machine_id = None

    if os.getenv("NIXOS_INSTALL_GRUB") == "1":
        warnings.warn(
            "NIXOS_INSTALL_GRUB env var deprecated, use NIXOS_INSTALL_BOOTLOADER",
            DeprecationWarning,
        )
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
        LOADER_CONF.unlink(missing_ok=True)

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
        installed_match = re.search(
            r"^\W+.*/EFI/(?:BOOT|systemd)/.*\.efi \(systemd-boot ([\d.]+[^)]*)\)$",
            installed_out,
            re.IGNORECASE | re.MULTILINE,
        )

        available_match = re.search(r"^\((.*)\)$", available_out)

        if installed_match is None:
            raise Exception(
                "Could not find any previously installed systemd-boot. If you are switching to systemd-boot from a different bootloader, you need to run `nixos-rebuild switch --install-bootloader`"
            )

        if available_match is None:
            raise Exception("could not determine systemd-boot version")

        installed_version = installed_match.group(1)
        available_version = available_match.group(1)

        if installed_version < available_version:
            print(
                "updating systemd-boot from %s to %s"
                % (installed_version, available_version),
                file=sys.stderr,
            )
            run(
                [f"{SYSTEMD}/bin/bootctl", f"--esp-path={EFI_SYS_MOUNT_POINT}"]
                + bootctl_flags
                + ["update"]
            )

    (BOOT_MOUNT_POINT / NIXOS_DIR).mkdir(parents=True, exist_ok=True)
    (BOOT_MOUNT_POINT / "loader/entries").mkdir(parents=True, exist_ok=True)

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
                profile = (
                    f"profile '{gen.profile}'" if gen.profile else "default profile"
                )
                print(
                    "ignoring {} in the list of boot entries because of the following error:\n{}".format(
                        profile, e
                    ),
                    file=sys.stderr,
                )
            else:
                raise e

    for gen in gens:
        try:
            bootspec = get_bootspec(gen.profile, gen.generation)
            is_default = Path(bootspec.init).parent == Path(args.default_config)
            write_entry(
                *gen, machine_id, bootspec, entries, sorted_first, current=is_default
            )
            for specialisation in bootspec.specialisations.keys():
                write_entry(
                    gen.profile,
                    gen.generation,
                    specialisation,
                    machine_id,
                    bootspec,
                    entries,
                    sorted_first,
                    current=(
                        is_default
                        and bootspec.specialisations[specialisation].sortKey
                        == bootspec.sortKey
                    ),
                )
            if is_default:
                write_loader_conf(gen.profile)
        except OSError as e:
            # See https://github.com/NixOS/nixpkgs/issues/114552
            if e.errno == errno.EINVAL:
                profile = (
                    f"profile '{gen.profile}'" if gen.profile else "default profile"
                )
                print(
                    "ignoring {} in the list of boot entries because of the following error:\n{}".format(
                        profile, e
                    ),
                    file=sys.stderr,
                )
            else:
                raise e

    if BOOT_MOUNT_POINT != EFI_SYS_MOUNT_POINT:
        # Cleanup any entries in ESP if xbootldrMountPoint is set.
        # If the user later unsets xbootldrMountPoint, entries in XBOOTLDR will not be cleaned up
        # automatically, as we don't have information about the mount point anymore.
        cleanup_esp()

    extra_files_dir = BOOT_MOUNT_POINT / NIXOS_DIR / ".extra-files"
    for root, _, files in extra_files_dir.walk(top_down=False):
        relative_root = root.relative_to(extra_files_dir)
        actual_root = BOOT_MOUNT_POINT / relative_root

        for file in files:
            actual_file = actual_root / file
            actual_file.unlink(missing_ok=True)
            (root / file).unlink()

        if not list(actual_root.iterdir()):
            actual_root.rmdir()
        root.rmdir()

    extra_files_dir.mkdir(parents=True, exist_ok=True)

    run([COPY_EXTRA_FILES])


def main() -> None:
    parser = argparse.ArgumentParser(
        description=f"Update {DISTRO_NAME}-related systemd-boot files"
    )
    parser.add_argument(
        "default_config",
        metavar="DEFAULT-CONFIG",
        help=f"The default {DISTRO_NAME} config to boot",
    )
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
            print(
                f"could not sync {BOOT_MOUNT_POINT}: {os.strerror(rc)}", file=sys.stderr
            )

        if BOOT_MOUNT_POINT != EFI_SYS_MOUNT_POINT:
            rc = libc.syncfs(os.open(EFI_SYS_MOUNT_POINT, os.O_RDONLY))
            if rc != 0:
                print(
                    f"could not sync {EFI_SYS_MOUNT_POINT}: {os.strerror(rc)}",
                    file=sys.stderr,
                )


if __name__ == "__main__":
    main()
