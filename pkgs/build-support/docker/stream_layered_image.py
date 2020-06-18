"""
This script generates a Docker image from a set of store paths. Uses
Docker Image Specification v1.2 as reference [1].

It expects a JSON file with the following properties and writes the
image as an uncompressed tarball to stdout:

* "architecture", "config", "os", "created", "repo_tag" correspond to
  the fields with the same name on the image spec [2].
* "created" can be "now".
* "created" is also used as mtime for files added to the image.
* "store_layers" is a list of layers in ascending order, where each
  layer is the list of store paths to include in that layer.

The main challenge for this script to create the final image in a
streaming fashion, without dumping any intermediate data to disk
for performance.

A docker image has each layer contents archived as separate tarballs,
and they later all get enveloped into a single big tarball in a
content addressed fashion. However, because how "tar" format works,
we have to know about the name (which includes the checksum in our
case) and the size of the tarball before we can start adding it to the
outer tarball.  We achieve that by creating the layer tarballs twice;
on the first iteration we calculate the file size and the checksum,
and on the second one we actually stream the contents. 'add_layer_dir'
function does all this.

[1]: https://github.com/moby/moby/blob/master/image/spec/v1.2.md
[2]: https://github.com/moby/moby/blob/4fb59c20a4fb54f944fe170d0ff1d00eb4a24d6f/image/spec/v1.2.md#image-json-field-descriptions
"""  # noqa: E501


import io
import os
import re
import sys
import json
import hashlib
import tarfile
import itertools
import threading
from datetime import datetime
from collections import namedtuple


# Adds the given store paths to as a tar to the given writable stream.
def archive_paths_to(obj, paths, mtime, add_nix, filter=None):
    filter = filter if filter else lambda i: i

    # gettarinfo makes the paths relative, this makes them
    # absolute again
    def append_root(ti):
        ti.name = "/" + ti.name
        return ti

    def apply_filters(ti):
        ti.mtime = mtime
        return filter(ti)

    def dir(path):
        ti = tarfile.TarInfo(path)
        ti.type = tarfile.DIRTYPE
        return ti

    with tarfile.open(fileobj=obj, mode="w|") as tar:
        # To be consistent with the docker utilities, we need to have
        # these directories first when building layer tarballs. But
        # we don't need them on the customisation layer.
        if add_nix:
            tar.addfile(apply_filters(dir("/nix")))
            tar.addfile(apply_filters(dir("/nix/store")))

        for path in paths:
            ti = tar.gettarinfo(os.path.join("/", path))
            tar.addfile(apply_filters(append_root(ti)))

            for root, dirs, files in os.walk(path, topdown=True):
                for name in itertools.chain(dirs, files):
                    name = os.path.join(root, name)
                    ti = append_root(tar.gettarinfo(name))

                    # copy hardlinks as regular files
                    if ti.islnk():
                        ti.type = tarfile.REGTYPE

                    ti = apply_filters(ti)
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
def add_layer_dir(tar, paths, mtime, add_nix=True, filter=None):
    assert all(i.startswith("/nix/store/") for i in paths)

    # First, calculate the tarball checksum and the size.
    extract_checksum = ExtractChecksum()
    archive_paths_to(
        extract_checksum,
        paths,
        mtime=mtime,
        add_nix=add_nix,
        filter=filter
    )
    (checksum, size) = extract_checksum.extract()

    path = f"{checksum}/layer.tar"
    ti = tarfile.TarInfo(path)
    ti.size = size
    ti.mtime = mtime

    # Then actually stream the contents to the outer tarball.
    read_fd, write_fd = os.pipe()
    with open(read_fd, "rb") as read, open(write_fd, "wb") as write:
        def producer():
            archive_paths_to(
                write,
                paths,
                mtime=mtime,
                add_nix=add_nix,
                filter=filter
            )
            write.close()

        # Closing the write end of the fifo also closes the read end,
        # so we don't need to wait until this thread is finished.
        #
        # Any exception from the thread will get printed by the default
        # exception handler, and the 'addfile' call will fail since it
        # won't be able to read required amount of bytes.
        threading.Thread(target=producer).start()
        tar.addfile(ti, read)

    return LayerInfo(size=size, checksum=checksum, path=path, paths=paths)


# Adds the contents of the store path to the root as a new layer.
def add_customisation_layer(tar, path, mtime):
    def filter(ti):
        ti.name = re.sub("^/nix/store/[^/]*", "", ti.name)
        return ti
    return add_layer_dir(
        tar,
        [path],
        mtime=mtime,
        add_nix=False,
        filter=filter
      )


# Adds a file to the tarball with given path and contents.
def add_bytes(tar, path, content, mtime):
    assert type(content) is bytes

    ti = tarfile.TarInfo(path)
    ti.size = len(content)
    ti.mtime = mtime
    tar.addfile(ti, io.BytesIO(content))


# Main

with open(sys.argv[1], "r") as f:
    conf = json.load(f)

created = (
  datetime.now(tz=datetime.timezone.utc)
  if conf["created"] == "now"
  else datetime.fromisoformat(conf["created"])
)
mtime = int(created.timestamp())

with tarfile.open(mode="w|", fileobj=sys.stdout.buffer) as tar:
    layers = []
    for num, store_layer in enumerate(conf["store_layers"]):
        print(
          "Creating layer", num,
          "from paths:", store_layer,
          file=sys.stderr)
        info = add_layer_dir(tar, store_layer, mtime=mtime)
        layers.append(info)

    print("Creating the customisation layer...", file=sys.stderr)
    layers.append(
      add_customisation_layer(
        tar,
        conf["customisation_layer"],
        mtime=mtime
      )
    )

    print("Adding manifests...", file=sys.stderr)

    image_json = {
        "created": datetime.isoformat(created),
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
    add_bytes(tar, image_json_path, image_json, mtime=mtime)

    manifest_json = [
        {
            "Config": image_json_path,
            "RepoTags": [conf["repo_tag"]],
            "Layers": [layer.path for layer in layers],
        }
    ]
    manifest_json = json.dumps(manifest_json, indent=4).encode("utf-8")
    add_bytes(tar, "manifest.json", manifest_json, mtime=mtime)

    print("Done.", file=sys.stderr)
