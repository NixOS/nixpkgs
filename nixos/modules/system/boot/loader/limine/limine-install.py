#!@python3@/bin/python3 -B

from dataclasses import dataclass
from typing import Any, Callable, Dict, List, Optional, Tuple

import datetime
import hashlib
import json
from ctypes import CDLL
import os
import psutil
import re
import shutil
import subprocess
import sys
import tempfile
import textwrap

@dataclass
class XenBootSpec:
    """Represent the bootspec extension for Xen dom0 kernels"""

    efiPath: str
    multibootPath: str
    params: List[str]
    version: str

@dataclass
class BootSpec:
    system: str
    init: str
    kernel: str
    kernelParams: List[str]
    label: str
    toplevel: str
    specialisations: Dict[str, "BootSpec"]
    xen: XenBootSpec | None
    initrd: str | None = None
    initrdSecrets: str | None = None

install_config = json.load(open('@configPath@', 'r'))
libc = CDLL("libc.so.6")

limine_install_dir: Optional[str] = None
can_use_direct_paths = False
paths: Dict[str, bool] = {}

def config(*path: str) -> Optional[Any]:
    result = install_config
    for component in path:
        result = result[component]
    return result


def bool_to_yes_no(value: bool) -> str:
    return 'yes' if value else 'no'


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
    nix_env = os.path.join(str(config('nixPath')), 'bin', 'nix-env')
    output = subprocess.check_output([
        nix_env, '--list-generations',
        '-p', get_system_path(profile),
        '--option', 'build-users-group', '',
    ], universal_newlines=True)

    gen_lines = output.splitlines()
    gen_nums = [int(line.split()[0]) for line in gen_lines]

    return [gen for gen in gen_nums][-config('maxGenerations'):]


def is_encrypted(device: str) -> bool:
    for name in config('luksDevices'):
        if os.readlink(os.path.join('/dev/mapper', name)) == os.readlink(device):
            return True

    return False


def is_fs_type_supported(fs_type: str) -> bool:
    return fs_type.startswith('vfat')


def get_dest_file(path: str) -> str:
    package_id = os.path.basename(os.path.dirname(path))
    suffix = os.path.basename(path)
    return f'{package_id}-{suffix}'


def get_dest_path(path: str, target: str) -> str:
    dest_file = get_dest_file(path)
    return os.path.join(str(limine_install_dir), target, dest_file)


def get_copied_path_uri(path: str, target: str) -> str:
    result = ''

    dest_file = get_dest_file(path)
    dest_path = get_dest_path(path, target)

    if not os.path.exists(dest_path):
        copy_file(path, dest_path)
    else:
        paths[dest_path] = True

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

def bootjson_to_bootspec(bootjson: dict) -> BootSpec:
    specialisations = bootjson['org.nixos.specialisation.v1']
    specialisations = {k: bootjson_to_bootspec(v) for k, v in specialisations.items()}
    xen = None
    if 'org.xenproject.bootspec.v2' in bootjson:
        xen = bootjson['org.xenproject.bootspec.v2']
    return BootSpec(
        **bootjson['org.nixos.bootspec.v1'],
        specialisations=specialisations,
        xen=xen,
    )

