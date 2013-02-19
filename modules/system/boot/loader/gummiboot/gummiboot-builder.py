#! @python@/bin/python
import argparse
import shutil
import os
import errno
import subprocess
import glob
import tempfile
import errno

def copy_if_not_exists(source, dest):
    known_paths.append(dest)
    if not os.path.exists(dest):
        shutil.copyfile(source, dest)

system_dir = lambda generation: "/nix/var/nix/profiles/system-%d-link" % (generation)

def write_entry(generation, kernel, initrd):
    entry_file = "@efiSysMountPoint@/loader/entries/nixos-generation-%d.conf" % (generation)
    generation_dir = os.readlink(system_dir(generation))
    tmp_path = "%s.tmp" % (entry_file)
    kernel_params = "systemConfig=%s init=%s/init " % (generation_dir, generation_dir)
    with open("%s/kernel-params" % (generation_dir)) as params_file:
        kernel_params = kernel_params + params_file.read()
    with open(tmp_path, 'w') as f:
        print >> f, "title NixOS"
        print >> f, "version Generation %d" % (generation)
        if machine_id is not None: print >> f, "machine-id %s" % (machine_id)
        print >> f, "linux %s" % (kernel)
        print >> f, "initrd %s" % (initrd)
        print >> f, "options %s" % (kernel_params)
    os.rename(tmp_path, entry_file)

def write_loader_conf(generation):
    with open("@efiSysMountPoint@/loader/loader.conf.tmp", 'w') as f:
        if "@timeout@" != "":
            print >> f, "timeout @timeout@"
        print >> f, "default nixos-generation-%d" % (generation)
    os.rename("@efiSysMountPoint@/loader/loader.conf.tmp", "@efiSysMountPoint@/loader/loader.conf")

def copy_from_profile(generation, name):
    store_file_path = os.readlink("%s/%s" % (system_dir(generation), name))
    suffix = os.path.basename(store_file_path)
    store_dir = os.path.basename(os.path.dirname(store_file_path))
    efi_file_path = "/efi/nixos/%s-%s.efi" % (store_dir, suffix)
    copy_if_not_exists(store_file_path, "@efiSysMountPoint@%s" % (efi_file_path))
    return efi_file_path

def add_entry(generation):
    efi_kernel_path = copy_from_profile(generation, "kernel")
    efi_initrd_path = copy_from_profile(generation, "initrd")
    write_entry(generation, efi_kernel_path, efi_initrd_path)

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
        "/nix/var/nix/profiles/%s" % (profile)
        ])
    gen_lines = gen_list.split('\n')
    gen_lines.pop()
    return [ int(line.split()[0]) for line in gen_lines ]

def remove_old_entries(gens):
    slice_start = len("@efiSysMountPoint@/loader/entries/nixos-generation-")
    slice_end = -1 * len(".conf")
    for path in glob.iglob("@efiSysMountPoint@/loader/entries/nixos-generation-[1-9][0-9]*.conf"):
        gen = int(path[slice_start:slice_end])
        if not gen in gens:
            os.unlink(path)
    for path in glob.iglob("@efiSysMountPoint@/efi/nixos/*"):
        if not path in known_paths:
            os.unlink(path)

def update_gummiboot():
    mkdir_p("@efiSysMountPoint@/efi/gummiboot")
    store_file_path = "@gummiboot@/bin/gummiboot.efi"
    store_dir = os.path.basename("@gummiboot@")
    efi_file_path = "/efi/gummiboot/%s-gummiboot.efi" % (store_dir)
    copy_if_not_exists(store_file_path, "@efiSysMountPoint@%s" % (efi_file_path))
    return efi_file_path

def update_efibootmgr(path):
    subprocess.call(["@kmod@/sbin/modprobe", "efivars"])
    post_efibootmgr = """
@postEfiBootMgrCommands@
    """
    efibootmgr_entries = subprocess.check_output(["@efibootmgr@/sbin/efibootmgr"]).split("\n")
    for entry in efibootmgr_entries:
        columns = entry.split()
        if len(columns) > 2:
            if ' '.join(columns[1:3]) == "NixOS gummiboot":
                subprocess.call([
                    "@efibootmgr@/sbin/efibootmgr",
                    "-B",
                    "-b",
                    columns[0][4:8]
                    ])
    subprocess.call([
        "@efibootmgr@/sbin/efibootmgr",
        "-c",
        "-d",
        "@efiDisk@",
        "-g",
        "-l",
        path.replace("/", "\\"),
        "-L",
        "NixOS gummiboot",
        "-p",
        "@efiPartition@",
        ])
    efibootmgr_entries = subprocess.check_output(["@efibootmgr@/sbin/efibootmgr"]).split("\n")
    for entry in efibootmgr_entries:
        columns = entry.split()
        if len(columns) > 1 and columns[0] == "BootOrder:":
            boot_order = columns[1].split(',')
        if len(columns) > 2:
            if ' '.join(columns[1:3]) == "NixOS gummiboot":
                bootnum = columns[0][4:8]
                if not bootnum in boot_order:
                    boot_order.insert(0, bootnum)
                    with open("/dev/null", 'w') as dev_null:
                        subprocess.call([
                            "@efibootmgr@/sbin/efibootmgr",
                            "-o",
                            ','.join(boot_order)
                            ], stdout=dev_null)
    subprocess.call(post_efibootmgr, shell=True)

parser = argparse.ArgumentParser(description='Update NixOS-related gummiboot files')
parser.add_argument('default_config', metavar='DEFAULT-CONFIG', help='The default NixOS config to boot')
args = parser.parse_args()

known_paths = []
mkdir_p("@efiSysMountPoint@/efi/nixos")
mkdir_p("@efiSysMountPoint@/loader/entries")
try:
    with open("/etc/machine-id") as machine_file:
        machine_id = machine_file.readlines()[0]
except IOError as e:
    if e.errno != errno.ENOENT:
        raise
    machine_id = None

gens = get_generations("system")
for gen in gens:
    add_entry(gen)
    if os.readlink(system_dir(gen)) == args.default_config:
        write_loader_conf(gen)

remove_old_entries(gens)

# We deserve our own env var!
if os.getenv("NIXOS_INSTALL_GRUB") == "1":
    gummiboot_path = update_gummiboot()
    if "@runEfibootmgr@" == "1":
        update_efibootmgr(gummiboot_path)
