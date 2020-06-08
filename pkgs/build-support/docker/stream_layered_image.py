import io
import os
import re
import sys
import json
import hashlib
import tarfile
import itertools
import threading
from collections import namedtuple


# Adds the given store paths to as a tar to the given writable stream.
def archive_paths_to(obj, paths, add_nix, filter=None):
    filter = filter if filter else lambda i: i

    # gettarinfo makes the paths relative, this makes them
    # absolute again
    def append_root(ti):
        ti.name = "/" + ti.name
        return ti

    def dir(path):
        ti = tarfile.TarInfo(path)
        ti.type = tarfile.DIRTYPE
        return ti

    with tarfile.open(fileobj=obj, mode="w|") as tar:
        if add_nix:
            tar.addfile(dir("/nix"))
            tar.addfile(dir("/nix/store"))

        for path in paths:
            ti = tar.gettarinfo(os.path.join("/", path))
            tar.addfile(filter(append_root(ti)))

            for root, dirs, files in os.walk(path, topdown=True):
                for name in itertools.chain(dirs, files):
                    name = os.path.join(root, name)
                    ti = append_root(tar.gettarinfo(name))

                    # copy hardlinks as regular files
                    if ti.islnk():
                        ti.type = tarfile.REGTYPE

                    ti = filter(ti)
                    if ti.isfile():
                        with open(name, "rb") as f:
                            tar.addfile(ti, f)
                    else:
                        tar.addfile(ti)


# A writable stream which only calculates the final file size and
# sha256sum, while discarding the actual contents.
class ExtractChecksum:
    def __init__(self):
        self._digest = hashlib.sha256()
        self._size = 0

    def write(self, data):
        self._digest.update(data)
        self._size += len(data)

    def extract(self):
        return (self._digest.hexdigest(), self._size)


# Some metadata for a layer
LayerInfo = namedtuple("LayerInfo", ["size", "checksum", "path", "paths"])


# Given a list of store paths 'paths', creates a layer add append it
# to tarfile 'tar'. Returns some a 'LayerInfo' for the layer.
def add_layer_dir(tar, paths, add_nix=True, filter=None):
    assert all(i.startswith("/nix/store/") for i in paths)

    extract_checksum = ExtractChecksum()
    archive_paths_to(extract_checksum, paths, add_nix=add_nix, filter=filter)
    (checksum, size) = extract_checksum.extract()

    path = f"{checksum}/layer.tar"
    ti = tarfile.TarInfo(path)
    ti.size = size

    read_fd, write_fd = os.pipe()
    with open(read_fd, "rb") as read, open(write_fd, "wb") as write:
        def producer():
            archive_paths_to(write, paths, add_nix=add_nix, filter=filter)
            write.close()
        threading.Thread(target=producer).start()
        tar.addfile(ti, read)

    return LayerInfo(size=size, checksum=checksum, path=path, paths=paths)


def add_customisation_layer(tar, path):
    def filter(ti):
        ti.name = re.sub("^/nix/store/[^/]*", "", ti.name)
        return ti
    return add_layer_dir(tar, [path], add_nix=False, filter=filter)


# Adds a file to the tarball with given path and contents.
def add_bytes(tar, path, content):
    assert type(content) is bytes

    ti = tarfile.TarInfo(path)
    ti.size = len(content)
    tar.addfile(ti, io.BytesIO(content))


# Main

with open(sys.argv[1], "r") as f:
    conf = json.load(f)

with tarfile.open(mode="w|", fileobj=sys.stdout.buffer) as tar:
    layers = []
    for num, store_layer in enumerate(conf["store_layers"]):
        print(
          "Creating layer", num,
          "from paths:", store_layer,
          file=sys.stderr)
        info = add_layer_dir(tar, store_layer)
        layers.append(info)

    print("Creating the customisation layer...", file=sys.stderr)
    layers.append(add_customisation_layer(tar, conf["customisation_layer"]))

    print("Adding manifests...", file=sys.stderr)
    image_json = {
        "created": conf["created"],
        "architecture": conf["architecture"],
        "os": "linux",
        "config": conf["config"],
        "rootfs": {
            "diff_ids": [f"sha256:{layer.checksum}" for layer in layers],
            "type": "layers",
        },
        "history": [
            {
              "created": conf["created"],
              "comment": f"store paths: {layer.paths}"
            }
            for layer in layers
        ],
    }

    image_json = json.dumps(image_json, indent=4).encode("utf-8")
    image_json_checksum = hashlib.sha256(image_json).hexdigest()
    image_json_path = f"{image_json_checksum}.json"
    add_bytes(tar, image_json_path, image_json)

    manifest_json = [
        {
            "Config": image_json_path,
            "RepoTags": [conf["repo_tag"]],
            "Layers": [layer.path for layer in layers],
        }
    ]
    manifest_json = json.dumps(manifest_json, indent=4).encode("utf-8")
    add_bytes(tar, "manifest.json", manifest_json)

    print("Done.", file=sys.stderr)
