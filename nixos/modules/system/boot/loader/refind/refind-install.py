#!@python3@/bin/python3 -B

from dataclasses import dataclass
from typing import Any, Callable, Dict, List, Optional, Tuple

import datetime
import json
from ctypes import CDLL
import os
import psutil
import re
import shutil
import subprocess
import textwrap


refind_dir = None
libc = CDLL("libc.so.6")
install_config = json.load(open('@configPath@', 'r'))


def config(*path: str) -> Optional[Any]:
    result = install_config
    for component in path:
        result = result[component]
    return result


def get_system_path(profile: str = 'system', gen: Optional[str] = None, spec: Optional[str] = None) -> str:
    basename = f'{profile}-{gen}-link' if gen is not None else profile
    profiles_dir = '/nix/var/nix/profiles'
    if profile == 'system':
        result = os.path.join(profiles_dir, basename)
    else:
        result = os.path.join(profiles_dir, 'system-profiles', basename)

    if spec is not None:
        result = os.path.join(result, 'specialisation', spec)

    return result


def get_profiles() -> List[str]:
    profiles_dir = '/nix/var/nix/profiles/system-profiles/'
    dirs = os.listdir(profiles_dir) if os.path.isdir(profiles_dir) else []

    return [path for path in dirs if not path.endswith('-link')]


def get_gens(profile: str = 'system') -> List[Tuple[int, List[str]]]:
    nix_env = os.path.join(config('nixPath'), 'bin', 'nix-env')
    output = subprocess.check_output([
        nix_env, '--list-generations',
        '-p', get_system_path(profile),
        '--option', 'build-users-group', '',
    ], universal_newlines=True)

    gen_lines = output.splitlines()
    gen_nums = [int(line.split()[0]) for line in gen_lines]

    return [gen for gen in gen_nums][-config('maxGenerations'):]


def is_encrypted(device: str) -> bool:
    for name, _ in config('luksDevices'):
        if os.readlink(os.path.join('/dev/mapper', name)) == os.readlink(device):
            return True

    return False


def is_fs_type_supported(fs_type: str) -> bool:
    return fs_type.startswith('vfat')


paths = {}

def get_copied_path_uri(path: str, target: str) -> str:
    package_id = os.path.basename(os.path.dirname(path))
    suffix = os.path.basename(path)
    dest_file = f'{package_id}-{suffix}'
    dest_path = os.path.join(refind_dir, target, dest_file)

    if not os.path.exists(dest_path):
        copy_file(path, dest_path)
    else:
        paths[dest_path] = True

    return os.path.join('/efi/refind', target, dest_file)

def get_path_uri(path: str) -> str:
    return get_copied_path_uri(path, "")


def get_file_uri(profile: str, gen: Optional[str], spec: Optional[str], name: str) -> str:
    gen_path = get_system_path(profile, gen, spec)
    path_in_store = os.path.realpath(os.path.join(gen_path, name))
    return get_path_uri(path_in_store)


def get_kernel_uri(kernel_path: str) -> str:
    return get_copied_path_uri(kernel_path, "kernels")


@dataclass
class BootSpec:
    system: str
    init: str
    kernel: str
    kernelParams: List[str]
    label: str
    toplevel: str
    specialisations: Dict[str, "BootSpec"]
    initrd: str | None = None
    initrdSecrets: str | None = None


def bootjson_to_bootspec(bootjson: dict) -> BootSpec:
    specialisations = bootjson['org.nixos.specialisation.v1']
    specialisations = {k: bootjson_to_bootspec(v) for k, v in specialisations.items()}
    return BootSpec(
        **bootjson['org.nixos.bootspec.v1'],
        specialisations=specialisations,
    )


def config_entry(is_sub: bool, bootspec: BootSpec, label: str, time: str) -> str:
    entry = ""
    if is_sub:
        entry += 'sub'

    entry += f'menuentry "{label}" {{\n'
    entry += '  loader ' + get_kernel_uri(bootspec.kernel) + '\n'

    if bootspec.initrd:
        entry += '  initrd ' + get_kernel_uri(bootspec.initrd) + '\n'

    entry += '  options "' + ' '.join(['init=' + bootspec.init] + bootspec.kernelParams).strip() + '"\n'
    entry += '}\n'
    return entry


