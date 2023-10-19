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
from typing import NamedTuple


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
    with open("@efiSysMountPoint@/loader/loader.conf.tmp", 'w') as f:
        if "@timeout@" != "":
            f.write("timeout @timeout@\n")
        f.write("default %s\n" % generation_conf_filename(profile, generation, specialisation))
        if not @editor@:
            f.write("editor 0\n")
        f.write("console-mode @consoleMode@\n")
        f.flush()
        os.fsync(f.fileno())
    os.rename("@efiSysMountPoint@/loader/loader.conf.tmp", "@efiSysMountPoint@/loader/loader.conf")


def profile_path(profile: str | None, generation: int, specialisation: str | None, name: str) -> str:
    return os.path.realpath("%s/%s" % (system_dir(profile, generation, specialisation), name))


def copy_from_profile(profile: str | None, generation: int, specialisation: str | None, name: str, dry_run: bool = False) -> str:
    store_file_path = profile_path(profile, generation, specialisation, name)
    suffix = os.path.basename(store_file_path)
    store_dir = os.path.basename(os.path.dirname(store_file_path))
    efi_file_path = "/efi/nixos/%s-%s.efi" % (store_dir, suffix)
    if not dry_run:
        copy_if_not_exists(store_file_path, "@efiSysMountPoint@%s" % (efi_file_path))
    return efi_file_path


def describe_generation(profile: str | None, generation: int, specialisation: str | None) -> str:
    try:
        with open(profile_path(profile, generation, specialisation, "nixos-version")) as f:
            nixos_version = f.read()
    except IOError:
        nixos_version = "Unknown"

    kernel_dir = os.path.dirname(profile_path(profile, generation, specialisation, "kernel"))
    module_dir = glob.glob("%s/lib/modules/*" % kernel_dir)[0]
    kernel_version = os.path.basename(module_dir)

    build_time = int(os.path.getctime(system_dir(profile, generation, specialisation)))
    build_date = datetime.datetime.fromtimestamp(build_time).strftime('%F')

    description = "@distroName@ {}, Linux Kernel {}, Built on {}".format(
        nixos_version, kernel_version, build_date
    )

    return description


def write_entry(profile: str | None, generation: int, specialisation: str | None,
                machine_id: str, current: bool) -> None:
    kernel = copy_from_profile(profile, generation, specialisation, "kernel")
    initrd = copy_from_profile(profile, generation, specialisation, "initrd")

    title = "@distroName@{profile}{specialisation}".format(
        profile=" [" + profile + "]" if profile else "",
        specialisation=" (%s)" % specialisation if specialisation else "")

    try:
        append_initrd_secrets = profile_path(profile, generation, specialisation, "append-initrd-secrets")
        subprocess.check_call([append_initrd_secrets, "@efiSysMountPoint@%s" % (initrd)])
    except FileNotFoundError:
        pass
    except subprocess.CalledProcessError:
        if current:
            print("failed to create initrd secrets!", file=sys.stderr)
            sys.exit(1)
        else:
            print("warning: failed to create initrd secrets "
                  f'for "{title} - Configuration {generation}", an older generation', file=sys.stderr)
            print("note: this is normal after having removed "
                  "or renamed a file in `boot.initrd.secrets`", file=sys.stderr)
    entry_file = "@efiSysMountPoint@/loader/entries/%s" % (
        generation_conf_filename(profile, generation, specialisation))
    tmp_path = "%s.tmp" % (entry_file)
    kernel_params = "init=%s " % profile_path(profile, generation, specialisation, "init")

    with open(profile_path(profile, generation, specialisation, "kernel-params")) as params_file:
        kernel_params = kernel_params + params_file.read()
    with open(tmp_path, 'w') as f:
        f.write(BOOT_ENTRY.format(title=title,
                    generation=generation,
                    kernel=kernel,
                    initrd=initrd,
                    kernel_params=kernel_params,
                    description=describe_generation(profile, generation, specialisation)))
        if machine_id is not None:
            f.write("machine-id %s\n" % machine_id)
        f.flush()
        os.fsync(f.fileno())
    os.rename(tmp_path, entry_file)


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


def get_specialisations(profile: str | None, generation: int, _: str | None) -> list[SystemIdentifier]:
    specialisations_dir = os.path.join(
            system_dir(profile, generation, None), "specialisation")
    if not os.path.exists(specialisations_dir):
        return []
    return [SystemIdentifier(profile, generation, spec) for spec in os.listdir(specialisations_dir)]


def remove_old_entries(gens: list[SystemIdentifier]) -> None:
    rex_profile = re.compile(r"^@efiSysMountPoint@/loader/entries/nixos-(.*)-generation-.*\.conf$")
    rex_generation = re.compile(r"^@efiSysMountPoint@/loader/entries/nixos.*-generation-([0-9]+)(-specialisation-.*)?\.conf$")
    known_paths = []
    for gen in gens:
        known_paths.append(copy_from_profile(*gen, "kernel", True))
        known_paths.append(copy_from_profile(*gen, "initrd", True))
    for path in glob.iglob("@efiSysMountPoint@/loader/entries/nixos*-generation-[1-9]*.conf"):
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
    for path in glob.iglob("@efiSysMountPoint@/efi/nixos/*"):
        if not path in known_paths and not os.path.isdir(path):
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
            subprocess.check_call(["@systemd@/bin/bootctl", "--esp-path=@efiSysMountPoint@", "update"])

    os.makedirs("@efiSysMountPoint@/efi/nixos", exist_ok=True)
    os.makedirs("@efiSysMountPoint@/loader/entries", exist_ok=True)

    gens = get_generations()
    for profile in get_profiles():
        gens += get_generations(profile)
    remove_old_entries(gens)
    for gen in gens:
        try:
            is_default = os.path.dirname(profile_path(*gen, "init")) == args.default_config
            write_entry(*gen, machine_id, current=is_default)
            for specialisation in get_specialisations(*gen):
                write_entry(*specialisation, machine_id, current=is_default)
            if is_default:
                write_loader_conf(*gen)
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
