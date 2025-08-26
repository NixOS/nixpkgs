"""
https://github.com/dart-lang/pub/issues/4522
This script generates a package_graph.json file.
"""

import json
import os
from pathlib import Path
from urllib.parse import unquote, urlparse

import yaml


def get_package(pubspec_path: Path, dev_dependencies: bool = False):
    with pubspec_path.open("r", encoding="utf-8") as f:
        pubspec = yaml.load(f, Loader=yaml.CSafeLoader)
    package = {
        "name": pubspec["name"],
        "version": pubspec.get("version") or "0.0.0",
        "dependencies": list(pubspec.get("dependencies") or {}),
    }
    if dev_dependencies:
        package["devDependencies"] = list(pubspec.get("dev_dependencies") or {})
    return package


def main() -> None:
    package_config_file_path = Path(os.environ["packageConfig"])  # noqa: SIM112
    with package_config_file_path.open("r", encoding="utf-8") as f:
        package_config = json.load(f)
    package_graph = []
    root_package = get_package(Path("pubspec.yaml"), dev_dependencies=True)
    for data in package_config.get("packages", []):
        if data["name"] == root_package["name"] or data["rootUri"] == "flutter_gen":
            continue
        package_graph.append(
            get_package(Path(unquote(urlparse(data["rootUri"]).path)) / "pubspec.yaml")
        )
    package_graph.append(root_package)
    print(
        json.dumps(
            {
                "roots": [root_package["name"]],
                "packages": package_graph,
                "configVersion": 1,
            },
            indent=2,
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