def generate_config_entry(profile: str, gen: str, special: bool, group_name: str) -> str:
    time = datetime.datetime.fromtimestamp(os.stat(get_system_path(profile,gen), follow_symlinks=False).st_mtime).strftime("%F %H:%M:%S")
    boot_json = json.load(open(os.path.join(get_system_path(profile, gen), 'boot.json'), 'r'))
    boot_spec = bootjson_to_bootspec(boot_json)

    specialisation_list = boot_spec.specialisations.items()
    entry = ""

    if len(specialisation_list) > 0:
        entry += f'menuentry "NixOS {group_name} Generation {gen}" {{\n'
        entry += config_entry(True, boot_spec, f'Default', str(time))

        for spec, spec_boot_spec in specialisation_list:
            entry += config_entry(True, spec_boot_spec, f'{spec}', str(time))

        entry += '}\n'
    else:
        entry += config_entry(False, boot_spec, f'NixOS {group_name} Generation {gen}', str(time))
    return entry


def find_disk_device(part: str) -> str:
    part = os.path.realpath(part)
    part = part.removeprefix('/dev/')
    disk = os.path.realpath(os.path.join('/sys', 'class', 'block', part))
    disk = os.path.dirname(disk)

    return os.path.join('/dev', os.path.basename(disk))


def find_mounted_device(path: str) -> str:
    path = os.path.abspath(path)

    while not os.path.ismount(path):
        path = os.path.dirname(path)

    devices = [x for x in psutil.disk_partitions() if x.mountpoint == path]

    assert len(devices) == 1
    return devices[0].device


def copy_file(from_path: str, to_path: str):
    dirname = os.path.dirname(to_path)

    if not os.path.exists(dirname):
        os.makedirs(dirname)

    shutil.copyfile(from_path, to_path + ".tmp")
    os.rename(to_path + ".tmp", to_path)

    paths[to_path] = True


