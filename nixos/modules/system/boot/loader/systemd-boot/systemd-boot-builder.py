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
from typing import NamedTuple, Dict, List
from dataclasses import dataclass

# These values will be replaced with actual values during the package build
EFI_SYS_MOUNT_POINT = "@efiSysMountPoint@"
BOOT_MOUNT_POINT = "@bootMountPoint@"
LOADER_CONF = f"{EFI_SYS_MOUNT_POINT}/loader/loader.conf"  # Always stored on the ESP
NIXOS_DIR = "@nixosDir@"
TIMEOUT = "@timeout@"
EDITOR = "@editor@" == "1"
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
    sortKey: str
    initrdSecrets: str | None = None


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

BOOT_ENTRY = """title {title}
sort-key {sort_key}
version Generation {generation} {description}
linux {kernel}
initrd {initrd}
options {kernel_params}
"""

def generation_conf_filename(profile: str | None, generation: int, specialisation: str | None) -> str:
    pieces = [
        "nixos",
        profile or None,
        "generation",
        str(generation),
        f"specialisation-{specialisation}" if specialisation else None,
    ]
    return "-".join(p for p in pieces if p) + ".conf"


def write_loader_conf(profile: str | None, generation: int, specialisation: str | None) -> None:
    with open(f"{LOADER_CONF}.tmp", 'w') as f:
        if TIMEOUT != "":
            f.write(f"timeout {TIMEOUT}\n")
        f.write("default %s\n" % generation_conf_filename(profile, generation, specialisation))
        if not EDITOR:
            f.write("editor 0\n")
        f.write(f"console-mode {CONSOLE_MODE}\n")
        f.flush()
        os.fsync(f.fileno())
    os.rename(f"{LOADER_CONF}.tmp", LOADER_CONF)


