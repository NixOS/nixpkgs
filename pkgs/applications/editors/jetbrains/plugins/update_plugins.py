#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3.pkgs.requests nix.out

from json import load, dumps
from pathlib import Path
from requests import get
from subprocess import run
from argparse import ArgumentParser

# Token priorities for version checking
# From https://github.com/JetBrains/intellij-community/blob/94f40c5d77f60af16550f6f78d481aaff8deaca4/platform/util-rt/src/com/intellij/util/text/VersionComparatorUtil.java#L50
TOKENS = {
    "snap": 10, "snapshot": 10,
    "m": 20,
    "eap": 25, "pre": 25, "preview": 25,
    "alpha": 30, "a": 30,
    "beta": 40, "betta": 40, "b": 40,
    "rc": 50,
    "sp": 70,
    "rel": 80, "release": 80, "r": 80, "final": 80
}
SNAPSHOT_VALUE = 99999
PLUGINS_FILE = Path(__file__).parent.joinpath("plugins.json").resolve()
IDES_FILE = Path(__file__).parent.joinpath("../versions.json").resolve()
# The plugin compatibility system uses a different naming scheme to the ide update system.
# These dicts convert between them
FRIENDLY_TO_PLUGIN = {
    "clion": "CLION",
    "datagrip": "DBE",
    "goland": "GOLAND",
    "idea-community": "IDEA_COMMUNITY",
    "idea-ultimate": "IDEA",
    "mps": "MPS",
    "phpstorm": "PHPSTORM",
    "pycharm-community": "PYCHARM_COMMUNITY",
    "pycharm-professional": "PYCHARM",
    "rider": "RIDER",
    "ruby-mine": "RUBYMINE",
    "rust-rover": "RUST",
    "webstorm": "WEBSTORM"
}
PLUGIN_TO_FRIENDLY = {j: i for i, j in FRIENDLY_TO_PLUGIN.items()}


def tokenize_stream(stream):
    for item in stream:
        if item in TOKENS:
            yield TOKENS[item], 0
        elif item.isalpha():
            for char in item:
                yield 90, ord(char) - 96
        elif item.isdigit():
            yield 100, int(item)


def split(version_string: str):
    prev_type = None
    block = ""
    for char in version_string:

        if char.isdigit():
            cur_type = "number"
        elif char.isalpha():
            cur_type = "letter"
        else:
            cur_type = "other"

        if cur_type != prev_type and block:
            yield block.lower()
            block = ""

        if cur_type in ("letter", "number"):
            block += char

        prev_type = cur_type

    if block:
        yield block


def tokenize_string(version_string: str):
    return list(tokenize_stream(split(version_string)))


def pick_newest(ver1: str, ver2: str) -> str:
    if ver1 is None or ver1 == ver2:
        return ver2

    if ver2 is None:
        return ver1

    presort = [tokenize_string(ver1), tokenize_string(ver2)]
    postsort = sorted(presort)
    if presort == postsort:
        return ver2
    else:
        return ver1


def is_build_older(ver1: str, ver2: str) -> int:
    ver1 = [int(i) for i in ver1.replace("*", str(SNAPSHOT_VALUE)).split(".")]
    ver2 = [int(i) for i in ver2.replace("*", str(SNAPSHOT_VALUE)).split(".")]

    for i in range(min(len(ver1), len(ver2))):
        if ver1[i] == ver2[i] and ver1[i] == SNAPSHOT_VALUE:
            return 0
        if ver1[i] == SNAPSHOT_VALUE:
            return 1
        if ver2[i] == SNAPSHOT_VALUE:
            return -1
        result = ver1[i] - ver2[i]
        if result != 0:
            return result

    return len(ver1) - len(ver2)


def is_compatible(build, since, until) -> bool:
    return (not since or is_build_older(since, build) < 0) and (not until or 0 < is_build_older(until, build))