def generate_xen_efi_files(
        bootspec: BootSpec,
        gen: str
        ) -> str:
    """Generate a Xen EFI xen.cfg file, and copy required files in place.

    Assumes the bootspec has already been validated as having the requried
    Xen keys.

    Arguments:
    bootspec -- the NixOS BootSpec requiring Xen EFI configuration
    gen -- The system generation requiring Xen EFI configuration

    Returns the path to the Xen EFI binary
    """

    xen_efi_boot_path = get_copied_path_uri(bootspec.xen['efiPath'], f'xen/{gen}')
    xen_efi_path = get_dest_path(bootspec.xen['efiPath'], f'xen/{gen}')

    xen_efi_cfg_dir = os.path.dirname(xen_efi_path)
    xen_efi_cfg_path = xen_efi_path[:-4] + '.cfg'

    if not os.path.exists(xen_efi_cfg_dir):
        os.makedirs(xen_efi_cfg_dir)

    xen_efi_cfg = (
        f'default=nixos{gen}\n\n' +
        f'[nixos{gen}]\n'
        )
    # set xen dom0 parameters
    if 'params' in bootspec.xen and len(bootspec.xen['params']) > 0:
        xen_efi_cfg += 'options=' + ' '.join(bootspec.xen['params']).strip() + '\n'

    # set kernel and copy in-place
    xen_efi_kernel_path = get_dest_path(bootspec.kernel, f'xen/{gen}')
    copy_file(bootspec.kernel, xen_efi_kernel_path)
    xen_efi_cfg += (
        'kernel=' + os.path.basename(xen_efi_kernel_path) + ' '
        + ' '.join(['init=' + bootspec.init] + bootspec.kernelParams).strip()
        + '\n'
    )

    # set ramdisk and copy initrd in-place
    if bootspec.initrd:
        xen_efi_initrd_path = get_dest_path(bootspec.initrd, f'xen/{gen}')
        copy_file(bootspec.initrd, xen_efi_initrd_path)
        xen_efi_cfg += 'ramdisk=' + os.path.basename(xen_efi_initrd_path) + '\n'

    with open(xen_efi_cfg_path, 'w') as xen_efi_cfg_file:
        xen_efi_cfg_file.write(xen_efi_cfg)

    return xen_efi_boot_path

def xen_config_entry(
    levels: int, bootspec: BootSpec, xenVersion: str, gen: str, time: str, efi: bool
) -> str:
    """Generate EFI and BIOS entries for Xen dom0 kernels.

    Arguments:
    levels -- The number of Limine menu levels for entries
    bootspec -- The NixOS BootSpec used for generating this Limine configuration
    xenVersion -- The version of Xen the entry is generated for, from the boot extension
    gen -- The system generation these entries are generated for
    time -- The build time for the configuration
    efi -- True if EFI protocol should be used for this entry
    """
    # generate Xen menu label for the current generation
    entry = '/' * levels + f'Generation {gen} with Xen {xenVersion}' + (' EFI\n' if efi else '\n')
    entry += f'comment: Xen {xenVersion} {bootspec.label}, built on {time}\n'
    # load Xen dom0 as the executable, using multiboot for EFI & BIOS
    if (
            efi and
            'multibootPath' in bootspec.xen and
            len(bootspec.xen['multibootPath']) > 0 and
            os.path.exists(bootspec.xen['multibootPath'])
        ):
        # Use the EFI protocol and generate Xen EFI configuration
        # files and directories which are loaded by Xen's EFI binary
        # directly.
        # Ideally both EFI and BIOS booting would use multiboot2,
        # however Limine's multiboot2 module has trouble finding
        # an entry-point in Xen's multiboot binary, and multiboot1
        # doesn't work under EFI.
        # Upstream Limine issue #482
        entry += 'protocol: efi\n'
        entry += (
            'path: ' + generate_xen_efi_files(bootspec, gen) + '\n'
        )
    elif (
            'multibootPath' in bootspec.xen and
            len(bootspec.xen['multibootPath']) > 0 and
            os.path.exists(bootspec.xen['multibootPath'])
        ):
        # Use multiboot1 if not generating an EFI entry, as multiboot2
        # doesn't work under Limine for booting Xen.
        # Upstream Limine issue #483
        entry += 'protocol: multiboot\n'
        entry += (
            'path: ' + get_copied_path_uri(bootspec.xen['multibootPath'], f'xen/{gen}') + '\n'
        )
        # set params as the multiboot executable's parameters
        if 'params' in bootspec.xen and len(bootspec.xen['params']) > 0:
            # TODO: Understand why the first argument is ignored below?
            # --- to work around first argument being ignored
            entry += (
                'cmdline: -- ' + ' '.join(bootspec.xen['params']).strip() + '\n'
            )
        # load the linux kernel as the second module
        entry += 'module_path: ' + get_kernel_uri(bootspec.kernel) + '\n'
        # set kernel parameters as the parameters to the first module
        # TODO: Understand why the first argument is ignored below?
        # --- to work around first argument being ignored
        entry += (
            'module_string: -- '
            + ' '.join(['init=' + bootspec.init] + bootspec.kernelParams).strip()
            + '\n'
        )
        if bootspec.initrd:
            # the final module is the initrd
            entry += 'module_path: ' + get_kernel_uri(bootspec.initrd) + '\n'
    return entry

