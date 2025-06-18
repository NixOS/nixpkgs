"""
This script generates a Docker image from a set of store paths. Uses
Docker Image Specification v1.2 as reference [1].

It expects a JSON file with the following properties and writes the
image as an uncompressed tarball to stdout:

* "architecture", "config", "os", "created", "repo_tag" correspond to
  the fields with the same name on the image spec [2].
* "created" can be "now".
* "created" is also used as mtime for files added to the image.
* "uid", "gid", "uname", "gname" is the file ownership, for example,
  0, 0, "root", "root".
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

import argparse
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


def archive_paths_to(obj, paths, mtime, uid, gid, uname, gname):
    """
    Writes the given store paths as a tar file to the given stream.

    obj: Stream to write to. Should have a 'write' method.
    paths: List of store paths.
    """

    # gettarinfo makes the paths relative, this makes them
    # absolute again
    def append_root(ti):
        ti.name = "/" + ti.name
        return ti

    def apply_filters(ti):
        ti.mtime = mtime
        ti.uid = uid
        ti.gid = gid
        ti.uname = uname
        ti.gname = gname
        return ti

    def nix_root(ti):
        ti.mode = 0o0755  # rwxr-xr-x
        return ti

    def dir(path):
        ti = tarfile.TarInfo(path)
        ti.type = tarfile.DIRTYPE
        return ti

    with tarfile.open(fileobj=obj, mode="w|") as tar:
        # To be consistent with the docker utilities, we need to have
        # these directories first when building layer tarballs.
        tar.addfile(apply_filters(nix_root(dir("/nix"))))
        tar.addfile(apply_filters(nix_root(dir("/nix/store"))))

        for path in paths:
            path = pathlib.Path(path)
            if path.is_symlink():
                files = [path]
            else:
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


FromImage = namedtuple("FromImage", ["tar", "manifest_json", "image_json"])
# Some metadata for a layer
LayerInfo = namedtuple("LayerInfo", ["size", "checksum", "path", "paths"])


def load_from_image(from_image_str):
    """
    Loads the given base image, if any.

    from_image_str: Path to the base image archive.

    Returns: A 'FromImage' object with references to the loaded base image,
             or 'None' if no base image was provided.
    """
    if from_image_str is None:
        return None

    base_tar = tarfile.open(from_image_str)

    manifest_json_tarinfo = base_tar.getmember("manifest.json")
    with base_tar.extractfile(manifest_json_tarinfo) as f:
        manifest_json = json.load(f)

    image_json_tarinfo = base_tar.getmember(manifest_json[0]["Config"])
    with base_tar.extractfile(image_json_tarinfo) as f:
        image_json = json.load(f)

    return FromImage(base_tar, manifest_json, image_json)


def add_base_layers(tar, from_image):
    """
    Adds the layers from the given base image to the final image.

    tar: 'tarfile.TarFile' object for new layers to be added to.
    from_image: 'FromImage' object with references to the loaded base image.
    """
    if from_image is None:
        print("No 'fromImage' provided", file=sys.stderr)
        return []

    layers = from_image.manifest_json[0]["Layers"]
    checksums = from_image.image_json["rootfs"]["diff_ids"]
    layers_checksums = zip(layers, checksums)

    for num, (layer, checksum) in enumerate(layers_checksums, start=1):
        layer_tarinfo = from_image.tar.getmember(layer)
        checksum = re.sub(r"^sha256:", "", checksum)

        tar.addfile(layer_tarinfo, from_image.tar.extractfile(layer_tarinfo))
        path = layer_tarinfo.path
        size = layer_tarinfo.size

        print("Adding base layer", num, "from", path, file=sys.stderr)
        yield LayerInfo(size=size, checksum=checksum, path=path, paths=[path])

    from_image.tar.close()


def overlay_base_config(from_image, final_config):
    """
    Overlays the final image 'config' JSON on top of selected defaults from the
    base image 'config' JSON.

    from_image: 'FromImage' object with references to the loaded base image.
    final_config: 'dict' object of the final image 'config' JSON.
    """
    if from_image is None:
        return final_config

    base_config = from_image.image_json["config"]

    # Preserve environment from base image
    final_env = base_config.get("Env", []) + final_config.get("Env", [])
    if final_env:
        # Resolve duplicates (last one wins) and format back as list
        resolved_env = {entry.split("=", 1)[0]: entry for entry in final_env}
        final_config["Env"] = list(resolved_env.values())
    return final_config


def add_layer_dir(tar, paths, store_dir, mtime, uid, gid, uname, gname):
    """
    Appends given store paths to a TarFile object as a new layer.

    tar: 'tarfile.TarFile' object for the new layer to be added to.
    paths: List of store paths.
    store_dir: the root directory of the nix store
    mtime: 'mtime' of the added files and the layer tarball.
           Should be an integer representing a POSIX time.

    Returns: A 'LayerInfo' object containing some metadata of
             the layer added.
    """

    invalid_paths = [i for i in paths if not i.startswith(store_dir)]
    assert (
        len(invalid_paths) == 0
    ), f"Expecting absolute paths from {store_dir}, but got: {invalid_paths}"

    # First, calculate the tarball checksum and the size.
    extract_checksum = ExtractChecksum()
    archive_paths_to(extract_checksum, paths, mtime, uid, gid, uname, gname)
    (checksum, size) = extract_checksum.extract()

    path = f"{checksum}/layer.tar"
    layer_tarinfo = tarfile.TarInfo(path)
    layer_tarinfo.size = size
    layer_tarinfo.mtime = mtime

    # Then actually stream the contents to the outer tarball.
    read_fd, write_fd = os.pipe()
    with open(read_fd, "rb") as read, open(write_fd, "wb") as write:

        def producer():
            archive_paths_to(write, paths, mtime, uid, gid, uname, gname)
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


def add_customisation_layer(target_tar, customisation_layer, mtime):
    """
    Adds the customisation layer as a new layer. This is layer is structured
    differently; given store path has the 'layer.tar' and corresponding
    sha256sum ready.

    tar: 'tarfile.TarFile' object for the new layer to be added to.
    customisation_layer: Path containing the layer archive.
    mtime: 'mtime' of the added layer tarball.
    """

    checksum_path = os.path.join(customisation_layer, "checksum")
    with open(checksum_path) as f:
        checksum = f.read().strip()
    assert len(checksum) == 64, f"Invalid sha256 at ${checksum_path}."

    layer_path = os.path.join(customisation_layer, "layer.tar")

    path = f"{checksum}/layer.tar"
    tarinfo = target_tar.gettarinfo(layer_path)
    tarinfo.name = path
    tarinfo.mtime = mtime

    with open(layer_path, "rb") as f:
        target_tar.addfile(tarinfo, f)

    return LayerInfo(
        size=None, checksum=checksum, path=path, paths=[customisation_layer]
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


now = datetime.now(tz=timezone.utc)


def parse_time(s):
    if s == "now":
        return now
    return datetime.fromisoformat(s)


def main():
    arg_parser = argparse.ArgumentParser(
        description="""