def get_newest_compatible(pid: str, build: str, plugin_infos: dict, quiet: bool) -> [None, str]:
    newest_ver = None
    newest_index = None
    for index, info in enumerate(plugin_infos):
        if pick_newest(newest_ver, info["version"]) != newest_ver and \
                is_compatible(build, info["since"], info["until"]):
            newest_ver = info["version"]
            newest_index = index

    if newest_ver is not None:
        return "https://plugins.jetbrains.com/files/" + plugin_infos[newest_index]["file"]
    else:
        if not quiet:
            print(f"WARNING: Could not find version of plugin {pid} compatible with build {build}")
        return None


def flatten(main_list: list[list]) -> list:
    return [item for sublist in main_list for item in sublist]


def get_compatible_ides(pid: str) -> list[str]:
    int_id = pid.split("-", 1)[0]
    url = f"https://plugins.jetbrains.com/api/plugins/{int_id}/compatible-products"
    result = get(url).json()
    return sorted([PLUGIN_TO_FRIENDLY[i] for i in result if i in PLUGIN_TO_FRIENDLY])


def id_to_name(pid: str, channel="") -> str:
    channel_ext = "-" + channel if channel else ""

    resp = get("https://plugins.jetbrains.com/api/plugins/" + pid).json()
    return resp["link"].split("-", 1)[1] + channel_ext


def sort_dict(to_sort: dict) -> dict:
    return {i: to_sort[i] for i in sorted(to_sort.keys())}


def make_name_mapping(infos: dict) -> dict[str, str]:
    return sort_dict({i: id_to_name(*i.split("-", 1)) for i in infos.keys()})


def make_plugin_files(plugin_infos: dict, ide_versions: dict, quiet: bool, extra_builds: list[str]) -> dict:
    result = {}
    names = make_name_mapping(plugin_infos)
    for pid in plugin_infos:
        plugin_versions = {
            "compatible": get_compatible_ides(pid),
            "builds": {},
            "name": names[pid]
        }
        relevant_builds = [builds for ide, builds in ide_versions.items() if ide in plugin_versions["compatible"]] + [extra_builds]
        relevant_builds = sorted(list(set(flatten(relevant_builds))))  # Flatten, remove duplicates and sort
        for build in relevant_builds:
            plugin_versions["builds"][build] = get_newest_compatible(pid, build, plugin_infos[pid], quiet)
        result[pid] = plugin_versions

    return result


def get_old_file_hashes() -> dict[str, str]:
    return load(open(PLUGINS_FILE))["files"]


def get_hash(url):
    print(f"Downloading {url}")
    args = ["nix-prefetch-url", url, "--print-path"]
    if url.endswith(".zip"):
        args.append("--unpack")
    else:
        args.append("--executable")
    path_process = run(args, capture_output=True)
    path = path_process.stdout.decode().split("\n")[1]
    result = run(["nix", "--extra-experimental-features", "nix-command", "hash", "path", path], capture_output=True)
    result_contents = result.stdout.decode()[:-1]
    if not result_contents:
        raise RuntimeError(result.stderr.decode())
    return result_contents


def print_file_diff(old, new):
    added = new.copy()
    removed = old.copy()
    to_delete = []

    for file in added:
        if file in removed:
            to_delete.append(file)

    for file in to_delete:
        added.remove(file)
        removed.remove(file)

    if removed:
        print("\nRemoved:")
        for file in removed:
            print(" - " + file)
        print()

    if added:
        print("\nAdded:")
        for file in added:
            print(" + " + file)
        print()


def get_file_hashes(file_list: list[str], refetch_all: bool) -> dict[str, str]:
    old = {} if refetch_all else get_old_file_hashes()
    print_file_diff(list(old.keys()), file_list)

    file_hashes = {}
    for file in sorted(file_list):
        if file in old:
            file_hashes[file] = old[file]
        else:
            file_hashes[file] = get_hash(file)
    return file_hashes


