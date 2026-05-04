#! @python3@/bin/python3 -B
import argparse
import ctypes
import datetime
import errno
import hashlib
import os
import re
import shutil
import subprocess
import sys
import tempfile
import warnings
import json
from typing import NamedTuple, Any, Protocol, Sequence
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
CAN_TOUCH_EFI_VARIABLES = "@canTouchEfiVariables@" == "1"
GRACEFUL = "@graceful@" == "1"
COPY_EXTRA_FILES = "@copyExtraFiles@"
CHECK_MOUNTPOINTS = "@checkMountpoints@"
STORE_DIR = "@storeDir@"
BOOT_COUNTING_TRIES = "@bootCountingTries@"
BOOT_COUNTING = "@bootCounting@" == "True"


@dataclass(frozen=True)
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


class WriteBootFile(Protocol):
    def write_boot_file(self, path: Path) -> None: ...


@dataclass
class CopyWriter:
    source: Path

    def write_boot_file(self, path: Path) -> None:
        if path.exists():
            return
        with tempfile.NamedTemporaryFile(
            mode="wb",
            dir=path.parent,
            delete=False,
            prefix=path.name,
            suffix=".tmp",
        ) as tmp:
            with open(self.source, mode="rb") as source_file:
                shutil.copyfileobj(source_file, tmp)
            tmp.flush()
            os.fsync(tmp.fileno())
            tmp.close()
            os.rename(tmp.name, path)


@dataclass
class InitrdWithSecretsWriter:
    source: Path
    initrd_secrets: Path

    def write_boot_file(self, path: Path) -> None:
        # Secrets can change between rebuilds, so always rebuild from the
        # pristine initrd into a temp file and rename into place.
        tmp = tempfile.NamedTemporaryFile(
            mode="wb",
            dir=path.parent,
            delete=False,
            prefix=path.name,
            suffix=".tmp",
        )
        try:
            with open(self.source, mode="rb") as source_file:
                shutil.copyfileobj(source_file, tmp)
            tmp.close()
            run([self.initrd_secrets, tmp.name])
            with open(tmp.name, "rb") as f:
                os.fsync(f.fileno())
        except BaseException:
            os.unlink(tmp.name)
            raise
        os.rename(tmp.name, path)


@dataclass
class ContentsWriter:
    contents: bytes

    def write_boot_file(self, path: Path) -> None:
        if path.exists():
            return
        with tempfile.NamedTemporaryFile(
            mode="wb",
            dir=path.parent,
            delete=False,
            prefix=path.name,
            suffix=".tmp",
        ) as tmp:
            tmp.write(self.contents)
            tmp.flush()
            os.fsync(tmp.fileno())
            tmp.close()
            os.rename(tmp.name, path)


class SystemIdentifier(NamedTuple):
    profile: str | None
    generation: int
    specialisation: str | None


@dataclass
class BootFile:
    system_identifier: SystemIdentifier
    current: bool
    path: Path
    writer: WriteBootFile

    @staticmethod
    def from_source(
        system_identifier: SystemIdentifier, current: bool, source: Path
    ) -> "BootFile":
        return BootFile(
            system_identifier=system_identifier,
            current=current,
            path=boot_path(source),
            writer=CopyWriter(source=source),
        )

    @staticmethod
    def from_initrd(
        system_identifier: SystemIdentifier,
        current: bool,
        source: Path,
        initrd_secrets: Path | None,
    ) -> "BootFile":
        if initrd_secrets is None:
            return BootFile.from_source(system_identifier, current, source)
        else:
            # We're trying to calculate a canonical path unique to
            # this initrd and secret-appender. The boot_path is the
            # canonical path for files that don't need modifications,
            # so it serves as a perfect proxy for the unique
            # information to combine for a combined unique path. The
            # original paths themselves would have also been fine, but
            # boot_path is more semantically representative, since
            # it's the actual path whose uniqueness we're trying to
            # ensure for other things.
            combined = "\n".join(
                [str(boot_path(source)), str(boot_path(initrd_secrets))]
            )
            combined_hash = hashlib.sha256(combined.encode("utf-8")).hexdigest()
            return BootFile(
                system_identifier=system_identifier,
                current=current,
                path=NIXOS_DIR / f"{combined_hash}-initrd.efi",
                writer=InitrdWithSecretsWriter(
                    source=source, initrd_secrets=initrd_secrets
                ),
            )

    @staticmethod
    def from_entry(
        system_identifier: SystemIdentifier, current: bool, contents: bytes
    ) -> tuple["BootFile", str]:
        contents_hash = hashlib.sha256(contents).hexdigest()
        path_prefix = f"nixos-{contents_hash}"
        path = None
        for e in os.scandir(path=BOOT_MOUNT_POINT / "loader" / "entries"):
            mat = re.fullmatch(
                rf"{re.escape(path_prefix)}(\+[0-9]+(-[0-9]+)?)?\.conf", e.name
            )
            if mat is not None:
                path = Path("loader/entries") / e.name
                break
        if path is None:
            counters = f"+{BOOT_COUNTING_TRIES}" if BOOT_COUNTING else ""
            path = Path(f"loader/entries/{path_prefix}{counters}.conf")
        return (
            BootFile(
                system_identifier=system_identifier,
                current=current,
                path=path,
                writer=ContentsWriter(contents=contents),
            ),
            f"{path_prefix}.conf",
        )


