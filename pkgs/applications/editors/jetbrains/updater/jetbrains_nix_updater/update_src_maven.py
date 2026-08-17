import bisect
import os
from pathlib import Path
from tempfile import TemporaryDirectory
from urllib.parse import urlparse
from xmltodict import parse

from jetbrains_nix_updater.config import UpdaterConfig
from jetbrains_nix_updater.ides import Ide
from jetbrains_nix_updater.util import ensure_is_list, run_command


def add_entries(sources, targets, hashes):
    for artefact in sources:
        target = None
        base_jar_name = os.path.basename(urlparse(artefact["@url"]).path)
        for candidate in targets:
            if candidate["@url"].endswith(base_jar_name + "!/"):
                target = candidate
                break
        if target is None:
            raise ValueError(f"Did not find target for source {artefact}")

        url = artefact["@url"].removeprefix("file://$MAVEN_REPOSITORY$/")
        if url == artefact["@url"]:
            raise ValueError(f"Unexpected artefact URL {url}")

        path = (
            target["@url"].removeprefix("jar://$MAVEN_REPOSITORY$/").removesuffix("!/")
        )
        if path == target["@url"]:
            raise ValueError(f"Unexpected target path {path}")

        bisect.insort(hashes, {"url": url, "hash": artefact["sha256sum"], "path": path}, key=lambda e: e["url"])


def add_libraries(
    root_path: str, hashes: list[dict[str, str]], projects_to_process: list[str]
):
    library_paths = os.listdir(root_path + "/libraries/")
    for path in library_paths:
        file_contents = parse(open(root_path + "/libraries/" + path).read())
        if "properties" not in file_contents["component"]["library"]:
            continue
        sources = ensure_is_list(
            file_contents["component"]["library"]["properties"]["verification"][
                "artifact"
            ]
        )
        targets = ensure_is_list(
            file_contents["component"]["library"]["CLASSES"]["root"]
        )
        add_entries(sources, targets, hashes)

    modules_xml = parse(open(root_path + "/modules.xml").read())
    for module in modules_xml["project"]["component"]["modules"]["module"]:
        projects_to_process.append(module["@filepath"])


def add_iml(path: str, hashes: list[dict[str, str]], projects_to_process: list[str]):
    try:
        contents = parse(open(path).read())
    except FileNotFoundError:
        print(
            f"Warning: path {path} does not exist (did you forget the android directory?)"
        )
        return
    for manager in ensure_is_list(contents["module"]["component"]):
        if manager["@name"] != "NewModuleRootManager":
            continue

        for entry in manager["orderEntry"]:
            if (
                type(entry) != dict
                or entry["@type"] != "module-library"
                or "properties" not in entry["library"]
            ):
                continue

            sources = ensure_is_list(
                entry["library"]["properties"]["verification"]["artifact"]
            )
            targets = ensure_is_list(entry["library"]["CLASSES"]["root"])
            add_entries(sources, targets, hashes)


def get_maven_deps_for_ide(config: UpdaterConfig, ide: Ide) -> list[dict]:
    with TemporaryDirectory() as tmp_dir:
        root_path = Path(tmp_dir) / "result"
        run_command(
            [
                "nix-build",
                "--out-link",
                root_path,
                "--attr",
                f"jetbrains.{ide.name}.src.src",
            ],
            cwd=config.nixpkgs_root,
        )

        file_hashes = []
        projects_to_process: list[str] = [str(root_path / ".idea")]

        while projects_to_process:
            elem = projects_to_process.pop()
            elem = elem.replace("$PROJECT_DIR$", str(root_path))
            if elem.endswith(".iml"):
                add_iml(elem, file_hashes, projects_to_process)
            else:
                add_libraries(elem, file_hashes, projects_to_process)

        return file_hashes
