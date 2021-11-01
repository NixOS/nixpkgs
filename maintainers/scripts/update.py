from __future__ import annotations
from typing import Dict, Generator, List, Optional, Tuple
import argparse
import asyncio
import contextlib
import json
import os
import re
import subprocess
import sys
import tempfile

class CalledProcessError(Exception):
    process: asyncio.subprocess.Process

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

async def check_subprocess(*args, **kwargs):
    """
    Emulate check argument of subprocess.run function.
    """
    process = await asyncio.create_subprocess_exec(*args, **kwargs)
    returncode = await process.wait()

    if returncode != 0:
        error = CalledProcessError()
        error.process = process

        raise error

    return process

async def run_update_script(nixpkgs_root: str, merge_lock: asyncio.Lock, temp_dir: Optional[Tuple[str, str]], package: Dict, keep_going: bool):
    worktree: Optional[str] = None

    update_script_command = package['updateScript']

    if temp_dir is not None:
        worktree, _branch = temp_dir

        # Ensure the worktree is clean before update.
        await check_subprocess('git', 'reset', '--hard', '--quiet', 'HEAD', cwd=worktree)

        # Update scripts can use $(dirname $0) to get their location but we want to run
        # their clones in the git worktree, not in the main nixpkgs repo.
        update_script_command = map(lambda arg: re.sub(r'^{0}'.format(re.escape(nixpkgs_root)), worktree, arg), update_script_command)

    eprint(f" - {package['name']}: UPDATING ...")

    try:
        update_process = await check_subprocess('env', f"UPDATE_NIX_ATTR_PATH={package['attrPath']}", *update_script_command, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE, cwd=worktree)
        update_info = await update_process.stdout.read()

        await merge_changes(merge_lock, package, update_info, temp_dir)
    except KeyboardInterrupt as e:
        eprint('Cancelling…')
        raise asyncio.exceptions.CancelledError()
    except CalledProcessError as e:
        eprint(f" - {package['name']}: ERROR")
        eprint()
        eprint(f"--- SHOWING ERROR LOG FOR {package['name']} ----------------------")
        eprint()
        stderr = await e.process.stderr.read()
        eprint(stderr.decode('utf-8'))
        with open(f"{package['pname']}.log", 'wb') as logfile:
            logfile.write(stderr)
        eprint()
        eprint(f"--- SHOWING ERROR LOG FOR {package['name']} ----------------------")

        if not keep_going:
            raise asyncio.exceptions.CancelledError()

@contextlib.contextmanager
def make_worktree() -> Generator[Tuple[str, str], None, None]:
    with tempfile.TemporaryDirectory() as wt:
        branch_name = f'update-{os.path.basename(wt)}'
        target_directory = f'{wt}/nixpkgs'

        subprocess.run(['git', 'worktree', 'add', '-b', branch_name, target_directory])
        yield (target_directory, branch_name)
        subprocess.run(['git', 'worktree', 'remove', '--force', target_directory])
        subprocess.run(['git', 'branch', '-D', branch_name])

async def commit_changes(name: str, merge_lock: asyncio.Lock, worktree: str, branch: str, changes: List[Dict]) -> None:
    for change in changes:
        # Git can only handle a single index operation at a time
        async with merge_lock:
            await check_subprocess('git', 'add', *change['files'], cwd=worktree)
            commit_message = '{attrPath}: {oldVersion} → {newVersion}'.format(**change)
            await check_subprocess('git', 'commit', '--quiet', '-m', commit_message, cwd=worktree)
            await check_subprocess('git', 'cherry-pick', branch)

async def check_changes(package: Dict, worktree: str, update_info: str):
    if 'commit' in package['supportedFeatures']:
        changes = json.loads(update_info)
    else:
        changes = [{}]

    # Try to fill in missing attributes when there is just a single change.
    if len(changes) == 1:
        # Dynamic data from updater take precedence over static data from passthru.updateScript.
        if 'attrPath' not in changes[0]:
            # update.nix is always passing attrPath
            changes[0]['attrPath'] = package['attrPath']

        if 'oldVersion' not in changes[0]:
            # update.nix is always passing oldVersion
            changes[0]['oldVersion'] = package['oldVersion']

        if 'newVersion' not in changes[0]:
            attr_path = changes[0]['attrPath']
            obtain_new_version_process = await check_subprocess('nix-instantiate', '--expr', f'with import ./. {{}}; lib.getVersion {attr_path}', '--eval', '--strict', '--json', stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE, cwd=worktree)
            changes[0]['newVersion'] = json.loads((await obtain_new_version_process.stdout.read()).decode('utf-8'))

        if 'files' not in changes[0]:
            changed_files_process = await check_subprocess('git', 'diff', '--name-only', 'HEAD', stdout=asyncio.subprocess.PIPE, cwd=worktree)
            changed_files = (await changed_files_process.stdout.read()).splitlines()
            changes[0]['files'] = changed_files

            if len(changed_files) == 0:
                return []

    return changes