# This gets its own type alias to document that the order is very
# important. The order ensures that entry files are written after
# their respective kernel / initrd / etc.
type BootFileList = list[BootFile]


libc = ctypes.CDLL("libc.so.6")

FILE = None | int


def run(
    cmd: Sequence[str | Path], stdout: FILE = None
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, check=True, text=True, stdout=stdout, stderr=sys.stderr)


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


def write_loader_conf(default_entry_id: str | None) -> None:
    tmp = LOADER_CONF.with_suffix(".tmp")
    with tmp.open("x") as f:
        f.write(f"timeout {TIMEOUT}\n")
        if default_entry_id is None:
            # No generation matched the requested default config; fall back to
            # the newest entry as determined by Boot Loader Spec sorting.
            f.write("default nixos-*\n")
        elif BOOT_COUNTING:
            # `preferred` (systemd-boot >= 260) honours boot assessment, so a
            # generation that exhausted its boot counter is skipped and we fall
            # through to `default`. systemd-boot sorts entries with
            # tries_left == 0 to the end of the list and resolves the `default`
            # glob against that order, so `nixos-*` yields the newest entry that
            # is not bad, or a bad one only if every nixos entry is bad.
            f.write(f"preferred {default_entry_id}\n")
            f.write("default nixos-*\n")
        else:
            f.write(f"default {default_entry_id}\n")
        if not EDITOR:
            f.write("editor 0\n")
        if REBOOT_FOR_BITLOCKER:
            f.write("reboot-for-bitlocker yes\n")
        f.write(f"console-mode {CONSOLE_MODE}\n")
        f.flush()
        os.fsync(f.fileno())
    os.rename(tmp, LOADER_CONF)


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


def boot_path(file: Path) -> Path:
    store_file_path = file.resolve()
    suffix = store_file_path.name
    store_subdir = store_file_path.relative_to(STORE_DIR).parts[0]
    return NIXOS_DIR / (
        f"{suffix}.efi" if suffix == store_subdir else f"{store_subdir}-{suffix}.efi"
    )


def boot_file(
    profile: str | None,
    generation: int,
    specialisation: str | None,
    machine_id: str | None,
    bootspec: BootSpec,
    current: bool,
) -> tuple[BootFileList, str]:
    system_identifier = SystemIdentifier(profile, generation, specialisation)
    if specialisation:
        bootspec = bootspec.specialisations[specialisation]
    kernel = BootFile.from_source(system_identifier, current, bootspec.kernel)
    initrd = BootFile.from_initrd(
        system_identifier,
        current,
        bootspec.initrd,
        Path(bootspec.initrdSecrets) if bootspec.initrdSecrets is not None else None,
    )
    devicetree = None
    if bootspec.devicetree is not None:
        devicetree = BootFile.from_source(
            system_identifier, current, bootspec.devicetree
        )

    kernel_params = " ".join([f"init={bootspec.init}"] + bootspec.kernelParams)
    build_time = int(system_dir(profile, generation, specialisation).stat().st_ctime)
    build_date = datetime.datetime.fromtimestamp(build_time).strftime("%F")

    title = "{name}{profile}{specialisation}".format(
        name=DISTRO_NAME,
        profile=" [" + profile + "]" if profile else "",
        specialisation=" (%s)" % specialisation if specialisation else "",
    )
    description = f"Generation {generation} {bootspec.label}, built on {build_date}"
    boot_entry = [
        f"title {title}",
        f"version {description}",
        f"linux /{str(kernel.path)}",
        f"initrd /{str(initrd.path)}",
        f"options {kernel_params}",
        f"machine-id {machine_id}" if machine_id is not None else None,
        f"devicetree /{str(devicetree.path)}" if devicetree is not None else None,
        f"sort-key {bootspec.sortKey}",
    ]
    contents = "\n".join(filter(None, boot_entry))
    entry, bootctl_id = BootFile.from_entry(
        system_identifier, current, contents.encode("utf-8")
    )
    return (list(filter(None, [kernel, initrd, devicetree, entry])), bootctl_id)


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


