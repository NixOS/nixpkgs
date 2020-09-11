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
import pathlib
import tarfile
import itertools
import threading
from datetime import datetime, timezone
from collections import namedtuple


def archive_paths_to(obj, paths, mtime, add_nix, filter=None):
    """
    Writes the given store paths as a tar file to the given stream.

    obj: Stream to write to. Should have a 'write' method.
    paths: List of store paths.
    add_nix: Whether /nix and /nix/store directories should be
             prepended to the archive.
    filter: An optional transformation to be applied to TarInfo
            objects. Should take a single TarInfo object and return
            another one. Defaults to identity.
    """

    filter = filter if filter else lambda i: i

    # gettarinfo makes the paths relative, this makes them
    # absolute again
    def append_root(ti):
        ti.name = "/" + ti.name
        return ti

    def apply_filters(ti):
        ti.mtime = mtime
        ti.uid = 0
        ti.gid = 0
        ti.uname = "root"
        ti.gname = "root"
        return filter(ti)

    def nix_root(ti):
        ti.mode = 0o0555  # r-xr-xr-x
        return ti

    def dir(path):
        ti = tarfile.TarInfo(path)
        ti.type = tarfile.DIRTYPE
        return ti

    with tarfile.open(fileobj=obj, mode="w|") as tar:
        # To be consistent with the docker utilities, we need to have
        # these directories first when building layer tarballs. But
        # we don't need them on the customisation layer.
        if add_nix:
            tar.addfile(apply_filters(nix_root(dir("/nix"))))
            tar.addfile(apply_filters(nix_root(dir("/nix/store"))))

        for path in paths:
            path = pathlib.Path(path)
            files = itertools.chain([path], path.rglob("*"))
            for filename in sorted(files):
                ti = append_root(tar.gettarinfo(filename))

                # copy hardlinks as regular files
                if ti.islnk():
                    ti.type = tarfile.REGTYPE
                    ti.linkname = ""
                    ti.size = filename.stat().st_size

                ti = apply_filters(ti)
                if ti.isfile():
                    with open(filename, "rb") as f:
                        tar.addfile(ti, f)
                else:
                    tar.addfile(ti)


class ExtractChecksum:
    """
    A writable stream which only calculates the final file size and
    sha256sum, while discarding the actual contents.
    """

    def __init__(self):
        self._digest = hashlib.sha256()
        self._size = 0

    def write(self, data):
        self._digest.update(data)
        self._size += len(data)

    def extract(self):
        """
        Returns: Hex-encoded sha256sum and size as a tuple.
        """
        return (self._digest.hexdigest(), self._size)


# Some metadata for a layer
LayerInfo = namedtuple("LayerInfo", ["size", "checksum", "path", "paths"])


def add_layer_dir(tar, paths, mtime, add_nix=True, filter=None):
    """
    Appends given store paths to a TarFile object as a new layer.

    tar: 'tarfile.TarFile' object for the new layer to be added to.
    paths: List of store paths.
    mtime: 'mtime' of the added files and the layer tarball.
           Should be an integer representing a POSIX time.
    add_nix: Whether /nix and /nix/store directories should be
             added to a layer.
    filter: An optional transformation to be applied to TarInfo
            objects inside the layer. Should take a single TarInfo
            object and return another one. Defaults to identity.

    Returns: A 'LayerInfo' object containing some metadata of
             the layer added.
    """

    invalid_paths = [i for i in paths if not i.startswith("/nix/store/")]
    assert len(invalid_paths) == 0, \
        "Expecting absolute store paths, but got: {invalid_paths}"

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
    layer_tarinfo = tarfile.TarInfo(path)
    layer_tarinfo.size = size
    layer_tarinfo.mtime = mtime

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
        tar.addfile(layer_tarinfo, read)

    return LayerInfo(size=size, checksum=checksum, path=path, paths=paths)


def add_customisation_layer(tar, path, mtime):
    """
    Adds the contents of the store path as a new layer. This is different
    than the 'add_layer_dir' function defaults in the sense that the contents
    of a single store path will be added to the root of the layer. eg (without
    the /nix/store prefix).

    tar: 'tarfile.TarFile' object for the new layer to be added to.
    path: A store path.
    mtime: 'mtime' of the added files and the layer tarball. Should be an
           integer representing a POSIX time.
    """

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


def add_bytes(tar, path, content, mtime):
    """
    Adds a file to the tarball with given path and contents.

    tar: 'tarfile.TarFile' object.
    path: Path of the file as a string.
    content: Contents of the file.
    mtime: 'mtime' of the file. Should be an integer representing a POSIX time.
    """
    assert type(content) is bytes

    ti = tarfile.TarInfo(path)
    ti.size = len(content)
    ti.mtime = mtime
    tar.addfile(ti, io.BytesIO(content))


def main():
    with open(sys.argv[1], "r") as f:
        conf = json.load(f)

    created = (
      datetime.now(tz=timezone.utc)
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
                  "created": datetime.isoformat(created),
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


if __name__ == "__main__":
    main()
