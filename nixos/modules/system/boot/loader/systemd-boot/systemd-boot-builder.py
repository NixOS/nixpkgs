#! @python3@/bin/python3
import argparse
import shutil
import os
import errno
import subprocess
import glob
import tempfile
import errno
import warnings

def copy_if_not_exists(source, dest):
    if not os.path.exists(dest):
        shutil.copyfile(source, dest)

def system_dir(generation):
    return "/nix/var/nix/profiles/system-%d-link" % (generation)

BOOT_ENTRY = """title NixOS
version Generation {generation}
linux {kernel}
initrd {initrd}
options {kernel_params}
"""

def write_loader_conf(generation):
    with open("@efiSysMountPoint@/loader/loader.conf.tmp", 'w') as f:
        if "@timeout@" != "":
            f.write("timeout @timeout@\n")
        f.write("default nixos-generation-%d\n" % generation)
        if not @editor@:
            f.write("editor 0");
    os.rename("@efiSysMountPoint@/loader/loader.conf.tmp", "@efiSysMountPoint@/loader/loader.conf")

def copy_from_profile(generation, name, dry_run=False):
    store_file_path = os.readlink("%s/%s" % (system_dir(generation), name))
    suffix = os.path.basename(store_file_path)
    store_dir = os.path.basename(os.path.dirname(store_file_path))
    efi_file_path = "/efi/nixos/%s-%s.efi" % (store_dir, suffix)
    if not dry_run:
        copy_if_not_exists(store_file_path, "@efiSysMountPoint@%s" % (efi_file_path))
    return efi_file_path

def write_entry(generation, machine_id):
    kernel = copy_from_profile(generation, "kernel")
    initrd = copy_from_profile(generation, "initrd")
    entry_file = "@efiSysMountPoint@/loader/entries/nixos-generation-%d.conf" % (generation)
    generation_dir = os.readlink(system_dir(generation))
    tmp_path = "%s.tmp" % (entry_file)
    kernel_params = "systemConfig=%s init=%s/init " % (generation_dir, generation_dir)
    with open("%s/kernel-params" % (generation_dir)) as params_file:
        kernel_params = kernel_params + params_file.read()
    with open(tmp_path, 'w') as f:
        f.write(BOOT_ENTRY.format(generation=generation,
                    kernel=kernel,
                    initrd=initrd,
                    kernel_params=kernel_params))
        if machine_id is not None:
            f.write("machine-id %s\n" % machine_id)
    os.rename(tmp_path, entry_file)

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as e:
        if e.errno != errno.EEXIST or not os.path.isdir(path):
            raise

def get_generations(profile):
    gen_list = subprocess.check_output([
        "@nix@/bin/nix-env",
        "--list-generations",
        "-p",
        "/nix/var/nix/profiles/%s" % (profile),
        "--option", "build-users-group", ""],
        universal_newlines=True)
    gen_lines = gen_list.split('\n')
    gen_lines.pop()
    return [ int(line.split()[0]) for line in gen_lines ]

def remove_old_entries(gens):
    slice_start = len("@efiSysMountPoint@/loader/entries/nixos-generation-")
    slice_end = -1 * len(".conf")
    known_paths = []
    for gen in gens:
        known_paths.append(copy_from_profile(gen, "kernel", True))
        known_paths.append(copy_from_profile(gen, "initrd", True))
    for path in glob.iglob("@efiSysMountPoint@/loader/entries/nixos-generation-[1-9]*.conf"):
        try:
            gen = int(path[slice_start:slice_end])
            if not gen in gens:
                os.unlink(path)
        except ValueError:
            pass
    for path in glob.iglob("@efiSysMountPoint@/efi/nixos/*"):
        if not path in known_paths:
            os.unlink(path)

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

    mkdir_p("@efiSysMountPoint@/efi/nixos")
    mkdir_p("@efiSysMountPoint@/loader/entries")

    gens = get_generations("system")
    remove_old_entries(gens)
    for gen in gens:
        write_entry(gen, machine_id)
        if os.readlink(system_dir(gen)) == args.default_config:
            write_loader_conf(gen)

if __name__ == '__main__':
    main()