def cleanup_esp() -> None:
    for path in (EFI_SYS_MOUNT_POINT / "loader" / "entries").glob("nixos*"):
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

    if not CAN_TOUCH_EFI_VARIABLES:
        bootctl_flags.append("--no-variables")

    if GRACEFUL:
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

    boot_files: BootFileList = []

    default_config = Path(args.default_config)
    default_entry_id: str | None = None

    for gen in gens:
        try:
            bootspec = get_bootspec(gen.profile, gen.generation)
            is_default = Path(bootspec.init).parent == default_config
            new_boot_files, new_bootctl_id = boot_file(
                *gen, machine_id, bootspec, current=is_default
            )
            boot_files.extend(new_boot_files)
            if is_default:
                default_entry_id = new_bootctl_id
            for specialisation_name, specialisation in bootspec.specialisations.items():
                is_default = Path(specialisation.init).parent == default_config
                new_boot_files, new_bootctl_id = boot_file(
                    gen.profile,
                    gen.generation,
                    specialisation_name,
                    machine_id,
                    bootspec,
                    current=is_default,
                )
                boot_files.extend(new_boot_files)
                if is_default:
                    default_entry_id = new_bootctl_id
        except OSError as e:
            # See https://github.com/NixOS/nixpkgs/issues/114552
            if e.errno != errno.EINVAL:
                raise
            profile = f"'{gen.profile}'" if gen.profile else "default"
            print(
                f"ignoring generation {gen.generation} of the {profile} profile "
                f"because of the following error:\n{e}",
                file=sys.stderr,
            )

    # Garbage-collect stale kernels/initrds/entries before re-populating extra
    # files, so that user-supplied extraEntries (which may also live under
    # loader/entries and start with `nixos-`) are not removed again.
    garbage_collect(boot_files)

    write_boot_files(boot_files)

    write_loader_conf(default_entry_id)

    remove_extra_files()
    run([COPY_EXTRA_FILES])

    if BOOT_MOUNT_POINT != EFI_SYS_MOUNT_POINT:
        # Cleanup any entries in ESP if xbootldrMountPoint is set.
        # If the user later unsets xbootldrMountPoint, entries in XBOOTLDR will not be cleaned up
        # automatically, as we don't have information about the mount point anymore.
        cleanup_esp()


def remove_extra_files() -> None:
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


def garbage_collect(gc_roots: BootFileList) -> None:
    # Check if a file is in the list of gc roots.
    def has_gc_root(p: Path) -> bool:
        for gc_root in gc_roots:
            gc_root_path = BOOT_MOUNT_POINT / gc_root.path
            if gc_root_path == p:
                return True
        return False

    def delete_path(e: os.DirEntry) -> None:
        if e.is_file(follow_symlinks=True) and not has_gc_root(Path(e.path)):
            os.remove(e.path)

    for e in os.scandir(BOOT_MOUNT_POINT / NIXOS_DIR):
        delete_path(e)

    for e in os.scandir(BOOT_MOUNT_POINT / "loader" / "entries"):
        match = re.fullmatch(r"nixos-.+\.conf", e.name)
        if match:
            delete_path(e)


def write_boot_files(boot_files: BootFileList) -> None:
    for boot_file in boot_files:
        boot_path = BOOT_MOUNT_POINT / boot_file.path
        try:
            boot_file.writer.write_boot_file(boot_path)
        except subprocess.CalledProcessError:
            if boot_file.current:
                print("failed to create initrd secrets!", file=sys.stderr)
                sys.exit(1)
            print(
                "warning: failed to create initrd secrets for generation "
                f"{boot_file.system_identifier.generation}, an older generation",
                file=sys.stderr,
            )
            print(
                "note: this is normal after having removed "
                "or renamed a file in `boot.initrd.secrets`",
                file=sys.stderr,
            )
        except OSError as e:
            # See https://github.com/NixOS/nixpkgs/issues/114552
            if e.errno == errno.EINVAL:
                profile = (
                    f"profile '{boot_file.system_identifier.profile}'"
                    if boot_file.system_identifier.profile
                    else "default profile"
                )
                print(
                    "ignoring {} in the list of boot entries because of the following error:\n{}".format(
                        profile, e
                    ),
                    file=sys.stderr,
                )
            else:
                raise e


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
