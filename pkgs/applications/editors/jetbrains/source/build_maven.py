#!/usr/bin/env nix-shell
# ! nix-shell -i python3 -p python3 python3.pkgs.xmltodict
import os
from argparse import ArgumentParser
from xmltodict import parse
from json import dump
from sys import stdout

def get_args() -> (str, list[str]):
    parser = ArgumentParser(
        description="Given the path of a intellij source tree, make a list of urls and hashes of maven artefacts required to build"
    )
    parser.add_argument("out", help="File to output json to")
    parser.add_argument("path", help="Path to the intellij-community source dir")
    args = parser.parse_args()
    return args.path, args.out


def ensure_is_list(x):
    if type(x) != list:
        return [x]
    return x

def add_entries(sources, targets, hashes):
    for num, artefact in enumerate(sources):
        hashes.append({
            "url": artefact["@url"][26:],
            "hash": artefact["sha256sum"],
            "path": targets[num]["@url"][25:-2]
        })


def add_libraries(root_path: str, hashes: list[dict[str, str]], projects_to_process: list[str]):
    library_paths = os.listdir(root_path + "/libraries/")
    for path in library_paths:
        file_contents = parse(open(root_path + "/libraries/" + path).read())
        if "properties" not in file_contents["component"]["library"]:
            continue
        sources = ensure_is_list(file_contents["component"]["library"]["properties"]["verification"]["artifact"])
        targets = ensure_is_list(file_contents["component"]["library"]["CLASSES"]["root"])
        add_entries(sources, targets, hashes)

    modules_xml = parse(open(root_path+"/modules.xml").read())
    for module in modules_xml["project"]["component"]["modules"]["module"]:
        projects_to_process.append(module["@filepath"])


def add_iml(path: str, hashes: list[dict[str, str]], projects_to_process: list[str]):
    try:
        contents = parse(open(path).read())
    except FileNotFoundError:
        print(f"Warning: path {path} does not exist (did you forget the android directory?)")
        return
    for manager in ensure_is_list(contents["module"]["component"]):
        if manager["@name"] != "NewModuleRootManager":
            continue

        for entry in manager["orderEntry"]:
            if type(entry) != dict or \
                entry["@type"] != "module-library" or \
                "properties" not in entry["library"]:
                continue

            sources = ensure_is_list(entry["library"]["properties"]["verification"]["artifact"])
            targets = ensure_is_list(entry["library"]["CLASSES"]["root"])
            add_entries(sources, targets, hashes)


def main():
    root_path, out = get_args()
    file_hashes = []
    projects_to_process: list[str] = [root_path+"/.idea"]

    while projects_to_process:
        elem = projects_to_process.pop()
        elem = elem.replace("$PROJECT_DIR$", root_path)
        if elem.endswith(".iml"):
            add_iml(elem, file_hashes, projects_to_process)
        else:
            add_libraries(elem, file_hashes, projects_to_process)

    if out == "stdout":
        dump(file_hashes, stdout, indent=4)
    else:
        file = open(out, "w")
        dump(file_hashes, file, indent=4)
        file.write("\n")


if __name__ == '__main__':
    main()
