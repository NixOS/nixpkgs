from graphlib import TopologicalSorter
from pathlib import Path
from typing import Any, Final, Generator, Literal
import argparse
import asyncio
import contextlib
import json
import os
import re
import shlex
import subprocess
import sys
import tempfile


Order = Literal["arbitrary", "reverse-topological", "topological"]


FAKE_DEPENDENCY_FOR_INDEPENDENT_PACKAGES: Final[str] = (
    "::fake_dependency_for_independent_packages"
)


class CalledProcessError(Exception):
    process: asyncio.subprocess.Process
    stderr: bytes | None


class UpdateFailedException(Exception):
    pass


def eprint(*args: Any, **kwargs: Any) -> None:
    print(*args, file=sys.stderr, **kwargs)


async def check_subprocess_output(*args: str, **kwargs: Any) -> bytes:
    """
    Emulate check and capture_output arguments of subprocess.run function.
    """
    process = await asyncio.create_subprocess_exec(*args, **kwargs)
    # We need to use communicate() instead of wait(), as the OS pipe buffers
    # can fill up and cause a deadlock.
    stdout, stderr = await process.communicate()

    if process.returncode != 0:
        error = CalledProcessError()
        error.process = process
        error.stderr = stderr

        raise error

    return stdout


async def nix_instantiate(attr_path: str) -> Path:
    out = await check_subprocess_output(
        "nix-instantiate",
        "-A",
        attr_path,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    drv = out.decode("utf-8").strip().split("!", 1)[0]

    return Path(drv)


async def nix_query_requisites(drv: Path) -> list[Path]:
    requisites = await check_subprocess_output(
        "nix-store",
        "--query",
        "--requisites",
        str(drv),
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )

    drv_str = str(drv)

    return [
        Path(requisite)
        for requisite in requisites.decode("utf-8").splitlines()
        # Avoid self-loops.
        if requisite != drv_str
    ]


async def attr_instantiation_worker(
    semaphore: asyncio.Semaphore,
    attr_path: str,
) -> tuple[Path, str]:
    async with semaphore:
        eprint(f"Instantiating {attr_path}…")
        try:
            return (await nix_instantiate(attr_path), attr_path)
        except Exception as e:
            # Failure should normally terminate the script but
            # looks like Python is buggy so we need to do it ourselves.
            eprint(f"Failed to instantiate {attr_path}")
            if e.stderr:
                eprint(e.stderr.decode("utf-8"))
            sys.exit(1)


async def requisites_worker(
    semaphore: asyncio.Semaphore,
    drv: Path,
) -> tuple[Path, list[Path]]:
    async with semaphore:
        eprint(f"Obtaining requisites for {drv}…")
        return (drv, await nix_query_requisites(drv))


def requisites_to_attrs(
    drv_attr_paths: dict[Path, str],
    requisites: list[Path],
) -> set[str]:
    """
    Converts a set of requisite `.drv`s to a set of attribute paths.
    Derivations that do not correspond to any of the packages we want to update will be discarded.
    """
    return {
        drv_attr_paths[requisite]
        for requisite in requisites
        if requisite in drv_attr_paths
    }


def reverse_edges(graph: dict[str, set[str]]) -> dict[str, set[str]]:
    """
    Flips the edges of a directed graph.

    Packages without any dependency relation in the updated set
    will be added to `FAKE_DEPENDENCY_FOR_INDEPENDENT_PACKAGES` node.
    """

    reversed_graph: dict[str, set[str]] = {}
    for dependent, dependencies in graph.items():
        dependencies = dependencies or {FAKE_DEPENDENCY_FOR_INDEPENDENT_PACKAGES}
        for dependency in dependencies:
            reversed_graph.setdefault(dependency, set()).add(dependent)

    return reversed_graph


def get_independent_sorter(
    packages: list[dict],
) -> TopologicalSorter[str]:
    """
    Returns a sorter which treats all packages as independent,
    which will allow them to be updated in parallel.
    """

    attr_deps: dict[str, set[str]] = {
        package["attrPath"]: set() for package in packages
    }
    sorter = TopologicalSorter(attr_deps)
    sorter.prepare()

    return sorter


async def get_topological_sorter(
    max_workers: int,
    packages: list[dict],
    reverse_order: bool,
) -> tuple[TopologicalSorter[str], list[dict]]:
    """
    Returns a sorter which returns packages in topological or reverse topological order,
    which will ensure a package is updated before or after its dependencies, respectively.
    """

    semaphore = asyncio.Semaphore(max_workers)

    drv_attr_paths = dict(
        await asyncio.gather(
            *(
                attr_instantiation_worker(semaphore, package["attrPath"])
                for package in packages
            )
        )
    )

    drv_requisites = await asyncio.gather(
        *(requisites_worker(semaphore, drv) for drv in drv_attr_paths.keys())
    )

    attr_deps = {
        drv_attr_paths[drv]: requisites_to_attrs(drv_attr_paths, requisites)
        for drv, requisites in drv_requisites
    }

    if reverse_order:
        attr_deps = reverse_edges(attr_deps)

    # Adjust packages order based on the topological one
    ordered = list(TopologicalSorter(attr_deps).static_order())
    packages = sorted(packages, key=lambda package: ordered.index(package["attrPath"]))

    sorter = TopologicalSorter(attr_deps)
    sorter.prepare()

    return sorter, packages


async def run_update_script(
    nixpkgs_root: str,
    merge_lock: asyncio.Lock,
    temp_dir: tuple[str, str] | None,
    package: dict,
    keep_going: bool,
) -> None:
    worktree: str | None = None

    update_script_command = package["updateScript"]

    if temp_dir is not None:
        worktree, _branch = temp_dir

        # Ensure the worktree is clean before update.
        await check_subprocess_output(
            "git",
            "reset",
            "--hard",
            "--quiet",
            "HEAD",
            cwd=worktree,
        )

        # Update scripts can use $(dirname $0) to get their location but we want to run
        # their clones in the git worktree, not in the main nixpkgs repo.
        update_script_command = map(
            lambda arg: re.sub(r"^{0}".format(re.escape(nixpkgs_root)), worktree, arg),
            update_script_command,
        )

    eprint(f" - {package['name']}: UPDATING ...")

    try:
        update_info = await check_subprocess_output(
            "env",
            f"UPDATE_NIX_NAME={package['name']}",
            f"UPDATE_NIX_PNAME={package['pname']}",
            f"UPDATE_NIX_OLD_VERSION={package['oldVersion']}",
            f"UPDATE_NIX_ATTR_PATH={package['attrPath']}",
            # Run all update scripts in the Nixpkgs development shell to get access to formatters and co.
            "nix-shell",
            nixpkgs_root + "/shell.nix",
            "--run",
            " ".join([ shlex.quote(s) for s in update_script_command ]),
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
            cwd=worktree,
        )
        await merge_changes(merge_lock, package, update_info, temp_dir)
    except KeyboardInterrupt as e:
        eprint("Cancelling…")
        raise asyncio.exceptions.CancelledError()
    except CalledProcessError as e:
        eprint(f" - {package['name']}: ERROR")
        if e.stderr is not None:
            eprint()
            eprint(
                f"--- SHOWING ERROR LOG FOR {package['name']} ----------------------"
            )
            eprint()
            eprint(e.stderr.decode("utf-8"))
            with open(f"{package['pname']}.log", "wb") as logfile:
                logfile.write(e.stderr)
            eprint()
            eprint(
                f"--- SHOWING ERROR LOG FOR {package['name']} ----------------------"
            )

        if not keep_going:
            raise UpdateFailedException(
                f"The update script for {package['name']} failed with exit code {e.process.returncode}"
            )


@contextlib.contextmanager
def make_worktree() -> Generator[tuple[str, str], None, None]:
    with tempfile.TemporaryDirectory() as wt:
        branch_name = f"update-{os.path.basename(wt)}"
        target_directory = f"{wt}/nixpkgs"

        subprocess.run(["git", "worktree", "add", "-b", branch_name, target_directory])
        try:
            yield (target_directory, branch_name)
        finally:
            subprocess.run(["git", "worktree", "remove", "--force", target_directory])
            subprocess.run(["git", "branch", "-D", branch_name])


async def commit_changes(
    name: str,
    merge_lock: asyncio.Lock,
    worktree: str,
    branch: str,
    changes: list[dict],
) -> None:
    for change in changes:
        # Git can only handle a single index operation at a time
        async with merge_lock:
            await check_subprocess_output("git", "add", *change["files"], cwd=worktree)
            commit_message = "{attrPath}: {oldVersion} -> {newVersion}".format(**change)
            if "commitMessage" in change:
                commit_message = change["commitMessage"]
            elif "commitBody" in change:
                commit_message = commit_message + "\n\n" + change["commitBody"]
            await check_subprocess_output(
                "git",
                "commit",
                "--quiet",
                "-m",
                commit_message,
                cwd=worktree,
            )
            await check_subprocess_output("git", "cherry-pick", branch)


async def check_changes(
    package: dict,
    worktree: str,
    update_info: bytes,
) -> list[dict]:
    if "commit" in package["supportedFeatures"]:
        changes = json.loads(update_info)
    else:
        changes = [{}]

    # Try to fill in missing attributes when there is just a single change.
    if len(changes) == 1:
        # Dynamic data from updater take precedence over static data from passthru.updateScript.
        if "attrPath" not in changes[0]:
            # update.nix is always passing attrPath
            changes[0]["attrPath"] = package["attrPath"]

        if "oldVersion" not in changes[0]:
            # update.nix is always passing oldVersion
            changes[0]["oldVersion"] = package["oldVersion"]

        if "newVersion" not in changes[0]:
            attr_path = changes[0]["attrPath"]
            obtain_new_version_output = await check_subprocess_output(
                "nix-instantiate",
                "--expr",
                f"with import ./. {{}}; lib.getVersion {attr_path}",
                "--eval",
                "--strict",
                "--json",
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
                cwd=worktree,
            )
            changes[0]["newVersion"] = json.loads(
                obtain_new_version_output.decode("utf-8")
            )

        if "files" not in changes[0]:
            changed_files_output = await check_subprocess_output(
                "git",
                "diff",
                "--name-only",
                "HEAD",
                stdout=asyncio.subprocess.PIPE,
                cwd=worktree,
            )
            changed_files = changed_files_output.splitlines()
            changes[0]["files"] = changed_files

            if len(changed_files) == 0:
                return []

    return changes


async def merge_changes(
    merge_lock: asyncio.Lock,
    package: dict,
    update_info: bytes,
    temp_dir: tuple[str, str] | None,
) -> None:
    if temp_dir is not None:
        worktree, branch = temp_dir
        changes = await check_changes(package, worktree, update_info)

        if len(changes) > 0:
            await commit_changes(package["name"], merge_lock, worktree, branch, changes)
        else:
            eprint(f" - {package['name']}: DONE, no changes.")
    else:
        eprint(f" - {package['name']}: DONE.")


async def updater(
    nixpkgs_root: str,
    temp_dir: tuple[str, str] | None,
    merge_lock: asyncio.Lock,
    packages_to_update: asyncio.Queue[dict | None],
    keep_going: bool,
    commit: bool,
) -> None:
    while True:
        package = await packages_to_update.get()
        if package is None:
            # A sentinel received, we are done.
            return

        if not ("commit" in package["supportedFeatures"] or "attrPath" in package):
            temp_dir = None

        await run_update_script(nixpkgs_root, merge_lock, temp_dir, package, keep_going)

        packages_to_update.task_done()


async def populate_queue(
    attr_packages: dict[str, dict],
    sorter: TopologicalSorter[str],
    packages_to_update: asyncio.Queue[dict | None],
    num_workers: int,
) -> None:
    """
    Keeps populating the queue with packages that can be updated
    according to ordering requirements. If topological order
    is used, the packages will appear in waves, as packages with
    no dependencies are processed and removed from the sorter.
    With `order="none"`, all packages will be enqueued simultaneously.
    """

    # Fill up an update queue,
    while sorter.is_active():
        ready_packages = list(sorter.get_ready())
        eprint(f"Enqueuing group of {len(ready_packages)} packages")
        for package in ready_packages:
            if package == FAKE_DEPENDENCY_FOR_INDEPENDENT_PACKAGES:
                continue
            await packages_to_update.put(attr_packages[package])
        await packages_to_update.join()
        sorter.done(*ready_packages)

    # Add sentinels, one for each worker.
    # A worker will terminate when it gets a sentinel from the queue.
    for i in range(num_workers):
        await packages_to_update.put(None)


async def start_updates(
    max_workers: int,
    keep_going: bool,
    commit: bool,
    attr_packages: dict[str, dict],
    sorter: TopologicalSorter[str],
) -> None:
    merge_lock = asyncio.Lock()
    packages_to_update: asyncio.Queue[dict | None] = asyncio.Queue()

    with contextlib.ExitStack() as stack:
        temp_dirs: list[tuple[str, str] | None] = []

        # Do not create more workers than there are packages.
        num_workers = min(max_workers, len(attr_packages))

        nixpkgs_root_output = await check_subprocess_output(
            "git",
            "rev-parse",
            "--show-toplevel",
            stdout=asyncio.subprocess.PIPE,
        )
        nixpkgs_root = nixpkgs_root_output.decode("utf-8").strip()

        # Set up temporary directories when using auto-commit.
        for i in range(num_workers):
            temp_dir = stack.enter_context(make_worktree()) if commit else None
            temp_dirs.append(temp_dir)

        queue_task = populate_queue(
            attr_packages,
            sorter,
            packages_to_update,
            num_workers,
        )

        # Prepare updater workers for each temp_dir directory.
        # At most `num_workers` instances of `run_update_script` will be running at one time.
        updater_tasks = [
            updater(
                nixpkgs_root,
                temp_dir,
                merge_lock,
                packages_to_update,
                keep_going,
                commit,
            )
            for temp_dir in temp_dirs
        ]

        tasks = asyncio.gather(
            *updater_tasks,
            queue_task,
        )

        try:
            # Start updater workers.
            await tasks
        except asyncio.exceptions.CancelledError:
            # When one worker is cancelled, cancel the others too.
            tasks.cancel()
        except UpdateFailedException as e:
            # When one worker fails, cancel the others, as this exception is only thrown when keep_going is false.
            tasks.cancel()
            eprint(e)
            sys.exit(1)


async def main(
    max_workers: int,
    keep_going: bool,
    commit: bool,
    packages_path: str,
    skip_prompt: bool,
    order: Order,
) -> None:
    with open(packages_path) as f:
        packages = json.load(f)

    if order != "arbitrary":
        eprint("Sorting packages…")
        reverse_order = order == "reverse-topological"
        sorter, packages = await get_topological_sorter(
            max_workers,
            packages,
            reverse_order,
        )
    else:
        sorter = get_independent_sorter(packages)

    attr_packages = {package["attrPath"]: package for package in packages}

    eprint()
    eprint("Going to be running update for following packages:")
    for package in packages:
        eprint(f" - {package['name']}")
    eprint()

    confirm = "" if skip_prompt else input("Press Enter key to continue...")

    if confirm == "":
        eprint()
        eprint("Running update for:")

        await start_updates(max_workers, keep_going, commit, attr_packages, sorter)

        eprint()
        eprint("Packages updated!")
        sys.exit()
    else:
        eprint("Aborting!")
        sys.exit(130)


parser = argparse.ArgumentParser(description="Update packages")
parser.add_argument(
    "--max-workers",
    "-j",
    dest="max_workers",
    type=int,
    help="Number of updates to run concurrently",
    nargs="?",
    default=4,
)
parser.add_argument(
    "--keep-going",
    "-k",
    dest="keep_going",
    action="store_true",
    help="Do not stop after first failure",
)
parser.add_argument(
    "--commit",
    "-c",
    dest="commit",
    action="store_true",
    help="Commit the changes",
)
parser.add_argument(
    "--order",
    dest="order",
    default="arbitrary",
    choices=["arbitrary", "reverse-topological", "topological"],
    help="Sort the packages based on dependency relation",
)
parser.add_argument(
    "packages",
    help="JSON file containing the list of package names and their update scripts",
)
parser.add_argument(
    "--skip-prompt",
    "-s",
    dest="skip_prompt",
    action="store_true",
    help="Do not stop for prompts",
)

if __name__ == "__main__":
    args = parser.parse_args()

    try:
        asyncio.run(
            main(
                args.max_workers,
                args.keep_going,
                args.commit,
                args.packages,
                args.skip_prompt,
                args.order,
            )
        )
    except KeyboardInterrupt as e:
        # Let’s cancel outside of the main loop too.
        sys.exit(130)