def install_bootloader() -> None:
    global refind_dir

    refind_dir = os.path.join(str(config('efiMountPoint')), 'efi', 'refind')

    if not os.path.exists(refind_dir):
        os.makedirs(refind_dir)
    else:
        for dir, dirs, files in os.walk(refind_dir, topdown=True):
            for file in files:
                paths[os.path.join(dir, file)] = False

    profiles = [('system', get_gens())]

    for profile in get_profiles():
        profiles += [(profile, get_gens(profile))]

    timeout = config('timeout')

    last_gen = get_gens()[-1]
    last_gen_json = json.load(open(os.path.join(get_system_path('system', last_gen), 'boot.json'), 'r'))
    last_gen_boot_spec = bootjson_to_bootspec(last_gen_json)

    config_file = str(config('extraConfig')) + '\n'
    config_file += textwrap.dedent(f'''
        timeout {timeout}
        default_selection {3 if len(last_gen_boot_spec.specialisations.items()) > 0 else 2}
    ''')

    config_file += textwrap.dedent('''
        # NixOS boot entries start here
    ''')

    for (profile, gens) in profiles:
        group_name = 'default profile' if profile == 'system' else f"profile '{profile}'"
        isFirst = True

        for gen in sorted(gens, key=lambda x: x, reverse=True):
            config_file += generate_config_entry(profile, gen, isFirst, group_name)
            isFirst = False

    config_file_path = os.path.join(refind_dir, 'refind.conf')
    config_file += '\n# NixOS boot entries end here\n\n'

    with open(f"{config_file_path}.tmp", 'w') as file:
        file.truncate()
        file.write(config_file.strip())
        file.flush()
        os.fsync(file.fileno())
    os.rename(f"{config_file_path}.tmp", config_file_path)

    paths[config_file_path] = True

    for dest_path, source_path in config('additionalFiles').items():
        dest_path = os.path.join(refind_dir, dest_path)

        copy_file(source_path, dest_path)

    cpu_family = config('hostArchitecture', 'family')
    if cpu_family == 'x86':
        if config('hostArchitecture', 'bits') == 32:
            boot_file = 'BOOTIA32.EFI'
            efi_file = 'refind_ia32.efi'
        elif config('hostArchitecture', 'bits') == 64:
            boot_file = 'BOOTX64.EFI'
            efi_file = 'refind_x64.efi'
    elif cpu_family == 'arm':
        if config('hostArchitecture', 'arch') == 'armv8-a' and config('hostArchitecture', 'bits') == 64:
            boot_file = 'BOOTAA64.EFI'
            efi_file = 'refind_aa64.efi'
        else:
            raise Exception(f'Unsupported CPU arch: {config("hostArchitecture", "arch")}')
    else:
        raise Exception(f'Unsupported CPU family: {cpu_family}')

    efi_path = os.path.join(config('refindPath'), 'share', 'refind', efi_file)
    dest_path = os.path.join(config('efiMountPoint'), 'efi', 'boot' if config('efiRemovable') else 'refind', boot_file)

    copy_file(efi_path, dest_path)

    if not config('efiRemovable') and not config('canTouchEfiVariables'):
        print('warning: boot.loader.efi.canTouchEfiVariables is set to false while boot.loader.limine.efiInstallAsRemovable.\n  This may render the system unbootable.')

    if config('canTouchEfiVariables'):
        if config('efiRemovable'):
            print('note: boot.loader.limine.efiInstallAsRemovable is true, no need to add EFI entry.')
        else:
            efibootmgr = os.path.join(str(config('efiBootMgrPath')), 'bin', 'efibootmgr')
            efi_partition = find_mounted_device(str(config('efiMountPoint')))
            efi_disk = find_disk_device(efi_partition)

            efibootmgr_output = subprocess.check_output([efibootmgr], stderr=subprocess.STDOUT, universal_newlines=True)

            # Check the output of `efibootmgr` to find if rEFInd is already installed and present in the boot record
            refind_boot_entry = None
            if matches := re.findall(r'Boot([0-9a-fA-F]{4})\*? rEFInd', efibootmgr_output):
                refind_boot_entry = matches[0]

            # If there's already a Limine entry, replace it
            if refind_boot_entry:
                boot_order = re.findall(r'BootOrder: ((?:[0-9a-fA-F]{4},?)*)', efibootmgr_output)[0]

                efibootmgr_output = subprocess.check_output([
                    efibootmgr,
                    '-b', refind_boot_entry,
                    '-B',
                ], stderr=subprocess.STDOUT, universal_newlines=True)

                efibootmgr_output = subprocess.check_output([
                    efibootmgr,
                    '-c',
                    '-b', refind_boot_entry,
                    '-d', efi_disk,
                    '-p', efi_partition.removeprefix(efi_disk).removeprefix('p'),
                    '-l', f'\\efi\\refind\\{boot_file}',
                    '-L', 'rEFInd',
                    '-o', boot_order,
                ], stderr=subprocess.STDOUT, universal_newlines=True)
            else:
                efibootmgr_output = subprocess.check_output([
                    efibootmgr,
                    '-c',
                    '-d', efi_disk,
                    '-p', efi_partition.removeprefix(efi_disk).removeprefix('p'),
                    '-l', f'\\efi\\refind\\{boot_file}',
                    '-L', 'rEFInd',
                ], stderr=subprocess.STDOUT, universal_newlines=True)

    print("removing unused boot files...")
    for path in paths:
        if not paths[path]:
            os.remove(path)


def main() -> None:
    try:
        install_bootloader()
    finally:
        # Since fat32 provides little recovery facilities after a crash,
        # it can leave the system in an unbootable state, when a crash/outage
        # happens shortly after an update. To decrease the likelihood of this
        # event sync the efi filesystem after each update.
        rc = libc.syncfs(os.open(f"{config('efiMountPoint')}", os.O_RDONLY))
        if rc != 0:
            print(f"could not sync {config('efiMountPoint')}: {os.strerror(rc)}", file=sys.stderr)

if __name__ == '__main__':
    main()
