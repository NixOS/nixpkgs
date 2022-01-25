#! @python3@/bin/python3 -B

from argparse import ArgumentParser
from datetime import datetime

import glob
import re

import os
from shutil import copyfile
from ctypes import CDLL

syncfs = CDLL("libc.so.6").syncfs

import subprocess

from sys import stderr
from warnings import warn

from typing import NamedTuple, Optional

class SystemIdentifier(NamedTuple):
    profile: Optional[str]
    generation: int
    specialisation: Optional[str]


def profile_path(profile: Optional[str]) -> str:
    return "/nix/var/nix/profiles/" + (f"system-profiles/{profile}" if profile else "system")

def system_dir(gen: SystemIdentifier) -> str:
    generation_dir = f"{profile_path(gen.profile)}-{gen.generation}-link"
    return f"{generation_dir}/specialisation/{gen.specialisation}" if gen.specialisation else generation_dir

BOOT_ENTRY = """title NixOS{profile}{specialisation}
version Generation {generation} {description}
linux {kernel}
initrd {initrd}
options {kernel_params}
"""

def generation_conf_filename(gen: SystemIdentifier) -> str:
    pieces = [
        "nixos",
        gen.profile,
        "generation",
        str(gen.generation),
        f"specialisation-{gen.specialisation}" if gen.specialisation else None,
    ]
    return "-".join(p for p in pieces if p) + ".conf"


def write_loader_conf(gen: SystemIdentifier) -> None:
    with open("@efiSysMountPoint@/loader/loader.conf.tmp", "w") as f:
        if "@timeout@" != "":
            f.write("timeout @timeout@\n")
        f.write(f"default {generation_conf_filename(gen)}\n")
        if not @editor@:
            f.write("editor 0\n")
        f.write("console-mode @consoleMode@\n")
    os.rename("@efiSysMountPoint@/loader/loader.conf.tmp", "@efiSysMountPoint@/loader/loader.conf")


def copy_from_profile(gen: SystemIdentifier, name: str, dry_run: bool = False) -> str:
    store_file_path = os.path.realpath(f"{system_dir(gen)}/{name}")
    suffix = os.path.basename(store_file_path)
    store_dir = os.path.basename(os.path.dirname(store_file_path))
    efi_file_path = f"/efi/nixos/{store_dir}-{suffix}.efi"
    if not dry_run and not os.path.exists(f"@efiSysMountPoint@{efi_file_path}"):
        copyfile(store_file_path, f"@efiSysMountPoint@{efi_file_path}")
    return efi_file_path


def describe_generation(generation_dir: str) -> str:
    try:
        with open(f"{generation_dir}/nixos-version") as f:
            nixos_version = f.read()
    except IOError:
        nixos_version = "Unknown"

    kernel_dir = os.path.dirname(os.path.realpath(f"{generation_dir}/kernel"))
    module_dir = glob.glob(fr"{kernel_dir}/lib/modules/*")[0]
    kernel_version = os.path.basename(module_dir)

    build_time = int(os.path.getctime(generation_dir))
    build_date = datetime.fromtimestamp(build_time).strftime("%F")

    return f"NixOS {nixos_version}, Linux Kernel {kernel_version}, Built on {build_date}"


def write_entry(gen: SystemIdentifier, machine_id: str) -> None:
    kernel = copy_from_profile(gen, "kernel")
    initrd = copy_from_profile(gen, "initrd")
    try:
        append_initrd_secrets = os.path.realpath(f"{system_dir(gen)}/append-initrd-secrets")
        subprocess.check_call([append_initrd_secrets, f"@efiSysMountPoint@{initrd}"])
    except FileNotFoundError:
        pass
    entry_file = f"@efiSysMountPoint@/loader/entries/{generation_conf_filename(gen)}"
    generation_dir = os.readlink(system_dir(gen))
    tmp_path = f"{entry_file}.tmp"
    kernel_params = f"init={generation_dir}/init "

    with open(f"{generation_dir}/kernel-params") as params_file:
        kernel_params += params_file.read()
    with open(tmp_path, "w") as f:
        f.write(BOOT_ENTRY.format(
            profile=f" [{gen.profile}]" if gen.profile else "",
            specialisation=f" ({gen.specialisation})" if gen.specialisation else "",
            generation=gen.generation,
            kernel=kernel,
            initrd=initrd,
            kernel_params=kernel_params,
            description=describe_generation(generation_dir)))
        if machine_id is not None:
            f.write(f"machine-id {machine_id}\n")
    os.rename(tmp_path, entry_file)


def get_generations(profile: Optional[str] = None) -> list[SystemIdentifier]:
    gen_list = subprocess.check_output([
        "@nix@/bin/nix-env",
        "--list-generations",
        "-p",
        profile_path(profile),
        "--option", "build-users-group", ""],
        universal_newlines=True)
    gen_lines = gen_list.split("\n")
    gen_lines.pop()

    configuration_limit = @configurationLimit@
    configurations = [SystemIdentifier(profile, int(line.split()[0]), None) for line in gen_lines]
    return configurations[-configuration_limit:]


def get_specialisations(gen: SystemIdentifier) -> list[SystemIdentifier]:
    try:
        return [SystemIdentifier(gen.profile, gen.generation, spec)
            for spec in os.listdir(f"{system_dir(gen)}/specialisation")]
    except OSError:
        return []


