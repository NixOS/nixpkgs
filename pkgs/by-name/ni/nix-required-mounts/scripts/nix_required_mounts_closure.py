import json
import os

store_dir = os.environ["storeDir"]

with open(os.environ["shallowConfigPath"], "r") as f:
    config = json.load(f)

cache = {}


def read_edges(path: str | dict) -> list[str | dict]:
    if isinstance(path, dict):
        return [path]
    assert isinstance(path, str)

    if not path.startswith(store_dir):
        return [path]
    if path in cache:
        return cache[path]

    name = f"references-{path.removeprefix(store_dir)}"

    assert os.path.exists(name)

    with open(name, "r") as f:
        return [p.strip() for p in f.readlines() if p.startswith(store_dir)]


def host_path(mount: str | dict) -> str:
    if isinstance(mount, dict):
        return mount["host"]
    assert isinstance(mount, str), mount
    return mount


for pattern in config:
    closure = []
    for path in config[pattern]["paths"]:
        closure.append(path)
        closure.extend(read_edges(path))
    config[pattern]["paths"] = list({host_path(m): m for m in closure}.values())

with open(os.environ["out"], "w") as f:
    json.dump(config, f)
