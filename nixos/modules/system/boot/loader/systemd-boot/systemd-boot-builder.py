#! @python3@/bin/python3 -B
import argparse
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

def copy_if_not_exists(source, dest):
    if not os.path.exists(dest):
        shutil.copyfile(source, dest)

def system_dir(profile, generation):
    if profile:
        return "/nix/var/nix/profiles/system-profiles/%s-%d-link" % (profile, generation)
    else:
        return "/nix/var/nix/profiles/system-%d-link" % (generation)

BOOT_ENTRY = """title NixOS{profile}
version Generation {generation} {description}
linux {kernel}
initrd {initrd}
options {kernel_params}
"""

# The boot loader entry for memtest86.
#
# TODO: This is hard-coded to use the 64-bit EFI app, but it could probably
# be updated to use the 32-bit EFI app on 32-bit systems.  The 32-bit EFI
# app filename is BOOTIA32.efi.
MEMTEST_BOOT_ENTRY = """title MemTest86
efi /efi/memtest86/BOOTX64.efi
"""

def write_loader_conf(profile, generation):
    with open("@efiSysMountPoint@/loader/loader.conf.tmp", 'w') as f:
        if "@timeout@" != "":
            f.write("timeout @timeout@\n")
        if profile:
            f.write("default nixos-%s-generation-%d.conf\n" % (profile, generation))
        else:
            f.write("default nixos-generation-%d.conf\n" % (generation))
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

def write_entry(profile, generation, machine_id):
    kernel = copy_from_profile(profile, generation, "kernel")
    initrd = copy_from_profile(profile, generation, "initrd")
    try:
        append_initrd_secrets = profile_path(profile, generation, "append-initrd-secrets")
        subprocess.check_call([append_initrd_secrets, "@efiSysMountPoint@%s" % (initrd)])
    except FileNotFoundError:
        pass
    if profile:
        entry_file = "@efiSysMountPoint@/loader/entries/nixos-%s-generation-%d.conf" % (profile, generation)
    else:
        entry_file = "@efiSysMountPoint@/loader/entries/nixos-generation-%d.conf" % (generation)
    generation_dir = os.readlink(system_dir(profile, generation))
    tmp_path = "%s.tmp" % (entry_file)
    kernel_params = "systemConfig=%s init=%s/init " % (generation_dir, generation_dir)

    with open("%s/kernel-params" % (generation_dir)) as params_file:
        kernel_params = kernel_params + params_file.read()
    with open(tmp_path, 'w') as f:
        f.write(BOOT_ENTRY.format(profile=" [" + profile + "]" if profile else "",
                    generation=generation,
                    kernel=kernel,
                    initrd=initrd,
                    kernel_params=kernel_params,
                    description=describe_generation(generation_dir)))
        if machine_id is not None:
            f.write("machine-id %s\n" % machine_id)
    os.rename(tmp_path, entry_file)

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

    configurationLimit = @configurationLimit@
    return [ (profile, int(line.split()[0])) for line in gen_lines ][-configurationLimit:]

def remove_old_entries(gens):
    rex_profile = re.compile("^@efiSysMountPoint@/loader/entries/nixos-(.*)-generation-.*\.conf$")
    rex_generation = re.compile("^@efiSysMountPoint@/loader/entries/nixos.*-generation-(.*)\.conf$")
    known_paths = []
    for gen in gens:
        known_paths.append(copy_from_profile(*gen, "kernel", True))
        known_paths.append(copy_from_profile(*gen, "initrd", True))
    for path in glob.iglob("@efiSysMountPoint@/loader/entries/nixos*-generation-[1-9]*.conf"):
        try:
            if rex_profile.match(path):
                prof = rex_profile.sub(r"\1", path)
            else:
                prof = "system"
            gen = int(rex_generation.sub(r"\1", path))
            if not (prof, gen) in gens:
                os.unlink(path)
        except ValueError:
            pass
    for path in glob.iglob("@efiSysMountPoint@/efi/nixos/*"):
        if not path in known_paths and not os.path.isdir(path):
            os.unlink(path)

def get_profiles():
    if os.path.isdir("/nix/var/nix/profiles/system-profiles/"):
        return [x
            for x in os.listdir("/nix/var/nix/profiles/system-profiles/")
            if not x.endswith("-link")]
    else:
        return []

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
    remove_old_entries(gens)
    for gen in gens:
        write_entry(*gen, machine_id)
        if os.readlink(system_dir(*gen)) == args.default_config:
            write_loader_conf(*gen)

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