async def merge_changes(merge_lock: asyncio.Lock, package: Dict, update_info: str, temp_dir: Optional[Tuple[str, str]]) -> None:
    if temp_dir is not None:
        worktree, branch = temp_dir
        changes = await check_changes(package, worktree, update_info)

        if len(changes) > 0:
            await commit_changes(package['name'], merge_lock, worktree, branch, changes)
        else:
            eprint(f" - {package['name']}: DONE, no changes.")
    else:
        eprint(f" - {package['name']}: DONE.")

async def updater(nixpkgs_root: str, temp_dir: Optional[Tuple[str, str]], merge_lock: asyncio.Lock, packages_to_update: asyncio.Queue[Optional[Dict]], keep_going: bool, commit: bool):
    while True:
        package = await packages_to_update.get()
        if package is None:
            # A sentinel received, we are done.
            return

        if not ('commit' in package['supportedFeatures'] or 'attrPath' in package):
            temp_dir = None

        await run_update_script(nixpkgs_root, merge_lock, temp_dir, package, keep_going)

async def start_updates(max_workers: int, keep_going: bool, commit: bool, packages: List[Dict]):
    merge_lock = asyncio.Lock()
    packages_to_update: asyncio.Queue[Optional[Dict]] = asyncio.Queue()

    with contextlib.ExitStack() as stack:
        temp_dirs: List[Optional[Tuple[str, str]]] = []

        # Do not create more workers than there are packages.
        num_workers = min(max_workers, len(packages))

        nixpkgs_root_process = await check_subprocess('git', 'rev-parse', '--show-toplevel', stdout=asyncio.subprocess.PIPE)
        nixpkgs_root = (await nixpkgs_root_process.stdout.read()).decode('utf-8').strip()

        # Set up temporary directories when using auto-commit.
        for i in range(num_workers):
            temp_dir = stack.enter_context(make_worktree()) if commit else None
            temp_dirs.append(temp_dir)

        # Fill up an update queue,
        for package in packages:
            await packages_to_update.put(package)

        # Add sentinels, one for each worker.
        # A workers will terminate when it gets sentinel from the queue.
        for i in range(num_workers):
            await packages_to_update.put(None)

        # Prepare updater workers for each temp_dir directory.
        # At most `num_workers` instances of `run_update_script` will be running at one time.
        updaters = asyncio.gather(*[updater(nixpkgs_root, temp_dir, merge_lock, packages_to_update, keep_going, commit) for temp_dir in temp_dirs])

        try:
            # Start updater workers.
            await updaters
        except asyncio.exceptions.CancelledError as e:
            # When one worker is cancelled, cancel the others too.
            updaters.cancel()

def main(max_workers: int, keep_going: bool, commit: bool, packages_path: str) -> None:
    with open(packages_path) as f:
        packages = json.load(f)

    eprint()
    eprint('Going to be running update for following packages:')
    for package in packages:
        eprint(f" - {package['name']}")
    eprint()

    confirm = input('Press Enter key to continue...')
    if confirm == '':
        eprint()
        eprint('Running update for:')

        asyncio.run(start_updates(max_workers, keep_going, commit, packages))

        eprint()
        eprint('Packages updated!')
        sys.exit()
    else:
        eprint('Aborting!')
        sys.exit(130)

parser = argparse.ArgumentParser(description='Update packages')
parser.add_argument('--max-workers', '-j', dest='max_workers', type=int, help='Number of updates to run concurrently', nargs='?', default=4)
parser.add_argument('--keep-going', '-k', dest='keep_going', action='store_true', help='Do not stop after first failure')
parser.add_argument('--commit', '-c', dest='commit', action='store_true', help='Commit the changes')
parser.add_argument('packages', help='JSON file containing the list of package names and their update scripts')

if __name__ == '__main__':
    args = parser.parse_args()

    try:
        main(args.max_workers, args.keep_going, args.commit, args.packages)
    except KeyboardInterrupt as e:
        # Let’s cancel outside of the main loop too.
        sys.exit(130)