def config_entry(levels: int, bootspec: BootSpec, label: str, time: str) -> str:
    entry = '/' * levels + label + '\n'
    entry += 'protocol: linux\n'
    entry += f'comment: {bootspec.label}, built on {time}\n'
    entry += 'kernel_path: ' + get_kernel_uri(bootspec.kernel) + '\n'
    entry += 'cmdline: ' + ' '.join(['init=' + bootspec.init] + bootspec.kernelParams).strip() + '\n'
    if bootspec.initrd:
        entry += f'module_path: ' + get_kernel_uri(bootspec.initrd) + '\n'

    if bootspec.initrdSecrets:
        base_path = str(limine_install_dir) + '/kernels/'
        initrd_secrets_path = base_path + os.path.basename(bootspec.toplevel) + '-secrets'
        if not os.path.exists(base_path):
            os.makedirs(base_path)

        old_umask = os.umask(0o137)
        initrd_secrets_path_temp = tempfile.mktemp(os.path.basename(bootspec.toplevel) + '-secrets')

        if os.system(bootspec.initrdSecrets + " " + initrd_secrets_path_temp) != 0:
            print(f'warning: failed to create initrd secrets for "{label}"', file=sys.stderr)
            print(f'note: if this is an older generation there is nothing to worry about')

        if os.path.exists(initrd_secrets_path_temp):
            copy_file(initrd_secrets_path_temp, initrd_secrets_path)
            os.unlink(initrd_secrets_path_temp)
            entry += 'module_path: ' + get_kernel_uri(initrd_secrets_path) + '\n'

        os.umask(old_umask)
    return entry


def generate_config_entry(profile: str, gen: str, special: bool) -> str:
    time = datetime.datetime.fromtimestamp(os.stat(get_system_path(profile,gen), follow_symlinks=False).st_mtime).strftime("%F %H:%M:%S")
    boot_json = json.load(open(os.path.join(get_system_path(profile, gen), 'boot.json'), 'r'))
    boot_spec = bootjson_to_bootspec(boot_json)

    specialisation_list = boot_spec.specialisations.items()
    depth = 2
    entry = ""

    # Xen, if configured, should be listed first for each generation
    if boot_spec.xen and 'version' in boot_spec.xen:
        xen_version = boot_spec.xen['version']
        if config('efiSupport'):
            entry += xen_config_entry(2, boot_spec, xen_version, gen, time, True)
        entry += xen_config_entry(2, boot_spec, xen_version, gen, time, False)

    if len(specialisation_list) > 0:
        depth += 1
        entry += '/' * (depth-1)

        if special:
            entry += '+'

        entry += f'Generation {gen}' + '\n'
        entry += config_entry(depth, boot_spec, f'Default', str(time))
    else:
        entry += config_entry(depth, boot_spec, f'Generation {gen}', str(time))

    for spec, spec_boot_spec in specialisation_list:
        entry += config_entry(depth, spec_boot_spec, f'{spec}', str(time))

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


def option_from_config(name: str, config_path: List[str]) -> str:
    value = config(*config_path)
    if value is None:
        return ""
    if isinstance(value, bool):
        value = bool_to_yes_no(value)
    return f"{name}: {config(*config_path)}\n"


