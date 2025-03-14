#!@python3@/bin/python3 -B

from dataclasses import dataclass
from typing import Any, Callable, Dict, List, Optional, Tuple

import datetime
import hashlib
import json
import os
import psutil
import re
import shutil
import subprocess
import sys
import tempfile
import textwrap


limine_dir = None
can_use_direct_paths = False
install_config = json.load(open('@configPath@', 'r'))


def config(*path: List[str]) -> Optional[Any]:
    result = install_config
    for component in path:
        result = result[component]
    return result


def get_system_path(profile: str = 'system', gen: Optional[str] = None, spec: Optional[str] = None) -> str:
    if profile == 'system':
        result = os.path.join('/nix', 'var', 'nix', 'profiles', 'system')
    else:
        result = os.path.join('/nix', 'var', 'nix', 'profiles', 'system-profiles', profile + f'-{gen}-link' if gen is not None else '')

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
    for name, _ in config('luksDevices').items():
        if os.readlink(os.path.join('/dev/mapper', name)) == os.readlink(device):
            return True

    return False


def is_fs_type_supported(fs_type: str) -> bool:
    return fs_type.startswith('vfat')


def get_copied_path_uri(path: str, target: str) -> str:
    result = ''

    package_id = os.path.basename(os.path.dirname(path))
    suffix = os.path.basename(path)
    dest_file = f'{package_id}-{suffix}'
    dest_path = os.path.join(limine_dir, target, dest_file)

    if not os.path.exists(dest_path):
        copy_file(path, dest_path)

    path_with_prefix = os.path.join('/limine', target, dest_file)
    result = f'boot():{path_with_prefix}'

    if config('validateChecksums'):
        with open(path, 'rb') as file:
            b2sum = hashlib.blake2b()
            b2sum.update(file.read())

            result += f'#{b2sum.hexdigest()}'

    return result


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


def config_entry(levels: int, bootspec: BootSpec, label: str, time: str) -> str:
    entry = '/' * levels + label + '\n'
    entry += 'protocol: linux\n'
    entry += f'comment: {bootspec.label}, built on {time}\n'
    entry += 'kernel_path: ' + get_kernel_uri(bootspec.kernel) + '\n'
    entry += 'cmdline: ' + ' '.join(['init=' + bootspec.init] + bootspec.kernelParams).strip() + '\n'
    if bootspec.initrd:
        entry += f'module_path: ' + get_kernel_uri(bootspec.initrd) + '\n'

    if bootspec.initrdSecrets:
        initrd_secrets_path = limine_dir + '/kernels/' + os.path.basename(toplevel) + '-secrets'
        os.makedirs(initrd_secrets_path)

        old_umask = os.umask()
        os.umask(0o137)
        initrd_secrets_path_temp = tempfile.mktemp(os.path.basename(toplevel) + '-secrets')

        if os.system(bootspec.initrdSecrets + " " + initrd_secrets_path_temp) != 0:
            print(f'warning: failed to create initrd secrets for "{label}"', file=sys.stderr)
            print(f'note: if this is an older generation there is nothing to worry about')

        if os.path.exists(initrd_secrets_path_temp):
            copy_file(initrd_secrets_path_temp, initrd_secrets_path)
            os.unlink(initrd_secrets_path_temp)
            entry += 'module_path: ' + get_kernel_uri(initrd_secrets_path) + '\n'

        os.umask(old_umask)
    return entry


def generate_config_entry(profile: str, gen: str) -> str:
    time = datetime.datetime.fromtimestamp(os.stat(get_system_path(profile,gen), follow_symlinks=False).st_mtime).strftime("%F %H:%M:%S")
    boot_json = json.load(open(os.path.join(get_system_path(profile, gen), 'boot.json'), 'r'))
    boot_spec = bootjson_to_bootspec(boot_json)

    entry = config_entry(2, boot_spec, f'Generation {gen}', time)
    for spec in boot_spec.specialisations:
        entry += config_entry(2, boot_spec, f'Generation {gen}, Specialisation {spec}', str(time))
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

    shutil.copyfile(from_path, to_path)

def option_from_config(name: str, config_path: List[str], conversion: Callable[[str], str] | None = None) -> str:
    if config(*config_path):
        return f'{name}: {conversion(config(*config_path)) if conversion else config(*config_path)}\n'
    return ''


