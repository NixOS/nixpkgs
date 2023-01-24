#!@python3@/bin/python3 -B

from typing import Any, List, Optional, Tuple

import hashlib
import json
import os
import psutil
import re
import shutil
import subprocess
import textwrap


limine_dir = None
root_fs_uuid = None
can_use_direct_paths = False
install_config = json.load(open('@configPath@', 'r'))


def config(*path: List[str]) -> Optional[Any]:
  result = install_config
  for component in path:
    result = result[component]
  return result


def get_system_path(profile: str = 'system', gen: Optional[str] = None, spec: Optional[str] = None) -> str:
  if profile == 'system':
    result = '/nix/var/nix/profiles/system'
  else:
    result = f'/nix/var/nix/profiles/system-profiles/{profile}'

  if gen is not None:
    result += f'-{gen}-link'

  if spec is not None:
    result = os.path.join(result, 'specialisation', spec)

  return result


def get_profiles() -> List[str]:
  profiles_dir = '/nix/var/nix/profiles/system-profiles/'
  dirs = os.listdir(profiles_dir) if os.path.isdir(profiles_dir) else []

  return [path for path in dirs if not path.endswith('-link')]


def get_specs(profile: str, gen: Optional[str]) -> List[str]:
  gen_dir = get_system_path(profile, gen)
  spec_dir = os.path.join(gen_dir, 'specialisation')

  return os.listdir(spec_dir) if os.path.exists(spec_dir) else []


def get_gens(profile: str = 'system') -> List[Tuple[int, List[str]]]:
  nix_env = os.path.join(config('nixPath'), 'bin', 'nix-env')
  output = subprocess.check_output([
    nix_env, '--list-generations',
    '-p', get_system_path(profile),
    '--option', 'build-users-group', '',
  ], universal_newlines=True)

  gen_lines = output.splitlines()
  gen_nums = [int(line.split()[0]) for line in gen_lines]

  return [(gen, get_specs(profile, gen)) for gen in gen_nums][-config('maxGenerations'):]


def is_encrypted(device: str) -> bool:
  for name, _ in config('luksDevices').items():
    if os.readlink(f'/dev/mapper/{name}') == os.readlink(device):
      return True

  return False


def is_fs_type_supported(fs_type: str) -> bool:
  return fs_type.startswith('ext') or fs_type.startswith('vfat')


def get_file_uri(profile: str, gen: Optional[str], spec: Optional[str], name: str) -> str:
  gen_path = get_system_path(profile, gen, spec)
  path_in_store = os.path.realpath(os.path.join(gen_path, name))
  result = ''

  if can_use_direct_paths:
    result = f'uuid://{root_fs_uuid}{path_in_store}'
  else:
    package_id = os.path.basename(os.path.dirname(path_in_store))
    suffix = os.path.basename(path_in_store)
    dest_file = f'{package_id}-{suffix}'
    dest_path = os.path.join(limine_dir, dest_file)

    if not os.path.exists(dest_path):
      copy_file(path_in_store, dest_path)

    path_with_prefix = os.path.join('/limine', dest_file)
    result = f'boot://{path_with_prefix}'

  if config('validateChecksums'):
    with open(path_in_store, 'rb') as file:
      b2sum = hashlib.blake2b()
      b2sum.update(file.read())

      result += f'#{b2sum.hexdigest()}'

  return result


def generate_config_entry(profile: str, gen: Optional[str], spec: Optional[str]) -> str:
  entry_name = f'Generation {gen}'

  if spec:
    entry_name += f' (specialisation {spec})'

  gen_path = os.readlink(get_system_path(profile, gen, spec))
  kernel_path = get_file_uri(profile, gen, spec, 'kernel')
  initrd_path = get_file_uri(profile, gen, spec, 'initrd')
  cmdline = f'init={gen_path}/init '

  with open(f'{gen_path}/kernel-params') as file:
    cmdline += file.read()

  return textwrap.dedent(f'''
    ::{entry_name}
    PROTOCOL=linux
    CMDLINE={cmdline.strip()}
    KERNEL_PATH={kernel_path}
    MODULE_PATH={initrd_path}
  ''')


def find_disk_device(part: str) -> str:
  part = os.path.realpath(part)
  part = part.removeprefix('/dev/')
  disk = os.path.realpath(f'/sys/class/block/{part}')
  disk = os.path.dirname(disk)

  return f'/dev/{os.path.basename(disk)}'


def find_mounted_device(path: str) -> str:
  path = os.path.abspath(path)

  while not os.path.ismount(path):
    path = os.path.dirname(path)

  devices = [x for x in psutil.disk_partitions(all=True) if x.mountpoint == path]

  assert len(devices) == 1
  return devices[0].device


def copy_file(from_path: str, to_path: str):
  dirname = os.path.dirname(to_path)

  if not os.path.exists(dirname):
    os.makedirs(dirname)

  shutil.copyfile(from_path, to_path)