This script generates a Docker image from a set of store paths. Uses
Docker Image Specification v1.2 as reference [1].

[1]: https://github.com/moby/moby/blob/master/image/spec/v1.2.md
    """
    )
    arg_parser.add_argument(
        "conf",
        type=str,
        help="""
        JSON file with the following properties and writes the
        image as an uncompressed tarball to stdout:

        * "architecture", "config", "os", "created", "repo_tag" correspond to
        the fields with the same name on the image spec [2].
        * "created" can be "now".
        * "created" is also used as mtime for files added to the image.
        * "uid", "gid", "uname", "gname" is the file ownership, for example,
        0, 0, "root", "root".
        * "store_layers" is a list of layers in ascending order, where each
        layer is the list of store paths to include in that layer.
    """,
    )
    arg_parser.add_argument(
        "--repo_tag", "-t", type=str,
        help="Override the RepoTags from the configuration"
    )

    args = arg_parser.parse_args()
    with open(args.conf, "r") as f:
        conf = json.load(f)

    created = parse_time(conf["created"])
    mtime = int(parse_time(conf["mtime"]).timestamp())
    uid = int(conf["uid"])
    gid = int(conf["gid"])
    uname = conf["uname"]
    gname = conf["gname"]
    store_dir = conf["store_dir"]

    from_image = load_from_image(conf["from_image"])

    with tarfile.open(mode="w|", fileobj=sys.stdout.buffer) as tar:
        layers = []
        layers.extend(add_base_layers(tar, from_image))

        start = len(layers) + 1
        for num, store_layer in enumerate(conf["store_layers"], start=start):
            print(
                "Creating layer",
                num,
                "from paths:",
                store_layer,
                file=sys.stderr,
            )
            info = add_layer_dir(
                tar, store_layer, store_dir, mtime, uid, gid, uname, gname
            )
            layers.append(info)

        print(
            "Creating layer",
            len(layers) + 1,
            "with customisation...",
            file=sys.stderr,
        )
        layers.append(
            add_customisation_layer(
                tar, conf["customisation_layer"], mtime=mtime
            )
        )

        print("Adding manifests...", file=sys.stderr)

        image_json = {
            "created": datetime.isoformat(created),
            "architecture": conf["architecture"],
            "os": "linux",
            "config": overlay_base_config(from_image, conf["config"]),
            "rootfs": {
                "diff_ids": [f"sha256:{layer.checksum}" for layer in layers],
                "type": "layers",
            },
            "history": [
                {
                    "created": datetime.isoformat(created),
                    "comment": f"store paths: {layer.paths}",
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
                "RepoTags": [args.repo_tag or conf["repo_tag"]],
                "Layers": [layer.path for layer in layers],
            }
        ]
        manifest_json = json.dumps(manifest_json, indent=4).encode("utf-8")
        add_bytes(tar, "manifest.json", manifest_json, mtime=mtime)

        print("Done.", file=sys.stderr)


if __name__ == "__main__":
    main()