def main():
    global limine_dir

    boot_fs = None

    for mount_point, fs in config('fileSystems').items():
        if mount_point == '/boot':
            boot_fs = fs

    if config('efiSupport'):
        limine_dir = os.path.join(config('efiMountPoint'), 'limine')
    elif boot_fs and is_fs_type_supported(boot_fs['fsType']) and not is_encrypted(boot_fs['device']):
        limine_dir = '/boot/limine'
    else:
        possible_causes = []
        if not boot_fs:
            possible_causes.append(f'/limine on the boot partition (not present)')
        else:
            is_boot_fs_type_ok = is_fs_type_supported(boot_fs['fsType'])
            is_boot_fs_encrypted = is_encrypted(boot_fs['device'])
            possible_causes.append(f'/limine on the boot partition ({is_boot_fs_type_ok=} {is_boot_fs_encrypted=})')

        causes_str = textwrap.indent('\n'.join(possible_causes), '  - ')

        raise Exception(textwrap.dedent('''
            Could not find a valid place for Limine configuration files!'
            Possible candidates that were ruled out:
        ''') + causes_str + textwrap.dedent('''
            Limine cannot be installed on a system without an unencrypted
            partition formatted as FAT.
        '''))

    if not os.path.exists(limine_dir):
        os.makedirs(limine_dir)

    if os.path.exists(os.path.join(limine_dir, 'kernels')):
        print(f'nuking {os.path.join(limine_dir, "kernels")}')
        shutil.rmtree(os.path.join(limine_dir, 'kernels'))

    os.makedirs(os.path.join(limine_dir, "kernels"))

    profiles = [('system', get_gens())]

    for profile in get_profiles():
        profiles += (profile, get_gens(profile))

    timeout = config('timeout')
    editor_enabled = 'yes' if config('enableEditor') else 'no'
    hash_mismatch_panic = 'yes' if config('panicOnChecksumMismatch') else 'no'

    config_file = config('extraConfig') + '\n'
    config_file += textwrap.dedent(f'''
        timeout: {timeout}
        editor_enabled: {editor_enabled}
        hash_mismatch_panic: {hash_mismatch_panic}
        graphics: yes
        default_entry: 2
    ''')

    if os.path.exists(os.path.join(limine_dir, 'wallpapers')):
        print(f'nuking {os.path.join(limine_dir, "wallpapers")}')
        shutil.rmtree(os.path.join(limine_dir, 'wallpapers'))

    if len(config('style', 'wallpapers')) > 0:
        os.makedirs(os.path.join(limine_dir, 'wallpapers'))

    for wallpaper in config('style', 'wallpapers'):
        config_file += f'''wallpaper: {get_copied_path_uri(wallpaper, 'wallpapers')}\n'''

    config_file += option_from_config('wallpaper_style', ['style', 'wallpaperStyle'])
    config_file += option_from_config('backdrop', ['style', 'backdrop'])

    config_file += option_from_config('interface_resolution', ['style', 'interface', 'resolution'])
    config_file += option_from_config('interface_branding', ['style', 'interface', 'branding'])
    config_file += option_from_config('interface_branding_colour', ['style', 'interface', 'brandingColor'])
    config_file += option_from_config('interface_help_hidden', ['style', 'interface', 'helpHidden'])
    config_file += option_from_config('term_font_scale', ['style', 'graphicalTerminal', 'font', 'scale'])
    config_file += option_from_config('term_font_spacing', ['style', 'graphicalTerminal', 'font', 'spacing'])
    config_file += option_from_config('term_palette', ['style', 'graphicalTerminal', 'palette'])
    config_file += option_from_config('term_palette_bright', ['style', 'graphicalTerminal', 'brightPalette'])
    config_file += option_from_config('term_foreground', ['style', 'graphicalTerminal', 'foreground'])
    config_file += option_from_config('term_background', ['style', 'graphicalTerminal', 'background'])
    config_file += option_from_config('term_foreground_bright', ['style', 'graphicalTerminal', 'brightForeground'])
    config_file += option_from_config('term_background_bright', ['style', 'graphicalTerminal', 'brightBackground'])
    config_file += option_from_config('term_margin', ['style', 'graphicalTerminal', 'margin'])
    config_file += option_from_config('term_margin_gradient', ['style', 'graphicalTerminal', 'marginGradient'])

    config_file += textwrap.dedent('''
        # NixOS boot entries start here
    ''')

    for (profile, gens) in profiles:
        group_name = 'default profile' if profile == 'system' else f"profile '{profile}'"
        config_file += f'/+NixOS {group_name}\n'

        for gen in sorted(gens, key=lambda x: x, reverse=True):
            config_file += generate_config_entry(profile, gen)

    config_file_path = os.path.join(limine_dir, 'limine.conf')
    config_file += '\n# NixOS boot entries end here\n\n'

    config_file += config('extraEntries')

    with open(config_file_path, 'w') as file:
        file.truncate()
        file.write(config_file.strip())

    for dest_path, source_path in config('additionalFiles').items():
        dest_path = os.path.join(limine_dir, dest_path)

        copy_file(source_path, dest_path)

    limine_binary = os.path.join(config('liminePath'), 'bin', 'limine')
    cpu_family = config('hostArchitecture', 'family')
    if config('efiSupport'):
        if cpu_family == 'x86':
            if config('hostArchitecture', 'bits') == 32:
                boot_file = 'BOOTIA32.EFI'
            elif config('hostArchitecture', 'bits') == 64:
                boot_file = 'BOOTX64.EFI'
        elif cpu_family == 'arm':
            if config('hostArchitecture', 'arch') == 'armv8-a' and config('hostArchitecture', 'bits') == 64:
                boot_file = 'BOOTAA64.EFI'
            else:
                raise Exception(f'Unsupported CPU arch: {config("hostArchitecture", "arch")}')
        else:
            raise Exception(f'Unsupported CPU family: {cpu_family}')

        efi_path = os.path.join(config('liminePath'), 'share', 'limine', boot_file)
        dest_path = os.path.join(config('efiMountPoint'), 'efi', 'boot' if config('efiRemovable') else 'limine', boot_file)

        copy_file(efi_path, dest_path)

        if config('enrollConfig'):
            b2sum = hashlib.blake2b()
            b2sum.update(config_file.strip().encode())
            try:
                subprocess.run([limine_binary, 'enroll-config', dest_path, b2sum.hexdigest()])
            except:
                print('error: failed to enroll limine config.', file=sys.stderr)
                sys.exit(1)

        if not config('efiRemovable') and not config('canTouchEfiVariables'):
            print('warning: boot.loader.efi.canTouchEfiVariables is set to false while boot.loader.limine.efiInstallAsRemovable.\n  This may render the system unbootable.')

        if config('canTouchEfiVariables'):
            if config('efiRemovable'):
                print('note: boot.loader.limine.efiInstallAsRemovable is true, no need to add EFI entry.')
            else:
                efibootmgr = os.path.join(config('efiBootMgrPath'), 'bin', 'efibootmgr')
                efi_partition = find_mounted_device(config('efiMountPoint'))
                efi_disk = find_disk_device(efi_partition)
                efibootmgr_output = subprocess.check_output([
                    efibootmgr,
                    '-c',
                    '-d', efi_disk,
                    '-p', efi_partition.removeprefix(efi_disk).removeprefix('p'),
                    '-l', f'\\efi\\limine\\{boot_file}',
                    '-L', 'Limine',
                ], stderr=subprocess.STDOUT, universal_newlines=True)

                for line in efibootmgr_output.split('\n'):
                    if matches := re.findall(r'Boot([0-9a-fA-F]{4}) has same label Limine', line):
                        subprocess.run(
                            [efibootmgr, '-b', matches[0], '-B'],
                            stdout=subprocess.DEVNULL,
                            stderr=subprocess.DEVNULL,
                        )
    if config('biosSupport'):
        if cpu_family != 'x86':
            raise Exception(f'Unsupported CPU family for BIOS install: {cpu_family}')

        limine_sys = os.path.join(config('liminePath'), 'share', 'limine', 'limine-bios.sys')
        limine_sys_dest = os.path.join(limine_dir, 'limine-bios.sys')

        copy_file(limine_sys, limine_sys_dest)

        device = config('biosDevice')

        if device == 'nodev':
            print("note: boot.loader.limine.biosSupport is set, but device is set to nodev, only the stage 2 bootloader will be installed.", file=sys.stderr)
            return
        else:
            limine_deploy_args = [limine_binary, 'bios-install', device]

        if config('partitionIndex'):
            limine_deploy_args.append(str(config('partitionIndex')))

        if config('forceMbr'):
            limine_deploy_args += '--force-mbr'

        try:
            subprocess.run(limine_deploy_args)
        except:
            raise Exception(
                'Failed to deploy BIOS stage 1 Limine bootloader!\n' +
                'You might want to try enabling the `boot.loader.limine.forceMbr` option.')

main()