def main():
  global root_fs_uuid
  global can_use_direct_paths
  global limine_dir

  root_fs = None
  boot_fs = None

  for mount_point, fs in config('fileSystems').items():
    if mount_point == '/':
      root_fs = fs
      root_fs_uuid = fs['device'].split('/')[-1]
    elif mount_point == '/boot':
      boot_fs = fs

  is_root_fs_type_ok = is_fs_type_supported(root_fs['fsType'])
  is_root_fs_encrypted = is_encrypted(root_fs['device'])
  can_use_direct_paths = config('useStorePaths') and is_root_fs_type_ok and not is_root_fs_encrypted

  if config('canTouchEfiVariables'):
    limine_dir = os.path.join(config('efiMountPoint'), 'limine')
  elif can_use_direct_paths:
    limine_dir = '/limine'
  else:
    if boot_fs and is_fs_type_supported(boot_fs['fsType']) and not is_encrypted(boot_fs['device']):
      limine_dir = '/boot/limine'
    else:
      possible_causes = [
        f'/limine on the root partition ({is_root_fs_type_ok=} {is_root_fs_encrypted=})'
      ]

      if not boot_fs:
        possible_causes.append(f'/limine on the boot partition (not present)')
      else:
        is_boot_fs_type_ok = is_fs_type_supported(boot_fs['fsType'])
        is_boot_fs_encrypted = is_encrypted(boot_fs['device'])
        possible_causes.append(f'/limine on the boot partition ({is_boot_fs_type_ok=} {is_boot_fs_encrypted=})')

      causes_str = textwrap.indent(possible_causes.join('\n'), '  - ')

      raise Exception(textwrap.dedent('''
        Could not find a valid place for Limine configuration files!'

        Possible candidates that were ruled out:
      ''') + causes_str + textwrap.dedent('''
        Limine cannot be installed on a system without an unencrypted
        partition formatted as EXT2/3/4 or FAT.
      '''))

  if not os.path.exists(limine_dir):
    os.makedirs(limine_dir)

  profiles = [('system', get_gens())]

  for profile in get_profiles():
    profiles += (profile, get_gens(profile))

  timeout = config('timeout')
  editor_enabled = 'yes' if config('enableEditor') else 'no'
  hash_mismatch_panic = 'yes' if config('panicOnChecksumMismatch') else 'no'
  config_file = textwrap.dedent(f'''
    TIMEOUT={timeout}
    EDITOR_ENABLED={editor_enabled}
    HASH_MISMATCH_PANIC={hash_mismatch_panic}
    GRAPHICS=yes
    DEFAULT_ENTRY=2

    # NixOS boot entries start here
  ''')

  for (profile, gens) in profiles:
    group_name = 'default profile' if profile == 'system' else f"profile '{profile}'"
    config_file += f':+NixOS {group_name}\n'

    for (gen, specs) in sorted(gens, key=lambda x: x[0], reverse=True):
      config_file += generate_config_entry(profile, gen, None)

      for spec in specs:
        config_file += generate_config_entry(profile, gen, spec)

  config_file_path = os.path.join(limine_dir, 'limine.cfg')
  config_file += '\n# NixOS boot entries end here\n\n'

  for name, entry in config('additionalEntries').items():
    indented_entry = textwrap.indent(entry, '  ')
    config_file += f':{name}\n{indented_entry}\n'

  with open(config_file_path, 'w') as file:
    file.write(config_file.strip())

  for dest_path, source_path in config('additionalFiles').items():
    dest_path = os.path.join(limine_dir, dest_path)

    copy_file(source_path, dest_path)

  if config('canTouchEfiVariables'):
    cpu_family = config('hostArchitecture', 'family')

    if cpu_family == 'x86':
      if config('hostArchitecture', 'bits') == 32:
        boot_file = 'BOOTIA32.EFI'
      elif config('hostArchitecture', 'bits') == 64:
        boot_file = 'BOOTX64.EFI'
    else:
      raise Exception(f'Unsupported CPU family: {cpu_family}')

    efi_path = os.path.join(config('liminePath'), 'share', 'limine', boot_file)
    dest_path = os.path.join(config('efiMountPoint'), 'efi', 'boot', boot_file)

    copy_file(efi_path, dest_path)

    efibootmgr = os.path.join(config('efiBootMgrPath'), 'bin', 'efibootmgr')
    efi_partition = find_mounted_device(config('efiMountPoint'))
    efi_disk = find_disk_device(efi_partition)
    efibootmgr_output = subprocess.check_output([
      efibootmgr,
      '-c',
      '-d', efi_disk,
      '-p', efi_partition.removeprefix(efi_disk).removeprefix('p'),
      '-l', f'\\efi\\boot\\{boot_file}',
      '-L', 'Limine',
    ], stderr=subprocess.STDOUT, universal_newlines=True)

    for line in efibootmgr_output.split('\n'):
      if matches := re.findall(r'Boot([0-9a-fA-F]{4}) has same label Limine', line):
        subprocess.run(
          [efibootmgr, '-b', matches[0], '-B'],
          stdout=subprocess.DEVNULL,
          stderr=subprocess.DEVNULL,
        )
  else:
    disk_device = find_disk_device(root_fs['device'])
    limine_deploy = os.path.join(config('liminePath'), 'bin', 'limine-deploy')
    limine_sys = os.path.join(config('liminePath'), 'share', 'limine', 'limine.sys')
    limine_sys_dest = os.path.join(limine_dir, 'limine.sys')
    limine_deploy_args = [limine_deploy, disk_device]

    if config('forceMbr'):
      limine_deploy_args += '--force-mbr'

    copy_file(limine_sys, limine_sys_dest)

    try:
      subprocess.run(limine_deploy_args)
    except:
      raise Exception(
        'Failed to deploy stage 1 Limine bootloader!\n' +
        'You might want to try enabling the `boot.loader.limine.forceMbr` option.'
      )


main()