def remove_old_entries(gens: list[SystemIdentifier]) -> None:
    rex_profile = re.compile(r"^@efiSysMountPoint@/loader/entries/nixos-(.*)-generation-.*\.conf$")
    rex_generation = re.compile(r"^@efiSysMountPoint@/loader/entries/nixos.*-generation-(.*)\.conf$")
    known_paths = []
    for gen in gens:
        known_paths.append(copy_from_profile(gen, "kernel", True))
        known_paths.append(copy_from_profile(gen, "initrd", True))
    for path in glob.iglob(r"@efiSysMountPoint@/loader/entries/nixos*-generation-[1-9]*.conf"):
        try:
            prof = rex_profile.sub(r"\1", path) if rex_profile.match(path) else "system"
            gen_number = int(rex_generation.sub(r"\1", path))
            if not (prof, gen_number) in gens:
                os.unlink(path)
        except ValueError:
            pass
    for path in glob.iglob(r"@efiSysMountPoint@/efi/nixos/*"):
        if not path in known_paths and not os.path.isdir(path):
            os.unlink(path)


def get_profiles() -> list[str]:
    try:
        return [generation_dir
            for generation_dir in os.listdir("/nix/var/nix/profiles/system-profiles/")
            if not generation_dir.endswith("-link")]
    except OSError:
        return []


def main() -> None:
    parser = ArgumentParser(description="Update NixOS-related systemd-boot files")
    parser.add_argument("default_config", metavar="DEFAULT-CONFIG", help="The default NixOS config to boot")
    args = parser.parse_args()

    try:
        with open("/etc/machine-id") as machine_file:
            machine_id = machine_file.readlines()[0]
    except FileNotFoundError:
        # Since systemd version 232 a machine ID is required and it might not
        # be there on newly installed systems, so let's generate one so that
        # bootctl can find it and we can also pass it to write_entry() later.
        cmd = ["@systemd@/bin/systemd-machine-id-setup", "--print"]
        machine_id = subprocess.run(cmd, text=True, check=True, stdout=subprocess.PIPE).stdout.rstrip()

    if os.getenv("NIXOS_INSTALL_GRUB") == "1":
        warn("NIXOS_INSTALL_GRUB env var deprecated, use NIXOS_INSTALL_BOOTLOADER", DeprecationWarning)
        os.environ["NIXOS_INSTALL_BOOTLOADER"] = "1"

    if os.getenv("NIXOS_INSTALL_BOOTLOADER") == "1":
        # bootctl uses fopen() with modes "wxe" and fails if the file exists.
        if os.path.exists("@efiSysMountPoint@/loader/loader.conf"):
            os.unlink("@efiSysMountPoint@/loader/loader.conf")

        flags = []

        if "@canTouchEfiVariables@" != "1":
            flags.append("--no-variables")

        if "@graceful@" == "1":
            flags.append("--graceful")

        subprocess.check_call(["@systemd@/bin/bootctl", "--path=@efiSysMountPoint@"] + flags + ["install"])
    else:
        # Update bootloader to latest if needed
        systemd_version = subprocess.check_output(["@systemd@/bin/bootctl", "--version"], universal_newlines=True).split()[2]
        sdboot_status = subprocess.check_output(["@systemd@/bin/bootctl", "--path=@efiSysMountPoint@", "status"], universal_newlines=True)

        # See status_binaries() in systemd bootctl.c for code which generates this
        m = re.search(r"^\W+File:.*/EFI/(BOOT|systemd)/.*\.efi \(systemd-boot ([\d.]+[^)]*)\)$",
                      sdboot_status, re.IGNORECASE | re.MULTILINE)

        needs_install = False

        if m is None:
            print("could not find any previously installed systemd-boot, installing.")
            # Let systemd-boot attempt an installation if a previous one wasn't found
            needs_install = True
        else:
            sdboot_version = f"({m.group(2)})"
            if systemd_version != sdboot_version:
                print(f"updating systemd-boot from {sdboot_version} to {systemd_version}")
                needs_install = True

        if needs_install:
            subprocess.check_call(["@systemd@/bin/bootctl", "--path=@efiSysMountPoint@", "update"])

    os.makedirs("@efiSysMountPoint@/efi/nixos", exist_ok=True)
    os.makedirs("@efiSysMountPoint@/loader/entries", exist_ok=True)

    gens = get_generations()
    for profile in get_profiles():
        gens += get_generations(profile)
    remove_old_entries(gens)
    for gen in gens:
        try:
            write_entry(gen, machine_id)
            for specialisation in get_specialisations(gen):
                write_entry(specialisation, machine_id)
            if os.readlink(system_dir(gen)) == args.default_config:
                write_loader_conf(gen)
        except OSError as e:
            profile = f"profile '{gen.profile}'" if gen.profile else "default profile"
            print(f"ignoring {profile} in the list of boot entries because of the following error:", e, sep="\n", file=stderr)

    for root, _, files in os.walk("@efiSysMountPoint@/efi/nixos/.extra-files", topdown=False):
        relative_root = root.removeprefix("@efiSysMountPoint@/efi/nixos/.extra-files").removeprefix("/")
        actual_root = f"@efiSysMountPoint@/{relative_root}"

        for file in files:
            actual_file = f"{actual_root}/{file}"

            if os.path.exists(actual_file):
                os.unlink(actual_file)
            os.unlink(f"{root}/{file}")

        if not os.listdir(actual_root):
            os.rmdir(actual_root)
        os.rmdir(root)

    os.makedirs("@efiSysMountPoint@/efi/nixos/.extra-files", exist_ok=True)

    subprocess.check_call("@copyExtraFiles@")

    # Since fat32 provides little recovery facilities after a crash,
    # it can leave the system in an unbootable state, when a crash/outage
    # happens shortly after an update. To decrease the likelihood of this
    # event sync the efi filesystem after each update.
    rc = syncfs(os.open("@efiSysMountPoint@", os.O_RDONLY))
    if rc != 0:
        print("could not sync @efiSysMountPoint@:", os.strerror(rc), file=stderr)


if __name__ == "__main__":
    main()