def get_args() -> tuple[list[str], list[str], bool, bool, bool, list[str]]:
    parser = ArgumentParser(
        description="Add/remove/update entries in plugins.json",
        epilog="To update all plugins, run with no args.\n"
               "To add a version of a plugin from a different channel, append -[channel] to the id.\n"
               "The id of a plugin is the number before the name in the address of its page on https://plugins.jetbrains.com/"
    )
    parser.add_argument("-r", "--refetch-all", action="store_true",
                        help="don't use previously collected hashes, redownload all")
    parser.add_argument("-l", "--list", action="store_true",
                        help="list plugin ids")
    parser.add_argument("-q", "--quiet", action="store_true",
                        help="suppress warnings about not being able to find compatible plugin versions")
    parser.add_argument("-w", "--with-build", action="append", default=[],
                        help="append [builds] to the list of builds to fetch plugin versions for")
    sub = parser.add_subparsers(dest="action")
    sub.add_parser("add").add_argument("ids", type=str, nargs="+", help="plugin(s) to add")
    sub.add_parser("remove").add_argument("ids", type=str, nargs="+", help="plugin(s) to remove")

    args = parser.parse_args()
    add = []
    remove = []

    if args.action == "add":
        add = args.ids
    elif args.action == "remove":
        remove = args.ids

    return add, remove, args.refetch_all, args.list, args.quiet, args.with_build


def sort_ids(ids: list[str]) -> list[str]:
    sortable_ids = []
    for pid in ids:
        if "-" in pid:
            split_pid = pid.split("-", 1)
            sortable_ids.append((int(split_pid[0]), split_pid[1]))
        else:
            sortable_ids.append((int(pid), ""))
    sorted_ids = sorted(sortable_ids)
    return [(f"{i}-{j}" if j else str(i)) for i, j in sorted_ids]


def get_plugin_ids(add: list[str], remove: list[str]) -> list[str]:
    ids = list(load(open(PLUGINS_FILE))["plugins"].keys())

    for pid in add:
        if pid in ids:
            raise ValueError(f"ID {pid} already in JSON file")
        ids.append(pid)

    for pid in remove:
        try:
            ids.remove(pid)
        except ValueError:
            raise ValueError(f"ID {pid} not in JSON file")
    return sort_ids(ids)


def get_plugin_info(pid: str, channel: str) -> dict:
    url = f"https://plugins.jetbrains.com/api/plugins/{pid}/updates?channel={channel}"
    resp = get(url)
    decoded = resp.json()

    if resp.status_code != 200:
        print(f"Server gave non-200 code {resp.status_code} with message " + decoded["message"])
        exit(1)

    return decoded


def ids_to_infos(ids: list[str]) -> dict:
    result = {}
    for pid in ids:

        if "-" in pid:
            int_id, channel = pid.split("-", 1)
        else:
            channel = ""
            int_id = pid

        result[pid] = get_plugin_info(int_id, channel)
    return result


def get_ide_versions() -> dict:
    ide_data = load(open(IDES_FILE))
    result = {}
    for platform in ide_data:
        for product in ide_data[platform]:

            version = ide_data[platform][product]["build_number"]
            if product not in result:
                result[product] = [version]
            elif version not in result[product]:
                result[product].append(version)

    # Gateway isn't a normal IDE, so it doesn't use the same plugins system
    del result["gateway"]

    return result


def get_file_names(plugins: dict[str, dict]) -> list[str]:
    result = []
    for plugin_info in plugins.values():
        for url in plugin_info["builds"].values():
            if url is not None:
                result.append(url)

    return list(set(result))


def dump(obj, file):
    file.write(dumps(obj, indent=2))
    file.write("\n")


def write_result(to_write):
    dump(to_write, open(PLUGINS_FILE, "w"))


def main():
    add, remove, refetch_all, list_ids, quiet, extra_builds = get_args()
    result = {}

    print("Fetching plugin info")
    ids = get_plugin_ids(add, remove)
    if list_ids:
        print(*ids)
    plugin_infos = ids_to_infos(ids)

    print("Working out which plugins need which files")
    ide_versions = get_ide_versions()
    result["plugins"] = make_plugin_files(plugin_infos, ide_versions, quiet, extra_builds)

    print("Getting file hashes")
    file_list = get_file_names(result["plugins"])
    result["files"] = get_file_hashes(file_list, refetch_all)

    write_result(result)

    # Commit the result
    commitMessage = "jetbrains.plugins: update"
    print("#### Committing changes... ####")
    run(['git', 'commit', f'-m{commitMessage}', '--', f'{PLUGINS_FILE}'], check=True)


if __name__ == '__main__':
    main()