def install_bootloader() -> None:
    global limine_install_dir

    boot_fs = None

    for mount_point, fs in config('fileSystems').items():
        if mount_point == '/boot':
            boot_fs = fs

    if config('efiSupport'):
        limine_install_dir = os.path.join(str(config('efiMountPoint')), 'limine')
    elif boot_fs and is_fs_type_supported(boot_fs['fsType']) and not is_encrypted(boot_fs['device']):
        limine_install_dir = '/boot/limine'
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

    if config('secureBoot', 'enable') and not config('secureBoot', 'createAndEnrollKeys') and not os.path.exists("/var/lib/sbctl"):
        print("There are no sbctl secure boot keys present. Please generate some.")
        sys.exit(1)

    if not os.path.exists(limine_install_dir):
        os.makedirs(limine_install_dir)
    else:
        for dir, dirs, files in os.walk(limine_install_dir, topdown=True):
            for file in files:
                paths[os.path.join(dir, file)] = False

    limine_xen_dir = os.path.join(limine_install_dir, 'xen')
    if os.path.exists(limine_xen_dir):
        print(f'cleaning {limine_xen_dir}')
        shutil.rmtree(limine_xen_dir)

    os.makedirs(limine_xen_dir)

    profiles = [('system', get_gens())]

    for profile in get_profiles():
        profiles += [(profile, get_gens(profile))]

    timeout = config('timeout')
    editor_enabled = bool_to_yes_no(config('enableEditor'))
    hash_mismatch_panic = bool_to_yes_no(config('panicOnChecksumMismatch'))

    last_gen = get_gens()[-1]
    last_gen_json = json.load(open(os.path.join(get_system_path('system', last_gen), 'boot.json'), 'r'))
    last_gen_boot_spec = bootjson_to_bootspec(last_gen_json)

    config_file = str(config('extraConfig')) + '\n'
    config_file += textwrap.dedent(f'''
        timeout: {timeout}
        editor_enabled: {editor_enabled}
        hash_mismatch_panic: {hash_mismatch_panic}
        graphics: yes
        default_entry: {3 if len(last_gen_boot_spec.specialisations.items()) > 0 else 2}
    ''')

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

        isFirst = True

        for gen in sorted(gens, key=lambda x: x, reverse=True):
            config_file += generate_config_entry(profile, gen, isFirst)
            isFirst = False

    config_file_path = os.path.join(limine_install_dir, 'limine.conf')
    config_file += '\n# NixOS boot entries end here\n\n'

    config_file += str(config('extraEntries'))

    with open(f"{config_file_path}.tmp", 'w') as file:
        file.truncate()
        file.write(config_file.strip())
        file.flush()
        os.fsync(file.fileno())
    os.rename(f"{config_file_path}.tmp", config_file_path)

    paths[config_file_path] = True

    for dest_path, source_path in config('additionalFiles').items():
        dest_path = os.path.join(limine_install_dir, dest_path)

        copy_file(source_path, dest_path)

    limine_binary = os.path.join(str(config('liminePath')), 'bin', 'limine')
    cpu_family = config('hostArchitecture', 'family')
    if config('efiSupport'):
        boot_file = ""
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

        efi_path = os.path.join(str(config('liminePath')), 'share', 'limine', boot_file)
        dest_path = os.path.join(str(config('efiMountPoint')), 'efi', 'boot' if config('efiRemovable') else 'limine', boot_file)

        copy_file(efi_path, dest_path)

        if config('enrollConfig'):
            b2sum = hashlib.blake2b()
            b2sum.update(config_file.strip().encode())
            try:
                subprocess.run([limine_binary, 'enroll-config', dest_path, b2sum.hexdigest()])
            except:
                print('error: failed to enroll limine config.', file=sys.stderr)
                sys.exit(1)

        if config('secureBoot', 'enable'):
            sbctl = os.path.join(str(config('secureBoot', 'sbctl')), 'bin', 'sbctl')
            if config('secureBoot', 'createAndEnrollKeys'):
                print("TEST MODE: creating and enrolling keys")
                try:
                    subprocess.run([sbctl, 'create-keys'])
                except:
                    print('error: failed to create keys', file=sys.stderr)
                    sys.exit(1)
                try:
                    subprocess.run([sbctl, 'enroll-keys', '--yes-this-might-brick-my-machine'])
                except:
                    print('error: failed to enroll keys', file=sys.stderr)
                    sys.exit(1)

            print('signing limine...')
            try:
                subprocess.run([sbctl, 'sign', dest_path])
            except:
                print('error: failed to sign limine', file=sys.stderr)
                sys.exit(1)

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

                # Check the output of `efibootmgr` to find if limine is already installed and present in the boot record
                limine_boot_entry = None
                if matches := re.findall(r'Boot([0-9a-fA-F]{4})\*? Limine', efibootmgr_output):
                    limine_boot_entry = matches[0]

                # If there's already a Limine entry, replace it
                if limine_boot_entry:
                    boot_order = re.findall(r'BootOrder: ((?:[0-9a-fA-F]{4},?)*)', efibootmgr_output)[0]

                    efibootmgr_output = subprocess.check_output([
                        efibootmgr,
                        '-b', limine_boot_entry,
                        '-B',
                    ], stderr=subprocess.STDOUT, universal_newlines=True)

                    efibootmgr_output = subprocess.check_output([
                        efibootmgr,
                        '-c',
                        '-b', limine_boot_entry,
                        '-d', efi_disk,
                        '-p', efi_partition.removeprefix(efi_disk).removeprefix('p'),
                        '-l', f'\\efi\\limine\\{boot_file}',
                        '-L', 'Limine',
                        '-o', boot_order,
                    ], stderr=subprocess.STDOUT, universal_newlines=True)
                else:
                    efibootmgr_output = subprocess.check_output([
                        efibootmgr,
                        '-c',
                        '-d', efi_disk,
                        '-p', efi_partition.removeprefix(efi_disk).removeprefix('p'),
                        '-l', f'\\efi\\limine\\{boot_file}',
                        '-L', 'Limine',
                    ], stderr=subprocess.STDOUT, universal_newlines=True)

    if config('biosSupport'):
        if cpu_family != 'x86':
            raise Exception(f'Unsupported CPU family for BIOS install: {cpu_family}')

        limine_sys = os.path.join(str(config('liminePath')), 'share', 'limine', 'limine-bios.sys')
        limine_sys_dest = os.path.join(limine_install_dir, 'limine-bios.sys')

        copy_file(limine_sys, limine_sys_dest)

        device = str(config('biosDevice'))

        if device == 'nodev':
            print("note: boot.loader.limine.biosSupport is set, but device is set to nodev, only the stage 2 bootloader will be installed.", file=sys.stderr)
            return

        limine_deploy_args: List[str] = [limine_binary, 'bios-install', device]

        if config('partitionIndex'):
            limine_deploy_args.append(str(config('partitionIndex')))

        if config('force'):
            limine_deploy_args.append('--force')

        try:
            subprocess.run(limine_deploy_args)
        except:
            raise Exception(
                'Failed to deploy BIOS stage 1 Limine bootloader!\n' +
                'You might want to try enabling the `boot.loader.limine.force` option.')

    print("removing unused boot files...")
    for path in paths:
        if not paths[path] and os.path.exists(path):
            os.remove(path)

def main() -> None:
    try:
        install_bootloader()
    finally:
        # Since fat32 provides little recovery facilities after a crash,
        # it can leave the system in an unbootable state, when a crash/outage
        # happens shortly after an update. To decrease the likelihood of this
        # event sync the efi filesystem after each update.
        rc = libc.syncfs(os.open(f"{str(config('efiMountPoint'))}", os.O_RDONLY))
        if rc != 0:
            print(f"could not sync {str(config('efiMountPoint'))}: {os.strerror(rc)}", file=sys.stderr)

if __name__ == '__main__':
    main()
