import sys
import os
import argparse
import json
from pathlib import Path

parser = argparse.ArgumentParser(description="secrets-plain-backend")
parser.add_argument("config")

subparsers = parser.add_subparsers(title="commands", dest="command", required=True)

get_parser = subparsers.add_parser("get")
get_parser.add_argument("generator")
get_parser.add_argument("filename")

set_parser = subparsers.add_parser("set")
set_parser.add_argument("generator")
set_parser.add_argument("filename")

exists_parser = subparsers.add_parser("exists")
exists_parser.add_argument("generator")
exists_parser.add_argument("filename")

list_parser = subparsers.add_parser("list")

delete_parser = subparsers.add_parser("delete")
delete_parser.add_argument("generator")
delete_parser.add_argument("filename")

deploy_local_parser = subparsers.add_parser("deploy-local")
deploy_local_parser.add_argument("system_root", type=Path)

args = vars(parser.parse_args())

with open(args["config"]) as f:
    config = json.loads(f.read())

host_directory = Path(config["hostDirectory"])
target_directory = Path(config["targetDirectory"])


def host_secret_path(generator, filename):
    return host_directory / "generators" / generator / "files" / filename


def target_secret_path(generator, filename):
    return target_directory / generator / filename


def parse_file_list(lines):
    pairs = []
    for line in lines:
        if not line:
            continue

        parts = line.strip().split()
        if len(parts) != 2:
            raise Exception(f"Malformed file list line: {line}")

        [generator, filename] = parts
        pairs.append((generator, filename))
    return pairs


if args["command"] == "get":
    host_secret_path(args["generator"], args["filename"]).copy(os.environ["out"])
elif args["command"] == "set":
    out_path = host_secret_path(args["generator"], args["filename"])
    out_path.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
    Path(os.environ["in"]).copy(out_path)
elif args["command"] == "exists":
    if not host_secret_path(args["generator"], args["filename"]).exists():
        sys.exit(42)
elif args["command"] == "list":
    if host_directory.exists():
        for generator in (host_directory / "generators").iterdir():
            for file in (generator / "files").iterdir():
                print(f"{generator.name} {file.name}")
elif args["command"] == "delete":
    host_secret_path(args["generator"], args["filename"]).unlink(missing_ok=True)
elif args["command"] == "deploy-local":
    sys_root = args["system_root"]
    if not sys_root.exists():
        raise Exception(f"Directory '{sys_root}' does not exist")
    for generator, filename in parse_file_list(sys.stdin):
        in_path = host_secret_path(generator, filename)
        if not in_path.exists():
            raise Exception(f"Missing secret file '{generator}/{filename}'")

        out_path = target_secret_path(generator, filename)
        # TODO: is there a better way to do this?
        out_path = Path(f"{sys_root}{out_path}")
        out_path.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
        in_path.copy(out_path)