def get_bootspec(profile: str | None, generation: int) -> BootSpec:
    system_directory = system_dir(profile, generation, None)
    boot_json_path = os.path.realpath("%s/%s" % (system_directory, "boot.json"))
    if os.path.isfile(boot_json_path):
        boot_json_f = open(boot_json_path, 'r')
        bootspec_json = json.load(boot_json_f)
    else:
        boot_json_str = subprocess.check_output([
        f"{BOOTSPEC_TOOLS}/bin/synthesize",
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

def write_entry(profile: str | None, generation: int, specialisation: str | None,
                machine_id: str, bootspec: BootSpec, current: bool) -> None:
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
            subprocess.check_call([bootspec.initrdSecrets, f"{BOOT_MOUNT_POINT}%s" % (initrd)])
    except subprocess.CalledProcessError:
        if current:
            print("failed to create initrd secrets!", file=sys.stderr)
            sys.exit(1)
        else:
            print("warning: failed to create initrd secrets "
                  f'for "{title} - Configuration {generation}", an older generation', file=sys.stderr)
            print("note: this is normal after having removed "
                  "or renamed a file in `boot.initrd.secrets`", file=sys.stderr)
    entry_file = f"{BOOT_MOUNT_POINT}/loader/entries/%s" % (
        generation_conf_filename(profile, generation, specialisation))
    tmp_path = "%s.tmp" % (entry_file)
    kernel_params = "init=%s " % bootspec.init

    kernel_params = kernel_params + " ".join(bootspec.kernelParams)
    build_time = int(os.path.getctime(system_dir(profile, generation, specialisation)))
    build_date = datetime.datetime.fromtimestamp(build_time).strftime('%F')

    with open(tmp_path, 'w') as f:
        f.write(BOOT_ENTRY.format(title=title,
                    sort_key=bootspec.sortKey,
                    generation=generation,
                    kernel=kernel,
                    initrd=initrd,
                    kernel_params=kernel_params,
                    description=f"{bootspec.label}, built on {build_date}"))
        if machine_id is not None:
            f.write("machine-id %s\n" % machine_id)
        f.flush()
        os.fsync(f.fileno())
    os.rename(tmp_path, entry_file)


def get_generations(profile: str | None = None) -> list[SystemIdentifier]:
    gen_list = subprocess.check_output([
        f"{NIX}/bin/nix-env",
        "--list-generations",
        "-p",
        "/nix/var/nix/profiles/%s" % ("system-profiles/" + profile if profile else "system")],
        universal_newlines=True)
    gen_lines = gen_list.split('\n')
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


def remove_old_entries(gens: list[SystemIdentifier]) -> None:
    rex_profile = re.compile(r"^" + re.escape(BOOT_MOUNT_POINT) + "/loader/entries/nixos-(.*)-generation-.*\.conf$")
    rex_generation = re.compile(r"^" + re.escape(BOOT_MOUNT_POINT) + "/loader/entries/nixos.*-generation-([0-9]+)(-specialisation-.*)?\.conf$")
    known_paths = []
    for gen in gens:
        bootspec = get_bootspec(gen.profile, gen.generation)
        known_paths.append(copy_from_file(bootspec.kernel, True))
        known_paths.append(copy_from_file(bootspec.initrd, True))
    for path in glob.iglob(f"{BOOT_MOUNT_POINT}/loader/entries/nixos*-generation-[1-9]*.conf"):
        if rex_profile.match(path):
            prof = rex_profile.sub(r"\1", path)
        else:
            prof = None
        try:
            gen_number = int(rex_generation.sub(r"\1", path))
        except ValueError:
            continue
        if not (prof, gen_number, None) in gens:
            os.unlink(path)
    for path in glob.iglob(f"{BOOT_MOUNT_POINT}/{NIXOS_DIR}/*"):
        if not path in known_paths and not os.path.isdir(path):
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
            machine_id = machine_file.readlines()[0]
    except IOError as e:
        if e.errno != errno.ENOENT:
            raise
        # Since systemd version 232 a machine ID is required and it might not
        # be there on newly installed systems, so let's generate one so that
        # bootctl can find it and we can also pass it to write_entry() later.
        cmd = [f"{SYSTEMD}/bin/systemd-machine-id-setup", "--print"]
        machine_id = subprocess.run(
          cmd, text=True, check=True, stdout=subprocess.PIPE
        ).stdout.rstrip()

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

        subprocess.check_call([f"{SYSTEMD}/bin/bootctl", f"--esp-path={EFI_SYS_MOUNT_POINT}"] + bootctl_flags + ["install"])
    else:
        # Update bootloader to latest if needed
        available_out = subprocess.check_output([f"{SYSTEMD}/bin/bootctl", "--version"], universal_newlines=True).split()[2]
        installed_out = subprocess.check_output([f"{SYSTEMD}/bin/bootctl", f"--esp-path={EFI_SYS_MOUNT_POINT}", "status"], universal_newlines=True)

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
            subprocess.check_call([f"{SYSTEMD}/bin/bootctl", f"--esp-path={EFI_SYS_MOUNT_POINT}"] + bootctl_flags + ["update"])

    os.makedirs(f"{BOOT_MOUNT_POINT}/{NIXOS_DIR}", exist_ok=True)
    os.makedirs(f"{BOOT_MOUNT_POINT}/loader/entries", exist_ok=True)

    gens = get_generations()
    for profile in get_profiles():
        gens += get_generations(profile)

    remove_old_entries(gens)

    for gen in gens:
        try:
            bootspec = get_bootspec(gen.profile, gen.generation)
            is_default = os.path.dirname(bootspec.init) == args.default_config
            write_entry(*gen, machine_id, bootspec, current=is_default)
            for specialisation in bootspec.specialisations.keys():
                write_entry(gen.profile, gen.generation, specialisation, machine_id, bootspec, current=is_default)
            if is_default:
                write_loader_conf(*gen)
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

    subprocess.check_call(COPY_EXTRA_FILES)


def main() -> None:
    parser = argparse.ArgumentParser(description=f"Update {DISTRO_NAME}-related systemd-boot files")
    parser.add_argument('default_config', metavar='DEFAULT-CONFIG', help=f"The default {DISTRO_NAME} config to boot")
    args = parser.parse_args()

    subprocess.check_call(CHECK_MOUNTPOINTS)

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
